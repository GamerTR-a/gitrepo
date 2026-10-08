import 'dart:math' as math;

/// Vakitlerin hesaplandığı yer. Yalnızca cihazda saklanır.
class Konum {
  const Konum({
    required this.ad,
    required this.enlem,
    required this.boylam,
    required this.dilim,
    this.ust = '',
    this.ulke = '',
    this.otomatik = false,
  });

  final String ad;

  /// İlçe ise bağlı olduğu il
  final String ust;
  final String ulke;
  final double enlem;
  final double boylam;

  /// IANA saat dilimi (ör. Europe/Istanbul)
  final String dilim;

  /// Cihazın konum servisinden mi alındı?
  final bool otomatik;

  /// Ülkesi bilinen ve Türkiye dışında olan bir konum mu? Listede olmayan
  /// bir yerde otomatik bulunan konumun ülkesi boştur ve Türkiye gibi
  /// hesaplanır.
  bool get yurtDisi => ulke.isNotEmpty && ulke != 'Türkiye';

  /// Konum seçilmeden önceki varsayılan
  static const istanbul = Konum(
    ad: 'İstanbul',
    ulke: 'Türkiye',
    enlem: 41.0138,
    boylam: 28.9497,
    dilim: 'Europe/Istanbul',
  );

  factory Konum.fromJson(Map<String, dynamic> j) => Konum(
    ad: j['ad'] as String,
    ust: (j['ust'] as String?) ?? '',
    ulke: (j['ulke'] as String?) ?? '',
    enlem: (j['enlem'] as num).toDouble(),
    boylam: (j['boylam'] as num).toDouble(),
    dilim: j['dilim'] as String,
    otomatik: (j['otomatik'] as bool?) ?? false,
  );

  Map<String, dynamic> toJson() => {
    'ad': ad,
    'ust': ust,
    'ulke': ulke,
    'enlem': enlem,
    'boylam': boylam,
    'dilim': dilim,
    'otomatik': otomatik,
  };

  Konum copyWith({bool? otomatik, String? dilim}) => Konum(
    ad: ad,
    ust: ust,
    ulke: ulke,
    enlem: enlem,
    boylam: boylam,
    dilim: dilim ?? this.dilim,
    otomatik: otomatik ?? this.otomatik,
  );
}

/// Aramada Türkçe harf ve büyük/küçük harf farkını yok sayar.
String aramaAnahtari(String metin) {
  const esler = {
    'ç': 'c',
    'ğ': 'g',
    'ı': 'i',
    'ö': 'o',
    'ş': 's',
    'ü': 'u',
    'â': 'a',
    'î': 'i',
    'û': 'u',
    'Ç': 'c',
    'Ğ': 'g',
    'İ': 'i',
    'I': 'i',
    'Ö': 'o',
    'Ş': 's',
    'Ü': 'u',
    'Â': 'a',
    'Î': 'i',
    'Û': 'u',
    "'": '',
    '’': '',
    '-': ' ',
  };
  final b = StringBuffer();
  for (final harf in metin.split('')) {
    b.write(esler[harf] ?? harf.toLowerCase());
  }
  return b.toString().trim();
}

/// [sehirler] içinde adı ya da ili [sorgu] ile başlayanlar önce, içerenler
/// sonra gelecek şekilde arar.
List<Konum> sehirAra(List<Konum> sehirler, String sorgu, {int azami = 60}) {
  final s = aramaAnahtari(sorgu);
  if (s.isEmpty) {
    return sehirler.where((k) => k.ust.isEmpty).take(azami).toList();
  }
  final baslayan = <Konum>[];
  final iceren = <Konum>[];
  for (final k in sehirler) {
    final ad = aramaAnahtari(k.ad);
    if (ad.startsWith(s)) {
      baslayan.add(k);
    } else if (ad.contains(s) || aramaAnahtari(k.ust).startsWith(s)) {
      iceren.add(k);
    }
  }
  return [...baslayan, ...iceren].take(azami).toList();
}

/// İki nokta arasındaki yaklaşık mesafe (km, haversine)
double mesafeKm(double enlem1, double boylam1, double enlem2, double boylam2) {
  double rad(double d) => d * math.pi / 180;
  final dEnlem = rad(enlem2 - enlem1);
  final dBoylam = rad(boylam2 - boylam1);
  final a =
      math.pow(math.sin(dEnlem / 2), 2) +
      math.cos(rad(enlem1)) *
          math.cos(rad(enlem2)) *
          math.pow(math.sin(dBoylam / 2), 2);
  return 6371 * 2 * math.asin(math.sqrt(a));
}

/// Koordinata en yakın kayıtlı yerleşim (internetsiz "neredeyim" için)
Konum? enYakinSehir(List<Konum> sehirler, double enlem, double boylam) {
  Konum? enYakin;
  var enKisa = double.infinity;
  for (final k in sehirler) {
    final m = mesafeKm(enlem, boylam, k.enlem, k.boylam);
    if (m < enKisa) {
      enKisa = m;
      enYakin = k;
    }
  }
  return enYakin;
}
