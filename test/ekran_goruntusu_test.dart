import 'dart:io';
import 'dart:ui' as ui;

import 'package:abyad/app/abyad_kabuk.dart';
import 'package:abyad/app/sekme.dart';
import 'package:abyad/core/icerik/icerik.dart';
import 'package:abyad/core/theme/abyad_colors.dart';
import 'package:abyad/features/ayarlar/ui/ayarlar_ekrani.dart';
import 'package:abyad/features/esma/ui/esma_ekrani.dart';
import 'package:abyad/features/hadis/ui/hadis_ekrani.dart';
import 'package:abyad/features/hatim/domain/hatim.dart';
import 'package:abyad/features/hatim/ui/hatim_ekrani.dart';
import 'package:abyad/features/ilk_acilis/ui/ilk_acilis_ekrani.dart';
import 'package:abyad/features/kaza/ui/kaza_ekrani.dart';
import 'package:abyad/features/kaza/ui/kaza_sihirbazi.dart';
import 'package:abyad/features/kible/ui/kible_ekrani.dart';
import 'package:abyad/features/konum/ui/sehir_sec_ekrani.dart';
import 'package:abyad/features/kuran/ui/kuran_metni_ekrani.dart';
import 'package:abyad/features/kuran/ui/kuran_oku_ekrani.dart';
import 'package:abyad/features/kuran/ui/kuran_sayfa_ekrani.dart';
import 'package:abyad/features/rehber/ui/rehber_ekrani.dart';
import 'package:abyad/features/vakitler/ui/ek_vakitler_ekrani.dart';
import 'package:abyad/features/vakitler/ui/imsakiye_ekrani.dart';
import 'package:abyad/features/zikirmatik/ui/zikirmatik_ekrani.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'yardimci.dart';

/// Ekranları gerçek yazı tipleriyle PNG olarak kaydeder; tasarımla göz
/// karşılaştırması içindir. Yalnızca hedef klasör verilince çalışır:
///
///   ABYAD_GORUNTU_KLASORU=build/goruntu flutter test test/ekran_goruntusu_test.dart
///
/// ABYAD_GORUNTU_TEMA=koyu verilirse ekranlar koyu temayla kaydedilir.
void main() {
  final klasor = Platform.environment['ABYAD_GORUNTU_KLASORU'];

  final koyu = Platform.environment['ABYAD_GORUNTU_TEMA'] == 'koyu';

  setUpAll(() async {
    await testOrtaminiKur();
    if (koyu) AbyadColors.palet = AbyadPalet.karanlik;
  });
  tearDownAll(() => AbyadColors.palet = AbyadPalet.acik);

  Widget sekmede(Sekme sekme) => Consumer(
    builder: (context, ref, _) {
      // İlk karede sekmeyi seç
      Future.microtask(() => ref.read(seciliSekmeProvider.notifier).git(sekme));
      return const AbyadKabuk();
    },
  );

  final ekranlar = <String, Widget Function()>{
    '01_ana_sayfa': () => const AbyadKabuk(),
    '02_vakitler': () => sekmede(Sekme.vakitler),
    '03_kuran_liste': () => sekmede(Sekme.kuran),
    '04_kuran_oku': () => const KuranOkuEkrani(sure: 1),
    '05_kaza': () => const KazaEkrani(),
    '06_rehber': () => const RehberEkrani(),
    '07_dualar': () => sekmede(Sekme.dualar),
    '08_zikirmatik': () => const ZikirmatikEkrani(),
    '09_gunler': () => sekmede(Sekme.gunler),
    '10_ayarlar': () => const AyarlarEkrani(),
    '13_esma': () => const EsmaEkrani(),
    '14_kible': () => const KibleEkrani(),
    '15_sehir_sec': () => const SehirSecEkrani(),
    '16_imsakiye': () => const ImsakiyeEkrani(),
    '17_ilk_acilis': () => const IlkAcilisEkrani(),
    '18_kaza_sihirbazi': () => const KazaSihirbazi(),
    '19_kuran_sayfa_1': () => const KuranSayfaEkrani(sure: 1),
    '20_kuran_sayfa_3': () => const KuranSayfaEkrani(sure: 2, ayet: 6),
    '21_kuran_sayfa_604': () => const KuranSayfaEkrani(sure: 114),
    '22_rehber_ogle_farz': () =>
        const RehberAdimlari(vakit: 'ogle', bolum: 'farz'),
    '23_rehber_abdest': () => const RehberAdimlari(),
    '24_hadis': () => const HadisEkrani(),
    '25_hatim_liste': () => const HatimEkrani(),
    '26_hatim_cuz': () => const HatimDetayEkrani(kod: ornekHatimKodu),
    '27_hatim_olustur': () => const HatimOlusturEkrani(),
    '28_zikirmatik_manzara': () => const ZikirmatikEkrani(),
    '29_ayarlar_bildirim': () => const BildirimAyarEkrani(),
    '33_kuran_metni': () => const KuranMetniEkrani(),
    '31_ek_vakitler': () => const EkVakitlerEkrani(),
    '32_vakitler_yuksek_enlem': () => sekmede(Sekme.vakitler),
    '30_hadis_detay': () => Consumer(
      builder: (context, ref, _) {
        final veri = ref.watch(hadislerProvider).valueOrNull;
        return veri == null
            ? const SizedBox.shrink()
            : HadisDetayEkrani(hadis: veri.hadisler[12]);
      },
    ),
  };

  for (final MapEntry(key: ad, value: kur) in ekranlar.entries) {
    for (final olcek in [1.0, 2.0]) {
      testWidgets('$ad görüntüsü, yazı ölçeği $olcek', (tester) async {
        final anahtar = GlobalKey();
        final ortam = await ekraniKur(
          tester,
          RepaintBoundary(key: anahtar, child: kur()),
          yaziOlcegi: olcek,
          ortam: await TestOrtami.olustur(
            ayarlar: ad.contains('hatim')
                ? ornekHatimAyarlari(BolmeSekli.cuz)
                : (ad.contains('manzara')
                      ? {'ayarlar_v1': '{"zikirArkaPlan": true}'}
                      : (ad.contains('yuksek_enlem')
                            ? yuksekEnlemAyarlari
                            : const {})),
          ),
        );
        await tester.runAsync(() async {
          // SVG ikonların çözülmesini bekle
          await Future<void>.delayed(const Duration(milliseconds: 300));
        });
        await yuklenmeyiBekle(tester);

        final sinir =
            anahtar.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final resim = await sinir.toImage(pixelRatio: 2);
          final bayt = await resim.toByteData(format: ui.ImageByteFormat.png);
          Directory(klasor!).createSync(recursive: true);
          File(
            '$klasor/${ad}_$olcek${koyu ? '_koyu' : ''}.png',
          ).writeAsBytesSync(bayt!.buffer.asUint8List());
        });
        await ekraniKapat(tester, ortam);
      }, skip: klasor == null);
    }
  }
}
