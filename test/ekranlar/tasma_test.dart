import 'package:abyad/app/abyad_kabuk.dart';
import 'package:abyad/core/icerik/icerik.dart';
import 'package:abyad/features/ayarlar/ui/ayarlar_ekrani.dart';
import 'package:abyad/features/ayarlar/ui/lisanslar_ekrani.dart';
import 'package:abyad/features/dualar/ui/dualar_ekrani.dart';
import 'package:abyad/features/esma/ui/esma_ekrani.dart';
import 'package:abyad/features/ilk_acilis/ui/ilk_acilis_ekrani.dart';
import 'package:abyad/features/kaza/ui/kaza_ekrani.dart';
import 'package:abyad/features/kaza/ui/kaza_sihirbazi.dart';
import 'package:abyad/features/kible/ui/kible_ekrani.dart';
import 'package:abyad/features/konum/ui/sehir_sec_ekrani.dart';
import 'package:abyad/features/kuran/ui/kuran_liste_ekrani.dart';
import 'package:abyad/features/kuran/ui/kuran_oku_ekrani.dart';
import 'package:abyad/features/onemli_gunler/ui/onemli_gunler_ekrani.dart';
import 'package:abyad/features/rehber/ui/rehber_ekrani.dart';
import 'package:abyad/features/vakitler/ui/imsakiye_ekrani.dart';
import 'package:abyad/features/vakitler/ui/vakitler_ekrani.dart';
import 'package:abyad/features/zikirmatik/ui/zikirmatik_ekrani.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../yardimci.dart';

const _ornekDua = Dua(
  id: 'ornek',
  kategori: 'sabah_aksam',
  ad: 'Âyetü\'l-Kürsî',
  arapcaKisa: '',
  ayetler: '2:255',
  okunus: 'Okunuş örneği',
  kaynak: 'Bakara, 255',
);

/// Sekme ekranları kendi Scaffold'larını kurmaz.
Widget _sekme(Widget w) => Scaffold(body: w);

/// CLAUDE.md §7: her ekran, yazı ölçeği 1.0 / 1.5 / 2.0'da taşmadan
/// kurulmalı. Ekranlar gerçek yazı tipleri ve gömülü verilerle kurulur,
/// sonra baştan sona kaydırılır.
final _ekranlar = <String, Widget Function()>{
  'kabuk (ana sayfa)': () => const AbyadKabuk(),
  'vakitler': () => _sekme(const VakitlerEkrani()),
  'imsakiye': () => const ImsakiyeEkrani(),
  'kıble': () => const KibleEkrani(),
  'şehir seç': () => const SehirSecEkrani(),
  "kur'an liste": () => _sekme(const KuranListeEkrani()),
  "kur'an oku (Fâtiha)": () => const KuranOkuEkrani(sure: 1),
  "kur'an oku (Bakara 255)": () => const KuranOkuEkrani(sure: 2, ayet: 255),
  'dualar': () => _sekme(const DualarEkrani()),
  'dua detay': () => const DuaDetayEkrani(dua: _ornekDua),
  'zikirmatik': () => const ZikirmatikEkrani(),
  'önemli günler': () => _sekme(const OnemliGunlerEkrani()),
  'ayarlar': () => const AyarlarEkrani(),
  'vakit bildirimleri': () => const VakitBildirimEkrani(),
  'dakika düzeltme': () => const DuzeltmeEkrani(),
  'lisanslar': () => const LisanslarEkrani(),
  'kaza takibi': () => const KazaEkrani(),
  'kaza sihirbazı': () => const KazaSihirbazi(),
  'rehber': () => const RehberEkrani(),
  'esmâ': () => const EsmaEkrani(),
  'ilk açılış': () => const IlkAcilisEkrani(),
};

void main() {
  setUpAll(testOrtaminiKur);

  for (final MapEntry(key: ad, value: kur) in _ekranlar.entries) {
    for (final boyut in [tasarimBoyutu, kucukTelefon]) {
      for (final olcek in yaziOlcekleri) {
        testWidgets('$ad: ${boyut.width.toInt()}x${boyut.height.toInt()}, '
            'yazı ölçeği $olcek', (tester) async {
          final ortam = await ekraniKur(
            tester,
            kur(),
            boyut: boyut,
            yaziOlcegi: olcek,
          );
          expect(tester.takeException(), isNull);

          // Ekran dışındaki satırlar da kurulsun diye sona kadar kaydır
          final kaydirilabilir = find.byWidgetPredicate(
            (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
          );
          if (kaydirilabilir.evaluate().isNotEmpty) {
            for (var i = 0; i < 12; i++) {
              await tester.drag(
                kaydirilabilir.first,
                Offset(0, -boyut.height * 0.7),
                warnIfMissed: false,
              );
              await tester.pump(const Duration(milliseconds: 50));
              expect(tester.takeException(), isNull, reason: 'kaydırma $i');
            }
          }
          await ekraniKapat(tester, ortam);
        });
      }
    }
  }

  testWidgets('pusula sensörü yoksa kıble ekranı açıklama gösterir', (
    tester,
  ) async {
    final ortam = await ekraniKur(tester, const KibleEkrani(), pusula: null);
    expect(find.text('Pusula sensörü bulunamadı'), findsOneWidget);
    expect(find.textContaining('152°'), findsOneWidget);
    await ekraniKapat(tester, ortam);
  });

  testWidgets('pusula hatası büyükse kalibrasyon uyarısı çıkar', (
    tester,
  ) async {
    final ortam = await ekraniKur(
      tester,
      const KibleEkrani(),
      pusula: (yon: 10.0, hata: 45.0),
    );
    expect(find.text('Pusula kalibrasyonu gerekiyor'), findsOneWidget);
    await ekraniKapat(tester, ortam);
  });

  testWidgets('telefon kıbleye dönükken "Kıbleye döndünüz" yazar', (
    tester,
  ) async {
    final ortam = await ekraniKur(
      tester,
      const KibleEkrani(),
      pusula: (yon: 151.0, hata: 5.0),
    );
    expect(find.text('Kıbleye döndünüz'), findsOneWidget);
    await ekraniKapat(tester, ortam);
  });
}
