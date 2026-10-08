import 'dart:convert';

import 'package:abyad/core/tarih/hicri.dart';
import 'package:abyad/features/ayarlar/domain/ayarlar.dart';
import 'package:abyad/features/bildirim/domain/bildirim_plani.dart';
import 'package:abyad/features/kaza/domain/kaza.dart';
import 'package:abyad/features/kible/domain/kible.dart';
import 'package:abyad/features/konum/domain/konum.dart';
import 'package:abyad/features/vakitler/domain/gunluk_vakitler.dart';
import 'package:abyad/features/vakitler/domain/vakit_hesaplama.dart';
import 'package:abyad/features/zikirmatik/ui/zikirmatik_ekrani.dart';
import 'package:flutter_test/flutter_test.dart';

GunlukVakitler _gun(DateTime gun) => vakitleriHesapla(
  enlem: 41.0138,
  boylam: 28.9497,
  gun: gun,
  utcFarki: const Duration(hours: 3),
);

void main() {
  group('kıble açısı', () {
    test('bilinen şehirler', () {
      expect(kibleAcisi(41.0138, 28.9497), closeTo(151.6, 0.6)); // İstanbul
      expect(kibleAcisi(39.9199, 32.8543), closeTo(160.1, 0.8)); // Ankara
      expect(kibleAcisi(52.5244, 13.4105), closeTo(136.7, 0.8)); // Berlin
      expect(kibleAcisi(52.374, 4.8897), closeTo(125.7, 1.0)); // Amsterdam
    });

    test("Kâbe'nin kuzeyinden güneye, güneyinden kuzeye bakılır", () {
      expect(kibleAcisi(kabeEnlem + 10, kabeBoylam), closeTo(180, 0.01));
      expect(kibleAcisi(kabeEnlem - 10, kabeBoylam), closeTo(0, 0.01));
    });

    test('yön adı ve açı farkı', () {
      expect(yon(151.6), Yon.guneydogu);
      expect(yon(359), Yon.kuzey);
      expect(yon(0), Yon.kuzey);
      expect(yon(200), Yon.guney);
      expect(aciFarki(10, 350), 20);
      expect(aciFarki(350, 10), -20);
      expect(aciFarki(180, 0).abs(), 180);
    });
  });

  group('hicrî tarih', () {
    test('düzeltme günü ileri/geri alır', () {
      final gun = DateTime(2026, 10, 2);
      final h = hicriTarih(gun);
      expect(h.yil, 1448);
      expect(h.ay, 4); // Rebiülâhir
      final ileri = hicriTarih(gun, duzeltme: 1);
      final geri = hicriTarih(gun, duzeltme: -1);
      expect(ileri.gun, h.gun + 1);
      expect(geri.gun, h.gun - 1);
    });

    test('ay başında düzeltme önceki aya geçer', () {
      // 1 Receb 1448'e denk gelen gün
      final gun = DateTime(2026, 12, 10);
      final h = hicriTarih(gun);
      expect((h.ay, h.gun), (7, 1));
      final geri = hicriTarih(gun, duzeltme: -1);
      expect(geri.ay, 6);
      expect(geri.gun, greaterThanOrEqualTo(29));
    });

    test("Diyanet'in ay başlangıçlarıyla aynı günü gösterir", () {
      (int, int, int) h(int y, int a, int g) {
        final t = hicriTarih(DateTime(y, a, g));
        return (t.yil, t.ay, t.gun);
      }

      // Ümmü'l-Kurâ hesabının bir gün farklı düştüğü iki ay
      expect(h(2026, 2, 19), (1447, 9, 1)); // 1 Ramazan 1447
      expect(h(2026, 11, 10), (1448, 6, 1)); // 1 Cemâziyelâhir 1448
      expect(h(2026, 11, 9), (1448, 5, 29));
      // Dinî günler listesindeki günler
      expect(h(2027, 2, 8), (1448, 9, 1)); // Ramazan başlangıcı
      expect(h(2027, 3, 5), (1448, 9, 26)); // Kadir Gecesi
      expect(h(2027, 3, 9), (1448, 10, 1)); // Ramazan Bayramı
      expect(h(2027, 5, 16), (1448, 12, 10)); // Kurban Bayramı
      expect(h(2027, 6, 6), (1449, 1, 1)); // Hicrî yılbaşı
      expect(h(2027, 12, 24), (1449, 7, 26)); // Miraç Kandili
    });

    test('tablonun dışındaki tarihlerde hesaba döner ve kesintisiz sürer', () {
      // Tablodan önce ve sonra da geçerli bir tarih verir
      for (final gun in [DateTime(2025, 6, 1), DateTime(2029, 1, 1)]) {
        final t = hicriTarih(gun);
        expect(t.ay, inInclusiveRange(1, 12));
        expect(t.gun, inInclusiveRange(1, 30));
      }
      // Tablonun son ayından hesaba geçerken gün atlamaz ya da tekrarlamaz
      var onceki = hicriTarih(DateTime(2027, 12, 29));
      for (var i = 1; i <= 45; i++) {
        final t = hicriTarih(DateTime(2027, 12, 29 + i));
        final ardisik =
            (t.ay == onceki.ay && t.gun == onceki.gun + 1) ||
            (t.gun == 1 && onceki.gun >= 29);
        expect(ardisik, isTrue, reason: 'gün $i: ${t.yil}-${t.ay}-${t.gun}');
        onceki = t;
      }
    });
  });

  group('bildirim planı', () {
    final gunler = [
      for (var i = 0; i < 7; i++) _gun(DateTime(2026, 10, 2 + i)),
    ];
    final simdi = DateTime(2026, 10, 2, 13, 52);

    test('yalnızca gelecekteki ve açık vakitler planlanır', () {
      final plan = bildirimPlani(
        simdi: simdi,
        gunler: gunler,
        ayar: const BildirimAyarlari(
          vakitler: {
            VakitTuru.imsak: VakitBildirimAyari(acik: true),
            VakitTuru.gunes: VakitBildirimAyari(acik: false),
            VakitTuru.ogle: VakitBildirimAyari(acik: true),
            VakitTuru.ikindi: VakitBildirimAyari(acik: true),
            VakitTuru.aksam: VakitBildirimAyari(acik: true),
            VakitTuru.yatsi: VakitBildirimAyari(acik: true),
          },
        ),
      );
      expect(plan.every((b) => b.zaman.isAfter(simdi)), isTrue);
      expect(plan.any((b) => b.vakit == VakitTuru.gunes), isFalse);
      // Bugün: ikindi, akşam, yatsı (3) + 6 gün x 5 vakit
      expect(plan, hasLength(3 + 6 * 5));
      expect(plan.first.vakit, VakitTuru.ikindi);
      for (var i = 1; i < plan.length; i++) {
        expect(plan[i].zaman.isBefore(plan[i - 1].zaman), isFalse);
      }
    });

    test('kimlikler benzersizdir', () {
      final plan = bildirimPlani(
        simdi: simdi,
        gunler: gunler,
        ayar: BildirimAyarlari.varsayilan,
        onemliGunler: [
          HatirlatilacakGun(ad: 'Regaip Kandili', tarih: DateTime(2026, 10, 5)),
        ],
      );
      expect(plan.map((b) => b.id).toSet(), hasLength(plan.length));
    });

    test('ön hatırlatma vakitten önce ve kısa uyarı sesiyle', () {
      final plan = bildirimPlani(
        simdi: simdi,
        gunler: gunler.take(1).toList(),
        ayar: BildirimAyarlari.varsayilan,
      );
      final ikindi = plan.firstWhere(
        (b) => b.tur == BildirimTuru.vakit && b.vakit == VakitTuru.ikindi,
      );
      final once = plan.firstWhere(
        (b) =>
            b.tur == BildirimTuru.onHatirlatma && b.vakit == VakitTuru.ikindi,
      );
      expect(ikindi.zaman.difference(once.zaman).inMinutes, 15);
      expect(once.ses, BildirimSesi.kisa);
      expect(ikindi.ses, BildirimSesi.ezan);
    });

    test('ön hatırlatma kapalıyken üretilmez', () {
      final plan = bildirimPlani(
        simdi: simdi,
        gunler: gunler,
        ayar: BildirimAyarlari(vakitler: BildirimAyarlari.varsayilan.vakitler),
      );
      expect(plan.any((b) => b.tur == BildirimTuru.onHatirlatma), isFalse);
    });

    test('Cuma öğlesi sessiz seçilince titreşim olur, diğer günler olmaz', () {
      final plan = bildirimPlani(
        simdi: DateTime(2026, 10, 2, 1),
        gunler: gunler,
        ayar: BildirimAyarlari(
          vakitler: BildirimAyarlari.varsayilan.vakitler,
          cumaSessiz: true,
        ),
      );
      final ogleler = plan.where((b) => b.vakit == VakitTuru.ogle).toList();
      expect(ogleler, hasLength(7));
      for (final b in ogleler) {
        expect(
          b.ses,
          b.zaman.weekday == DateTime.friday
              ? BildirimSesi.titresim
              : BildirimSesi.ezan,
        );
      }
    });

    test('iOS sınırı: en yakın bildirimler tutulur', () {
      final plan = bildirimPlani(
        simdi: simdi,
        gunler: gunler,
        ayar: BildirimAyarlari.varsayilan,
        azami: 20,
      );
      expect(plan, hasLength(20));
      expect(
        plan.last.zaman.isBefore(DateTime(2026, 10, 5)),
        isTrue,
        reason: 'sınır, uzak günleri atar',
      );
    });

    test('önemli gün hatırlatması o gün saat 10:00', () {
      final plan = bildirimPlani(
        simdi: simdi,
        gunler: const [],
        ayar: BildirimAyarlari.varsayilan,
        onemliGunler: [
          HatirlatilacakGun(
            ad: 'Regaip Kandili',
            tarih: DateTime(2026, 12, 10),
          ),
          HatirlatilacakGun(ad: 'Geçmiş', tarih: DateTime(2026, 8, 24)),
        ],
      );
      expect(plan, hasLength(1));
      expect(plan.single.zaman, DateTime(2026, 12, 10, 10));
      expect(plan.single.gunAdi, 'Regaip Kandili');
    });
  });

  group('kaza', () {
    test('tahmini bitiş', () {
      expect(tahminiBitisGunu(1248, 2), 624);
      expect(tahminiBitisGunu(5, 2), 3);
      expect(tahminiBitisGunu(0, 2), isNull);
      expect(tahminiBitisGunu(10, 0), isNull);
    });

    test('süre yıl/ay/gün olarak bölünür', () {
      expect(sureyeBol(624), (yil: 1, ay: 8, gun: 19));
      expect(sureyeBol(20), (yil: 0, ay: 0, gun: 20));
    });

    test('sihirbaz: yıl ve ay girdisi', () {
      const h = KazaHesabi(
        namazKilinmayanYil: 2,
        namazKilinmayanAy: 3,
        orucTutulmayanYil: 2,
      );
      expect(h.sonuc[KazaTuru.sabah], 2 * 365 + 90);
      expect(h.sonuc[KazaTuru.vitir], 2 * 365 + 90);
      expect(h.sonuc[KazaTuru.oruc], 60);
      expect(h.sonuc, hasLength(KazaTuru.values.length));
    });

    test('sihirbaz: özür günleri namazdan düşülür, oruçtan düşülmez', () {
      const h = KazaHesabi(
        namazKilinmayanYil: 1,
        namazKilinmayanAy: 0,
        orucTutulmayanYil: 1,
        ozurluGunAylik: 7,
      );
      expect(h.sonuc[KazaTuru.ogle], 365 - 12 * 7);
      expect(h.sonuc[KazaTuru.oruc], 30);
    });
  });

  group('zikir sayacı', () {
    test('hedefe ulaşınca tur artar ve sayaç sıfırlanır', () {
      var s = const ZikirSayaci(hedef: 3);
      var bitti = false;
      (s, bitti) = s.artir();
      expect((s.sayi, s.tur, bitti), (1, 0, false));
      (s, bitti) = s.artir();
      (s, bitti) = s.artir();
      expect((s.sayi, s.tur, bitti), (0, 1, true));
    });

    test('serbest hedefte tur olmaz', () {
      var s = const ZikirSayaci(hedef: 0);
      for (var i = 0; i < 150; i++) {
        s = s.artir().$1;
      }
      expect((s.sayi, s.tur), (150, 0));
    });
  });

  group('konum ve arama', () {
    const sehirler = [
      Konum(
        ad: 'İstanbul',
        enlem: 41.01,
        boylam: 28.95,
        dilim: 'Europe/Istanbul',
      ),
      Konum(ad: 'Iğdır', enlem: 39.92, boylam: 44.04, dilim: 'Europe/Istanbul'),
      Konum(
        ad: 'Üsküdar',
        ust: 'İstanbul',
        enlem: 41.02,
        boylam: 29.02,
        dilim: 'Europe/Istanbul',
      ),
      Konum(
        ad: 'Şanlıurfa',
        enlem: 37.17,
        boylam: 38.79,
        dilim: 'Europe/Istanbul',
      ),
    ];

    test('Türkçe harf ve büyük/küçük harf duyarsız', () {
      expect(aramaAnahtari('ŞANLIURFA'), aramaAnahtari('şanlıurfa'));
      expect(sehirAra(sehirler, 'sanli').single.ad, 'Şanlıurfa');
      expect(sehirAra(sehirler, 'ISTANBUL').first.ad, 'İstanbul');
      expect(sehirAra(sehirler, 'uskudar').single.ad, 'Üsküdar');
      expect(sehirAra(sehirler, 'igdir').single.ad, 'Iğdır');
    });

    test('il adıyla aranınca ilçeleri de gelir, il önce', () {
      final sonuc = sehirAra(sehirler, 'istan');
      expect(sonuc.map((k) => k.ad), ['İstanbul', 'Üsküdar']);
    });

    test('boş aramada yalnızca il ve şehirler listelenir', () {
      expect(sehirAra(sehirler, '').any((k) => k.ust.isNotEmpty), isFalse);
    });

    test('en yakın yerleşim', () {
      expect(enYakinSehir(sehirler, 41.03, 29.03)!.ad, 'Üsküdar');
      expect(enYakinSehir(sehirler, 37.0, 39.0)!.ad, 'Şanlıurfa');
    });
  });

  group('ayarlar', () {
    test('JSON gidiş-dönüşte hiçbir alan kaybolmaz', () {
      final a = const Ayarlar().copyWith(
        ilkAcilisTamam: true,
        yaziBoyutu: YaziBoyutu.cokBuyuk,
        yuksekKontrast: true,
        yontem: HesapYontemi.misir,
        duzeltmeler: {VakitTuru.ogle: 2, VakitTuru.yatsi: -3},
        hicriDuzeltme: -1,
        bildirim: const BildirimAyarlari(
          vakitler: {
            VakitTuru.imsak: VakitBildirimAyari(
              acik: false,
              ses: BildirimSesi.titresim,
            ),
            VakitTuru.gunes: VakitBildirimAyari(acik: true),
            VakitTuru.ogle: VakitBildirimAyari(acik: true),
            VakitTuru.ikindi: VakitBildirimAyari(acik: true),
            VakitTuru.aksam: VakitBildirimAyari(acik: true),
            VakitTuru.yatsi: VakitBildirimAyari(acik: true),
          },
          onceDakika: 0,
          cumaSessiz: true,
        ),
        kazaGizli: true,
        kazaTempo: 5,
        hatirlatilanGunler: {'regaip_1448'},
        kuranYaziOlcegi: 1.4,
        ozelZikir: 'Estağfirullah',
      );
      final b = Ayarlar.fromJson(
        jsonDecode(jsonEncode(a.toJson())) as Map<String, dynamic>,
      );
      expect(jsonEncode(b.toJson()), jsonEncode(a.toJson()));
      expect(b.bildirim.vakitler[VakitTuru.imsak]!.ses, BildirimSesi.titresim);
      expect(b.duzeltmeler[VakitTuru.yatsi], -3);
    });

    test('eksik ve tanınmayan alanlar varsayılana düşer', () {
      final a = Ayarlar.fromJson({
        'yaziBoyutu': 'dev',
        'yontem': 'bilinmeyen',
        'bildirim': {'onceDakika': 30},
        'fazladan': 1,
      });
      expect(a.yaziBoyutu, YaziBoyutu.normal);
      expect(a.yontem, HesapYontemi.diyanet);
      expect(a.bildirim.onceDakika, 30);
      expect(a.bildirim.vakitler[VakitTuru.gunes]!.acik, isFalse);
      expect(a.konum.ad, 'İstanbul');
    });
  });
}
