import 'package:hijri/hijri_calendar.dart';

/// Hicrî tarih (Ümmü'l-Kurâ takvimi).
class HicriTarih {
  const HicriTarih(this.yil, this.ay, this.gun);
  final int yil;

  /// 1: Muharrem … 12: Zilhicce
  final int ay;
  final int gun;
}

/// [gun]'ün hicrî karşılığı. [duzeltme], kullanıcının Ayarlar'da seçtiği
/// ±1 günlük farktır (rü'yet/hesap farkları için).
HicriTarih hicriTarih(DateTime gun, {int duzeltme = 0}) {
  final h = HijriCalendar.fromDate(
    DateTime(gun.year, gun.month, gun.day + duzeltme),
  );
  return HicriTarih(h.hYear, h.hMonth, h.hDay);
}
