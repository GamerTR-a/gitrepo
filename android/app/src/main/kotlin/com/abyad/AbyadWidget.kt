package com.abyad

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.SystemClock
import android.view.View
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject
import java.util.Calendar
import java.util.Locale
import java.util.TimeZone

/**
 * Widget'ların okuduğu veri. Uygulama (lib/features/widget/data/widget_servisi.dart)
 * önümüzdeki günlerin vakitlerini dakika cinsinden önceden yazar; hangi vaktin
 * sırada olduğuna burada karar verilir. Böylece uygulama açılmasa da widget
 * doğru vakti gösterir. Ağ erişimi yoktur.
 */
class WidgetVerisi(
    val konum: String,
    val adlar: List<String>,
    /** Bugünün altı vakti, gece yarısından itibaren dakika */
    val bugun: List<Int>,
    val simdikiIndex: Int,
    val sonrakiIndex: Int,
    /** Sıradaki vaktin anı (epoch ms) */
    val sonrakiAn: Long,
    val sonrakiDakika: Int,
    /** Sıradaki vakit yarının imsakı mı? */
    val yarin: Boolean,
) {
    companion object {
        // home_widget paketinin kullandığı tercih dosyası
        private const val TERCIHLER = "HomeWidgetPreferences"

        fun oku(context: Context): WidgetVerisi? {
            val p = context.getSharedPreferences(TERCIHLER, Context.MODE_PRIVATE)
            val gunlerJson = p.getString("gunler", null) ?: return null
            return try {
                val gunler = JSONObject(gunlerJson)
                val adlar = JSONArray(p.getString("vakit_adlari", "[]")).let { a ->
                    List(a.length()) { a.getString(it) }
                }
                if (adlar.size != 6) return null
                val dilim = TimeZone.getTimeZone(p.getString("dilim", null) ?: return null)
                val simdi = Calendar.getInstance(dilim)

                fun anahtar(c: Calendar) = String.format(
                    Locale.US, "%04d-%02d-%02d",
                    c.get(Calendar.YEAR), c.get(Calendar.MONTH) + 1, c.get(Calendar.DAY_OF_MONTH),
                )

                fun vakitler(c: Calendar): List<Int>? =
                    gunler.optJSONArray(anahtar(c))?.let { a -> List(a.length()) { a.getInt(it) } }

                fun an(gun: Calendar, dakika: Int): Long =
                    (gun.clone() as Calendar).apply {
                        set(Calendar.HOUR_OF_DAY, dakika / 60)
                        set(Calendar.MINUTE, dakika % 60)
                        set(Calendar.SECOND, 0)
                        set(Calendar.MILLISECOND, 0)
                    }.timeInMillis

                val bugun = vakitler(simdi) ?: return null
                val simdiDakika = simdi.get(Calendar.HOUR_OF_DAY) * 60 + simdi.get(Calendar.MINUTE)
                val sonraki = bugun.indexOfFirst { it > simdiDakika }
                if (sonraki >= 0) {
                    WidgetVerisi(
                        konum = p.getString("konum", "") ?: "",
                        adlar = adlar,
                        bugun = bugun,
                        simdikiIndex = sonraki - 1,
                        sonrakiIndex = sonraki,
                        sonrakiAn = an(simdi, bugun[sonraki]),
                        sonrakiDakika = bugun[sonraki],
                        yarin = false,
                    )
                } else {
                    // Yatsıdan sonra: yarının imsakı
                    val yarin = (simdi.clone() as Calendar).apply { add(Calendar.DAY_OF_MONTH, 1) }
                    val yarinki = vakitler(yarin) ?: return null
                    WidgetVerisi(
                        konum = p.getString("konum", "") ?: "",
                        adlar = adlar,
                        bugun = bugun,
                        simdikiIndex = 5,
                        sonrakiIndex = 0,
                        sonrakiAn = an(yarin, yarinki[0]),
                        sonrakiDakika = yarinki[0],
                        yarin = true,
                    )
                }
            } catch (e: Exception) {
                null
            }
        }

        fun saat(dakika: Int): String = String.format(Locale.US, "%02d:%02d", dakika / 60, dakika % 60)
    }
}

