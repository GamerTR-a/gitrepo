import 'package:abyad/core/storage/ayarlar_deposu.dart';
import 'package:abyad/core/storage/veritabani.dart';
import 'package:abyad/features/ayarlar/data/ayarlar_saglayici.dart';
import 'package:abyad/features/ayarlar/domain/ayarlar.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ayarlar', () {
    test('değişiklik kaydedilir ve yeniden açılışta okunur', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      ProviderContainer kap() => ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      final ilk = kap();
      expect(ilk.read(ayarlarProvider).yaziBoyutu, YaziBoyutu.normal);
      await ilk
          .read(ayarlarProvider.notifier)
          .guncelle((a) => a.copyWith(yaziBoyutu: YaziBoyutu.buyuk));
      ilk.dispose();

      final ikinci = kap();
      expect(ikinci.read(ayarlarProvider).yaziBoyutu, YaziBoyutu.buyuk);
      ikinci.dispose();
    });

    test('bozuk kayıt varsayılan ayarlarla açılır', () async {
      SharedPreferences.setMockInitialValues({'ayarlar_v1': '{bozuk'});
      final kap = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(
            await SharedPreferences.getInstance(),
          ),
        ],
      );
      expect(kap.read(ayarlarProvider).konum.ad, 'İstanbul');
      kap.dispose();
    });
  });

  group('veritabanı', () {
    late AbyadVeritabani vt;
    setUp(() => vt = AbyadVeritabani(NativeDatabase.memory()));
    tearDown(() => vt.close());

    test('okuma durumu tek satırdır ve üzerine yazılır', () async {
      expect(await vt.okumaDurumunuIzle().first, isNull);
      await vt.okumaDurumunuKaydet(2, 255);
      await vt.okumaDurumunuKaydet(3, 10);
      final d = await vt.okumaDurumunuIzle().first;
      expect((d!.sure, d.ayet), (3, 10));
    });

    test('yer imi eklenir, aynı ayette tekrar çağrılınca kaldırılır', () async {
      expect(await vt.yerImiDegistir(2, 255), isTrue);
      expect(await vt.yerImiDegistir(36, 1), isTrue);
      expect(await vt.yerImleriniIzle().first, hasLength(2));
      expect(await vt.yerImiDegistir(2, 255), isFalse);
      final kalan = await vt.yerImleriniIzle().first;
      expect(kalan.single.sure, 36);
    });

    test('kaza sayacı artar, azalır ve sıfırın altına inmez', () async {
      expect(await vt.kazaDegistir('sabah', 2), 2);
      expect(await vt.kazaDegistir('sabah', -1), 1);
      expect(await vt.kazaDegistir('sabah', -5), 0);
      await vt.kazaAyarla('ogle', 198);
      expect(await vt.kazaSayaclariniIzle().first, {'sabah': 0, 'ogle': 198});
    });

    test('günlük sayaç gün ve anahtara göre ayrı tutulur', () async {
      await vt.gunlukSayaciArtir('2026-10-02', 'zikir', 33);
      await vt.gunlukSayaciArtir('2026-10-02', 'zikir', 1);
      await vt.gunlukSayaciArtir('2026-10-02', 'kaza', 2);
      await vt.gunlukSayaciArtir('2026-10-03', 'zikir', 5);
      expect(await vt.gunlukSayaciIzle('2026-10-02', 'zikir').first, 34);
      expect(await vt.gunlukSayaciIzle('2026-10-02', 'kaza').first, 2);
      expect(await vt.gunlukSayaciIzle('2026-10-04', 'zikir').first, 0);
      expect(gunAnahtari(DateTime(2026, 3, 5)), '2026-03-05');
    });
  });
}
