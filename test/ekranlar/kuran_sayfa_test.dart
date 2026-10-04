import 'dart:convert';
import 'dart:io';

import 'package:abyad/features/ayarlar/data/ayarlar_saglayici.dart';
import 'package:abyad/features/kuran/data/kuran_deposu.dart';
import 'package:abyad/features/kuran/ui/kuran_oku_ekrani.dart';
import 'package:abyad/features/kuran/ui/kuran_sayfa_ekrani.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../yardimci.dart';

KuranVerisi _kuran() => KuranVerisi.coz(
  File('assets/data/quran/quran-uthmani.txt').readAsStringSync(),
  File('assets/data/quran/quran_meta.json').readAsStringSync(),
);

/// Gerçek bir meal değildir: yalnızca altyapıyı denemek için her ayete
/// "TEST s:a" yazan sahte dosya.
class _SahteMealPaketi extends DiskPaketi {
  @override
  Future<String> loadString(String key, {bool cache = true}) {
    if (key.endsWith('mealler.json')) {
      return Future.value(
        jsonEncode({
          'mealler': [
            {
              'id': 'test',
              'ad': 'Test Meali',
              'sahip': 'Test',
              'lisans': 'Yalnızca test',
              'dosya': 'test.txt',
            },
          ],
        }),
      );
    }
    if (key.endsWith('meal/test.txt')) {
      final k = _kuran();
      return Future.value(
        [
          '# yorum satırı',
          for (final s in k.sureler)
            for (var a = 1; a <= s.ayetSayisi; a++)
              '${s.no}|$a|TEST ${s.no}:$a',
        ].join('\n'),
      );
    }
    return super.loadString(key, cache: cache);
  }
}

