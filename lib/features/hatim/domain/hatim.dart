/// Toplu hatmin veri modeli ve pay kuralları (CLAUDE.md §6.15). Saf Dart.
///
/// Kurallar depodan bağımsızdır: bugün hatim yalnızca cihazda tutulur,
/// sunucu kararı verilince aynı kurallar sunucu yanıtlarına uygulanır.
library;

import 'dart:math';

const hatimCuzSayisi = 30;
const hatimSayfaSayisi = 604;

/// Sayfa bazlı hatimde bir payın sayfa sayısı
const sayfaPayBoyu = 5;

const hatimBaslikSiniri = 60;
const hatimNotSiniri = 140;

enum BolmeSekli { cuz, sayfa }

enum PayDurumu { bos, alindi, okundu }

class Pay {
  const Pay({
    required this.no,
    required this.baslangic,
    required this.bitis,
    this.durum = PayDurumu.bos,
    this.katilimci,
    this.guncellenme,
  });

  factory Pay.fromJson(Map<String, dynamic> j) => Pay(
    no: j['no'] as int,
    baslangic: j['baslangic'] as int,
    bitis: j['bitis'] as int,
    durum: PayDurumu.values.byName(j['durum'] as String),
    katilimci: j['katilimci'] as String?,
    guncellenme: j['guncellenme'] == null
        ? null
        : DateTime.parse(j['guncellenme'] as String),
  );

  /// 1'den başlayan sıra
  final int no;

  /// Cüz hatminde cüz numarası, sayfa hatminde ilk ve son sayfa
  final int baslangic;
  final int bitis;
  final PayDurumu durum;

  /// Payı alan cihazın rastgele anahtarı; kişiyle eşleşmez
  final String? katilimci;
  final DateTime? guncellenme;

  Map<String, dynamic> toJson() => {
    'no': no,
    'baslangic': baslangic,
    'bitis': bitis,
    'durum': durum.name,
    'katilimci': katilimci,
    'guncellenme': guncellenme?.toIso8601String(),
  };

  Pay _degis(PayDurumu durum, String? katilimci, DateTime simdi) => Pay(
    no: no,
    baslangic: baslangic,
    bitis: bitis,
    durum: durum,
    katilimci: katilimci,
    guncellenme: simdi,
  );
}

/// Bir pay işleminin sonucu
enum PaySonucu {
  tamam,

  /// Pay boş değil: bir başkası az önce aldı
  alinmis,

  /// Pay bu katılımcının değil ya da durumu işleme uygun değil
  gecersiz,
}

class Hatim {
  const Hatim({
    required this.kod,
    required this.baslik,
    required this.bolmeSekli,
    required this.olusturma,
    required this.sonHareket,
    required this.paylar,
    this.not,
    this.hedefTarih,
  });

  /// Bütün payları boş yeni hatim
  factory Hatim.yeni({
    required String kod,
    required String baslik,
    required BolmeSekli bolmeSekli,
    required DateTime simdi,
    String? not,
    DateTime? hedefTarih,
  }) => Hatim(
    kod: kod,
    baslik: baslik,
    not: not,
    bolmeSekli: bolmeSekli,
    hedefTarih: hedefTarih,
    olusturma: simdi,
    sonHareket: simdi,
    paylar: switch (bolmeSekli) {
      BolmeSekli.cuz => [
        for (var c = 1; c <= hatimCuzSayisi; c++)
          Pay(no: c, baslangic: c, bitis: c),
      ],
      BolmeSekli.sayfa => [
        for (var s = 1, no = 1; s <= hatimSayfaSayisi; s += sayfaPayBoyu, no++)
          Pay(
            no: no,
            baslangic: s,
            bitis: min(s + sayfaPayBoyu - 1, hatimSayfaSayisi),
          ),
      ],
    },
  );

  factory Hatim.fromJson(Map<String, dynamic> j) => Hatim(
    kod: j['kod'] as String,
    baslik: j['baslik'] as String,
    not: j['not'] as String?,
    bolmeSekli: BolmeSekli.values.byName(j['bolme_sekli'] as String),
    hedefTarih: j['hedef_tarih'] == null
        ? null
        : DateTime.parse(j['hedef_tarih'] as String),
    olusturma: DateTime.parse(j['olusturma'] as String),
    sonHareket: DateTime.parse(j['son_hareket'] as String),
    paylar: [
      for (final p in (j['paylar'] as List).cast<Map<String, dynamic>>())
        Pay.fromJson(p),
    ],
  );

  final String kod;
  final String baslik;
  final String? not;
  final BolmeSekli bolmeSekli;
  final DateTime? hedefTarih;
  final DateTime olusturma;
  final DateTime sonHareket;
  final List<Pay> paylar;

