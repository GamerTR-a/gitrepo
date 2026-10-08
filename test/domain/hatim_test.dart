import 'dart:convert';
import 'dart:math';

import 'package:abyad/core/storage/ayarlar_deposu.dart';
import 'package:abyad/features/hatim/data/hatim_saglayici.dart';
import 'package:abyad/features/hatim/domain/hatim.dart';
import 'package:abyad/features/vakitler/data/vakit_saglayicilari.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final simdi = DateTime(2026, 10, 5, 9);
  Hatim yeni(BolmeSekli bolme) => Hatim.yeni(
    kod: 'abcdefghjkmn',
    baslik: 'Ramazan Aile Hatmi',
    bolmeSekli: bolme,
    simdi: simdi,
  );

  group('hatim payları', () {
    test('cüz hatmi 30 pay, sayfa hatmi 604 sayfayı boşluksuz kaplar', () {
      final cuz = yeni(BolmeSekli.cuz);
      expect(cuz.paylar, hasLength(30));
      expect(cuz.paylar.first.baslangic, 1);
      expect(cuz.paylar.last.bitis, 30);

      final sayfa = yeni(BolmeSekli.sayfa);
      expect(sayfa.paylar, hasLength(121));
      expect(sayfa.paylar.first.baslangic, 1);
      expect(sayfa.paylar.last.baslangic, 601);
      expect(sayfa.paylar.last.bitis, 604);
      for (var i = 1; i < sayfa.paylar.length; i++) {
        expect(sayfa.paylar[i].baslangic, sayfa.paylar[i - 1].bitis + 1);
        expect(sayfa.paylar[i].no, i + 1);
      }
      expect(sayfa.paylar.every((p) => p.durum == PayDurumu.bos), isTrue);
    });

    test('aynı payı iki kişiden yalnızca ilki alır', () {
      final (ilk, s1) = yeni(BolmeSekli.cuz).payAl(20, 'ayse', simdi);
      expect(s1, PaySonucu.tamam);
      expect(ilk.pay(20).katilimci, 'ayse');

      final (ikinci, s2) = ilk.payAl(20, 'fatma', simdi);
      expect(s2, PaySonucu.alinmis);
      expect(identical(ikinci, ilk), isTrue);
      expect(ikinci.pay(20).katilimci, 'ayse');
    });

    test('okudum, geri al ve bırak yalnızca payın sahibinde çalışır', () {
      final sonra = simdi.add(const Duration(hours: 2));
      var (h, _) = yeni(BolmeSekli.cuz).payAl(3, 'ayse', simdi);

      expect(h.okundu(3, 'fatma', sonra).$2, PaySonucu.gecersiz);
      expect(h.payBirak(3, 'fatma', sonra).$2, PaySonucu.gecersiz);
      expect(h.okunmadi(3, 'ayse', sonra).$2, PaySonucu.gecersiz);
      expect(h.okundu(4, 'ayse', sonra).$2, PaySonucu.gecersiz);

      (h, _) = h.okundu(3, 'ayse', sonra);
      expect(h.pay(3).durum, PayDurumu.okundu);
      expect(h.okunan, 1);
      expect(h.sonHareket, sonra);
      // Okunan pay bırakılamaz, başkası da alamaz
      expect(h.payBirak(3, 'ayse', sonra).$2, PaySonucu.gecersiz);
      expect(h.payAl(3, 'fatma', sonra).$2, PaySonucu.alinmis);

      (h, _) = h.okunmadi(3, 'ayse', sonra);
      expect(h.pay(3).durum, PayDurumu.alindi);
      (h, _) = h.payBirak(3, 'ayse', sonra);
      expect(h.pay(3).durum, PayDurumu.bos);
      expect(h.pay(3).katilimci, isNull);
      expect(h.payAl(3, 'fatma', sonra).$2, PaySonucu.tamam);
    });

    test('sınır dışı pay numarası geçersiz', () {
      final h = yeni(BolmeSekli.cuz);
      expect(h.payAl(0, 'a', simdi).$2, PaySonucu.gecersiz);
      expect(h.payAl(31, 'a', simdi).$2, PaySonucu.gecersiz);
      expect(
        yeni(BolmeSekli.sayfa).payAl(122, 'a', simdi).$2,
        PaySonucu.gecersiz,
      );
    });

    test('bütün paylar okununca hatim tamamlanır', () {
      var h = yeni(BolmeSekli.cuz);
      for (var c = 1; c <= 30; c++) {
        expect(h.tamamlandi, isFalse);
        (h, _) = h.payAl(c, 'ayse', simdi);
        (h, _) = h.okundu(c, 'ayse', simdi);
      }
      expect(h.tamamlandi, isTrue);
      expect(h.oran, 1);
    });

    test('JSON gidiş dönüşü', () {
      final (h, _) = Hatim.yeni(
        kod: 'abcdefghjkmn',
        baslik: 'Aile Hatmi',
        not: 'Annemizin ruhu için',
        bolmeSekli: BolmeSekli.sayfa,
        hedefTarih: DateTime(2027, 3, 1),
        simdi: simdi,
      ).payAl(7, 'ayse', simdi);
      final geri = Hatim.fromJson(
        jsonDecode(jsonEncode(h.toJson())) as Map<String, dynamic>,
      );
      expect(geri.toJson(), h.toJson());
      expect(geri.pay(7).durum, PayDurumu.alindi);
      expect(geri.hedefTarih, DateTime(2027, 3, 1));
      expect(geri.not, 'Annemizin ruhu için');
    });
  });

  group('kod ve metin denetimi', () {
    test('hatim kodu en az 10 karakter, karışan harf içermez', () {
      final r = Random(1);
      final kodlar = {for (var i = 0; i < 200; i++) hatimKoduUret(r)};
      expect(kodlar, hasLength(200));
      for (final k in kodlar) {
        expect(k.length, greaterThanOrEqualTo(10));
        expect(RegExp(r'^[a-hj-km-np-z2-9]+$').hasMatch(k), isTrue, reason: k);
      }
      expect(katilimciAnahtariUret(r), matches(RegExp(r'^[0-9a-f]{32}$')));
    });

    test('başlık ve not: boşluk, uzunluk ve link', () {
      MetinHatasi? baslik(String m) =>
          hatimMetniDenetle(m, sinir: hatimBaslikSiniri, zorunlu: true);
      expect(baslik('Ramazan Aile Hatmi'), isNull);
      expect(baslik('   '), MetinHatasi.bos);
      expect(baslik('a' * 61), MetinHatasi.uzun);
      expect(baslik('a' * 60), isNull);
      expect(baslik('bkz https://ornek.com'), MetinHatasi.link);
      expect(baslik('www.ornek.net hatmi'), MetinHatasi.link);
      expect(baslik('ornek.com hatmi'), MetinHatasi.link);
      expect(baslik('Hz. Ali Camii hatmi'), isNull);
      expect(hatimMetniDenetle('', sinir: hatimNotSiniri), isNull);
    });
  });

  test('hatimler cihazda saklanır ve yeniden açılışta okunur', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    ProviderContainer kap() => ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        saatProvider.overrideWithValue(() => simdi),
      ],
    );

    final ilk = kap();
    expect(ilk.read(hatimlerProvider), isEmpty);
    final hatim = ilk
        .read(hatimlerProvider.notifier)
        .olustur(baslik: '  Aile Hatmi ', bolmeSekli: BolmeSekli.cuz, not: ' ');
    expect(hatim.baslik, 'Aile Hatmi');
    expect(hatim.not, isNull);
    expect(hatim.kod.length, greaterThanOrEqualTo(10));
    final n = ilk.read(hatimlerProvider.notifier);
    expect(n.payAl(hatim.kod, 5), PaySonucu.tamam);
    expect(n.payAl(hatim.kod, 5), PaySonucu.alinmis);
    expect(n.okundu(hatim.kod, 5), PaySonucu.tamam);
    expect(n.payAl('olmayan', 1), PaySonucu.gecersiz);
    final ben = ilk.read(katilimciAnahtariProvider);
    ilk.dispose();

    final ikinci = kap();
    final okunan = ikinci.read(hatimlerProvider).single;
    expect(okunan.baslik, 'Aile Hatmi');
    expect(okunan.pay(5).durum, PayDurumu.okundu);
    expect(okunan.pay(5).katilimci, ben);
    expect(ikinci.read(katilimciAnahtariProvider), ben);
    ikinci.read(hatimlerProvider.notifier).sil(okunan.kod);
    expect(ikinci.read(hatimlerProvider), isEmpty);
    ikinci.dispose();
  });
}