void main() {
  setUpAll(testOrtaminiKur);

  group('sayfa verisi', () {
    final k = _kuran();

    test('604 sayfa bütün ayetleri tam bir kez ve sırayla kapsar', () {
      var sira = 0;
      for (var s = 1; s <= toplamSayfa; s++) {
        final ayetler = k.sayfaAyetleri(s);
        expect(ayetler, isNotEmpty, reason: 'sayfa $s');
        for (final a in ayetler) {
          expect(k.sira(a.sure, a.ayet), sira++, reason: 'sayfa $s');
          expect(k.sayfaNo(a.sure, a.ayet), s);
        }
      }
      expect(sira, 6236);
    });

    test('bilinen sayfalar', () {
      expect(k.sayfaAyetleri(1), [
        for (var a = 1; a <= 7; a++) (sure: 1, ayet: a),
      ]);
      expect(k.sayfaAyetleri(2).first, (sure: 2, ayet: 1));
      expect(k.sayfaAyetleri(604).first, (sure: 112, ayet: 1));
      expect(k.sayfaAyetleri(604).last, (sure: 114, ayet: 6));
    });
  });

  group('meal dosyası', () {
    final k = _kuran();
    const bilgi = MealBilgisi(
      id: 'x',
      ad: 'X',
      sahip: 'Y',
      lisans: 'Z',
      dosya: 'x.txt',
    );

    test('satırlar ayetlere eşlenir; eksik ve hatalı satırlar sayılır', () {
      final m = DosyaMeali.coz(
        bilgi,
        k,
        '# başlık\n1|1|Birinci\n\n2|255|İçinde | çizgi olan metin\n'
        '115|1|olmayan sure\n1|99|olmayan ayet\nbozuk satır\n',
      );
      expect(m.meal(1, 1), 'Birinci');
      expect(m.meal(2, 255), 'İçinde | çizgi olan metin');
      expect(m.meal(1, 2), isNull);
      expect(m.eksikSayisi, 6236 - 2);
      expect(m.ad, 'X');
    });
  });

  group('gömülü mealler', () {
    test('listedeki her meal tam, lisanslı ve izin belgeli olmalı', () {
      final j =
          jsonDecode(File('assets/data/quran/mealler.json').readAsStringSync())
              as Map<String, dynamic>;
      final k = _kuran();
      for (final m in (j['mealler'] as List).cast<Map<String, dynamic>>()) {
        final bilgi = MealBilgisi.fromJson(m);
        expect(bilgi.sahip, isNotEmpty);
        expect(bilgi.lisans, isNotEmpty);
        final belge = m['izinBelgesi'] as String?;
        expect(
          belge != null && File(belge).existsSync(),
          isTrue,
          reason: '${bilgi.id}: izin belgesi depoda olmalı (docs/lisanslar/)',
        );
        final meal = DosyaMeali.coz(
          bilgi,
          k,
          File('assets/data/quran/meal/${bilgi.dosya}').readAsStringSync(),
        );
        expect(meal.eksikSayisi, 0, reason: '${bilgi.id}: eksik ayet');
      }
    });
  });

  for (final olcek in yaziOlcekleri) {
    for (final boyut in [tasarimBoyutu, kucukTelefon]) {
      testWidgets('sayfa görünümü taşmaz: ${boyut.width.toInt()} genişlik, '
          'yazı ölçeği $olcek', (tester) async {
        final ortam = await ekraniKur(
          tester,
          const KuranSayfaEkrani(sure: 2, ayet: 255),
          boyut: boyut,
          yaziOlcegi: olcek,
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Sayfa 42 / 604'), findsOneWidget);
        await tester.tap(find.byTooltip('Sonraki sayfa'));
        await tester.pumpAndSettle();
        expect(find.text('Sayfa 43 / 604'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await ekraniKapat(tester, ortam);
      });
    }
  }

  testWidgets('sayfa çevrilince kalınan yer kaydedilir; sola-sağa kaydırma '
      'Mushaf yönündedir', (tester) async {
    final ortam = await ekraniKur(tester, const KuranSayfaEkrani(sure: 1));
    expect(find.text('Sayfa 1 / 604'), findsOneWidget);
    expect(find.text('Fâtiha Suresi'), findsWidgets);

    // Sonraki sayfa soldadır: parmak soldan sağa kayar
    await tester.drag(find.byType(PageView), const Offset(300, 0));
    await tester.pumpAndSettle();
    expect(find.text('Sayfa 2 / 604'), findsOneWidget);
    final durum = await tester.runAsync(
      () => ortam.veritabani.okumaDurumunuIzle().first,
    );
    expect((durum!.sure, durum.ayet), (2, 1));

    await tester.tap(find.byTooltip('Önceki sayfa'));
    await tester.pumpAndSettle();
    expect(find.text('Sayfa 1 / 604'), findsOneWidget);
    await ekraniKapat(tester, ortam);
  });

  testWidgets('sayfaya git ve ayet ayet görünüme geçiş', (tester) async {
    final ortam = await ekraniKur(tester, const KuranSayfaEkrani(sure: 1));
    await tester.tap(find.text('Sayfa 1 / 604'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '604');
    await tester.tap(find.text('Tamam'));
    await tester.pumpAndSettle();
    expect(find.text('Sayfa 604 / 604'), findsOneWidget);
    expect(find.text('İhlâs Suresi'), findsWidgets);

    await tester.tap(find.byTooltip('Ayet ayet görünüm'));
    await tester.pumpAndSettle();
    expect(find.byType(KuranOkuEkrani), findsOneWidget);
    final kap = ProviderScope.containerOf(
      tester.element(find.byType(KuranOkuEkrani)),
    );
    expect(kap.read(ayarlarProvider).kuranSayfaGorunumu, isFalse);

    await tester.tap(find.byTooltip('Sayfa görünümü'));
    await tester.pumpAndSettle();
    expect(find.byType(KuranSayfaEkrani), findsOneWidget);
    expect(kap.read(ayarlarProvider).kuranSayfaGorunumu, isTrue);
    await ekraniKapat(tester, ortam);
  });

  testWidgets('meal eklendiğinde ayet görünümünde gösterilir, yer tutucu '
      'kalkar', (tester) async {
    final ortam = await ekraniKur(
      tester,
      const KuranOkuEkrani(sure: 1),
      paket: _SahteMealPaketi(),
    );
    expect(find.text('TEST 1:1'), findsOneWidget);
    expect(find.textContaining('Meal kaynağı eklenecek'), findsNothing);
    await ekraniKapat(tester, ortam);
  });
}