  int get okunan => paylar.where((p) => p.durum == PayDurumu.okundu).length;
  bool get tamamlandi => okunan == paylar.length;
  double get oran => okunan / paylar.length;

  Pay pay(int no) => paylar[no - 1];

  Map<String, dynamic> toJson() => {
    'kod': kod,
    'baslik': baslik,
    'not': not,
    'bolme_sekli': bolmeSekli.name,
    'hedef_tarih': hedefTarih?.toIso8601String(),
    'olusturma': olusturma.toIso8601String(),
    'son_hareket': sonHareket.toIso8601String(),
    'paylar': [for (final p in paylar) p.toJson()],
  };

  /// Boş payı [katilimci]'ya verir. Pay boş değilse hatim değişmez ve
  /// [PaySonucu.alinmis] döner: aynı payı iki kişiden yalnızca biri alır.
  (Hatim, PaySonucu) payAl(int no, String katilimci, DateTime simdi) => _islem(
    no,
    simdi,
    (p) => p.durum == PayDurumu.bos
        ? (p._degis(PayDurumu.alindi, katilimci, simdi), PaySonucu.tamam)
        : (p, PaySonucu.alinmis),
  );

  /// Katılımcı, okumadığı payını bırakır.
  (Hatim, PaySonucu) payBirak(int no, String katilimci, DateTime simdi) =>
      _sahibinin(no, katilimci, simdi, PayDurumu.alindi, PayDurumu.bos);

  /// "Okudum"
  (Hatim, PaySonucu) okundu(int no, String katilimci, DateTime simdi) =>
      _sahibinin(no, katilimci, simdi, PayDurumu.alindi, PayDurumu.okundu);

  /// Yanlışlıkla işaretlenen payı geri alır.
  (Hatim, PaySonucu) okunmadi(int no, String katilimci, DateTime simdi) =>
      _sahibinin(no, katilimci, simdi, PayDurumu.okundu, PayDurumu.alindi);

  (Hatim, PaySonucu) _sahibinin(
    int no,
    String katilimci,
    DateTime simdi,
    PayDurumu onceki,
    PayDurumu sonraki,
  ) => _islem(
    no,
    simdi,
    (p) => p.durum == onceki && p.katilimci == katilimci
        ? (
            p._degis(
              sonraki,
              sonraki == PayDurumu.bos ? null : katilimci,
              simdi,
            ),
            PaySonucu.tamam,
          )
        : (p, PaySonucu.gecersiz),
  );

  (Hatim, PaySonucu) _islem(
    int no,
    DateTime simdi,
    (Pay, PaySonucu) Function(Pay) degistir,
  ) {
    if (no < 1 || no > paylar.length) return (this, PaySonucu.gecersiz);
    final (yeni, sonuc) = degistir(pay(no));
    if (sonuc != PaySonucu.tamam) return (this, sonuc);
    return (
      Hatim(
        kod: kod,
        baslik: baslik,
        not: not,
        bolmeSekli: bolmeSekli,
        hedefTarih: hedefTarih,
        olusturma: olusturma,
        sonHareket: simdi,
        paylar: [for (final p in paylar) p.no == no ? yeni : p],
      ),
      sonuc,
    );
  }
}

// Karıştırılan harfler (0/O, 1/l/I) yok
const _kodAlfabesi = 'abcdefghjkmnpqrstuvwxyz23456789';

/// Tahmin edilemeyen hatim kodu; linkte kullanılır (en az 10 karakter).
String hatimKoduUret(Random rastgele, {int uzunluk = 12}) {
  assert(uzunluk >= 10);
  return [
    for (var i = 0; i < uzunluk; i++)
      _kodAlfabesi[rastgele.nextInt(_kodAlfabesi.length)],
  ].join();
}

/// Cihazın rastgele katılımcı anahtarı (32 onaltılık hane).
String katilimciAnahtariUret(Random rastgele) => [
  for (var i = 0; i < 16; i++)
    rastgele.nextInt(256).toRadixString(16).padLeft(2, '0'),
].join();

enum MetinHatasi { bos, uzun, link }

final _link = RegExp(
  r'https?:|www\.|\b[\w-]+\.(com|net|org|info|io|me|ly|tr|de|nl)\b',
  caseSensitive: false,
);

/// Başlık ve not alanlarının denetimi: uzunluk sınırı ve link yasağı.
/// Geçerliyse null döner.
MetinHatasi? hatimMetniDenetle(
  String metin, {
  required int sinir,
  bool zorunlu = false,
}) {
  final m = metin.trim();
  if (m.isEmpty) return zorunlu ? MetinHatasi.bos : null;
  if (m.length > sinir) return MetinHatasi.uzun;
  if (_link.hasMatch(m)) return MetinHatasi.link;
  return null;
}
