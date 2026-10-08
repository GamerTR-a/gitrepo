import 'dart:math' as math;

import 'gunluk_vakitler.dart';

/// Vakit hesaplama yöntemleri.
///
/// [diyanet] parametreleri (imsak 18°, yatsı 17° ve temkin dakikaları),
/// açık kaynaklı Adhan kütüphanesinin "Turkey" yöntemindeki değerlerdir
/// (github.com/batoulapps/adhan-js, CalculationMethod.Turkey). Türkiye'de
/// sekiz şehirde bir yıl boyunca Diyanet'in yayımladığı vakitlerle ±2 dakika
/// içinde tutar. Diyanet, uygulamadaki Avrupa ülkelerinde yatsıyı 16° ile
/// yayımlıyor ([yatsiAcisiYurtDisi]); ayrıntı: docs/vakit_dogrulama.md.
enum HesapYontemi {
  diyanet(
    imsakAcisi: 18,
    yatsiAcisi: 17,
    yatsiAcisiYurtDisi: 16,
    temkin: {
      VakitTuru.gunes: -7,
      VakitTuru.ogle: 5,
      VakitTuru.ikindi: 4,
      VakitTuru.aksam: 7,
    },
  ),
  dunyaIslamBirligi(imsakAcisi: 18, yatsiAcisi: 17),
  kuzeyAmerika(imsakAcisi: 15, yatsiAcisi: 15),
  misir(imsakAcisi: 19.5, yatsiAcisi: 17.5);

  const HesapYontemi({
    required this.imsakAcisi,
    required this.yatsiAcisi,
    this.yatsiAcisiYurtDisi,
    this.temkin = const {},
  });

  /// Güneşin ufkun altındaki açısı (derece)
  final double imsakAcisi;
  final double yatsiAcisi;

  /// Türkiye dışındaki konumlarda kullanılan yatsı açısı; yoksa [yatsiAcisi]
  final double? yatsiAcisiYurtDisi;

  /// Hesaplanan vakte eklenen ihtiyat payı (dakika)
  final Map<VakitTuru, int> temkin;
}

class HesapAyarlari {
  const HesapAyarlari({
    this.yontem = HesapYontemi.diyanet,
    this.duzeltmeler = const {},
  });

  final HesapYontemi yontem;

  /// Kullanıcının vakit başına eklediği/çıkardığı dakika
  final Map<VakitTuru, int> duzeltmeler;
}

/// Güneşin doğuş/batışta ufkun altındaki açısı (kırılma + güneş yarıçapı)
const _ufukAcisi = 0.833;

/// Verilen konum ve gün için vakitleri hesaplar. İnternet gerektirmez.
///
/// [utcFarki], konumun o günkü saat dilimi farkıdır (yaz saati dahil).
/// [yurtDisi], konumun Türkiye dışında olduğu biliniyorsa `true` verilir.
/// Yatsı/imsak oluşmayan yüksek enlem günlerinde "gecenin yedide biri"
/// kuralı uygulanır; hiçbir girdi için hata fırlatmaz.
GunlukVakitler vakitleriHesapla({
  required double enlem,
  required double boylam,
  required DateTime gun,
  required Duration utcFarki,
  HesapAyarlari ayar = const HesapAyarlari(),
  bool yurtDisi = false,
}) {
  final jd = _julianGunu(gun.year, gun.month, gun.day) - boylam / 360;
  final yontem = ayar.yontem;

  // Saat cinsinden, yerel ortalama güneş zamanına göre
  final ogle = _ogle(jd, 12 / 24);
  final gunes = _aciZamani(jd, enlem, _ufukAcisi, 6 / 24, -1);
  final aksam = _aciZamani(jd, enlem, _ufukAcisi, 18 / 24, 1);
  var imsak = _aciZamani(jd, enlem, yontem.imsakAcisi, 5 / 24, -1);
  final yatsiAcisi = yurtDisi
      ? (yontem.yatsiAcisiYurtDisi ?? yontem.yatsiAcisi)
      : yontem.yatsiAcisi;
  var yatsi = _aciZamani(jd, enlem, yatsiAcisi, 18 / 24, 1);
  final ikindi = _ikindi(jd, enlem, 13 / 24);

  // Kutup gündüzü/gecesi: doğuş-batış yoksa öğleye göre 6'şar saat varsay
  final dogus = gunes ?? ogle - 6;
  final batis = aksam ?? ogle + 6;
  final geceYedideBir = (24 - (batis - dogus)) / 7;
  if (gunes == null || aksam == null) {
    imsak = null;
    yatsi = null;
  }
  final tahmini = {
    if (imsak == null) VakitTuru.imsak,
    if (gunes == null) VakitTuru.gunes,
    if (aksam == null) VakitTuru.aksam,
    if (yatsi == null) VakitTuru.yatsi,
  };
  imsak ??= dogus - geceYedideBir;
  yatsi ??= batis + geceYedideBir;

  final kaydirma = utcFarki.inMinutes / 60 - boylam / 15;
  final saatler = {
    VakitTuru.imsak: imsak,
    VakitTuru.gunes: dogus,
    VakitTuru.ogle: ogle,
    VakitTuru.ikindi: ikindi ?? ogle + (batis - ogle) / 2,
    VakitTuru.aksam: batis,
    VakitTuru.yatsi: yatsi,
  };

  return GunlukVakitler(
    gun: DateTime(gun.year, gun.month, gun.day),
    tahminiVakitler: tahmini,
    vakitler: [
      for (final tur in VakitTuru.values)
        _vakit(
          tur,
          saatler[tur]! + kaydirma,
          (yontem.temkin[tur] ?? 0) + (ayar.duzeltmeler[tur] ?? 0),
        ),
    ],
  );
}

