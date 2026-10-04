import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icerik/icerik.dart';
import '../../ayarlar/data/ayarlar_saglayici.dart';

class Sure {
  const Sure({
    required this.no,
    required this.ad,
    required this.arapca,
    required this.ayetSayisi,
    required this.baslangic,
    required this.mekki,
  });

  final int no;
  final String ad;
  final String arapca;
  final int ayetSayisi;

  /// Surenin ilk ayetinin bütün Kur'an içindeki sırası (0'dan başlar)
  final int baslangic;
  final bool mekki;
}

/// Sure ve ayet numarası (1'den başlar)
typedef AyetKonumu = ({int sure, int ayet});

const toplamSayfa = 604;

/// Gömülü Tanzil metni ve üst verisi. Metin değiştirilmez; yalnızca
/// satırlara ayrılır (bkz. assets/data/quran/quran-uthmani.txt içindeki
/// lisans bloğu).
class KuranVerisi {
  KuranVerisi({
    required this.sureler,
    required List<String> ayetler,
    required this.cuzler,
    required this.sayfalar,
  }) : _ayetler = ayetler;

  final List<Sure> sureler;
  final List<String> _ayetler;

  /// Her cüzün / sayfanın ilk ayeti
  final List<AyetKonumu> cuzler;
  final List<AyetKonumu> sayfalar;

  /// Fâtiha'nın ilk ayeti; Tevbe dışındaki surelerin başında da yer alır.
  String get besmele => _ayetler.first;

  Sure sure(int no) => sureler[no - 1];

  int _sira(int sure, int ayet) => this.sure(sure).baslangic + ayet - 1;

  /// Dosyadaki hâliyle ayet. Fâtiha ve Tevbe dışındaki surelerin ilk
  /// ayeti, Tanzil dosyasında besmele ile birlikte gelir.
  String hamAyet(int sure, int ayet) => _ayetler[_sira(sure, ayet)];

  /// Ekranda gösterilecek ayet: surenin ilk ayetinin başındaki besmele
  /// ayrı bir başlık olarak gösterildiği için burada ayrılır.
  String ayetMetni(int sure, int ayet) {
    final ham = hamAyet(sure, ayet);
    if (ayet == 1 && besmeleBasligi(sure) && ham.startsWith('$besmele ')) {
      return ham.substring(besmele.length + 1);
    }
    return ham;
  }

  bool besmeleBasligi(int sure) => sure != 1 && sure != 9;

  int _bolum(List<AyetKonumu> baslangiclar, int sure, int ayet) {
    var alt = 0;
    var ust = baslangiclar.length - 1;
    while (alt < ust) {
      final orta = (alt + ust + 1) ~/ 2;
      final b = baslangiclar[orta];
      if (b.sure < sure || (b.sure == sure && b.ayet <= ayet)) {
        alt = orta;
      } else {
        ust = orta - 1;
      }
    }
    return alt + 1;
  }

  int sayfaNo(int sure, int ayet) => _bolum(sayfalar, sure, ayet);
  int cuzNo(int sure, int ayet) => _bolum(cuzler, sure, ayet);

  int get ayetSayisi => _ayetler.length;

  /// Ayetin bütün Kur'an içindeki sırası (0'dan başlar)
  int sira(int sure, int ayet) => _sira(sure, ayet);

  /// [sayfa] (1–604) içindeki ayetler, okunuş sırasıyla.
  List<AyetKonumu> sayfaAyetleri(int sayfa) {
    final bas = sayfalar[sayfa - 1];
    final son = sayfa < sayfalar.length ? sayfalar[sayfa] : null;
    final liste = <AyetKonumu>[];
    var s = bas.sure;
    var a = bas.ayet;
    while (s <= sureler.length &&
        (son == null || s < son.sure || (s == son.sure && a < son.ayet))) {
      liste.add((sure: s, ayet: a));
      if (a < sure(s).ayetSayisi) {
        a++;
      } else {
        s++;
        a = 1;
      }
    }
    return liste;
  }

