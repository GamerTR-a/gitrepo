/// Günün altı vakti. Görünen adlar arayüz katmanında çeviriden gelir
/// (bkz. `vakit_adlari.dart`); bu dosya saf Dart'tır.
enum VakitTuru { imsak, gunes, ogle, ikindi, aksam, yatsi }

/// Bir namaz vakti
class Vakit {
  const Vakit(this.tur, this.saat, this.dakika);
  final VakitTuru tur;
  final int saat;
  final int dakika;

  String get metin =>
      '${saat.toString().padLeft(2, '0')}:${dakika.toString().padLeft(2, '0')}';

  DateTime gunde(DateTime gun) =>
      DateTime(gun.year, gun.month, gun.day, saat, dakika);
}

/// Bir günün vakitleri. Bütün saatler, konumun kendi saat dilimindeki
/// duvar saatidir.
class GunlukVakitler {
  const GunlukVakitler({
    required this.gun,
    required this.vakitler,
    this.tahminiVakitler = const {},
  });

  /// Vakitlerin ait olduğu gün (saat kısmı kullanılmaz)
  final DateTime gun;

  /// Sırası: İmsak, Güneş, Öğle, İkindi, Akşam, Yatsı
  final List<Vakit> vakitler;

  /// O gün astronomik olarak oluşmadığı için yüksek enlem kuralıyla
  /// (gecenin yedide biri) belirlenen vakitler
  final Set<VakitTuru> tahminiVakitler;

  Vakit operator [](VakitTuru tur) => vakitler[tur.index];

  DateTime zaman(VakitTuru tur) => this[tur].gunde(gun);
}

/// Şu anki ve sıradaki vakit.
class VakitDurumu {
  const VakitDurumu({
    required this.simdiki,
    required this.sonraki,
    required this.sonrakiZaman,
  });

  /// İmsaktan önce `null` (dünün yatsısı sürüyor)
  final VakitTuru? simdiki;
  final VakitTuru sonraki;
  final DateTime sonrakiZaman;

  Duration kalan(DateTime simdi) => sonrakiZaman.difference(simdi);

  /// Sıradaki vakit yarının imsakı mı?
  bool yarinMi(DateTime simdi) => sonrakiZaman.day != simdi.day;
}

/// [bugun] ve [yarin] vakitlerine göre [simdi] anındaki durum.
/// Yatsıdan sonra sıradaki vakit yarının imsakıdır.
VakitDurumu vakitDurumu(
  DateTime simdi,
  GunlukVakitler bugun,
  GunlukVakitler yarin,
) {
  VakitTuru? simdiki;
  for (final v in bugun.vakitler) {
    final zaman = v.gunde(bugun.gun);
    if (simdi.isBefore(zaman)) {
      return VakitDurumu(simdiki: simdiki, sonraki: v.tur, sonrakiZaman: zaman);
    }
    simdiki = v.tur;
  }
  return VakitDurumu(
    simdiki: simdiki,
    sonraki: VakitTuru.imsak,
    sonrakiZaman: yarin.zaman(VakitTuru.imsak),
  );
}
