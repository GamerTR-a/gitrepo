import 'dart:io';

import 'package:abyad/core/icerik/icerik.dart';
import 'package:abyad/core/l10n/app_localizations.dart';
import 'package:abyad/core/storage/ayarlar_deposu.dart';
import 'package:abyad/core/storage/veritabani.dart';
import 'package:abyad/core/theme/abyad_theme.dart';
import 'package:abyad/features/ayarlar/ui/ayarlar_ekrani.dart';
import 'package:abyad/features/kible/ui/kible_ekrani.dart';
import 'package:abyad/features/vakitler/data/vakit_saglayicilari.dart';
import 'package:abyad/features/zikirmatik/ui/zikirmatik_ekrani.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;

/// Tasarım kanvasındaki telefon boyutu
const tasarimBoyutu = Size(390, 844);

/// Dar ve kısa bir telefon (eski/küçük Android cihazlar)
const kucukTelefon = Size(320, 568);

/// CLAUDE.md §7: her ekran bu ölçeklerde taşmadan çalışmalı.
const yaziOlcekleri = [1.0, 1.5, 2.0];

/// Testlerdeki sabit an: 2 Ekim 2026 Cuma 13:52 (İstanbul)
DateTime testAni() => DateTime(2026, 10, 2, 13, 52);

/// Testler varsayılan olarak her harfi kare çizen bir yazı tipi kullanır.
/// Gerçek genişliklerle taşma denetimi için uygulamanın yazı tiplerini,
/// ayrıca saat dilimi verisini yükler.
Future<void> testOrtaminiKur() async {
  tzdata.initializeTimeZones();
  const aileler = {
    'Manrope': ['fonts/Manrope-Variable.ttf'],
    'Fraunces': ['fonts/Fraunces-Variable.ttf'],
    'Amiri': ['fonts/Amiri-Regular.ttf', 'fonts/Amiri-Bold.ttf'],
  };
  for (final MapEntry(key: aile, value: dosyalar) in aileler.entries) {
    final yukleyici = FontLoader(aile);
    for (final dosya in dosyalar) {
      final bayt = File(dosya).readAsBytesSync();
      yukleyici.addFont(Future.value(ByteData.sublistView(bayt)));
    }
    await yukleyici.load();
  }
}

/// Gömülü veri dosyalarını doğrudan diskten okur (test saatinde eşzamanlı).
class DiskPaketi extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(File(key).readAsBytesSync());

  @override
  Future<String> loadString(String key, {bool cache = true}) =>
      Future.value(File(key).readAsStringSync());
}

/// Bir ekran testinin ortamı: sahte ayar deposu, bellek içi veritabanı,
/// sabit saat ve eklentisiz servisler.
class TestOrtami {
  TestOrtami._(this.prefs, this.veritabani);

  final SharedPreferences prefs;
  final AbyadVeritabani veritabani;

  static Future<TestOrtami> olustur({
    Map<String, Object> ayarlar = const {},
  }) async {
    SharedPreferences.setMockInitialValues(ayarlar);
    return TestOrtami._(
      await SharedPreferences.getInstance(),
      AbyadVeritabani(NativeDatabase.memory()),
    );
  }

  List<Override> overrides({
    PusulaOkumasi? pusula = (yon: 120.0, hata: 5.0),
    AssetBundle? paket,
  }) => [
    sharedPreferencesProvider.overrideWithValue(prefs),
    veritabaniProvider.overrideWithValue(veritabani),
    varlikPaketiProvider.overrideWithValue(paket ?? DiskPaketi()),
    saatProvider.overrideWithValue(testAni),
    pusulaProvider.overrideWith((ref) => Stream.value(pusula)),
    ekranAcikTutProvider.overrideWithValue((_) {}),
    sistemAyarlariProvider.overrideWithValue(() async {}),
  ];
}

/// [govde]'yi uygulamanın teması, Türkçe çevirileri ve verilen ekran
/// boyutu / yazı ölçeğiyle kurar; gömülü veriler yüklenene kadar bekler.
Future<TestOrtami> ekraniKur(
  WidgetTester tester,
  Widget govde, {
  Size boyut = tasarimBoyutu,
  double yaziOlcegi = 1.0,
  TestOrtami? ortam,
  PusulaOkumasi? pusula = (yon: 120.0, hata: 5.0),
  AssetBundle? paket,
}) async {
  tester.view.physicalSize = boyut;
  tester.view.devicePixelRatio = 1.0;
  tester.platformDispatcher.textScaleFactorTestValue = yaziOlcegi;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAllTestValues);

  final o = ortam ?? await TestOrtami.olustur();
  await tester.pumpWidget(
    ProviderScope(
      overrides: o.overrides(pusula: pusula, paket: paket),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AbyadTheme.light(),
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: govde,
      ),
    ),
  );
  await yuklenmeyiBekle(tester);
  return o;
}

/// Gömülü JSON'lar ve veritabanı akışları gelene kadar birkaç kare ilerler.
Future<void> yuklenmeyiBekle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// Ekranı kaldırıp bekleyen zamanlayıcıları (geri sayım, veritabanı
/// akışları) temizler. Her ekran testinin sonunda çağrılır.
Future<void> ekraniKapat(WidgetTester tester, TestOrtami ortam) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
  await tester.runAsync(ortam.veritabani.close);
  await tester.pump(const Duration(seconds: 1));
}
