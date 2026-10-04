import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/sekme.dart';
import '../../../core/icerik/icerik.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/tarih/hicri.dart';
import '../../../core/tarih/tarih_metni.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_icon.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';
import '../../../core/widgets/sekiz_kose_yildiz.dart';
import '../../ayarlar/data/ayarlar_saglayici.dart';
import '../../ayarlar/ui/ayarlar_ekrani.dart';
import '../../esma/ui/esma_ekrani.dart';
import '../../kaza/ui/kaza_ekrani.dart';
import '../../kible/ui/kible_ekrani.dart';
import '../../kuran/data/kuran_deposu.dart';
import '../../kuran/ui/kuran_liste_ekrani.dart' show okumaDurumuProvider;
import '../../kuran/ui/kuran_sayfa_ekrani.dart';
import '../../rehber/ui/rehber_ekrani.dart';
import '../../vakitler/data/vakit_saglayicilari.dart';
import '../../vakitler/domain/gunluk_vakitler.dart';
import '../../vakitler/ui/vakit_adlari.dart';
import '../../zikirmatik/ui/zikirmatik_ekrani.dart';

/// Tasarım: docs/tasarim/01_ana_sayfa
class AnaSayfa extends ConsumerWidget {
  const AnaSayfa({super.key, required this.sekmeyeGit});

