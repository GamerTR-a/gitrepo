import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/storage/veritabani.dart';
import '../../ayarlar/data/ayarlar_saglayici.dart';
import '../../vakitler/data/vakit_saglayicilari.dart';
import '../../vakitler/domain/gunluk_vakitler.dart';
import '../../vakitler/ui/vakit_adlari.dart';

/// Widget'ların önceden yazılan gün sayısı. Uygulama bu süre açılmasa da
/// widget doğru vakti gösterir; her açılışta pencere yenilenir.
const widgetGunSayisi = 30;

const _androidWidgetlar = [
  'com.abyad.SiradakiVakitWidget',
  'com.abyad.GununVakitleriWidget',
];

/// Ana ekran widget'larının okuyacağı veriyi yazar. Widget'lar uygulama
/// açılmadan da doğru vakti göstersin diye günlerin vakitleri önceden
/// (dakika cinsinden) kaydedilir; hangi vaktin sırada olduğuna yerel
/// (Kotlin/Swift) kod karar verir.
class WidgetServisi {
  WidgetServisi(this._ref);
  final Ref _ref;

  Future<void> guncelle() async {
    final l10n = lookupAppLocalizations(const Locale('tr'));
    final ayarlar = _ref.read(ayarlarProvider);
    final servis = _ref.read(vakitServisiProvider);
    final simdi = _ref.read(saatProvider)();

    final gunler = {
      for (final g in servis.gunler(simdi, widgetGunSayisi))
        gunAnahtari(g.gun): [
          for (final v in g.vakitler) v.saat * 60 + v.dakika,
        ],
    };
    await HomeWidget.saveWidgetData('konum', ayarlar.konum.ad);
    await HomeWidget.saveWidgetData('dilim', ayarlar.konum.dilim);
    await HomeWidget.saveWidgetData('gunler', jsonEncode(gunler));
    await HomeWidget.saveWidgetData(
      'vakit_adlari',
      jsonEncode([for (final t in VakitTuru.values) l10n.vakitAdi(t)]),
    );
    for (final ad in _androidWidgetlar) {
      await HomeWidget.updateWidget(qualifiedAndroidName: ad);
    }
  }
}

final widgetServisiProvider = Provider<WidgetServisi>(WidgetServisi.new);
