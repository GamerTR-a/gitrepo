// Namaz ve abdest rehberi veri dosyalarının şemasını doğrular (CLAUDE.md §6.14).
//
//   dart run tool/rehber_dogrula.dart
//
// Hata varsa listeler ve 1 koduyla çıkar. Çizim ve ses dosyalarından eksik
// olanları yalnızca bilgi olarak yazar (ses yoksa düğme gizlenir).
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:abyad/features/rehber/domain/rehber.dart';

Map<String, dynamic> _oku(String yol) =>
    jsonDecode(File(yol).readAsStringSync()) as Map<String, dynamic>;

void main() {
  final abdest = _oku('assets/data/rehber/abdest.json');
  final namazAdimlari = _oku('assets/data/rehber/namaz_adimlari.json');
  final namazVakitleri = _oku('assets/data/rehber/namaz_vakitleri.json');
  final dualar = {
    for (final d in _oku('assets/data/dualar.json')['dualar'] as List)
      (d as Map)['id'] as String,
  };

  final hatalar = rehberiDogrula(
    abdest: abdest,
    namazAdimlari: namazAdimlari,
    namazVakitleri: namazVakitleri,
    duaKimlikleri: dualar,
  );

  print('Rehber doğrulaması');
  print('=' * 60);
  if (hatalar.isNotEmpty) {
    for (final h in hatalar) {
      print('HATA  $h');
    }
    print('=' * 60);
    print('${hatalar.length} hata bulundu.');
    exitCode = 1;
    return;
  }

  final rehber = NamazRehberi.fromJson(namazAdimlari, namazVakitleri);
  for (final v in rehber.vakitler) {
    if (v.yerTutucu) {
      print('${v.ad.padRight(8)} yer tutucu (içerik bekleniyor)');
      continue;
    }
    for (final b in v.bolumler) {
      print(
        '${v.ad.padRight(8)} ${b.ad.padRight(12)} ${b.rekat} rekat, '
        '${rehber.adimlariUret(b).length} adım',
      );
    }
  }
  print(
    'Abdest   ${(abdest['adimlar'] as List).length} adım, '
    '${(abdest['bozanlar'] as List).length} bozan durum',
  );

  final tumAdimlar = [
    ...(abdest['adimlar'] as List).cast<Map<String, dynamic>>(),
    ...(namazAdimlari['adimlar'] as List).cast<Map<String, dynamic>>(),
  ];
  Set<String> eksik(String alan, String klasor) => {
    for (final a in tumAdimlar)
      if (a[alan] != null && !File('$klasor/${a[alan]}').existsSync())
        a[alan] as String,
  };
  final eksikCizim = eksik('cizim', 'assets/rehber');
  final eksikSes = eksik('ses', 'assets/audio/rehber');
  print('=' * 60);
  print(
    eksikCizim.isEmpty
        ? 'Çizimler: tamam'
        : 'Eksik çizim (${eksikCizim.length}): ${eksikCizim.join(', ')}',
  );
  print(
    eksikSes.isEmpty
        ? 'Sesler: tamam'
        : 'Eksik ses (${eksikSes.length}; düğme gizli): ${eksikSes.join(', ')}',
  );
  print('Şema geçerli.');
}
