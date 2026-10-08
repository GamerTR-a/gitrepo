/// Namaz ve abdest rehberinin veri modeli, adım üretimi ve şema doğrulaması.
/// Saf Dart: Flutter'a bağımlı değildir (tool/rehber_dogrula.dart da kullanır).
library;

/// Rehberdeki tek bir adımın tanımı (assets/data/rehber/*.json).
class RehberAdimi {
  const RehberAdimi({
    required this.id,
    required this.baslik,
    required this.aciklama,
    this.arapca,
    this.okunus,
    this.anlam,
    this.dualar = const [],
    this.zammiSure = false,
    this.tekrar = 1,
    this.cizim,
    this.cizimTarifi,
    this.ses,
    this.kadinNotu,
  });

  factory RehberAdimi.fromJson(Map<String, dynamic> j) => RehberAdimi(
    id: j['id'] as String,
    baslik: j['baslik'] as String,
    aciklama: j['aciklama'] as String,
    arapca: j['arapca'] as String?,
    okunus: j['okunus'] as String?,
    anlam: j['anlam'] as String?,
    dualar: (j['dualar'] as List).cast<String>(),
    zammiSure: j['zammi_sure'] as bool,
    tekrar: j['tekrar'] as int,
    cizim: j['cizim'] as String?,
    cizimTarifi: j['cizim_tarifi'] as String?,
    ses: j['ses'] as String?,
    kadinNotu: j['kadin_notu'] as String?,
  );

  final String id;
  final String baslik;
  final String aciklama;

  /// Kısa tesbih ve tekbirler; sure ve dua metinleri [dualar] ile gelir.
  final String? arapca;
  final String? okunus;
  final String? anlam;

  /// dualar.json'daki kayıtların kimlikleri, okunuş sırasıyla
  final List<String> dualar;

  /// Fâtiha'dan sonra kısa bir sure okunur
  final bool zammiSure;
  final int tekrar;

  /// assets/rehber/ altındaki çizim dosyası ve ekran okuyucu tarifi
  final String? cizim;
  final String? cizimTarifi;

  /// assets/audio/rehber/ altındaki ses dosyası
  final String? ses;
  final String? kadinNotu;
}

enum BolumTuru {
  farz('farz'),
  sunnet('sunnet'),

  /// İkindinin sünneti ve yatsının ilk sünneti
  sunnetGayriMuekked('sunnet_gayri_muekked'),
  vitir('vitir');

  const BolumTuru(this.kod);
  final String kod;

  static BolumTuru? bul(Object? kod) =>
      values.where((t) => t.kod == kod).firstOrNull;
}

/// Bir vaktin tek bölümü ("Öğle – farz", 4 rekat)
class NamazBolumu {
  const NamazBolumu({
    required this.id,
    required this.ad,
    required this.tur,
    required this.rekat,
    required this.niyet,
  });

  final String id;
  final String ad;
  final BolumTuru tur;
  final int rekat;
  final String niyet;
}

class NamazVakti {
  const NamazVakti({
    required this.id,
    required this.ad,
    required this.bolumler,
    required this.yerTutucu,
  });

  final String id;
  final String ad;
  final List<NamazBolumu> bolumler;

  /// İçeriği henüz gelmemiş vakit (Cuma)
  final bool yerTutucu;
}

/// Sıraya dizilmiş, ekranda gösterilecek adım.
class SiraliAdim {
  const SiraliAdim(this.adim, {this.rekat, this.okunus, this.sure});

  final RehberAdimi adim;

  /// Kaçıncı rekat; abdest ve niyet adımlarında yok
  final int? rekat;

  /// Bölüme özgü okunuş (niyet cümlesi)
  final String? okunus;

  /// Bu rekatta örnek gösterilen surenin dualar.json kimliği
  final String? sure;
}

class NamazRehberi {
  const NamazRehberi({
    required this.adimlar,
    required this.zammiSureler,
    required this.vakitler,
  });