  /// "2:255" ya da "2:285-286" biçimindeki başvuruyu ayetlere çevirir.
  List<AyetKonumu> aralik(String basvuru) {
    final parcalar = basvuru.split(':');
    final sure = int.parse(parcalar[0]);
    final sinirlar = parcalar[1].split('-').map(int.parse).toList();
    return [
      for (var a = sinirlar.first; a <= sinirlar.last; a++)
        (sure: sure, ayet: a),
    ];
  }

  /// Sure adına ya da "sure:ayet" / "sure ayet" yazımına göre arar.
  List<({Sure sure, int? ayet})> ara(String sorgu) {
    final temiz = sorgu.trim();
    if (temiz.isEmpty) return const [];
    final sayi = RegExp(
      r'^(\d{1,3})(?:\s*[:.\s]\s*(\d{1,3}))?$',
    ).firstMatch(temiz);
    if (sayi != null) {
      final no = int.parse(sayi.group(1)!);
      if (no < 1 || no > sureler.length) return const [];
      final s = sure(no);
      final ayet = int.tryParse(sayi.group(2) ?? '');
      if (ayet != null && (ayet < 1 || ayet > s.ayetSayisi)) return const [];
      return [(sure: s, ayet: ayet)];
    }
    final anahtar = aramaAnahtari(temiz);
    return [
      for (final s in sureler)
        if (aramaAnahtari(s.ad).contains(anahtar)) (sure: s, ayet: null),
    ];
  }

  static KuranVerisi coz(String metin, String ustVeri) {
    final ayetler = <String>[];
    for (final satir in const LineSplitter().convert(metin)) {
      if (satir.isEmpty || satir.startsWith('#')) continue;
      // sure|ayet|metin
      final ilk = satir.indexOf('|');
      final ikinci = satir.indexOf('|', ilk + 1);
      ayetler.add(satir.substring(ikinci + 1));
    }
    final j = jsonDecode(ustVeri) as Map<String, dynamic>;
    List<AyetKonumu> konumlar(String alan) => [
      for (final k in j[alan] as List)
        (sure: (k as List)[0] as int, ayet: k[1] as int),
    ];
    return KuranVerisi(
      ayetler: ayetler,
      sureler: [
        for (final s in (j['sureler'] as List).cast<Map<String, dynamic>>())
          Sure(
            no: s['no'] as int,
            ad: s['ad'] as String,
            arapca: s['arapca'] as String,
            ayetSayisi: s['ayet'] as int,
            baslangic: s['baslangic'] as int,
            mekki: s['mekki'] as bool,
          ),
      ],
      cuzler: konumlar('cuzler'),
      sayfalar: konumlar('sayfalar'),
    );
  }
}

final kuranProvider = FutureProvider<KuranVerisi>((ref) async {
  final paket = ref.watch(varlikPaketiProvider);
  final metin = await paket.loadString('assets/data/quran/quran-uthmani.txt');
  final ustVeri = await paket.loadString('assets/data/quran/quran_meta.json');
  return KuranVerisi.coz(metin, ustVeri);
});

/// Ekranların meal okuduğu arayüz. Lisanslı meal eklenene kadar [MealYok]
/// kullanılır ve yer tutucu gösterilir. Hiçbir meal internetten indirilip
/// gömülmez (CLAUDE.md §2.8); nasıl ekleneceği: assets/data/quran/README.md
abstract interface class MealKaynagi {
  /// Mealin adı; kaynak yoksa `null`
  String? get ad;

  /// Ayetin meali; kaynak yoksa `null`
  String? meal(int sure, int ayet);
}

class MealYok implements MealKaynagi {
  const MealYok();

  @override
  String? get ad => null;

  @override
  String? meal(int sure, int ayet) => null;
}

/// `assets/data/quran/mealler.json` içindeki bir meal kaydı.
class MealBilgisi {
  const MealBilgisi({
    required this.id,
    required this.ad,
    required this.sahip,
    required this.lisans,
    required this.dosya,
  });

  final String id;
  final String ad;

  /// Mütercim ya da hak sahibi kurum
  final String sahip;