/** İki widget'ın ortak davranışı: çizim, dokununca uygulamayı açma, vakit geçişinde yenilenme. */
abstract class AbyadWidget : AppWidgetProvider() {

    protected abstract fun ciz(context: Context, veri: WidgetVerisi?): RemoteViews

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        // Saat/saat dilimi değişimi, yeniden başlatma ve kendi kurduğumuz yenileme alarmı
        if (intent.action != AppWidgetManager.ACTION_APPWIDGET_UPDATE) {
            val yonetici = AppWidgetManager.getInstance(context)
            val kimlikler = yonetici.getAppWidgetIds(ComponentName(context, javaClass))
            if (kimlikler.isNotEmpty()) onUpdate(context, yonetici, kimlikler)
        }
    }

    override fun onUpdate(context: Context, yonetici: AppWidgetManager, kimlikler: IntArray) {
        val veri = WidgetVerisi.oku(context)
        val gorunum = ciz(context, veri)
        context.packageManager.getLaunchIntentForPackage(context.packageName)?.let { ac ->
            gorunum.setOnClickPendingIntent(
                R.id.widget_kok,
                PendingIntent.getActivity(
                    context, 0, ac,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                ),
            )
        }
        kimlikler.forEach { yonetici.updateAppWidget(it, gorunum) }
        if (veri != null) sonrakiYenilemeyiKur(context, veri.sonrakiAn)
    }

    override fun onDisabled(context: Context) {
        (context.getSystemService(Context.ALARM_SERVICE) as AlarmManager).cancel(yenilemeNiyeti(context))
    }

    private fun yenilemeNiyeti(context: Context): PendingIntent =
        PendingIntent.getBroadcast(
            context,
            javaClass.name.hashCode(),
            Intent(context, javaClass).setAction(YENILE),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

    /** Sıradaki vakit girince widget'ı yeniden çizmek için alarm kurar. */
    private fun sonrakiYenilemeyiKur(context: Context, an: Long) {
        val alarm = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val zaman = an + 2_000
        val niyet = yenilemeNiyeti(context)
        val tamZamanli = Build.VERSION.SDK_INT < Build.VERSION_CODES.S || alarm.canScheduleExactAlarms()
        try {
            if (tamZamanli) {
                alarm.setExactAndAllowWhileIdle(AlarmManager.RTC, zaman, niyet)
            } else {
                alarm.setAndAllowWhileIdle(AlarmManager.RTC, zaman, niyet)
            }
        } catch (e: SecurityException) {
            alarm.setAndAllowWhileIdle(AlarmManager.RTC, zaman, niyet)
        }
    }

    /** Geri sayımı sistem saatiyle canlı gösterir; widget'ın her dakika güncellenmesi gerekmez. */
    protected fun geriSayim(gorunum: RemoteViews, kimlik: Int, an: Long) {
        val kalan = an - System.currentTimeMillis()
        gorunum.setChronometer(kimlik, SystemClock.elapsedRealtime() + kalan, null, true)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            gorunum.setChronometerCountDown(kimlik, true)
        }
    }

    companion object {
        const val YENILE = "com.abyad.widget.YENILE"
    }
}

