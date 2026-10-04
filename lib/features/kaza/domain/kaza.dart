/// Kaza sayaçları: beş vakit farz, vitir ve Ramazan orucu.
enum KazaTuru { sabah, ogle, ikindi, aksam, yatsi, vitir, oruc }

const kazaNamazlari = [
  KazaTuru.sabah,
  KazaTuru.ogle,
  KazaTuru.ikindi,
  KazaTuru.aksam,
  KazaTuru.yatsi,
  KazaTuru.vitir,
];

/// Günde [gunlukTempo] vakit kaza kılınırsa [kalanNamaz] kaç günde biter.
/// Tempo 0 ise ya da borç yoksa `null`.
int? tahminiBitisGunu(int kalanNamaz, int gunlukTempo) {
  if (kalanNamaz <= 0 || gunlukTempo <= 0) return null;
  return (kalanNamaz / gunlukTempo).ceil();
}

/// Gün sayısını yıl ve ay olarak böler (1 yıl = 365 gün, 1 ay = 30 gün).
({int yil, int ay, int gun}) sureyeBol(int gunSayisi) {
  final yil = gunSayisi ~/ 365;
  final kalan = gunSayisi % 365;
  return (yil: yil, ay: kalan ~/ 30, gun: kalan % 30);
}

/// Kaza borcu hesaplama sihirbazının girdileri.
///
/// Varsayımlar (Hanefi, Diyanet uygulaması): sorumluluk buluğ ile başlar;
/// her gün beş farz ve vitir kazaya kalır; yılda 30 gün Ramazan orucu
/// hesaplanır. Sonuç kesin değil tahmindir; kullanıcı elle düzeltebilir.
class KazaHesabi {
  const KazaHesabi({
    required this.namazKilinmayanYil,
    required this.namazKilinmayanAy,
    required this.orucTutulmayanYil,
    this.ozurluGunAylik = 0,
  });

  /// Buluğdan sonra namaz kılınmayan süre
  final int namazKilinmayanYil;
  final int namazKilinmayanAy;

  /// Buluğdan sonra Ramazan orucu tutulmayan yıl sayısı
  final int orucTutulmayanYil;

  /// Kadınlar için her ay namazdan muaf olunan gün sayısı (kazası yoktur)
  final int ozurluGunAylik;

  int get _gun {
    final aylar = namazKilinmayanYil * 12 + namazKilinmayanAy;
    final toplam = namazKilinmayanYil * 365 + namazKilinmayanAy * 30;
    final muaf = aylar * ozurluGunAylik;
    return toplam > muaf ? toplam - muaf : 0;
  }

  /// Her tür için tahmini borç
  Map<KazaTuru, int> get sonuc => {
    for (final tur in kazaNamazlari) tur: _gun,
    KazaTuru.oruc: orucTutulmayanYil * 30,
  };
}
