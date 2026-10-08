// Hesaplama motorunu Diyanet'in yayımladığı vakitlerle karşılaştırır.
//
//   dart run tool/diyanet_karsilastir.dart DIYANET.json
//
// DIYANET.json biçimi: { "Şehir": { "vakitler": { "YYYY-AA-GG":
// ["imsak","gunes","ogle","ikindi","aksam","yatsi"] } } }; şehir adı
// assets/data/sehirler.json'daki adla aynı olmalıdır. Her şehir ve vakit için
// farkın (motor − Diyanet, dakika) en küçük, en büyük ve ortalama değerini
// ve ±2 dakikayı aşan gün sayısını yazar. Dosya depoya konmaz; test için
// seçilmiş günler test/fixtures/diyanet_referans.json içindedir.
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:abyad/features/konum/domain/konum.dart';
import 'package:abyad/features/vakitler/domain/gunluk_vakitler.dart';
import 'package:abyad/features/vakitler/domain/vakit_hesaplama.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main(List<String> args) {
  if (args.length != 1) {
    print('Kullanım: dart run tool/diyanet_karsilastir.dart DIYANET.json');
    exitCode = 2;
    return;
  }
  tzdata.initializeTimeZones();
  final diyanet =
      jsonDecode(File(args.single).readAsStringSync()) as Map<String, dynamic>;
  final sehirler =
      ((jsonDecode(File('assets/data/sehirler.json').readAsStringSync())
                  as Map<String, dynamic>)['sehirler']
              as List)
          .cast<Map<String, dynamic>>()
          .map(Konum.fromJson)
          .toList();

  print(
    '${'şehir'.padRight(10)} ${'vakit'.padRight(7)} en küçük  en büyük  '
    'ortalama  ±2 dk dışı / gün',
  );
  for (final MapEntry(key: ad, value: veri) in diyanet.entries) {
    final konum = sehirler.firstWhere((s) => s.ad == ad && s.ust.isEmpty);
    final dilim = tz.getLocation(konum.dilim);
    final vakitler = ((veri as Map)['vakitler'] as Map).cast<String, dynamic>();
    final farklar = {for (final t in VakitTuru.values) t: <int>[]};
    var tahmini = 0;
    for (final MapEntry(key: tarih, value: saatler) in vakitler.entries) {
      final gun = DateTime.parse(tarih);
      final v = vakitleriHesapla(
        enlem: konum.enlem,
        boylam: konum.boylam,
        gun: gun,
        utcFarki: tz.TZDateTime(
          dilim,
          gun.year,
          gun.month,
          gun.day,
          12,
        ).timeZoneOffset,
        yurtDisi: konum.yurtDisi,
      );
      if (v.tahminiVakitler.isNotEmpty) tahmini++;
      for (final tur in VakitTuru.values) {
        final p = ((saatler as List)[tur.index] as String).split(':');
        var fark =
            v[tur].saat * 60 +
            v[tur].dakika -
            (int.parse(p[0]) * 60 + int.parse(p[1]));
        // Gece yarısını aşan yatsı/imsak
        if (fark > 720) fark -= 1440;
        if (fark < -720) fark += 1440;
        farklar[tur]!.add(fark);
      }
    }
    for (final tur in VakitTuru.values) {
      final f = farklar[tur]!..sort();
      final ort = f.reduce((a, b) => a + b) / f.length;
      final disi = f.where((x) => x.abs() > 2).length;
      print(
        '${ad.padRight(10)} ${tur.name.padRight(7)} '
        '${f.first.toString().padLeft(8)}  ${f.last.toString().padLeft(8)}  '
        '${ort.toStringAsFixed(2).padLeft(8)}  '
        '${disi.toString().padLeft(4)} / ${f.length}',
      );
    }
    print(
      '${ad.padRight(10)} kural uygulanan gün (motor): $tahmini; '
      'konum ${konum.enlem}, ${konum.boylam}',
    );
  }
}
