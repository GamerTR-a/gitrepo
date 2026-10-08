import 'dart:io';
import 'dart:math' as math;

import 'package:abyad/core/theme/abyad_colors.dart';
import 'package:abyad/features/ayarlar/domain/ayarlar.dart';
import 'package:abyad/features/zikirmatik/ui/zikir_arka_plani.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

double _parlaklik(Color c) {
  double k(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * k(c.r) + 0.7152 * k(c.g) + 0.0722 * k(c.b);
}

/// WCAG kontrast oranı
double kontrast(Color a, Color b) {
  final (acik, koyu) = _parlaklik(a) > _parlaklik(b)
      ? (_parlaklik(a), _parlaklik(b))
      : (_parlaklik(b), _parlaklik(a));
  return (acik + 0.05) / (koyu + 0.05);
}

void main() {
  tearDown(() => AbyadColors.palet = AbyadPalet.acik);

  for (final palet in [AbyadPalet.acik, AbyadPalet.karanlik]) {
    test('${palet.koyu ? 'koyu' : 'açık'} tema: yazı ve zemin çiftleri '
        'WCAG AA (4.5:1) sağlar', () {
      AbyadColors.palet = palet;
      final ciftler = <String, (Color, Color)>{
        'metin / zemin': (AbyadColors.metin, AbyadColors.zemin),
        'metin / kart': (AbyadColors.metin, AbyadColors.yuzey),
        'metin / okuma zemini': (AbyadColors.metin, AbyadColors.okumaZemini),
        'ikincil metin / zemin': (AbyadColors.metinIkincil, AbyadColors.zemin),
        'ikincil metin / kart': (AbyadColors.metinIkincil, AbyadColors.yuzey),
        'ikincil metin / segment': (
          AbyadColors.metinIkincil,
          AbyadColors.segmentZemin,
        ),
        'pasif metin / kart': (AbyadColors.metinPasif, AbyadColors.yuzey),
        'menü pasif / kart': (AbyadColors.menuPasif, AbyadColors.yuzey),
        'vurgu / zemin': (AbyadColors.zumrut, AbyadColors.zemin),
        'vurgu / kart': (AbyadColors.zumrut, AbyadColors.yuzey),
        'vurgu / yeşil zemin': (AbyadColors.zumrut, AbyadColors.yesilZemin),
        'dolu düğme yazısı': (AbyadColors.yuzey, AbyadColors.zumrut),
        'pirinç yazı / kart': (AbyadColors.pirincYazi, AbyadColors.yuzey),
        'pirinç yazı / zemin': (AbyadColors.pirincYazi, AbyadColors.zemin),
        'pirinç yazı / pirinç açık': (
          AbyadColors.pirincYazi,
          AbyadColors.pirincAcik,
        ),
        'metin / pirinç açık': (AbyadColors.metin, AbyadColors.pirincAcik),
        'metin / pirinç zemin': (AbyadColors.metin, AbyadColors.pirincZemin),
        'koyu panel yazısı': (AbyadColors.koyuUstu, AbyadColors.koyuZemin),
        'koyu panel ikincil': (
          AbyadColors.koyuUstuIkincil,
          AbyadColors.koyuZemin,
        ),
        'koyu panel pirinç': (AbyadColors.pirinc, AbyadColors.koyuZemin),
        'pirinç üstü yazı': (AbyadColors.pirincUstu, AbyadColors.pirinc),
      };
      for (final MapEntry(key: ad, value: (on, arka)) in ciftler.entries) {
        expect(
          kontrast(on, arka),
          greaterThanOrEqualTo(4.5),
          reason: '$ad: ${kontrast(on, arka).toStringAsFixed(2)}',
        );
      }
    });
  }

  test(
    'yeni ayarlar: varsayılanlar eski görünümü korur, kayıt gidiş dönüşü',
    () {
      const v = Ayarlar();
      expect(v.koyuTema, isFalse);
      expect(v.zikirArkaPlan, isFalse);
      expect(v.zikirArkaPlanSaniye, 30);
      // Eski sürümün kaydında bu alanlar yoktur
      final eski = Ayarlar.fromJson(const {'yuksekKontrast': true});
      expect((eski.koyuTema, eski.zikirArkaPlan), (false, false));
      final yeni = Ayarlar.fromJson(
        v
            .copyWith(
              koyuTema: true,
              zikirArkaPlan: true,
              zikirArkaPlanSaniye: 60,
            )
            .toJson(),
      );
      expect(
        (yeni.koyuTema, yeni.zikirArkaPlan, yeni.zikirArkaPlanSaniye),
        (true, true, 60),
      );
    },
  );

  test('manzara görselleri yerinde, listeyle birebir ve küçültülmüş', () {
    expect(zikirManzaralari.toSet(), hasLength(zikirManzaralari.length));
    for (final ad in zikirManzaralari) {
      final dosya = File('assets/zikir_arkaplan/$ad.webp');
      expect(dosya.existsSync(), isTrue, reason: ad);
      // Uygulama boyutu şişmesin: kaynak görseller 3-4 MB'tır
      expect(dosya.lengthSync(), lessThan(300 * 1024), reason: ad);
    }
    expect(
      Directory(
        'assets/zikir_arkaplan',
      ).listSync().map((d) => d.uri.pathSegments.last.split('.').first),
      unorderedEquals(zikirManzaralari),
      reason: 'klasörde listede olmayan dosya var',
    );
    expect(zikirManzaraSureleri, contains(const Ayarlar().zikirArkaPlanSaniye));
  });
}