/// Diyanet'in Avrupa'da yaz aylarında imsak ve yatsıyı açıyla değil,
/// kısaltılmış bir süreyle yayımladığı günleri yaklaşık olarak tanır:
/// fecir süresi gecenin yüzde 23'ünü aşınca kısaltma başlar (yayımlanan
/// vakitlerden çıkarılan ölçüt; docs/vakit_dogrulama.md). Motor bu günlerde
/// açıyla hesaplamayı sürdürür; ekran farkı kullanıcıya bildirir.
bool diyanetYazKisaltmasi(GunlukVakitler v) {
  if (v.tahminiVakitler.isNotEmpty) return false;
  int dakika(VakitTuru t) => v[t].saat * 60 + v[t].dakika;
  // Güneş ve akşam temkinli gösterilir (−7 / +7 dakika)
  final dogus = dakika(VakitTuru.gunes) + 7;
  final batis = dakika(VakitTuru.aksam) - 7;
  final gece = 1440 - (batis - dogus);
  final fecir = (dogus - dakika(VakitTuru.imsak)) % 1440;
  return fecir > gece * 0.23;
}

Vakit _vakit(VakitTuru tur, double saat, int ekDakika) {
  final toplam = ((saat * 60).round() + ekDakika) % 1440;
  final dakika = toplam < 0 ? toplam + 1440 : toplam;
  return Vakit(tur, dakika ~/ 60, dakika % 60);
}

// ---------------------------------------------------------------------------
// Güneş konumu (düşük hassasiyetli, ~1 yay dakikası; US Naval Observatory
// "Approximate Solar Coordinates" formülleri — PrayTimes.org ile aynı)
// ---------------------------------------------------------------------------
double _rad(double derece) => derece * math.pi / 180;
double _derece(double rad) => rad * 180 / math.pi;
double _sin(double d) => math.sin(_rad(d));
double _cos(double d) => math.cos(_rad(d));
double _tan(double d) => math.tan(_rad(d));
double _mod(double a, double n) => a - n * (a / n).floorToDouble();

double _julianGunu(int yil, int ay, int gun) {
  if (ay <= 2) {
    yil -= 1;
    ay += 12;
  }
  final a = (yil / 100).floor();
  final b = 2 - a + (a / 4).floor();
  return (365.25 * (yil + 4716)).floor() +
      (30.6001 * (ay + 1)).floor() +
      gun +
      b -
      1524.5;
}

/// Güneşin sapma açısı (derece) ve zaman denklemi (saat)
({double sapma, double zamanDenklemi}) _gunes(double jd) {
  final d = jd - 2451545.0;
  final g = _mod(357.529 + 0.98560028 * d, 360);
  final q = _mod(280.459 + 0.98564736 * d, 360);
  final l = _mod(q + 1.915 * _sin(g) + 0.020 * _sin(2 * g), 360);
  final e = 23.439 - 0.00000036 * d;
  final ra = _mod(_derece(math.atan2(_cos(e) * _sin(l), _cos(l))), 360) / 15;
  final sapma = _derece(math.asin(_sin(e) * _sin(l)));
  var denklem = q / 15 - ra;
  if (denklem > 12) denklem -= 24;
  if (denklem < -12) denklem += 24;
  return (sapma: sapma, zamanDenklemi: denklem);
}

double _ogle(double jd, double gunKesri) =>
    12 - _gunes(jd + gunKesri).zamanDenklemi;

/// Güneşin ufkun [aci] derece altında olduğu an; o gün oluşmuyorsa `null`.
/// [yon] -1: öğleden önce, 1: öğleden sonra.
double? _aciZamani(
  double jd,
  double enlem,
  double aci,
  double gunKesri,
  int yon,
) {
  final sapma = _gunes(jd + gunKesri).sapma;
  final x =
      (-_sin(aci) - _sin(sapma) * _sin(enlem)) / (_cos(sapma) * _cos(enlem));
  if (x.isNaN || x < -1 || x > 1) return null;
  return _ogle(jd, gunKesri) + yon * _derece(math.acos(x)) / 15;
}

/// İkindi (asr-ı evvel): gölge, cismin boyu + öğle gölgesi kadar olduğunda.
double? _ikindi(double jd, double enlem, double gunKesri) {
  final sapma = _gunes(jd + gunKesri).sapma;
  final aci = -_derece(math.atan(1 / (1 + _tan((enlem - sapma).abs()))));
  return _aciZamani(jd, enlem, aci, gunKesri, 1);
}
