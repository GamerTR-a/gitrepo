/// Boşluk, köşe ve dokunma alanı ölçüleri (tasarımdaki piksel değerleri).
class AbyadSpace {
  AbyadSpace._();
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 20;
  static const double xxl = 24;

  /// Ekranın sağ/sol kenar boşluğu
  static const double ekranKenar = 20;

  /// Kartlar arası dikey boşluk
  static const double bolumArasi = 20;
}

class AbyadRadius {
  AbyadRadius._();
  static const double cip = 12;
  static const double dugme = 14;
  static const double ikonKutu = 18;
  static const double kart = 20;
  static const double buyukKart = 22;
  static const double baslikAlt = 28;
}

class AbyadSize {
  AbyadSize._();

  /// Erişilebilirlik: hiçbir dokunma alanı bundan küçük olmamalı.
  static const double minDokunma = 48;
  static const double ikon = 24;
}
