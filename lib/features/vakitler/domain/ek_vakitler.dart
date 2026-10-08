import 'gunluk_vakitler.dart';

/// Kerahat sürelerinin dakika cinsinden uzunlukları.
///
/// Varsayılanlar taslaktır ve `assets/data/ek_vakitler.json` içindeki
/// `sureler` alanından okunur; inceleyen hoca farklı bir süre uygun görürse
/// yalnızca o dosya değişir (bkz. docs/hoca/danisilacak_konular.md).
class EkVakitSureleri {
  const EkVakitSureleri({
    this.dogusDakika = 45,
    this.istivaDakika = 10,
    this.batisDakika = 45,
  });

  /// Güneş doğduktan sonra kerahatin sürdüğü süre
  final int dogusDakika;

  /// Öğle vaktinden önce, güneş tepedeyken kerahat sayılan süre
  final int istivaDakika;

  /// Güneş batmadan önce kerahatin başladığı süre
  final int batisDakika;

  factory EkVakitSureleri.fromJson(Map<String, dynamic> j) {
    const v = EkVakitSureleri();
    int oku(String alan, int varsayilan) {
      final d = j[alan];
      return d is int && d >= 0 ? d : varsayilan;
    }

    return EkVakitSureleri(
      dogusDakika: oku('dogus_dakika', v.dogusDakika),
      istivaDakika: oku('istiva_dakika', v.istivaDakika),
      batisDakika: oku('batis_dakika', v.batisDakika),
    );
  }
}

/// Başı dahil, sonu hariç zaman aralığı (konumun duvar saatiyle).
class ZamanAraligi {
  const ZamanAraligi(this.baslangic, this.bitis);
  final DateTime baslangic;
  final DateTime bitis;

  Duration get sure => bitis.difference(baslangic);

  bool icinde(DateTime an) => !an.isBefore(baslangic) && an.isBefore(bitis);
}

/// Altı vaktin dışında gösterilen vakitler: kerahat vakitleri, işrak/duhâ
/// ve gecenin son üçte biri (teheccüd).
class EkVakitler {
  const EkVakitler({
    required this.dogusKerahati,
    required this.istivaKerahati,
    required this.batisKerahati,
    required this.duha,
    required this.gecenSonUcteBiri,
  });

  /// Güneşin doğuşundan yükselmesine kadar
  final ZamanAraligi dogusKerahati;

  /// Güneş tepedeyken, öğle vaktine kadar
  final ZamanAraligi istivaKerahati;

  /// Güneş batmadan önce, akşam vaktine kadar
  final ZamanAraligi batisKerahati;

  /// İşrak ve duhâ (kuşluk): doğuş kerahati çıkınca başlar, istiva
  /// kerahatine kadar sürer. Gündüz çok kısaysa `null`.
  final ZamanAraligi? duha;

  /// Akşamdan ertesi günün imsakına kadar süren gecenin son üçte biri.
  /// Gece oluşmuyorsa (kutup gündüzü) `null`.
  final ZamanAraligi? gecenSonUcteBiri;

  /// [an] bir kerahat vaktine denk geliyorsa o aralık
  ZamanAraligi? kerahat(DateTime an) => [
    dogusKerahati,
    istivaKerahati,
    batisKerahati,
  ].where((a) => a.icinde(an)).firstOrNull;
}

/// [bugun] ve [yarin] vakitlerinden ek vakitleri türetir. Hata fırlatmaz.
EkVakitler ekVakitleriHesapla(
  GunlukVakitler bugun,
  GunlukVakitler yarin, {
  EkVakitSureleri sureler = const EkVakitSureleri(),
}) {
  final gunes = bugun.zaman(VakitTuru.gunes);
  final ogle = bugun.zaman(VakitTuru.ogle);
  final aksam = bugun.zaman(VakitTuru.aksam);
  final yarinImsak = yarin.zaman(VakitTuru.imsak);

  final israk = gunes.add(Duration(minutes: sureler.dogusDakika));
  final istiva = ogle.subtract(Duration(minutes: sureler.istivaDakika));
  final gece = yarinImsak.difference(aksam);

  return EkVakitler(
    dogusKerahati: ZamanAraligi(gunes, israk),
    istivaKerahati: ZamanAraligi(istiva, ogle),
    batisKerahati: ZamanAraligi(
      aksam.subtract(Duration(minutes: sureler.batisDakika)),
      aksam,
    ),
    duha: israk.isBefore(istiva) ? ZamanAraligi(israk, istiva) : null,
    gecenSonUcteBiri: gece > Duration.zero && gece < const Duration(hours: 24)
        ? ZamanAraligi(
            yarinImsak.subtract(Duration(minutes: gece.inMinutes ~/ 3)),
            yarinImsak,
          )
        : null,
  );
}