  /// Alt menüde başka bir sekmeye geçmek için
  final ValueChanged<Sekme> sekmeyeGit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    void ac(Widget ekran) => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => ekran));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          SystemUiOverlayStyle.light, // koyu başlık üstünde açık durum çubuğu
      child: ListView(
        padding: const EdgeInsets.only(bottom: AbyadSpace.xxl),
        children: [
          // Geri sayım dakika bazında; 15 sn'de bir yenilemek yeterli ve pil dostu.
          ZamanIzleyici(
            saat: ref.watch(saatProvider),
            builder: (context, simdi) => _BaslikAlani(simdi: simdi),
          ),
          const SizedBox(height: AbyadSpace.bolumArasi),
          _HizliErisim(
            ogeler: [
              ('compass', l10n.hizliKible, () => ac(const KibleEkrani())),
              ('book', l10n.hizliKuran, () => sekmeyeGit(Sekme.kuran)),
              (
                'counter',
                l10n.hizliZikirmatik,
                () => ac(const ZikirmatikEkrani()),
              ),
              ('moon', l10n.hizliDualar, () => sekmeyeGit(Sekme.dualar)),
            ],
          ),
          const SizedBox(height: AbyadSpace.bolumArasi),
          _kenarli(_DevamKarti(kuranSekmesi: () => sekmeyeGit(Sekme.kuran))),
          const SizedBox(height: AbyadSpace.bolumArasi),
          _kenarli(const _GununAyeti()),
          const SizedBox(height: AbyadSpace.bolumArasi),
          _kenarli(_YaklasanGun(onTap: () => sekmeyeGit(Sekme.gunler))),
          const SizedBox(height: AbyadSpace.bolumArasi),
          _kenarli(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BolumBasligi(l10n.dahaFazlasi),
                const SizedBox(height: 10),
                AbyadKart(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Column(
                    children: [
                      GezinmeSatiri(
                        ikon: 'person',
                        baslik: l10n.rehberBaslik,
                        aciklama: l10n.rehberAciklama,
                        onTap: () => ac(const RehberEkrani()),
                      ),
                      const Divider(height: 1, color: AbyadColors.ayrac),
                      GezinmeSatiri(
                        ikon: 'check',
                        baslik: l10n.kazaTakibi,
                        aciklama: l10n.kazaAciklama,
                        onTap: () => ac(const KazaEkrani()),
                      ),
                      const Divider(height: 1, color: AbyadColors.ayrac),
                      GezinmeSatiri(
                        ikon: 'star',
                        baslik: l10n.esmaBaslik,
                        aciklama: l10n.esmaAltBaslik,
                        onTap: () => ac(const EsmaEkrani()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kenarli(Widget w) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AbyadSpace.ekranKenar),
    child: w,
  );
}

// ---------------------------------------------------------------------------
// Koyu başlık: konum, tarih, sıradaki vakit, 6 vakit
// ---------------------------------------------------------------------------
class _BaslikAlani extends ConsumerWidget {
  const _BaslikAlani({required this.simdi});

  final DateTime simdi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ustBosluk = MediaQuery.paddingOf(context).top;
    final servis = ref.watch(vakitServisiProvider);
    final konum = ref.watch(konumProvider);
    final hicri = hicriTarih(
      simdi,
      duzeltme: ref.watch(ayarlarProvider.select((a) => a.hicriDuzeltme)),
    );
    final vakitler = servis.gunluk(simdi);
    final durum = servis.durum(simdi);
    final sonrakiAd = l10n.vakitAdi(durum.sonraki);
    final sonrakiSaat =
        '${ikiHane(durum.sonrakiZaman.hour)}:'
        '${ikiHane(durum.sonrakiZaman.minute)}';
    final kalan = l10n.kalanMetni(durum.kalan(simdi));

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AbyadColors.zumrut,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AbyadRadius.baslikAlt),
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -80,
            top: -60,
            child: Opacity(
              opacity: 0.35,
              child: SekizKoseYildiz(
                boyut: 280,
                renk: AbyadColors.pirinc,
                cizgiKalinligi: 1.4,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, ustBosluk + 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const AbyadIcon(
                                'pin',
                                renk: AbyadColors.koyuUstuIkincil,
                                boyut: 16,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  konum.ad,
                                  style: abyadStil(
                                    AbyadFonts.metin,
                                    13,
                                    500,
                                    color: AbyadColors.koyuUstuIkincil,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.tarihSatiri(
                              hicriMetin(l10n, hicri),
                              miladiKisa(context, simdi),
                            ),
                            style: abyadStil(
                              AbyadFonts.metin,
                              13,
                              500,
                              color: AbyadColors.pirinc,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _YuvarlakIkonDugme(
                      ikon: 'bell',
                      etiket: l10n.bildirimler,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const VakitBildirimEkrani(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _YuvarlakIkonDugme(
                      ikon: 'settings',
                      etiket: l10n.ayarlar,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const AyarlarEkrani(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Semantics(
                  container: true,
                  label: l10n.siradakiVakitOkuma(sonrakiAd, sonrakiSaat, kalan),
                  excludeSemantics: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.siradakiVakit(sonrakiAd),
                        style: abyadStil(
                          AbyadFonts.metin,
                          14,
                          500,
                          color: AbyadColors.koyuUstuIkincil,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(sonrakiSaat, style: AbyadText.saatDev),
                      ),
                      Text(
                        kalan,
                        style: abyadStil(
                          AbyadFonts.metin,
                          14,
                          500,
                          color: AbyadColors.yuzey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _VakitCipleri(
                  vakitler: vakitler.vakitler,
                  // Yatsıdan sonra sıradaki vakit yarının imsakıdır; bugünün
                  // çiplerinde "sıradaki" vurgusu yapılmaz.
                  sonraki: durum.yarinMi(simdi) ? null : durum.sonraki,
                  simdiki: durum.simdiki,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Altı vakit çipi. Tasarımdaki tek sıra, yazı büyütüldüğünde sığmaz;
/// o zaman çipler 3'erli (çok büyük yazıda 2'şerli) satırlara bölünür.
class _VakitCipleri extends StatelessWidget {
  const _VakitCipleri({
    required this.vakitler,
    required this.sonraki,
    required this.simdiki,
  });

  final List<Vakit> vakitler;
  final VakitTuru? sonraki;
  final VakitTuru? simdiki;

  static const _aralik = 6.0;

  @override
  Widget build(BuildContext context) {
    final olcek = MediaQuery.textScalerOf(context).scale(14) / 14;
    return LayoutBuilder(
      builder: (context, kisit) {
        // Bir çipin "00:00" metnini taşmadan gösterebilmesi için gereken en dar genişlik.
        final enAz = 50 * olcek;
        var sutun = 6;
        for (final aday in const [6, 3, 2]) {
          sutun = aday;
          final genislik = (kisit.maxWidth - _aralik * (aday - 1)) / aday;
          if (genislik >= enAz) break;
        }
        return Column(
          children: [
            for (var satir = 0; satir < vakitler.length; satir += sutun) ...[
              if (satir > 0) const SizedBox(height: _aralik),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = satir; i < satir + sutun; i++) ...[
                      if (i > satir) const SizedBox(width: _aralik),
                      Expanded(
                        child: _VakitCipi(
                          vakit: vakitler[i],
                          sirada: vakitler[i].tur == sonraki,
                          simdiki: vakitler[i].tur == simdiki,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _VakitCipi extends StatelessWidget {
  const _VakitCipi({
    required this.vakit,
    required this.sirada,
    required this.simdiki,
  });

  final Vakit vakit;
  final bool sirada;
  final bool simdiki;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ad = l10n.vakitAdi(vakit.tur);
    final zemin = sirada
        ? AbyadColors.pirinc
        : (simdiki ? AbyadColors.koyuUstuSecili : AbyadColors.koyuUstuKart);
    final adRengi = sirada
        ? AbyadColors.zumrut
        : (simdiki ? AbyadColors.yuzey : AbyadColors.koyuUstuIkincil);
    final saatRengi = sirada ? AbyadColors.zumrut : AbyadColors.yuzey;
    final okuma = sirada
        ? l10n.vakitCipiSiradakiOkuma(ad, vakit.metin)
        : (simdiki
              ? l10n.vakitCipiSimdikiOkuma(ad, vakit.metin)
              : l10n.vakitCipiOkuma(ad, vakit.metin));

    return Semantics(
      container: true,
      label: okuma,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
        decoration: BoxDecoration(
          color: zemin,
          borderRadius: BorderRadius.circular(AbyadRadius.cip),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ad,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: abyadStil(
                AbyadFonts.metin,
                11,
                sirada ? 600 : 500,
                color: adRengi,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              vakit.metin,
              maxLines: 1,
              softWrap: false,
              style: abyadStil(AbyadFonts.metin, 14, 700, color: saatRengi),
            ),
          ],
        ),
      ),
    );
  }
}

class _YuvarlakIkonDugme extends StatelessWidget {
  const _YuvarlakIkonDugme({
    required this.ikon,
    required this.etiket,
    required this.onTap,
  });

  final String ikon;
  final String etiket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(
        side: BorderSide(color: AbyadColors.koyuUstuKenar),
      ),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        tooltip: etiket, // ekran okuyucu bu etiketi okur
        onPressed: onTap,
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        icon: AbyadIcon(ikon, renk: AbyadColors.yuzey, boyut: 20),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hızlı erişim: Kıble, Kur'an, Zikirmatik, Dualar
// ---------------------------------------------------------------------------
class _HizliErisim extends StatelessWidget {
  const _HizliErisim({required this.ogeler});
  final List<(String ikon, String etiket, VoidCallback onTap)> ogeler;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AbyadSpace.ekranKenar),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (i, (ikon, etiket, onTap)) in ogeler.indexed) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(
              child: _HizliDugme(ikon: ikon, etiket: etiket, onTap: onTap),
            ),
          ],
        ],
      ),
    );
  }
}

class _HizliDugme extends StatelessWidget {
  const _HizliDugme({
    required this.ikon,
    required this.etiket,
    required this.onTap,
  });

  final String ikon;
  final String etiket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: etiket,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AbyadRadius.ikonKutu),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AbyadColors.yuzey,
                  borderRadius: BorderRadius.circular(AbyadRadius.ikonKutu),
                  border: Border.all(color: AbyadColors.kenarlik),
                ),
                alignment: Alignment.center,
                child: AbyadIcon(ikon, renk: AbyadColors.zumrut),
              ),
              const SizedBox(height: 8),
              // Büyük yazıda "Zikirmatik" kesilmesin diye sığacak kadar küçülür.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  etiket,
                  maxLines: 1,
                  style: abyadStil(AbyadFonts.metin, 12, 600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Kaldığın yerden devam et
// ---------------------------------------------------------------------------
class _DevamKarti extends ConsumerWidget {
  const _DevamKarti({required this.kuranSekmesi});
  final VoidCallback kuranSekmesi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kuran = ref.watch(kuranProvider).valueOrNull;
    final durum = ref.watch(okumaDurumuProvider).valueOrNull;

    if (kuran == null || durum == null) {
      return AbyadKart(
        onTap: kuranSekmesi,
        semanticLabel: l10n.kuranaBasla,
        child: ExcludeSemantics(
          child: Row(
            children: [
              _ikonKutusu('book', AbyadColors.yesilZemin, AbyadColors.zumrut),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.kuranaBasla, style: AbyadText.kartBasligi),
                    const SizedBox(height: 3),
                    Text(l10n.kuranaBaslaAlt, style: AbyadText.etiket),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const AbyadIcon(
                'chevron_right',
                renk: AbyadColors.metinIkincil,
                boyut: 20,
              ),
            ],
          ),
        ),
      );
    }

    final sure = kuran.sure(durum.sure).ad;
    final sayfa = kuran.sayfaNo(durum.sure, durum.ayet);
    final oran = sayfa / toplamSayfa;
    final yuzde = (oran * 100).round();

    return AbyadKart(
      onTap: () => kuranAc(context, ref, sure: durum.sure, ayet: durum.ayet),
      semanticLabel: l10n.devamOkuma(sure, durum.ayet, yuzde),
      child: ExcludeSemantics(
        child: Row(
          children: [
            _ikonKutusu('bookmark', AbyadColors.yesilZemin, AbyadColors.zumrut),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.devamEt, style: AbyadText.etiket),
                  const SizedBox(height: 4),
                  Text(
                    l10n.devamKonum(sure, durum.ayet),
                    style: AbyadText.kartBasligi,
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: oran,
                      minHeight: 6,
                      backgroundColor: AbyadColors.yesilZemin,
                      color: AbyadColors.zumrut,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.hatimDurumu(yuzde, sayfa, toplamSayfa),
                    style: AbyadText.etiket,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const AbyadIcon(
              'chevron_right',
              renk: AbyadColors.metinIkincil,
              boyut: 20,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _ikonKutusu(String ikon, Color zemin, Color renk) => Container(
  width: 48,
  height: 48,
  decoration: BoxDecoration(
    color: zemin,
    borderRadius: BorderRadius.circular(AbyadRadius.dugme),
  ),
  alignment: Alignment.center,
  child: AbyadIcon(ikon, renk: renk, boyut: 22),
);

// ---------------------------------------------------------------------------
// Günün ayeti (gömülü listeden, tarihe göre deterministik)
// ---------------------------------------------------------------------------
class _GununAyeti extends ConsumerWidget {
  const _GununAyeti();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kuran = ref.watch(kuranProvider).valueOrNull;
    final liste = ref.watch(gununAyetleriProvider).valueOrNull;
    final meal = ref.watch(mealKaynagiProvider);
    if (kuran == null || liste == null || liste.isEmpty) {
      return const SizedBox.shrink();
    }
    final bugun = ref.watch(saatProvider)();
    final konum = kuran.aralik(gununAyeti(liste, bugun)).first;
    final sure = kuran.sure(konum.sure);
    final anlam = meal.meal(konum.sure, konum.ayet);

    return AbyadKart(
      padding: const EdgeInsets.all(AbyadSpace.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const SekizKoseYildiz(
                boyut: 16,
                renk: AbyadColors.pirincYazi,
                cizgiKalinligi: 1.1,
                halkalar: false,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.gununAyeti,
                  style: abyadStil(
                    AbyadFonts.metin,
                    13,
                    700,
                    color: AbyadColors.pirincYazi,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ArapcaMetin(
            kuran.ayetMetni(konum.sure, konum.ayet),
            boyut: 26,
            satirYuksekligi: 1.9,
          ),
          const SizedBox(height: 12),
          if (anlam != null)
            Text(anlam, style: AbyadText.govde)
          else
            Text(l10n.mealYokKisa, style: AbyadText.etiket),
          const SizedBox(height: 8),
          Text(l10n.ayetKaynagi(sure.ad, konum.ayet), style: AbyadText.kucuk),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Yaklaşan mübarek gün
// ---------------------------------------------------------------------------
class _YaklasanGun extends ConsumerWidget {
  const _YaklasanGun({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bugun = ref.watch(saatProvider)();
    final gun = ref.watch(onemliGunlerProvider).valueOrNull?.siradaki(bugun);
    if (gun == null) return const SizedBox.shrink();
    final kalan = gun.kalanGun(bugun);
    final tarih = miladiUzun(context, gun.tarih);

    return AbyadKart(
      onTap: onTap,
      semanticLabel: l10n.yaklasanGunOkuma(gun.ad, tarih, kalan),
      child: ExcludeSemantics(
        child: Row(
          children: [
            _ikonKutusu(
              'calendar',
              AbyadColors.pirincZemin,
              AbyadColors.pirincYazi,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.yaklasanGun, style: AbyadText.etiket),
                  const SizedBox(height: 3),
                  Text(gun.ad, style: AbyadText.kartBasligi),
                  const SizedBox(height: 3),
                  Text(tarih, style: AbyadText.kucuk),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Text('$kalan', style: AbyadText.sayiBuyuk),
                Text(l10n.gunBirimi, style: AbyadText.etiket),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