  /// Kullanım izninin özeti (Kaynaklar ve Lisanslar'da gösterilir)
  final String lisans;

  /// `assets/data/quran/meal/` altındaki dosya adı
  final String dosya;

  factory MealBilgisi.fromJson(Map<String, dynamic> j) => MealBilgisi(
    id: j['id'] as String,
    ad: j['ad'] as String,
    sahip: j['sahip'] as String,
    lisans: j['lisans'] as String,
    dosya: j['dosya'] as String,
  );
}

/// Dosyadan okunan meal. Biçim Tanzil ile aynıdır: her satır
/// `sure|ayet|metin`; boş satırlar ve `#` ile başlayanlar atlanır.
class DosyaMeali implements MealKaynagi {
  DosyaMeali._(this.bilgi, this._kuran, this._metinler);

  final MealBilgisi bilgi;
  final KuranVerisi _kuran;
  final List<String?> _metinler;

  @override
  String get ad => bilgi.ad;

  @override
  String? meal(int sure, int ayet) => _metinler[_kuran.sira(sure, ayet)];

  /// Meali bulunmayan ayet sayısı; tam bir mealde 0 olmalı.
  int get eksikSayisi => _metinler.where((m) => m == null).length;

  static DosyaMeali coz(MealBilgisi bilgi, KuranVerisi kuran, String metin) {
    final metinler = List<String?>.filled(kuran.ayetSayisi, null);
    for (final satir in const LineSplitter().convert(metin)) {
      if (satir.isEmpty || satir.startsWith('#')) continue;
      final parca = satir.split('|');
      if (parca.length < 3) continue;
      final sure = int.tryParse(parca[0]);
      final ayet = int.tryParse(parca[1]);
      if (sure == null || ayet == null) continue;
      if (sure < 1 || sure > kuran.sureler.length) continue;
      if (ayet < 1 || ayet > kuran.sure(sure).ayetSayisi) continue;
      final govde = parca.sublist(2).join('|').trim();
      if (govde.isNotEmpty) metinler[kuran.sira(sure, ayet)] = govde;
    }
    return DosyaMeali._(bilgi, kuran, metinler);
  }
}

const _mealKlasoru = 'assets/data/quran/meal';

/// Uygulamaya gömülü meallerin listesi (boş olabilir).
final meallerProvider = FutureProvider<List<MealBilgisi>>((ref) async {
  final paket = ref.watch(varlikPaketiProvider);
  final j =
      jsonDecode(await paket.loadString('assets/data/quran/mealler.json'))
          as Map<String, dynamic>;
  return [
    for (final m in (j['mealler'] as List).cast<Map<String, dynamic>>())
      MealBilgisi.fromJson(m),
  ];
});

final _yukluMealProvider = FutureProvider<MealKaynagi>((ref) async {
  final mealler = await ref.watch(meallerProvider.future);
  if (mealler.isEmpty) return const MealYok();
  // Ayarlar'da seçilen meal; seçim yoksa listedeki ilk meal
  final secili = ref.watch(ayarlarProvider.select((a) => a.mealId));
  final bilgi = mealler.firstWhere(
    (m) => m.id == secili,
    orElse: () => mealler.first,
  );
  final kuran = await ref.watch(kuranProvider.future);
  final metin = await ref
      .watch(varlikPaketiProvider)
      .loadString('$_mealKlasoru/${bilgi.dosya}');
  return DosyaMeali.coz(bilgi, kuran, metin);
});

/// Ekranların kullandığı meal; yüklenene kadar ve meal yokken [MealYok].
final mealKaynagiProvider = Provider<MealKaynagi>(
  (ref) => ref.watch(_yukluMealProvider).valueOrNull ?? const MealYok(),
);

/// Arapça-Hint rakamlarıyla ayet sonu işareti: ﴿١﴾
String ayetIsareti(int no) {
  const rakamlar = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  final b = StringBuffer('﴿');
  for (final r in no.toString().split('')) {
    b.write(rakamlar[int.parse(r)]);
  }
  b.write('﴾');
  return b.toString();
}
