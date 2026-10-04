import '../../bildirim/domain/bildirim_plani.dart';
import '../../konum/domain/konum.dart';
import '../../vakitler/domain/gunluk_vakitler.dart';
import '../../vakitler/domain/vakit_hesaplama.dart';

/// Yazı boyutu seçenekleri; telefonun kendi yazı ölçeğiyle çarpılır.
enum YaziBoyutu {
  normal(1.0),
  buyuk(1.25),
  cokBuyuk(1.5);

  const YaziBoyutu(this.carpan);
  final double carpan;
}

/// Kullanıcının bütün tercihleri. Yalnızca cihazda saklanır.
class Ayarlar {
  const Ayarlar({
    this.ilkAcilisTamam = false,
    this.yaziBoyutu = YaziBoyutu.normal,
    this.yuksekKontrast = false,
    this.konum = Konum.istanbul,
    this.yontem = HesapYontemi.diyanet,
    this.duzeltmeler = const {},
    this.hicriDuzeltme = 0,
    this.bildirim = BildirimAyarlari.varsayilan,
    this.alarmOlarakCal = true,
    this.zikirTitresim = true,
    this.zikirTumEkran = false,
    this.zikirEkranAcik = false,
    this.kibleTitresim = true,
    this.kazaGizli = false,
    this.kazaTempo = 2,
    this.hatirlatilanGunler = const {},
    this.kuranYaziOlcegi = 1.0,
    this.ozelZikir = '',
    this.kuranSayfaGorunumu = true,
    this.mealId = '',
  });

  final bool ilkAcilisTamam;
  final YaziBoyutu yaziBoyutu;
  final bool yuksekKontrast;
  final Konum konum;
  final HesapYontemi yontem;
  final Map<VakitTuru, int> duzeltmeler;

  /// Hicrî tarihe eklenen gün (−1, 0, +1)
  final int hicriDuzeltme;
  final BildirimAyarlari bildirim;

  /// Ezan, medya sesi kısıkken de duyulsun diye alarm kanalından çalınır
  final bool alarmOlarakCal;
  final bool zikirTitresim;
  final bool zikirTumEkran;
  final bool zikirEkranAcik;
  final bool kibleTitresim;
  final bool kazaGizli;
  final int kazaTempo;

  /// Hatırlatması açık önemli günlerin kimlikleri
  final Set<String> hatirlatilanGunler;
  final double kuranYaziOlcegi;

  /// Zikirmatik'e kullanıcının eklediği zikir; boşsa yok
  final String ozelZikir;

  /// Kur'an sayfa sayfa mı (Mushaf düzeni) yoksa ayet ayet mi açılsın
  final bool kuranSayfaGorunumu;

  /// Seçili mealin kimliği; boşsa gömülü ilk meal
  final String mealId;

  HesapAyarlari get hesap =>
      HesapAyarlari(yontem: yontem, duzeltmeler: duzeltmeler);

  Ayarlar copyWith({
    bool? ilkAcilisTamam,
    YaziBoyutu? yaziBoyutu,
    bool? yuksekKontrast,
    Konum? konum,
    HesapYontemi? yontem,
    Map<VakitTuru, int>? duzeltmeler,
    int? hicriDuzeltme,
    BildirimAyarlari? bildirim,
    bool? alarmOlarakCal,
    bool? zikirTitresim,
    bool? zikirTumEkran,
    bool? zikirEkranAcik,
    bool? kibleTitresim,
    bool? kazaGizli,
    int? kazaTempo,
    Set<String>? hatirlatilanGunler,
    double? kuranYaziOlcegi,
    String? ozelZikir,
    bool? kuranSayfaGorunumu,
    String? mealId,
  }) => Ayarlar(
    ilkAcilisTamam: ilkAcilisTamam ?? this.ilkAcilisTamam,
    yaziBoyutu: yaziBoyutu ?? this.yaziBoyutu,
    yuksekKontrast: yuksekKontrast ?? this.yuksekKontrast,
    konum: konum ?? this.konum,
    yontem: yontem ?? this.yontem,
    duzeltmeler: duzeltmeler ?? this.duzeltmeler,
    hicriDuzeltme: hicriDuzeltme ?? this.hicriDuzeltme,
    bildirim: bildirim ?? this.bildirim,
    alarmOlarakCal: alarmOlarakCal ?? this.alarmOlarakCal,
    zikirTitresim: zikirTitresim ?? this.zikirTitresim,
    zikirTumEkran: zikirTumEkran ?? this.zikirTumEkran,
    zikirEkranAcik: zikirEkranAcik ?? this.zikirEkranAcik,
    kibleTitresim: kibleTitresim ?? this.kibleTitresim,
    kazaGizli: kazaGizli ?? this.kazaGizli,
    kazaTempo: kazaTempo ?? this.kazaTempo,
    hatirlatilanGunler: hatirlatilanGunler ?? this.hatirlatilanGunler,
    kuranYaziOlcegi: kuranYaziOlcegi ?? this.kuranYaziOlcegi,
    ozelZikir: ozelZikir ?? this.ozelZikir,
    kuranSayfaGorunumu: kuranSayfaGorunumu ?? this.kuranSayfaGorunumu,
    mealId: mealId ?? this.mealId,
  );