/** Küçük widget: sıradaki vakit ve geri sayım. Tasarım: docs/tasarim/11_widget */
class SiradakiVakitWidget : AbyadWidget() {
    override fun ciz(context: Context, veri: WidgetVerisi?): RemoteViews {
        val g = RemoteViews(context.packageName, R.layout.widget_siradaki)
        if (veri == null) {
            g.setTextViewText(R.id.widget_konum, context.getString(R.string.app_name_widget))
            g.setTextViewText(R.id.widget_vakit_adi, context.getString(R.string.widget_veri_yok))
            g.setTextViewText(R.id.widget_saat, "")
            g.setViewVisibility(R.id.widget_kalan, View.GONE)
            return g
        }
        g.setTextViewText(R.id.widget_konum, veri.konum)
        g.setTextViewText(R.id.widget_vakit_adi, veri.adlar[veri.sonrakiIndex])
        g.setTextViewText(R.id.widget_saat, WidgetVerisi.saat(veri.sonrakiDakika))
        g.setViewVisibility(R.id.widget_kalan, View.VISIBLE)
        geriSayim(g, R.id.widget_kalan, veri.sonrakiAn)
        g.setContentDescription(
            R.id.widget_kok,
            context.getString(
                R.string.widget_siradaki_okuma,
                veri.adlar[veri.sonrakiIndex],
                WidgetVerisi.saat(veri.sonrakiDakika),
            ),
        )
        return g
    }
}

/** Orta widget: günün altı vakti. Tasarım: docs/tasarim/11_widget */
class GununVakitleriWidget : AbyadWidget() {
    private val adlar = intArrayOf(
        R.id.widget_ad_0, R.id.widget_ad_1, R.id.widget_ad_2,
        R.id.widget_ad_3, R.id.widget_ad_4, R.id.widget_ad_5,
    )
    private val saatler = intArrayOf(
        R.id.widget_saat_0, R.id.widget_saat_1, R.id.widget_saat_2,
        R.id.widget_saat_3, R.id.widget_saat_4, R.id.widget_saat_5,
    )
    private val hucreler = intArrayOf(
        R.id.widget_hucre_0, R.id.widget_hucre_1, R.id.widget_hucre_2,
        R.id.widget_hucre_3, R.id.widget_hucre_4, R.id.widget_hucre_5,
    )

    override fun ciz(context: Context, veri: WidgetVerisi?): RemoteViews {
        val g = RemoteViews(context.packageName, R.layout.widget_gunun)
        if (veri == null) {
            g.setTextViewText(R.id.widget_konum, context.getString(R.string.widget_veri_yok))
            g.setTextViewText(R.id.widget_siradaki, "")
            g.setViewVisibility(R.id.widget_kalan, View.GONE)
            g.setViewVisibility(R.id.widget_satir, View.INVISIBLE)
            return g
        }
        g.setViewVisibility(R.id.widget_satir, View.VISIBLE)
        g.setTextViewText(R.id.widget_konum, veri.konum)
        g.setTextViewText(R.id.widget_siradaki, veri.adlar[veri.sonrakiIndex])
        g.setViewVisibility(R.id.widget_kalan, View.VISIBLE)
        geriSayim(g, R.id.widget_kalan, veri.sonrakiAn)

        val pirinc = 0xFFE2C27A.toInt()
        val zumrut = 0xFF0F3D33.toInt()
        val beyaz = 0xFFFFFFFF.toInt()
        val soluk = 0xFFCFE0D8.toInt()
        for (i in 0 until 6) {
            g.setTextViewText(adlar[i], veri.adlar[i])
            g.setTextViewText(saatler[i], WidgetVerisi.saat(veri.bugun[i]))
            val sirada = !veri.yarin && i == veri.sonrakiIndex
            val simdiki = i == veri.simdikiIndex
            g.setInt(
                hucreler[i], "setBackgroundResource",
                when {
                    sirada -> R.drawable.widget_cip_sirada
                    simdiki -> R.drawable.widget_cip_simdiki
                    else -> android.R.color.transparent
                },
            )
            g.setTextColor(adlar[i], if (sirada) zumrut else if (simdiki) beyaz else soluk)
            g.setTextColor(saatler[i], if (sirada) zumrut else beyaz)
        }
        // Renk tek başına bilgi taşımasın: sıradaki vakit metin olarak da var
        g.setContentDescription(
            R.id.widget_kok,
            context.getString(
                R.string.widget_siradaki_okuma,
                veri.adlar[veri.sonrakiIndex],
                WidgetVerisi.saat(veri.sonrakiDakika),
            ),
        )
        g.setTextColor(R.id.widget_siradaki, pirinc)
        return g
    }
}
