// İncelenmemiş dinî içerik kayıtlarını sayar (CLAUDE.md §8).
//
//   dart run tool/inceleme_raporu.dart
//
// `incelendi: false` ya da `kaynak_dogrulandi: false` olan her kayıt yayın
// öncesi bir hoca / resmî kaynak tarafından doğrulanmalıdır. Betik,
// incelenmemiş kayıt varsa 1 koduyla çıkar (yayın denetiminde kullanılabilir).
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// JSON ağacında inceleme alanı taşıyan bütün kayıtları dolaşır.
void _tara(Object? dugum, void Function(Map<String, dynamic>) kayit) {
  if (dugum is Map<String, dynamic>) {
    if (dugum.containsKey('incelendi') ||
        dugum.containsKey('kaynak_dogrulandi')) {
      kayit(dugum);
    }
    for (final v in dugum.values) {
      _tara(v, kayit);
    }
  } else if (dugum is List) {
    for (final v in dugum) {
      _tara(v, kayit);
    }
  }
}

void main() {
  final dosyalar =
      Directory('assets/data')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  var toplam = 0;
  var eksik = 0;
  print('İnceleme raporu');
  print('=' * 60);
  for (final dosya in dosyalar) {
    var dosyaToplam = 0;
    final incelenmemis = <String>[];
    _tara(jsonDecode(dosya.readAsStringSync()), (k) {
      dosyaToplam++;
      final tamam = k['incelendi'] == true || k['kaynak_dogrulandi'] == true;
      if (!tamam) {
        incelenmemis.add(
          '${k['id'] ?? k['ad'] ?? k['baslik'] ?? k['no'] ?? '(dosya geneli)'}',
        );
      }
    });
    if (dosyaToplam == 0) continue;
    toplam += dosyaToplam;
    eksik += incelenmemis.length;
    final ad = dosya.uri.pathSegments.last;
    print(
      '${ad.padRight(24)} ${incelenmemis.length.toString().padLeft(4)} / '
      '${dosyaToplam.toString().padLeft(4)} incelenmemiş',
    );
    if (incelenmemis.isNotEmpty && incelenmemis.length <= 20) {
      print('    ${incelenmemis.join(', ')}');
    }
  }
  print('=' * 60);
  print('Toplam: $eksik / $toplam kayıt incelenmemiş.');
  final mealler =
      (jsonDecode(File('assets/data/quran/mealler.json').readAsStringSync())
              as Map<String, dynamic>)['mealler']
          as List;
  print(
    mealler.isEmpty
        ? 'Meal: YOK (yer tutucu gösteriliyor)'
        : 'Meal: ${mealler.length} adet',
  );
  if (eksik > 0) exitCode = 1;
}