  Map<String, dynamic> toJson() => {
    'ilkAcilisTamam': ilkAcilisTamam,
    'yaziBoyutu': yaziBoyutu.name,
    'yuksekKontrast': yuksekKontrast,
    'konum': konum.toJson(),
    'yontem': yontem.name,
    'duzeltmeler': {for (final e in duzeltmeler.entries) e.key.name: e.value},
    'hicriDuzeltme': hicriDuzeltme,
    'bildirim': {
      'vakitler': {
        for (final e in bildirim.vakitler.entries)
          e.key.name: {'acik': e.value.acik, 'ses': e.value.ses.name},
      },
      'onceDakika': bildirim.onceDakika,
      'cumaSessiz': bildirim.cumaSessiz,
    },
    'alarmOlarakCal': alarmOlarakCal,
    'zikirTitresim': zikirTitresim,
    'zikirTumEkran': zikirTumEkran,
    'zikirEkranAcik': zikirEkranAcik,
    'kibleTitresim': kibleTitresim,
    'kazaGizli': kazaGizli,
    'kazaTempo': kazaTempo,
    'hatirlatilanGunler': hatirlatilanGunler.toList(),
    'kuranYaziOlcegi': kuranYaziOlcegi,
    'ozelZikir': ozelZikir,
    'kuranSayfaGorunumu': kuranSayfaGorunumu,
    'mealId': mealId,
  };

  /// Eksik ya da tanınmayan alanlarda varsayılana düşer; eski sürümün
  /// kaydı yeni sürümde uygulamayı bozmaz.
  factory Ayarlar.fromJson(Map<String, dynamic> j) {
    const v = Ayarlar();
    T secenek<T extends Enum>(List<T> degerler, Object? ad, T varsayilan) =>
        degerler.where((d) => d.name == ad).firstOrNull ?? varsayilan;

    final b = j['bildirim'];
    var bildirim = v.bildirim;
    if (b is Map<String, dynamic>) {
      final vakitler = Map.of(v.bildirim.vakitler);
      final kayitli = b['vakitler'];
      if (kayitli is Map<String, dynamic>) {
        for (final tur in VakitTuru.values) {
          final k = kayitli[tur.name];
          if (k is Map<String, dynamic>) {
            vakitler[tur] = VakitBildirimAyari(
              acik: (k['acik'] as bool?) ?? vakitler[tur]!.acik,
              ses: secenek(BildirimSesi.values, k['ses'], vakitler[tur]!.ses),
            );
          }
        }
      }
      bildirim = BildirimAyarlari(
        vakitler: vakitler,
        onceDakika: (b['onceDakika'] as int?) ?? v.bildirim.onceDakika,
        cumaSessiz: (b['cumaSessiz'] as bool?) ?? v.bildirim.cumaSessiz,
      );
    }

    final d = j['duzeltmeler'];
    final k = j['konum'];
    return Ayarlar(
      ilkAcilisTamam: (j['ilkAcilisTamam'] as bool?) ?? v.ilkAcilisTamam,
      yaziBoyutu: secenek(YaziBoyutu.values, j['yaziBoyutu'], v.yaziBoyutu),
      yuksekKontrast: (j['yuksekKontrast'] as bool?) ?? v.yuksekKontrast,
      konum: k is Map<String, dynamic> ? Konum.fromJson(k) : v.konum,
      yontem: secenek(HesapYontemi.values, j['yontem'], v.yontem),
      duzeltmeler: {
        if (d is Map<String, dynamic>)
          for (final tur in VakitTuru.values)
            if (d[tur.name] is int && d[tur.name] != 0) tur: d[tur.name] as int,
      },
      hicriDuzeltme: (j['hicriDuzeltme'] as int?) ?? v.hicriDuzeltme,
      bildirim: bildirim,
      alarmOlarakCal: (j['alarmOlarakCal'] as bool?) ?? v.alarmOlarakCal,
      zikirTitresim: (j['zikirTitresim'] as bool?) ?? v.zikirTitresim,
      zikirTumEkran: (j['zikirTumEkran'] as bool?) ?? v.zikirTumEkran,
      zikirEkranAcik: (j['zikirEkranAcik'] as bool?) ?? v.zikirEkranAcik,
      kibleTitresim: (j['kibleTitresim'] as bool?) ?? v.kibleTitresim,
      kazaGizli: (j['kazaGizli'] as bool?) ?? v.kazaGizli,
      kazaTempo: (j['kazaTempo'] as int?) ?? v.kazaTempo,
      hatirlatilanGunler: {
        if (j['hatirlatilanGunler'] is List)
          for (final g in j['hatirlatilanGunler'] as List)
            if (g is String) g,
      },
      kuranYaziOlcegi:
          (j['kuranYaziOlcegi'] as num?)?.toDouble() ?? v.kuranYaziOlcegi,
      ozelZikir: (j['ozelZikir'] as String?) ?? v.ozelZikir,
      kuranSayfaGorunumu:
          (j['kuranSayfaGorunumu'] as bool?) ?? v.kuranSayfaGorunumu,
      mealId: (j['mealId'] as String?) ?? v.mealId,
    );
  }
}