  factory NamazRehberi.fromJson(
    Map<String, dynamic> adimlar,
    Map<String, dynamic> vakitler,
  ) => NamazRehberi(
    adimlar: {
      for (final a in (adimlar['adimlar'] as List).cast<Map<String, dynamic>>())
        a['id'] as String: RehberAdimi.fromJson(a),
    },
    zammiSureler: (vakitler['zammi_sureler'] as List).cast<String>(),
    vakitler: [
      for (final v
          in (vakitler['vakitler'] as List).cast<Map<String, dynamic>>())
        NamazVakti(
          id: v['id'] as String,
          ad: v['ad'] as String,
          yerTutucu: v['yer_tutucu'] as bool,
          bolumler: [
            for (final b
                in (v['bolumler'] as List).cast<Map<String, dynamic>>())
              NamazBolumu(
                id: b['id'] as String,
                ad: b['ad'] as String,
                tur: BolumTuru.bul(b['tur'])!,
                rekat: b['rekat'] as int,
                niyet: b['niyet'] as String,
              ),
          ],
        ),
    ],
  );

  final Map<String, RehberAdimi> adimlar;
  final List<String> zammiSureler;
  final List<NamazVakti> vakitler;

  /// [bolum] için baştan sona adım listesi (Hanefi, Diyanet uygulaması):
  ///
  /// * Sübhâneke ilk rekatta, gayr-i müekked sünnetlerde üçüncü rekatta da
  ///   okunur.
  /// * Farzların üçüncü ve dördüncü rekatlarında yalnızca Fâtiha okunur.
  /// * İkinci rekatın sonunda (namaz daha uzunsa) ilk oturuş, son rekatın
  ///   sonunda son oturuş ve selam vardır.
  /// * Vitrin üçüncü rekatında rükûdan önce tekbir alınıp Kunut okunur.
  List<SiraliAdim> adimlariUret(NamazBolumu bolum) {
    final sira = <SiraliAdim>[];
    void ekle(String id, {int? rekat, String? okunus, String? sure}) =>
        sira.add(
          SiraliAdim(adimlar[id]!, rekat: rekat, okunus: okunus, sure: sure),
        );

    final gayriMuekked = bolum.tur == BolumTuru.sunnetGayriMuekked;
    ekle('niyet', okunus: bolum.niyet);
    ekle('iftitah_tekbiri', rekat: 1);
    for (var r = 1; r <= bolum.rekat; r++) {
      if (r == 1 || (r == 3 && gayriMuekked)) ekle('kiyam', rekat: r);
      final sureli = bolum.tur != BolumTuru.farz || r <= 2;
      ekle(
        r == 1 ? 'kiraat_ilk' : (sureli ? 'kiraat' : 'kiraat_fatiha'),
        rekat: r,
        sure: sureli ? zammiSureler[(r - 1) % zammiSureler.length] : null,
      );
      if (bolum.tur == BolumTuru.vitir && r == 3) {
        ekle('kunut_tekbiri', rekat: r);
        ekle('kunut', rekat: r);
      }
      for (final id in const [
        'ruku',
        'kavme',
        'secde',
        'celse',
        'ikinci_secde',
      ]) {
        ekle(id, rekat: r);
      }
      if (r == bolum.rekat) {
        ekle('kade_ahire', rekat: r);
        ekle('selam', rekat: r);
      } else if (r == 2) {
        ekle(gayriMuekked ? 'kade_ula_salavatli' : 'kade_ula', rekat: r);
      }
    }
    return sira;
  }
}

class AbdestRehberi {
  const AbdestRehberi({required this.adimlar, required this.bozanlar});

  factory AbdestRehberi.fromJson(Map<String, dynamic> j) => AbdestRehberi(
    adimlar: [
      for (final a in (j['adimlar'] as List).cast<Map<String, dynamic>>())
        SiraliAdim(RehberAdimi.fromJson(a)),
    ],
    bozanlar: [
      for (final b in (j['bozanlar'] as List).cast<Map<String, dynamic>>())
        b['metin'] as String,
    ],
  );

  final List<SiraliAdim> adimlar;

  /// Abdesti bozan durumlar (kısa liste)
  final List<String> bozanlar;
}

