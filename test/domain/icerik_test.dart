import 'dart:convert';
import 'dart:io';

import 'package:abyad/core/icerik/icerik.dart';
import 'package:abyad/features/kuran/data/kuran_deposu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../yardimci.dart';

Map<String, dynamic> _oku(String yol) =>
    jsonDecode(File(yol).readAsStringSync()) as Map<String, dynamic>;

/// CLAUDE.md §8: her dinî metin bu alanlarla tutulur.
const _incelemeAlanlari = ['kaynak', 'incelendi', 'inceleyen', 'not'];

void main() {
  late KuranVerisi kuran;

  setUpAll(() {
    kuran = KuranVerisi.coz(
      File('assets/data/quran/quran-uthmani.txt').readAsStringSync(),
      File('assets/data/quran/quran_meta.json').readAsStringSync(),
    );
  });

  group("Kur'an verisi (Tanzil)", () {
    test('114 sure, 6236 ayet, 30 cüz, 604 sayfa', () {
      expect(kuran.sureler, hasLength(114));
      expect(kuran.sureler.fold(0, (t, s) => t + s.ayetSayisi), 6236);
      expect(kuran.cuzler, hasLength(30));
      expect(kuran.sayfalar, hasLength(toplamSayfa));
      // Son surenin son ayeti okunabiliyor: metin ile üst veri uyumlu
      expect(kuran.hamAyet(114, 6), isNotEmpty);
    });

    test('lisans bloğu dosyada duruyor (metin değiştirilmedi)', () {
      final metin = File(
        'assets/data/quran/quran-uthmani.txt',
      ).readAsStringSync();
      expect(metin, contains('Tanzil Quran Text (Uthmani'));
      expect(metin, contains('CHANGING IT IS NOT ALLOWED'));
    });

    test('besmele: Fâtiha ve Tevbe dışında ayrı başlık olarak gösterilir', () {
      expect(kuran.besmele, kuran.hamAyet(1, 1));
      expect(kuran.besmeleBasligi(1), isFalse);
      expect(kuran.besmeleBasligi(9), isFalse);
      expect(kuran.besmeleBasligi(2), isTrue);
      expect(kuran.hamAyet(2, 1), startsWith(kuran.besmele));
      expect(kuran.ayetMetni(2, 1), isNot(contains(kuran.besmele)));
      expect(
        '${kuran.besmele} ${kuran.ayetMetni(2, 1)}',
        kuran.hamAyet(2, 1),
        reason: 'gösterim, dosyadaki metni eksiksiz yeniden kurar',
      );
      expect(kuran.ayetMetni(1, 1), kuran.besmele);
      expect(kuran.ayetMetni(9, 1), kuran.hamAyet(9, 1));
    });

    test('sayfa ve cüz numaraları', () {
      expect(kuran.sayfaNo(1, 1), 1);
      expect(kuran.sayfaNo(2, 255), 42);
      expect(kuran.sayfaNo(114, 6), 604);
      expect(kuran.cuzNo(1, 1), 1);
      expect(kuran.cuzNo(2, 141), 1);
      expect(kuran.cuzNo(2, 142), 2);
      expect(kuran.cuzNo(2, 255), 3);
      expect(kuran.cuzNo(78, 1), 30);
    });

    test('başvuru çözme', () {
      expect(kuran.aralik('2:255'), [(sure: 2, ayet: 255)]);
      expect(kuran.aralik('112:1-4'), hasLength(4));
      expect(kuran.aralik('2:285-286').last, (sure: 2, ayet: 286));
    });

    test('arama: sure adı ve sure:ayet', () {
      expect(kuran.ara('bakara').single.sure.no, 2);
      expect(kuran.ara('YASIN').single.sure.no, 36);
      expect(kuran.ara('2:255').single, (sure: kuran.sure(2), ayet: 255));
      expect(kuran.ara('36').single.sure.ad, 'Yâsîn');
      expect(kuran.ara('2:999'), isEmpty);
      expect(kuran.ara('115'), isEmpty);
      expect(kuran.ara(''), isEmpty);
    });

    test('ayet işareti Arapça rakamla yazılır', () {
      expect(ayetIsareti(1), '﴿١﴾');
      expect(ayetIsareti(255), '﴿٢٥٥﴾');
    });

    test('meal eklenene kadar kaynak yok', () {
      const meal = MealYok();
      expect(meal.ad, isNull);
      expect(meal.meal(1, 1), isNull);
    });
  });

  group('dinî içerik dosyaları', () {
    test('dualar: inceleme alanları ve geçerli ayet başvuruları', () {
      final j = _oku('assets/data/dualar.json');
      final kategoriler = {
        for (final k in j['kategoriler'] as List) (k as Map)['id'],
      };
      expect(kategoriler, {'sabah_aksam', 'namaz', 'yemek', 'sifa'});
      final kimlikler = <String>{};
      for (final d in (j['dualar'] as List).cast<Map<String, dynamic>>()) {
        expect(kimlikler.add(d['id'] as String), isTrue, reason: '${d['id']}');
        expect(kategoriler, contains(d['kategori']));
        for (final alan in _incelemeAlanlari) {
          expect(d.containsKey(alan), isTrue, reason: '${d['id']}: $alan');
        }
        expect(d['kaynak'], isNotEmpty, reason: '${d['id']}');
        // Ya ayet başvurusu ya Arapça metin; ikisi birden olmaz
        expect(
          (d['ayetler'] == null) != (d['arapca'] == null),
          isTrue,
          reason: '${d['id']}: ayet metni elle yazılmamalı',
        );
        if (d['ayetler'] != null) {
          for (final a in kuran.aralik(d['ayetler'] as String)) {
            expect(a.ayet, lessThanOrEqualTo(kuran.sure(a.sure).ayetSayisi));
          }
          expect(d['anlam'], isNull, reason: 'ayet anlamı mealden gelir');
        }
      }
    });

    test('zikirler, rehber ve Esmâ: inceleme alanları', () {
      for (final z
          in (_oku('assets/data/zikirler.json')['zikirler'] as List)
              .cast<Map<String, dynamic>>()) {
        for (final alan in _incelemeAlanlari) {
          expect(z.containsKey(alan), isTrue);
        }
      }
      final rehberler = (_oku('assets/data/rehber.json')['rehberler'] as List)
          .cast<Map<String, dynamic>>();
      expect(rehberler.map((r) => r['id']), ['namaz', 'abdest']);
      for (final r in rehberler) {
        for (final a in (r['adimlar'] as List).cast<Map<String, dynamic>>()) {
          for (final alan in _incelemeAlanlari) {
            expect(a.containsKey(alan), isTrue, reason: '${a['id']}');
          }
        }
      }
      final esma = _oku('assets/data/esma.json');
      final isimler = (esma['isimler'] as List).cast<Map<String, dynamic>>();
      expect(isimler, hasLength(99));
      expect(isimler.map((i) => i['no']), [for (var i = 1; i <= 99; i++) i]);
      expect(isimler.map((i) => i['ad']).toSet(), hasLength(99));
      expect(isimler.map((i) => i['arapca']).toSet(), hasLength(99));
      for (final i in isimler) {
        expect(i.containsKey('incelendi'), isTrue);
      }
    });

    test('günün ayeti: geçerli başvurular ve deterministik seçim', () {
      final liste = (_oku('assets/data/gunun_ayetleri.json')['ayetler'] as List)
          .cast<String>();
      expect(liste, isNotEmpty);
      for (final b in liste) {
        final a = kuran.aralik(b).single;
        expect(a.ayet, lessThanOrEqualTo(kuran.sure(a.sure).ayetSayisi));
      }
      final gun = DateTime(2026, 10, 2, 9);
      expect(
        gununAyeti(liste, gun),
        gununAyeti(liste, DateTime(2026, 10, 2, 23)),
      );
      expect(
        {
          for (var i = 0; i < liste.length; i++)
            gununAyeti(liste, DateTime(2026, 1, 1 + i)),
        },
        hasLength(liste.length),
        reason: 'art arda günlerde liste sırayla dolaşılır',
      );
    });

    test('önemli günler: şema ve doğrulanma alanı', () {
      final gunler = (_oku('assets/data/onemli_gunler.json')['gunler'] as List)
          .cast<Map<String, dynamic>>();
      expect(gunler, isNotEmpty);
      for (final g in gunler) {
        expect(DateTime.tryParse(g['tarih'] as String), isNotNull);
        expect(g.containsKey('kaynak_dogrulandi'), isTrue);
        if (g['bitis'] != null) {
          expect(
            DateTime.parse(
              g['bitis'] as String,
            ).isAfter(DateTime.parse(g['tarih'] as String)),
            isTrue,
          );
        }
      }
    });
  });

  group('içerik yükleyiciler', () {
    test('bütün gömülü dosyalar modele çözülür', () async {
      final kap = ProviderContainer(
        overrides: [varlikPaketiProvider.overrideWithValue(DiskPaketi())],
      );
      addTearDown(kap.dispose);

      final sehirler = await kap.read(sehirlerProvider.future);
      expect(
        sehirler.where((s) => s.ust.isEmpty && s.ulke == 'Türkiye'),
        hasLength(81),
      );
      expect(sehirler.any((s) => s.ad == 'Berlin'), isTrue);
      expect(sehirler.every((s) => s.dilim.contains('/')), isTrue);

      final dualar = await kap.read(dualarProvider.future);
      expect(dualar.kategoride('namaz'), isNotEmpty);
      expect(await kap.read(zikirlerProvider.future), hasLength(4));
      expect(await kap.read(esmaProvider.future), hasLength(99));
      expect(await kap.read(rehberlerProvider.future), hasLength(2));
      expect(await kap.read(kazaBilgileriProvider.future), isNotEmpty);
      expect((await kap.read(kuranProvider.future)).sureler, hasLength(114));

      final gunler = await kap.read(onemliGunlerProvider.future);
      final bugun = DateTime(2026, 10, 2);
      expect(gunler.siradaki(bugun)!.ad, 'Regaip Kandili');
      expect(gunler.siradaki(bugun)!.kalanGun(bugun), 69);
      expect(gunler.gunler.first.kalanGun(bugun), isNegative);
      expect(gunler.siradaki(DateTime(2030)), isNull);
    });
  });
}
