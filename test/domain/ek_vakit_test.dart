import 'package:abyad/features/vakitler/domain/ek_vakitler.dart';
import 'package:abyad/features/vakitler/domain/gunluk_vakitler.dart';
import 'package:abyad/features/vakitler/domain/vakit_hesaplama.dart';
import 'package:flutter_test/flutter_test.dart';

GunlukVakitler _vakit(
  DateTime gun, {
  double enlem = 41.0138,
  double boylam = 28.9497,
  int utc = 3,
}) => vakitleriHesapla(
  enlem: enlem,
  boylam: boylam,
  gun: gun,
  utcFarki: Duration(hours: utc),
);

void main() {
  final gun = DateTime(2026, 10, 2);
  final bugun = _vakit(gun);
  final yarin = _vakit(DateTime(2026, 10, 3));

  group('ek vakitler (İstanbul, 2 Ekim 2026)', () {
    final ek = ekVakitleriHesapla(bugun, yarin);

    test('doğuş kerahati güneşle başlar, 45 dakika sürer', () {
      expect(ek.dogusKerahati.baslangic, bugun.zaman(VakitTuru.gunes));
      expect(ek.dogusKerahati.sure, const Duration(minutes: 45));
    });

    test('istiva kerahati öğle vaktinde biter', () {
      expect(ek.istivaKerahati.bitis, bugun.zaman(VakitTuru.ogle));
      expect(ek.istivaKerahati.sure, const Duration(minutes: 10));
    });

    test('batış kerahati akşam vaktinde biter, 45 dakika sürer', () {
      expect(ek.batisKerahati.bitis, bugun.zaman(VakitTuru.aksam));
      expect(ek.batisKerahati.sure, const Duration(minutes: 45));
      expect(
        ek.batisKerahati.baslangic.isAfter(bugun.zaman(VakitTuru.ikindi)),
        isTrue,
      );
    });

    test('duhâ iki kerahat vaktinin arasını doldurur', () {
      expect(ek.duha!.baslangic, ek.dogusKerahati.bitis);
      expect(ek.duha!.bitis, ek.istivaKerahati.baslangic);
      expect(ek.duha!.sure, greaterThan(const Duration(hours: 4)));
    });

    test('gecenin son üçte biri yarının imsakında biter', () {
      final aksam = bugun.zaman(VakitTuru.aksam);
      final imsak = yarin.zaman(VakitTuru.imsak);
      final son = ek.gecenSonUcteBiri!;
      expect(son.bitis, imsak);
      expect(son.sure.inMinutes, imsak.difference(aksam).inMinutes ~/ 3);
      expect(son.baslangic.day, 3, reason: 'gece yarısından sonra başlar');
      expect(son.baslangic.isAfter(bugun.zaman(VakitTuru.yatsi)), isTrue);
    });

    test('bir anın kerahat vaktine denk gelip gelmediği', () {
      final gunes = bugun.zaman(VakitTuru.gunes);
      final ogle = bugun.zaman(VakitTuru.ogle);
      DateTime sonra(DateTime t, int dk) => t.add(Duration(minutes: dk));
      expect(ek.kerahat(gunes), ek.dogusKerahati);
      expect(ek.kerahat(sonra(gunes, 44)), ek.dogusKerahati);
      expect(ek.kerahat(sonra(gunes, 45)), isNull, reason: 'bitiş hariçtir');
      expect(ek.kerahat(sonra(ogle, -5)), ek.istivaKerahati);
      expect(ek.kerahat(ogle), isNull, reason: 'öğle vakti girmiştir');
      expect(
        ek.kerahat(sonra(bugun.zaman(VakitTuru.aksam), -1)),
        ek.batisKerahati,
      );
      expect(ek.kerahat(DateTime(2026, 10, 2, 10)), isNull);
    });
  });

  group('süreler', () {
    test('verilen dakikalar uygulanır', () {
      final ek = ekVakitleriHesapla(
        bugun,
        yarin,
        sureler: const EkVakitSureleri(
          dogusDakika: 50,
          istivaDakika: 20,
          batisDakika: 40,
        ),
      );
      expect(ek.dogusKerahati.sure.inMinutes, 50);
      expect(ek.istivaKerahati.sure.inMinutes, 20);
      expect(ek.batisKerahati.sure.inMinutes, 40);
    });

    test('eksik ya da bozuk alanlarda varsayılana düşer', () {
      final s = EkVakitSureleri.fromJson({
        'dogus_dakika': 50,
        'istiva_dakika': 'on',
        'batis_dakika': -3,
      });
      expect(s.dogusDakika, 50);
      expect(s.istivaDakika, 10);
      expect(s.batisDakika, 45);
    });
  });

  group('yüksek enlem', () {
    test('İstanbul\'da hiçbir vakit tahminî değildir', () {
      for (final g in [gun, DateTime(2026, 6, 21), DateTime(2026, 12, 21)]) {
        expect(_vakit(g).tahminiVakitler, isEmpty, reason: '$g');
      }
    });

    test('Berlin, 21 Haziran: imsak ve yatsı kuralla belirlenir', () {
      final v = _vakit(
        DateTime(2026, 6, 21),
        enlem: 52.5244,
        boylam: 13.4105,
        utc: 2,
      );
      expect(v.tahminiVakitler, {VakitTuru.imsak, VakitTuru.yatsi});
    });

    test('Berlin, kışın: vakitler astronomik olarak oluşur', () {
      final v = _vakit(
        DateTime(2026, 12, 21),
        enlem: 52.5244,
        boylam: 13.4105,
        utc: 1,
      );
      expect(v.tahminiVakitler, isEmpty);
    });

    test('kutup gündüzünde güneş ve akşam da tahminîdir', () {
      final v = _vakit(
        DateTime(2026, 6, 21),
        enlem: 78.2,
        boylam: 15.6,
        utc: 2,
      );
      expect(
        v.tahminiVakitler,
        VakitTuru.values.toSet()
          ..remove(VakitTuru.ogle)
          ..remove(VakitTuru.ikindi),
      );
    });

    test('uç enlemlerde ek vakitler hata fırlatmaz', () {
      for (final enlem in [52.5, 60.0, 69.65, 78.2, -77.8, 89.9]) {
        for (final g in [DateTime(2026, 6, 21), DateTime(2026, 12, 21)]) {
          final ek = ekVakitleriHesapla(
            _vakit(g, enlem: enlem, boylam: 18.95, utc: 1),
            _vakit(
              DateTime(g.year, g.month, g.day + 1),
              enlem: enlem,
              boylam: 18.95,
              utc: 1,
            ),
          );
          final duha = ek.duha;
          if (duha != null) expect(duha.sure, greaterThan(Duration.zero));
          final gece = ek.gecenSonUcteBiri;
          if (gece != null) {
            expect(gece.sure, greaterThan(Duration.zero));
            expect(gece.sure, lessThan(const Duration(hours: 8)));
          }
        }
      }
    });
  });
}
