import 'dart:io';
import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icerik/icerik.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../ayarlar/data/ayarlar_saglayici.dart';
import '../../ayarlar/domain/ayarlar.dart';
import '../../vakitler/data/vakit_saglayicilari.dart';
import '../../vakitler/ui/vakit_adlari.dart';
import '../domain/bildirim_plani.dart';

/// Lisanslı ezan kaydı `android/app/src/main/res/raw/ezan.*` (ve iOS için
/// 30 saniyeyi geçmeyen `ezan.caf`) olarak eklendiğinde `true` yapılır.
/// O zamana kadar telefonun varsayılan bildirim sesi çalar.
const ezanSesiVar = false;

/// Android'de kaç günlük vakit önceden planlanır. Uygulama her açıldığında
/// ve telefon yeniden başladığında pencere yenilenir.
const _androidGunSayisi = 7;

/// iOS bekleyen yerel bildirim sınırı 64'tür; pay bırakılır.
const _iosAzami = 60;

const _testKimligi = 1;

class _Kanal {
  const _Kanal(this.id, this.ses, {required this.alarm});
  final String id;
  final BildirimSesi ses;
  final bool alarm;
}

/// Ezan bildirimlerini işletim sistemine planlar. Hangi bildirimin ne
/// zaman olacağına [bildirimPlani] karar verir; bu sınıf yalnızca uygular.
class BildirimServisi {
  BildirimServisi(this._ref);

  final Ref _ref;
  final _eklenti = FlutterLocalNotificationsPlugin();
  bool _hazir = false;

  AndroidFlutterLocalNotificationsPlugin? get _android => _eklenti
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  Future<void> _hazirla() async {
    if (_hazir) return;
    await _eklenti.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _hazir = true;
  }

  /// Bildirim izni (Android 13+, iOS). Verildiyse `true`.
  Future<bool> izinIste() async {
    await _hazirla();
    if (Platform.isAndroid) {
      return await _android?.requestNotificationsPermission() ?? false;
    }
    final ios = _eklenti
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(alert: true, sound: true) ?? false;
  }

  Future<bool> izinVarMi() async {
    await _hazirla();
    if (Platform.isAndroid) {
      return await _android?.areNotificationsEnabled() ?? false;
    }
    return true;
  }

  /// Android 12+: tam zamanlı alarm kurulabiliyor mu?
  Future<bool> tamZamanliMi() async {
    await _hazirla();
    if (!Platform.isAndroid) return true;
    return await _android?.canScheduleExactNotifications() ?? false;
  }

  /// Kullanıcıyı "Alarmlar ve hatırlatıcılar" sistem ekranına götürür.
  Future<void> tamZamanliIzniIste() async {
    await _hazirla();
    await _android?.requestExactAlarmsPermission();
  }

