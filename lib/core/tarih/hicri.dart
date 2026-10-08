import 'package:hijri/hijri_calendar.dart';

/// Hicrî tarih.
class HicriTarih {
  const HicriTarih(this.yil, this.ay, this.gun);
  final int yil;

  /// 1: Muharrem … 12: Zilhicce
  final int ay;
  final int gun;
}

/// Diyanet İşleri Başkanlığı'nın dinî günler listelerindeki hicrî ay
/// başlangıçları (miladî gün, hicrî yıl, hicrî ay). Kaynak:
/// vakithesaplama.diyanet.gov.tr, 2026 ve 2027 listeleri (8 Ekim 2026).
/// Ümmü'l-Kurâ hesabı bu aralıktaki 25 ayın ikisinde bir gün farklıdır;
/// Türkiye'deki takvimle aynı günü göstermek için tablo önceliklidir.
/// Yeni yılın listesi yayımlanınca satırları sona eklenir.
const _diyanetAyBaslangiclari = <(int, int, int, int, int)>[
  (2026, 1, 20, 1447, 8),
  (2026, 2, 19, 1447, 9),
  (2026, 3, 20, 1447, 10),
  (2026, 4, 18, 1447, 11),
  (2026, 5, 18, 1447, 12),
  (2026, 6, 16, 1448, 1),
  (2026, 7, 15, 1448, 2),
  (2026, 8, 14, 1448, 3),
  (2026, 9, 12, 1448, 4),
  (2026, 10, 12, 1448, 5),
  (2026, 11, 10, 1448, 6),
  (2026, 12, 10, 1448, 7),
  (2027, 1, 9, 1448, 8),
  (2027, 2, 8, 1448, 9),
  (2027, 3, 9, 1448, 10),
  (2027, 4, 8, 1448, 11),
  (2027, 5, 7, 1448, 12),
  (2027, 6, 6, 1449, 1),
  (2027, 7, 5, 1449, 2),
  (2027, 8, 3, 1449, 3),
  (2027, 9, 2, 1449, 4),
  (2027, 10, 1, 1449, 5),
  (2027, 10, 31, 1449, 6),
  (2027, 11, 29, 1449, 7),
  (2027, 12, 29, 1449, 8),
];

/// Tablonun son ayı için kesin bitiş bilinmez; bu günden sonrası hesaba
/// bırakılır (bir hicrî ay en az 29 gündür).
const _sonAyGuvenliGun = 29;

/// [gun]'ün hicrî karşılığı: Diyanet'in yayımladığı ay başlangıçları
/// biliniyorsa onlara, bilinmiyorsa Ümmü'l-Kurâ hesabına göre.
/// [duzeltme], kullanıcının Ayarlar'da seçtiği ±1 günlük farktır.
HicriTarih hicriTarih(DateTime gun, {int duzeltme = 0}) {
  // Gün farkları yaz saatinden etkilenmesin diye UTC gün sayılır
  final t = DateTime.utc(gun.year, gun.month, gun.day + duzeltme);
  for (var i = _diyanetAyBaslangiclari.length - 1; i >= 0; i--) {
    final (y, a, g, hYil, hAy) = _diyanetAyBaslangiclari[i];
    final fark = t.difference(DateTime.utc(y, a, g)).inDays;
    if (fark < 0) continue;
    final sonAy = i == _diyanetAyBaslangiclari.length - 1;
    if (sonAy && fark >= _sonAyGuvenliGun) break;
    return HicriTarih(hYil, hAy, fark + 1);
  }
  final h = HijriCalendar.fromDate(DateTime(t.year, t.month, t.day));
  return HicriTarih(h.hYear, h.hMonth, h.hDay);
}