/// [NamazRehberi.adimlariUret] içinde adıyla kullanılan adımlar.
const zorunluNamazAdimlari = [
  'niyet',
  'iftitah_tekbiri',
  'kiyam',
  'kiraat_ilk',
  'kiraat',
  'kiraat_fatiha',
  'kunut_tekbiri',
  'kunut',
  'ruku',
  'kavme',
  'secde',
  'celse',
  'ikinci_secde',
  'kade_ula',
  'kade_ula_salavatli',
  'kade_ahire',
  'selam',
];

const _incelemeAlanlari = ['kaynak', 'incelendi', 'inceleyen', 'not'];
final _cizimAdi = RegExp(r'^(abdest|namaz)_\d{2}_[a-z_]+\.svg$');
final _sesAdi = RegExp(r'^[a-z_]+\.mp3$');

/// Üç rehber dosyasının şemasını denetler; bulduğu hataları döndürür
/// (boş liste = geçerli). [duaKimlikleri] dualar.json'daki kimliklerdir.
List<String> rehberiDogrula({
  required Map<String, dynamic> abdest,
  required Map<String, dynamic> namazAdimlari,
  required Map<String, dynamic> namazVakitleri,
  required Set<String> duaKimlikleri,
}) {
  final hatalar = <String>[];

  void inceleme(String yer, Map<String, dynamic> j) {
    for (final alan in _incelemeAlanlari) {
      if (!j.containsKey(alan)) hatalar.add('$yer: "$alan" alanı yok');
    }
    if (j['incelendi'] is! bool) hatalar.add('$yer: "incelendi" bool olmalı');
    if (j['kaynak'] is! String || (j['kaynak'] as String).isEmpty) {
      hatalar.add('$yer: "kaynak" boş');
    }
    if (j['incelendi'] == true &&
        (j['inceleyen'] is! String || (j['inceleyen'] as String).isEmpty)) {
      hatalar.add('$yer: incelendi ama "inceleyen" boş');
    }
  }

  bool dolu(Object? d) => d is String && d.trim().isNotEmpty;
  bool metinVeyaYok(Object? d) => d == null || dolu(d);

  List<Map<String, dynamic>> liste(Map<String, dynamic> j, String alan) {
    final l = j[alan];
    if (l is! List || l.any((e) => e is! Map<String, dynamic>)) {
      hatalar.add('"$alan" bir kayıt listesi olmalı');
      return const [];
    }
    return l.cast<Map<String, dynamic>>();
  }

  Set<String> adimlar(String dosya, Map<String, dynamic> j) {
    final kimlikler = <String>{};
    for (final a in liste(j, 'adimlar')) {
      final yer = '$dosya/${a['id']}';
      if (!dolu(a['id']) || !kimlikler.add(a['id'] as String)) {
        hatalar.add('$yer: kimlik boş ya da yinelenmiş');
      }
      if (!dolu(a['baslik'])) hatalar.add('$yer: "baslik" boş');
      if (!dolu(a['aciklama'])) hatalar.add('$yer: "aciklama" boş');
      for (final alan in const [
        'arapca',
        'okunus',
        'anlam',
        'kadin_notu',
        'cizim_tarifi',
      ]) {
        if (!a.containsKey(alan) || !metinVeyaYok(a[alan])) {
          hatalar.add('$yer: "$alan" metin ya da null olmalı');
        }
      }
      // Arapça metin tek başına bırakılmaz
      if (a['arapca'] != null && (a['okunus'] == null || a['anlam'] == null)) {
        hatalar.add('$yer: "arapca" varsa okunuş ve anlam da olmalı');
      }
      final tekrar = a['tekrar'];
      if (tekrar is! int || tekrar < 1) {
        hatalar.add('$yer: "tekrar" en az 1 olan tam sayı olmalı');
      }
      if (a['zammi_sure'] is! bool) {
        hatalar.add('$yer: "zammi_sure" bool olmalı');
      }
      final dualar = a['dualar'];
      if (dualar is! List) {
        hatalar.add('$yer: "dualar" liste olmalı');
      } else {
        for (final d in dualar) {
          if (!duaKimlikleri.contains(d)) {
            hatalar.add('$yer: dualar.json içinde "$d" yok');
          }
        }
      }
      final cizim = a['cizim'];
      if (cizim != null && !(cizim is String && _cizimAdi.hasMatch(cizim))) {
        hatalar.add('$yer: çizim adı kurala uymuyor ($cizim)');
      }
      if (cizim != null && !dolu(a['cizim_tarifi'])) {
        hatalar.add('$yer: çizimin "cizim_tarifi" yok');
      }
      final ses = a['ses'];
      if (ses != null && !(ses is String && _sesAdi.hasMatch(ses))) {
        hatalar.add('$yer: ses adı kurala uymuyor ($ses)');
      }
      inceleme(yer, a);
    }
    return kimlikler;
  }

  // abdest.json
  final abdestKimlikleri = adimlar('abdest', abdest);
  if (abdestKimlikleri.isEmpty) hatalar.add('abdest: adım yok');
  final bozanlar = liste(abdest, 'bozanlar');
  if (bozanlar.isEmpty) hatalar.add('abdest: "bozanlar" boş');
  for (final b in bozanlar) {
    final yer = 'abdest/bozanlar/${b['id']}';
    if (!dolu(b['id'])) hatalar.add('$yer: kimlik boş');
    if (!dolu(b['metin'])) hatalar.add('$yer: "metin" boş');
    inceleme(yer, b);
  }

  // namaz_adimlari.json
  final namazKimlikleri = adimlar('namaz_adimlari', namazAdimlari);
  for (final id in zorunluNamazAdimlari) {
    if (!namazKimlikleri.contains(id)) {
      hatalar.add('namaz_adimlari: "$id" adımı yok');
    }
  }

  // namaz_vakitleri.json
  final sureler = namazVakitleri['zammi_sureler'];
  if (sureler is! List || sureler.isEmpty) {
    hatalar.add('namaz_vakitleri: "zammi_sureler" boş');
  } else {
    for (final s in sureler) {
      if (!duaKimlikleri.contains(s)) {
        hatalar.add('namaz_vakitleri: dualar.json içinde "$s" suresi yok');
      }
    }
  }
  final vakitKimlikleri = <String>{};
  for (final v in liste(namazVakitleri, 'vakitler')) {
    final yer = 'namaz_vakitleri/${v['id']}';
    if (!dolu(v['id']) || !vakitKimlikleri.add(v['id'] as String)) {
      hatalar.add('$yer: kimlik boş ya da yinelenmiş');
    }
    if (!dolu(v['ad'])) hatalar.add('$yer: "ad" boş');
    if (v['yer_tutucu'] is! bool) {
      hatalar.add('$yer: "yer_tutucu" bool olmalı');
      continue;
    }
    final bolumler = liste(v, 'bolumler');
    if (v['yer_tutucu'] == true) {
      if (bolumler.isNotEmpty) hatalar.add('$yer: yer tutucunun bölümü olmaz');
      continue;
    }
    if (bolumler.isEmpty) hatalar.add('$yer: bölüm yok');
    final bolumKimlikleri = <String>{};
    for (final b in bolumler) {
      final byer = '$yer/${b['id']}';
      if (!dolu(b['id']) || !bolumKimlikleri.add(b['id'] as String)) {
        hatalar.add('$byer: kimlik boş ya da yinelenmiş');
      }
      if (!dolu(b['ad'])) hatalar.add('$byer: "ad" boş');
      if (!dolu(b['niyet'])) hatalar.add('$byer: "niyet" boş');
      final tur = BolumTuru.bul(b['tur']);
      if (tur == null) hatalar.add('$byer: bilinmeyen tür (${b['tur']})');
      final rekat = b['rekat'];
      if (rekat is! int || rekat < 2 || rekat > 4) {
        hatalar.add('$byer: "rekat" 2–4 arasında olmalı');
      } else if (tur == BolumTuru.vitir && rekat != 3) {
        hatalar.add('$byer: vitir 3 rekattır');
      } else if (tur == BolumTuru.sunnetGayriMuekked && rekat != 4) {
        hatalar.add('$byer: gayr-i müekked sünnet 4 rekattır');
      }
      inceleme(byer, b);
    }
  }
  for (final id in const ['sabah', 'ogle', 'ikindi', 'aksam', 'yatsi']) {
    if (!vakitKimlikleri.contains(id)) {
      hatalar.add('namaz_vakitleri: "$id" vakti yok');
    }
  }
  return hatalar;
}