  NotificationDetails _ayrinti(
    AppLocalizations l10n,
    BildirimSesi ses, {
    required bool alarm,
  }) {
    final kanal = switch (ses) {
      BildirimSesi.ezan => _Kanal(
        alarm ? 'ezan_alarm' : 'ezan',
        ses,
        alarm: alarm,
      ),
      BildirimSesi.kisa => _Kanal('hatirlatma', ses, alarm: false),
      BildirimSesi.titresim => _Kanal('titresim', ses, alarm: false),
    };
    final sesli = ses != BildirimSesi.titresim;
    return NotificationDetails(
      android: AndroidNotificationDetails(
        kanal.id,
        switch (kanal.id) {
          'ezan_alarm' => l10n.kanalEzanAlarm,
          'ezan' => l10n.kanalEzan,
          'hatirlatma' => l10n.kanalHatirlatma,
          _ => l10n.kanalTitresim,
        },
        channelDescription: l10n.kanalAciklama,
        importance: Importance.max,
        priority: Priority.max,
        playSound: sesli,
        sound: sesli && ses == BildirimSesi.ezan && ezanSesiVar
            ? const RawResourceAndroidNotificationSound('ezan')
            : null,
        enableVibration: true,
        // Medya sesi kısıkken de duyulması için alarm ses akışı
        audioAttributesUsage: kanal.alarm
            ? AudioAttributesUsage.alarm
            : AudioAttributesUsage.notification,
        category: kanal.alarm
            ? AndroidNotificationCategory.alarm
            : AndroidNotificationCategory.reminder,
        visibility: NotificationVisibility.public,
      ),
      iOS: DarwinNotificationDetails(
        presentSound: sesli,
        sound: sesli && ses == BildirimSesi.ezan && ezanSesiVar
            ? 'ezan.caf'
            : null,
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );
  }

  /// Bekleyen bütün bildirimleri silip güncel ayarlara göre yeniden kurar.
  /// Planlanan bildirim sayısını döner.
  Future<int> yenidenKur() async {
    await _hazirla();
    final l10n = lookupAppLocalizations(const Locale('tr'));
    final ayarlar = _ref.read(ayarlarProvider);
    final servis = _ref.read(vakitServisiProvider);
    final simdi = _ref.read(saatProvider)();

    final gunler = <HatirlatilacakGun>[];
    if (ayarlar.hatirlatilanGunler.isNotEmpty) {
      try {
        final veri = await _ref.read(onemliGunlerProvider.future);
        for (final g in veri.gunler) {
          if (ayarlar.hatirlatilanGunler.contains(g.id)) {
            gunler.add(HatirlatilacakGun(ad: g.ad, tarih: g.tarih));
          }
        }
      } on Object catch (hata) {
        debugPrint('Önemli günler okunamadı: $hata');
      }
    }

    final plan = bildirimPlani(
      simdi: simdi,
      gunler: servis.gunler(simdi, _androidGunSayisi),
      ayar: ayarlar.bildirim,
      onemliGunler: gunler,
      azami: Platform.isIOS ? _iosAzami : null,
    );

    final mod = await tamZamanliMi()
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    await _eklenti.cancelAll();
    for (final b in plan) {
      final (baslik, govde) = _metin(l10n, ayarlar, b);
      await _eklenti.zonedSchedule(
        id: b.id,
        title: baslik,
        body: govde,
        scheduledDate: servis.dilimli(b.zaman),
        notificationDetails: _ayrinti(
          l10n,
          b.ses,
          alarm: ayarlar.alarmOlarakCal,
        ),
        androidScheduleMode: mod,
      );
    }
    return plan.length;
  }

  (String, String) _metin(
    AppLocalizations l10n,
    Ayarlar ayarlar,
    PlanliBildirim b,
  ) {
    String saat(DateTime z) =>
        '${z.hour.toString().padLeft(2, '0')}:'
        '${z.minute.toString().padLeft(2, '0')}';
    switch (b.tur) {
      case BildirimTuru.vakit:
        final ad = l10n.vakitAdi(b.vakit!);
        return (
          l10n.bildirimVakitBaslik(ad),
          l10n.bildirimVakitGovde(ayarlar.konum.ad, saat(b.zaman)),
        );
      case BildirimTuru.onHatirlatma:
        final ad = l10n.vakitAdi(b.vakit!);
        return (
          l10n.bildirimOnceBaslik(ad, ayarlar.bildirim.onceDakika),
          l10n.bildirimVakitGovde(
            ayarlar.konum.ad,
            saat(b.zaman.add(Duration(minutes: ayarlar.bildirim.onceDakika))),
          ),
        );
      case BildirimTuru.onemliGun:
        return (b.gunAdi!, l10n.bildirimGunGovde);
    }
  }

  /// Ezanın çaldığını hemen doğrulamak için 5 saniye sonraya bildirim kurar.
  Future<void> testGonder() async {
    await _hazirla();
    final l10n = lookupAppLocalizations(const Locale('tr'));
    final ayarlar = _ref.read(ayarlarProvider);
    final servis = _ref.read(vakitServisiProvider);
    final zaman = _ref.read(saatProvider)().add(const Duration(seconds: 5));
    await _eklenti.zonedSchedule(
      id: _testKimligi,
      title: l10n.bildirimTestBaslik,
      body: l10n.bildirimTestGovde,
      scheduledDate: servis.dilimli(zaman),
      notificationDetails: _ayrinti(
        l10n,
        BildirimSesi.ezan,
        alarm: ayarlar.alarmOlarakCal,
      ),
      androidScheduleMode: await tamZamanliMi()
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}

final bildirimServisiProvider = Provider<BildirimServisi>(BildirimServisi.new);
