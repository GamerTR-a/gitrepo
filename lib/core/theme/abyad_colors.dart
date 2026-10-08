import 'package:flutter/painting.dart';

/// Bir temanın bütün renkleri. Açık ve koyu tema aynı alanları doldurur.
class AbyadPalet {
  const AbyadPalet({
    required this.koyu,
    required this.zumrut,
    required this.zumrutKoyu,
    required this.koyuZemin,
    required this.pirincYazi,
    required this.pirincSus,
    required this.pirincZemin,
    required this.pirincAcik,
    required this.pirincKenar,
    required this.zemin,
    required this.yuzey,
    required this.okumaZemini,
    required this.yesilZemin,
    required this.segmentZemin,
    required this.kenarlik,
    required this.ayrac,
    required this.metin,
    required this.metinIkincil,
    required this.metinPasif,
    required this.menuPasif,
  });

  final bool koyu;
  final Color zumrut;
  final Color zumrutKoyu;
  final Color koyuZemin;
  final Color pirincYazi;
  final Color pirincSus;
  final Color pirincZemin;
  final Color pirincAcik;
  final Color pirincKenar;
  final Color zemin;
  final Color yuzey;
  final Color okumaZemini;
  final Color yesilZemin;
  final Color segmentZemin;
  final Color kenarlik;
  final Color ayrac;
  final Color metin;
  final Color metinIkincil;
  final Color metinPasif;
  final Color menuPasif;

  static const acik = AbyadPalet(
    koyu: false,
    zumrut: Color(0xFF0F3D33),
    zumrutKoyu: Color(0xFF0A2B24),
    koyuZemin: Color(0xFF0F3D33),
    pirincYazi: Color(0xFF8A6316),
    pirincSus: Color(0xFFB9944A),
    pirincZemin: Color(0xFFF4EBD6),
    pirincAcik: Color(0xFFFBF5E7),
    pirincKenar: Color(0xFFE4D6B4),
    zemin: Color(0xFFF3F4EF),
    yuzey: Color(0xFFFFFFFF),
    okumaZemini: Color(0xFFFBFBF8),
    yesilZemin: Color(0xFFE3ECE7),
    segmentZemin: Color(0xFFE6EAE4),
    kenarlik: Color(0xFFE1E5DF),
    ayrac: Color(0xFFEEF1EC),
    metin: Color(0xFF17231F),
    metinIkincil: Color(0xFF56625D),
    metinPasif: Color(0xFF6B7772),
    menuPasif: Color(0xFF5E6B66),
  );

  static const karanlik = AbyadPalet(
    koyu: true,
    zumrut: Color(0xFF8FD0BC),
    zumrutKoyu: Color(0xFF6FB9A3),
    koyuZemin: Color(0xFF14433A),
    pirincYazi: Color(0xFFE2C27A),
    pirincSus: Color(0xFFB9944A),
    pirincZemin: Color(0xFF3A3018),
    pirincAcik: Color(0xFF2A2415),
    pirincKenar: Color(0xFF5A4C26),
    zemin: Color(0xFF0E1513),
    yuzey: Color(0xFF18221F),
    okumaZemini: Color(0xFF121A17),
    yesilZemin: Color(0xFF1F302A),
    segmentZemin: Color(0xFF232E2A),
    kenarlik: Color(0xFF2C3833),
    ayrac: Color(0xFF232D29),
    metin: Color(0xFFE8EEEA),
    metinIkincil: Color(0xFFA9B6B0),
    metinPasif: Color(0xFF8B9892),
    menuPasif: Color(0xFF96A39D),
  );
}

/// Abyad renk paleti. Tasarımdaki bütün renkler buradan gelir;
/// ekranlarda doğrudan hex kod yazmayın, bu sınıfı kullanın.
///
/// Renkler seçili temaya ([palet]) göre değişir; bu yüzden sabit (`const`)
/// ifadelerde kullanılamaz. Tema, uygulamanın kökünde (AbyadApp) değişir.
class AbyadColors {
  AbyadColors._();

  static AbyadPalet palet = AbyadPalet.acik;

  /// Vurgu rengi: başlıklar, ikonlar, dolu düğmeler. Açık temada koyu
  /// zümrüt, koyu temada açık yeşil; üstündeki yazı [yuzey] olur.
  static Color get zumrut => palet.zumrut;
  static Color get zumrutKoyu => palet.zumrutKoyu; // basılı durum

  /// Koyu paneller (ana sayfa başlığı, vurgu kartları). İki temada da
  /// koyu yeşildir; üstündeki yazı [koyuUstu], [pirinc], [koyuUstuIkincil].
  static Color get koyuZemin => palet.koyuZemin;
  static const koyuUstu = Color(0xFFFFFFFF);

  static const pirinc = Color(0xFFE2C27A); // koyu zemin üstünde vurgu
  static const pirincUstu = Color(0xFF0F3D33); // pirinç zemin üstünde yazı
  static Color get pirincYazi => palet.pirincYazi; // zemin üstünde pirinç yazı
  static Color get pirincSus => palet.pirincSus; // süsleme çizgisi
  static Color get pirincZemin => palet.pirincZemin; // "sıradaki" vurgusu
  static Color get pirincAcik => palet.pirincAcik; // seçili kart zemini
  static Color get pirincKenar => palet.pirincKenar;

  // Zeminler
  static Color get zemin => palet.zemin; // ekran zemini
  static Color get yuzey => palet.yuzey; // kartlar
  static Color get okumaZemini => palet.okumaZemini; // Kur'an okuma ekranı
  static Color get yesilZemin => palet.yesilZemin; // ikon kutuları
  static Color get segmentZemin => palet.segmentZemin;

  /// Rehber çizimlerinin arkası; çizimler koyu çizgili olduğu için iki
  /// temada da açıktır.
  static const cizimZemini = Color(0xFFF3F4EF);

  // Çizgiler
  static Color get kenarlik => palet.kenarlik;
  static Color get ayrac => palet.ayrac;

  // Yazılar
  static Color get metin => palet.metin;
  static Color get metinIkincil => palet.metinIkincil;
  static Color get metinPasif => palet.metinPasif; // geçmiş vakitler
  static Color get menuPasif => palet.menuPasif;
  static const koyuUstuIkincil = Color(0xFFCFE0D8); // koyu panelde ikincil

  // Koyu panel üstündeki yarı saydam katmanlar
  static const koyuUstuKart = Color(0x0FFFFFFF); // %6 beyaz
  static const koyuUstuSecili = Color(0x29FFFFFF); // %16 beyaz
  static const koyuUstuKenar = Color(0x47FFFFFF); // %28 beyaz
}
