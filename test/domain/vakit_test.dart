import 'dart:convert';
import 'dart:io';

import 'package:abyad/features/konum/domain/konum.dart';
import 'package:abyad/features/vakitler/data/vakit_saglayicilari.dart';
import 'package:abyad/features/vakitler/domain/gunluk_vakitler.dart';
import 'package:abyad/features/vakitler/domain/vakit_hesaplama.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;

int _dakika(Vakit v) => v.saat * 60 + v.dakika;

GunlukVakitler _istanbul(DateTime gun, {HesapAyarlari? ayar}) =>
    vakitleriHesapla(
      enlem: 41.0138,
      boylam: 28.9497,
      gun: gun,
      utcFarki: const Duration(hours: 3),
      ayar: ayar ?? const HesapAyarlari(),
    );

void main() {
  setUpAll(tzdata.initializeTimeZones);

  group('hesaplama motoru', () {
    test('vakitler sırayla artar ve altı vakit döner', () {
      for (final gun in [
        DateTime(2026, 1, 15),
        DateTime(2026, 3, 21),
        DateTime(2026, 6, 21),
        DateTime(2026, 10, 2),
        DateTime(2026, 12, 21),
      ]) {
        final v = _istanbul(gun);
        expect(v.vakitler.map((x) => x.tur), VakitTuru.values);
        final dakikalar = v.vakitler.map(_dakika).toList();
        for (var i = 1; i < dakikalar.length; i++) {
          expect(dakikalar[i], greaterThan(dakikalar[i - 1]), reason: '$gun');
        }
      }
    });

    test('İstanbul için astronomik olarak makul değerler', () {
      // Kesin doğrulama Diyanet referanslarıyla yapılır (aşağıdaki grup);
      // burada yalnızca kaba sınırlar denetlenir.
      final v = _istanbul(DateTime(2026, 10, 2));
      expect(_dakika(v[VakitTuru.ogle]), closeTo(12 * 60 + 58, 4));
      expect(_dakika(v[VakitTuru.gunes]), closeTo(6 * 60 + 55, 8));
      expect(_dakika(v[VakitTuru.aksam]), closeTo(18 * 60 + 50, 8));
      expect(_dakika(v[VakitTuru.imsak]), closeTo(5 * 60 + 30, 10));
      expect(_dakika(v[VakitTuru.yatsi]), closeTo(20 * 60 + 10, 10));
    });

    test('kullanıcı düzeltmesi dakikayı kaydırır', () {
      final gun = DateTime(2026, 10, 2);
      final duz = _istanbul(gun);
      final kayik = _istanbul(
        gun,
        ayar: const HesapAyarlari(duzeltmeler: {VakitTuru.ogle: 3}),
      );
      expect(_dakika(kayik[VakitTuru.ogle]) - _dakika(duz[VakitTuru.ogle]), 3);
      expect(kayik[VakitTuru.aksam].metin, duz[VakitTuru.aksam].metin);
    });

    test('Diyanet temkini diğer yöntemlerden farklı sonuç verir', () {
      final gun = DateTime(2026, 10, 2);
      final diyanet = _istanbul(gun);
      final birlik = _istanbul(
        gun,
        ayar: const HesapAyarlari(yontem: HesapYontemi.dunyaIslamBirligi),
      );
      expect(
        _dakika(diyanet[VakitTuru.aksam]) - _dakika(birlik[VakitTuru.aksam]),
        7,
      );
      expect(
        _dakika(diyanet[VakitTuru.gunes]) - _dakika(birlik[VakitTuru.gunes]),
        -7,
      );
    });

    test('yüksek enlemde yatsı/imsak oluşmayan gün: gecenin yedide biri', () {
      // Berlin, 21 Haziran: güneş 17–18° altına inmez
      final v = vakitleriHesapla(
        enlem: 52.5244,
        boylam: 13.4105,
        gun: DateTime(2026, 6, 21),
        utcFarki: const Duration(hours: 2),
      );
      final gunes = _dakika(v[VakitTuru.gunes]);
      final aksam = _dakika(v[VakitTuru.aksam]);
      final imsak = _dakika(v[VakitTuru.imsak]);
      final yatsi = _dakika(v[VakitTuru.yatsi]);
      // Temkin dakikaları yüzünden birkaç dakikalık pay bırakılır
      final geceYedideBir = (1440 - (aksam - gunes)) / 7;
      expect(gunes - imsak, closeTo(geceYedideBir, 12));
      expect(yatsi - aksam, closeTo(geceYedideBir, 12));
      expect(imsak, lessThan(gunes));
      expect(yatsi, greaterThan(aksam));
    });

    test('kutup bölgesi ve uç girdilerde hata fırlatmaz', () {
      for (final enlem in [69.65, 78.2, -77.8, 89.9, 0.0]) {
        for (final gun in [DateTime(2026, 6, 21), DateTime(2026, 12, 21)]) {
          final v = vakitleriHesapla(
            enlem: enlem,
            boylam: 18.95,
            gun: gun,
            utcFarki: const Duration(hours: 1),
          );
          expect(v.vakitler, hasLength(6));
          for (final x in v.vakitler) {
            expect(x.saat, inInclusiveRange(0, 23));
            expect(x.dakika, inInclusiveRange(0, 59));
          }
        }
      }
    });
  });

  group('saat dilimi ve yaz saati', () {
    const berlin = Konum(
      ad: 'Berlin',
      enlem: 52.5244,
      boylam: 13.4105,
      dilim: 'Europe/Berlin',
    );

    test('yaz saatine geçişte öğle vakti bir saat ileri kayar', () {
      final servis = VakitServisi(berlin, const HesapAyarlari());
      // 2026'da Avrupa'da yaz saati 29 Mart Pazar günü başlar
      final once = servis.gunluk(DateTime(2026, 3, 28))[VakitTuru.ogle];
      final sonra = servis.gunluk(DateTime(2026, 3, 29))[VakitTuru.ogle];
      expect(_dakika(sonra) - _dakika(once), closeTo(60, 2));
    });

    test('kış saatine dönüşte öğle vakti bir saat geri gelir', () {
      final servis = VakitServisi(berlin, const HesapAyarlari());
      // 25 Ekim 2026 Pazar
      final once = servis.gunluk(DateTime(2026, 10, 24))[VakitTuru.ogle];
      final sonra = servis.gunluk(DateTime(2026, 10, 25))[VakitTuru.ogle];
      expect(_dakika(sonra) - _dakika(once), closeTo(-60, 2));
    });

    test('Türkiye yıl boyu UTC+3: geçiş günlerinde sıçrama yok', () {
      final servis = VakitServisi(Konum.istanbul, const HesapAyarlari());
      final once = servis.gunluk(DateTime(2026, 3, 28))[VakitTuru.ogle];
      final sonra = servis.gunluk(DateTime(2026, 3, 29))[VakitTuru.ogle];
      expect((_dakika(sonra) - _dakika(once)).abs(), lessThanOrEqualTo(1));
    });

    test('bilinmeyen saat dilimi uygulamayı düşürmez', () {
      const k = Konum(ad: 'X', enlem: 40, boylam: 30, dilim: 'Yok/Boyle');
      expect(
        VakitServisi(k, const HesapAyarlari()).gunluk(DateTime(2026, 5, 1)),
        isA<GunlukVakitler>(),
      );
    });
  });

  group('şimdiki ve sıradaki vakit', () {
    final bugun = _istanbul(DateTime(2026, 10, 2));
    final yarin = _istanbul(DateTime(2026, 10, 3));
    DateTime an(int saat, int dakika) => DateTime(2026, 10, 2, saat, dakika);

    test('gün içinde', () {
      final d = vakitDurumu(an(13, 52), bugun, yarin);
      expect(d.simdiki, VakitTuru.ogle);
      expect(d.sonraki, VakitTuru.ikindi);
      expect(d.yarinMi(an(13, 52)), isFalse);
      expect(
        d.kalan(an(13, 52)),
        bugun.zaman(VakitTuru.ikindi).difference(an(13, 52)),
      );
    });

    test('vakit tam girdiği anda o vakit şimdiki olur', () {
      final ikindi = bugun.zaman(VakitTuru.ikindi);
      final d = vakitDurumu(ikindi, bugun, yarin);
      expect(d.simdiki, VakitTuru.ikindi);
      expect(d.sonraki, VakitTuru.aksam);
    });

    test('gece yarısından sonra, imsaktan önce', () {
      final d = vakitDurumu(an(0, 30), bugun, yarin);
      expect(d.simdiki, isNull);
      expect(d.sonraki, VakitTuru.imsak);
      expect(d.sonrakiZaman, bugun.zaman(VakitTuru.imsak));
      expect(d.yarinMi(an(0, 30)), isFalse);
    });

    test('yatsıdan sonra sıradaki vakit yarının imsakıdır', () {
      final d = vakitDurumu(an(23, 0), bugun, yarin);
      expect(d.simdiki, VakitTuru.yatsi);
      expect(d.sonraki, VakitTuru.imsak);
      expect(d.sonrakiZaman, yarin.zaman(VakitTuru.imsak));
      expect(d.yarinMi(an(23, 0)), isTrue);
      expect(d.kalan(an(23, 0)).inHours, inInclusiveRange(5, 7));
    });

    test('gece yarısında (00:00) geri sayım kesintisiz devam eder', () {
      final oncesi = vakitDurumu(an(23, 59), bugun, yarin);
      final sonrasi = vakitDurumu(
        DateTime(2026, 10, 3),
        yarin,
        _istanbul(DateTime(2026, 10, 4)),
      );
      expect(oncesi.sonrakiZaman, sonrasi.sonrakiZaman);
    });
  });

  group('Diyanet referansları (±2 dk)', () {
    final dosya =
        jsonDecode(
              File('test/fixtures/diyanet_referans.json').readAsStringSync(),
            )
            as Map<String, dynamic>;
    final kayitlar = (dosya['kayitlar'] as List).cast<Map<String, dynamic>>();
    final sehirler =
        ((jsonDecode(File('assets/data/sehirler.json').readAsStringSync())
                    as Map<String, dynamic>)['sehirler']
                as List)
            .cast<Map<String, dynamic>>()
            .map(Konum.fromJson)
            .toList();

    test(
      'referans dosyası dolu',
      () => expect(kayitlar, isNotEmpty),
      skip: kayitlar.isEmpty
          ? 'test/fixtures/diyanet_referans.json boş; Diyanet vakitleri '
                'eklenince bu testler çalışır'
          : false,
    );

    for (final k in kayitlar) {
      test('${k['sehir']} ${k['tarih']}', () {
        final konum = sehirler.firstWhere(
          (s) => s.ad == k['sehir'] && s.ust.isEmpty,
        );
        final v = VakitServisi(
          konum,
          const HesapAyarlari(),
        ).gunluk(DateTime.parse(k['tarih'] as String));
        for (final tur in VakitTuru.values) {
          final beklenen = (k[tur.name] as String).split(':').map(int.parse);
          expect(
            _dakika(v[tur]),
            closeTo(beklenen.first * 60 + beklenen.last, 2),
            reason: '${tur.name}: hesaplanan ${v[tur].metin}',
          );
        }
      });
    }

    test('en az sekiz Türkiye şehri ve yaz saati olan şehirler var', () {
      final adlar = kayitlar.map((k) => k['sehir']).toSet();
      expect(
        adlar,
        containsAll([
          'İstanbul',
          'Ankara',
          'İzmir',
          'Erzurum',
          'Van',
          'Trabzon',
          'Berlin',
          'Amsterdam',
        ]),
      );
    });

    // Avrupa'da yaz günlerinde Diyanet imsak ve yatsıyı açıyla değil,
    // kısaltılmış bir süreyle yayımlar; motor bunu taklit etmez
    // (docs/vakit_dogrulama.md). Güneşe bağlı dört vakit yine tutmalıdır.
    for (final k
        in (dosya['yaz_farklari'] as List).cast<Map<String, dynamic>>()) {
      test('yaz: ${k['sehir']} ${k['tarih']} (güneş, öğle, ikindi, akşam)', () {
        final konum = sehirler.firstWhere(
          (s) => s.ad == k['sehir'] && s.ust.isEmpty,
        );
        final v = VakitServisi(
          konum,
          const HesapAyarlari(),
        ).gunluk(DateTime.parse(k['tarih'] as String));
        for (final tur in [
          VakitTuru.gunes,
          VakitTuru.ogle,
          VakitTuru.ikindi,
          VakitTuru.aksam,
        ]) {
          final beklenen = (k[tur.name] as String).split(':').map(int.parse);
          expect(
            _dakika(v[tur]),
            closeTo(beklenen.first * 60 + beklenen.last, 2),
            reason: '${tur.name}: hesaplanan ${v[tur].metin}',
          );
        }
      });
    }
  });

  group('yurt dışında Diyanet yatsı açısı', () {
    GunlukVakitler berlin({required bool yurtDisi, HesapYontemi? yontem}) =>
        vakitleriHesapla(
          enlem: 52.5244,
          boylam: 13.4105,
          gun: DateTime(2027, 1, 15),
          utcFarki: const Duration(hours: 1),
          ayar: HesapAyarlari(yontem: yontem ?? HesapYontemi.diyanet),
          yurtDisi: yurtDisi,
        );

    test('16° ile yatsı daha erken girer, diğer vakitler değişmez', () {
      final tr = berlin(yurtDisi: false);
      final ab = berlin(yurtDisi: true);
      expect(
        _dakika(tr[VakitTuru.yatsi]) - _dakika(ab[VakitTuru.yatsi]),
        inInclusiveRange(5, 12),
      );
      for (final tur in VakitTuru.values.where((t) => t != VakitTuru.yatsi)) {
        expect(ab[tur].metin, tr[tur].metin, reason: tur.name);
      }
    });

    test('diğer yöntemleri etkilemez', () {
      for (final y in HesapYontemi.values.where(
        (y) => y != HesapYontemi.diyanet,
      )) {
        expect(
          berlin(yurtDisi: true, yontem: y)[VakitTuru.yatsi].metin,
          berlin(yurtDisi: false, yontem: y)[VakitTuru.yatsi].metin,
          reason: y.name,
        );
      }
    });

    test('yaz kısaltması ölçütü: fecir gecenin yüzde 23\'ünü aşınca', () {
      GunlukVakitler lyon(DateTime gun, int utc) => vakitleriHesapla(
        enlem: 45.7491,
        boylam: 4.8479,
        gun: gun,
        utcFarki: Duration(hours: utc),
        yurtDisi: true,
      );
      // Diyanet Lyon'da 10 Mayıs'ta açıyla, 21 Haziran'da kısaltarak yayımlar
      expect(diyanetYazKisaltmasi(lyon(DateTime(2027, 1, 15), 1)), isFalse);
      expect(diyanetYazKisaltmasi(lyon(DateTime(2027, 5, 10), 2)), isFalse);
      expect(diyanetYazKisaltmasi(lyon(DateTime(2027, 6, 21), 2)), isTrue);
      // Kuralla belirlenen günlerde ayrı açıklama gösterilir
      final berlin = vakitleriHesapla(
        enlem: 52.5244,
        boylam: 13.4105,
        gun: DateTime(2027, 6, 21),
        utcFarki: const Duration(hours: 2),
        yurtDisi: true,
      );
      expect(berlin.tahminiVakitler, isNotEmpty);
      expect(diyanetYazKisaltmasi(berlin), isFalse);
    });

    test('ülkesi bilinmeyen konum Türkiye gibi hesaplanır', () {
      const bilinmeyen = Konum(ad: 'X', enlem: 50, boylam: 10, dilim: 'UTC');
      expect(bilinmeyen.yurtDisi, isFalse);
      expect(Konum.istanbul.yurtDisi, isFalse);
      expect(
        const Konum(
          ad: 'Berlin',
          ulke: 'Almanya',
          enlem: 52.5,
          boylam: 13.4,
          dilim: 'Europe/Berlin',
        ).yurtDisi,
        isTrue,
      );
    });
  });
}
