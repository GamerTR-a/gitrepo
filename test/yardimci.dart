import 'dart:convert';
import 'dart:io';

import 'package:abyad/core/icerik/icerik.dart';
import 'package:abyad/core/l10n/app_localizations.dart';
import 'package:abyad/core/storage/ayarlar_deposu.dart';
import 'package:abyad/core/storage/veritabani.dart';
import 'package:abyad/core/theme/abyad_theme.dart';
import 'package:abyad/features/ayarlar/ui/ayarlar_ekrani.dart';
import 'package:abyad/features/hatim/domain/hatim.dart';
import 'package:abyad/features/kible/ui/kible_ekrani.dart';
import 'package:abyad/features/rehber/data/rehber_saglayici.dart';
import 'package:abyad/features/rehber/ui/rehber_adim_ekrani.dart';
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

/// Rehberin adım ekranını gömülü veriden kurar; [vakit] verilmezse abdest.
class RehberAdimlari extends ConsumerWidget {
  const RehberAdimlari({super.key, this.vakit, this.bolum});
  final String? vakit;
  final String? bolum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (vakit == null) {
      final abdest = ref.watch(abdestRehberiProvider).valueOrNull;
      if (abdest == null) return const SizedBox.shrink();
      return RehberAdimEkrani(
        baslik: 'Abdest Rehberi',
        altBaslik: 'Abdestin adım adım alınışı',
        adimlar: abdest.adimlar,
      );
    }
    final rehber = ref.watch(namazRehberiProvider).valueOrNull;
    if (rehber == null) return const SizedBox.shrink();
    final v = rehber.vakitler.firstWhere((v) => v.id == vakit);
    final b = v.bolumler.firstWhere((b) => b.id == bolum);
    return RehberAdimEkrani(
      baslik: '${v.ad} – ${b.ad}',
      altBaslik: '${b.rekat} rekat',
      adimlar: rehber.adimlariUret(b),
    );
  }
}

/// Test anında (2 Ekim) yatsı ve imsakın astronomik olarak oluşmadığı bir
/// konumla başlayan ayarlar: güney yarımkürede bahar, 75° enlem.
final yuksekEnlemAyarlari = <String, Object>{
  'ayarlar_v1': jsonEncode({
    'konum': {
      'ad': 'Yüksek enlem (örnek)',
      'enlem': -75.0,
      'boylam': 0.0,
      'dilim': 'UTC',
    },
  }),
};

/// Test anında (2 Ekim) Diyanet'in yaz kısaltmasını uyguladığı türden bir
/// gün: ülkesi bilinen, Türkiye dışında, 60° enlemde bir konum (güney
/// yarımkürede bahar; şafak oluşur ama gecenin büyük bölümünü kaplar).
final yazFarkiAyarlari = <String, Object>{
  'ayarlar_v1': jsonEncode({
    'konum': {
      'ad': 'Yurt dışı (örnek)',
      'ulke': 'Örnek',
      'enlem': -60.0,
      'boylam': 0.0,
      'dilim': 'UTC',
    },
  }),
};

const ornekHatimKodu = 'ornekhatim23';

/// Kayıtlı bir hatimle başlayan ayarlar: 1–3. paylar okunmuş, 4. pay bu
/// cihazda, 5. pay başka bir katılımcıda.
Map<String, Object> ornekHatimAyarlari(BolmeSekli bolme) {
  final an = testAni();
  var hatim = Hatim.yeni(
    kod: ornekHatimKodu,
    baslik: 'Ramazan Aile Hatmi',
    not: 'Annemizin ruhu için',
    bolmeSekli: bolme,
    hedefTarih: DateTime(2027, 3, 1),
    simdi: an,
  );
  for (var no = 1; no <= 4; no++) {
    (hatim, _) = hatim.payAl(no, 'ben', an);
    if (no < 4) (hatim, _) = hatim.okundu(no, 'ben', an);
  }
  (hatim, _) = hatim.payAl(5, 'baskasi', an);
  return {
    'hatim.katilimci': 'ben',
    'hatim.liste': jsonEncode([hatim.toJson()]),
  };
}
