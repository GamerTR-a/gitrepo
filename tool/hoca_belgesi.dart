// Hoca incelemesi için yazdırılabilir belge üretir.
//
//   dart run tool/hoca_belgesi.dart
//
// Çıktılar (tarayıcıda açıp yazdırın; A4 yatay):
//   docs/hoca/inceleme_belgesi.html   danışılacak konular + bütün kayıtlar
//   docs/hoca/ek_temsili_hikayeler.html   uygulamada kapalı olan hikâyeler
//
// Belge gömülü veri dosyalarından üretilir; elle düzenlenmez. Sorular
// docs/hoca/danisilacak_konular.md içinden okunur.
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

Map<String, dynamic> _oku(String ad) =>
    jsonDecode(File('assets/data/$ad.json').readAsStringSync())
        as Map<String, dynamic>;

List<Map<String, dynamic>> _liste(Map<String, dynamic> j, String alan) =>
    (j[alan] as List).cast<Map<String, dynamic>>();

String _kacis(Object? metin) => const HtmlEscape().convert('${metin ?? ''}');

/// Tanzil dosyasından "2:255" ya da "112:1-4" başvurusunun metni.
/// Metin değiştirilmez; yalnızca okunuşla karşılaştırmak için basılır.
class _Kuran {
  _Kuran() {
    for (final satir in File(
      'assets/data/quran/quran-uthmani.txt',
    ).readAsLinesSync()) {
      final p = satir.split('|');
      if (p.length == 3 && int.tryParse(p[0]) != null) {
        _ayetler['${p[0]}:${p[1]}'] = p[2];
      }
    }
  }

  final _ayetler = <String, String>{};

  String metin(String basvuru) {
    final p = basvuru.split(':');
    final aralik = p[1].split('-').map(int.parse).toList();
    return [
      for (var a = aralik.first; a <= aralik.last; a++)
        '${_ayetler['${p[0]}:$a']} ﴿$a﴾',
    ].join(' ');
  }
}

/// Tablonun bir satırı
class _Satir {
  _Satir(
    this.ad, {
    this.arapca,
    this.arapcaNotu,
    this.turkce = const [],
    this.kaynak,
    this.not,
  });

  final String ad;
  final String? arapca;
  final String? arapcaNotu;

  /// (etiket, metin) çiftleri; boş metinler basılmaz
  final List<(String, Object?)> turkce;
  final String? kaynak;
  final String? not;
}

class _Bolum {
  _Bolum(this.baslik, this.aciklama, this.satirlar, {this.kuran = false});

  /// Kur'an metni ya da Arapça yazımla ilgili bölüm; belgede öne alınır
  final bool kuran;
  final String baslik;
  final String aciklama;
  final List<_Satir> satirlar;
}

String _tablo(_Bolum b, int no) {
  final s = StringBuffer()
    ..writeln('<section class="bolum">')
    ..writeln(
      '<h2>$no. ${_kacis(b.baslik)} '
      '<span class="adet">${b.satirlar.length} kayıt</span></h2>',
    )
    ..writeln('<p class="aciklama">${_kacis(b.aciklama)}</p>')
    ..writeln(
      '<table><thead><tr><th class="no">No</th><th class="ar">Arapça</th>'
      '<th class="tr">Türkçe</th><th class="kaynak">Kaynak</th>'
      '<th class="karar">Karar ve notunuz</th></tr></thead><tbody>',
    );
  for (final (i, r) in b.satirlar.indexed) {
    s
      ..writeln('<tr><td class="no">${i + 1}</td><td class="ar">')
      ..writeln(
        r.arapca == null ? '' : '<p class="arapca">${_kacis(r.arapca)}</p>',
      )
      ..writeln(
        r.arapcaNotu == null
            ? ''
            : '<p class="kucuk">${_kacis(r.arapcaNotu)}</p>',
      )
      ..writeln('</td><td class="tr"><p class="ad">${_kacis(r.ad)}</p>');
    for (final (etiket, metin) in r.turkce) {
      if (metin == null || '$metin'.trim().isEmpty) continue;
      s.writeln(
        '<p>${etiket.isEmpty ? '' : '<b>${_kacis(etiket)}:</b> '}'
        '${_kacis(metin)}</p>',
      );
    }
    s
      ..writeln('</td><td class="kaynak">${_kacis(r.kaynak)}')
      ..writeln(
        (r.not ?? '').isEmpty
            ? ''
            : '<p class="kucuk">Not: ${_kacis(r.not)}</p>',
      )
      ..writeln(
        '</td><td class="karar"><p>☐ Uygun</p><p>☐ Düzeltilecek</p>'
        '<p>☐ Çıkarılsın</p></td></tr>',
      );
  }
  s.writeln('</tbody></table></section>');
  return s.toString();
}

/// danisilacak_konular.md için küçük bir çevirici: başlık, paragraf ve madde.
/// Her maddenin altına cevap için boş satır bırakır.
String _sorular(String md) {
  final s = StringBuffer();
  final paragraf = <String>[];
  var listede = false;
  void paragrafiKapat() {
    if (paragraf.isNotEmpty) {
      s.writeln('<p>${_kacis(paragraf.join(' '))}</p>');
      paragraf.clear();
    }
  }

  void listeyiKapat() {
    if (listede) s.writeln('</li></ul>');
    listede = false;
  }

  for (final satir in const LineSplitter().convert(md)) {
    if (satir.startsWith('# ')) continue;
    if (satir.startsWith('## ')) {
      paragrafiKapat();
      listeyiKapat();
      s.writeln('<h3>${_kacis(satir.substring(3))}</h3>');
    } else if (satir.startsWith('- ')) {
      paragrafiKapat();
      s.write(listede ? '</li>' : '<ul class="sorular">');
      listede = true;
      s.write('<li>${_kacis(satir.substring(2))}');
    } else if (satir.trim().isEmpty) {
      paragrafiKapat();
      listeyiKapat();
    } else if (listede) {
      s.write(' ${_kacis(satir.trim())}');
    } else {
      paragraf.add(satir.trim());
    }
  }
  paragrafiKapat();
  listeyiKapat();
  return s.toString();
}

const _stil = '''
@font-face { font-family: Amiri; src: url("../../fonts/Amiri-Regular.ttf"); }
@font-face { font-family: Manrope; src: url("../../fonts/Manrope-Variable.ttf"); }
@page { size: A4 landscape; margin: 12mm; }
* { box-sizing: border-box; }
body { font-family: Manrope, "Segoe UI", sans-serif; font-size: 10.5pt;
  line-height: 1.45; color: #1b2420; margin: 0 auto; max-width: 277mm;
  padding: 8mm; }
h1 { font-size: 22pt; margin: 0 0 4pt; color: #0f3d33; }
h2 { font-size: 15pt; margin: 0 0 4pt; color: #0f3d33; }
h3 { font-size: 12pt; margin: 14pt 0 4pt; break-after: avoid; }
p { margin: 0 0 4pt; }
.adet { font-size: 10pt; font-weight: 400; color: #56625d; }
.aciklama, .kucuk { color: #56625d; font-size: 9pt; }
.kapak, .bolum, .danisma { break-after: page; }
.kapak table { width: auto; margin: 8pt 0; }
.kapak td { border: 0; padding: 1pt 14pt 1pt 0; }
table { width: 100%; border-collapse: collapse; table-layout: fixed; }
th, td { border: 0.6pt solid #9aa5a0; padding: 5pt 6pt; vertical-align: top;
  text-align: left; overflow-wrap: anywhere; }
th { background: #e3ece7; font-size: 9pt; }
tr { break-inside: avoid; }
thead { display: table-header-group; }
.no { width: 9mm; text-align: center; }
th.ar, td.ar { width: 32%; }
th.kaynak, td.kaynak { width: 15%; font-size: 9pt; }
th.karar, td.karar { width: 21%; }
td.karar p { margin-bottom: 2pt; font-size: 9.5pt; }
.arapca { font-family: Amiri, "Traditional Arabic", serif; font-size: 15pt;
  line-height: 1.95; direction: rtl; text-align: right; margin: 0; }
.ad { font-weight: 700; }
ul.sorular { padding-left: 16pt; margin: 4pt 0; }
ul.sorular li { margin-bottom: 4pt; padding-bottom: 20pt;
  border-bottom: 0.6pt dotted #9aa5a0; break-inside: avoid; }
.hikaye { break-inside: avoid; margin-bottom: 12pt; padding-bottom: 8pt;
  border-bottom: 0.6pt solid #9aa5a0; }
@media screen { body { background: #f3f4ef; }
  .kapak, .bolum, .danisma, .hikayeler { background: #fff; padding: 10mm;
    margin-bottom: 8mm; border: 1px solid #e1e5df; border-radius: 8px; } }
''';

String _sayfa(String baslik, String govde) =>
    '<!doctype html>\n<html lang="tr"><head><meta charset="utf-8">'
    '<title>${_kacis(baslik)}</title><style>$_stil</style></head>'
    '<body>\n$govde</body></html>\n';

void main() {
  final kuran = _Kuran();
  const taslakNotu =
      'Metinler taslaktır; lütfen ifadeyi, eksiği ve kaynağı işaretleyin.';

  final dualar = _oku('dualar');
  final hadisler = _oku('hadisler');
  final adimlar = _oku('rehber/namaz_adimlari');
  final abdest = _oku('rehber/abdest');
  final namazlar = _oku('rehber/namaz_vakitleri');
  final ekVakit = _oku('ek_vakitler');
  final kaza = _oku('kaza_bilgi');
  final gunler = _oku('onemli_gunler');
  final esma = _oku('esma');

  _Satir adim(Map<String, dynamic> a) => _Satir(
    a['baslik'] as String,
    arapca: a['arapca'] as String?,
    turkce: [
      ('', a['aciklama']),
      ('Okunuş', a['okunus']),
      ('Anlam', a['anlam']),
      ('Tekrar', (a['tekrar'] as int) > 1 ? '${a['tekrar']} kez' : null),
      ('Kadınlar için', a['kadin_notu']),
    ],
    kaynak: a['kaynak'] as String?,
    not: a['not'] as String?,
  );

  final kuranMetni = _oku('kuran_metni');

  final tumBolumler = [
    _Bolum(
      "Kur'an metni ve işaretler",
      "Kur'an sekmesindeki 'Metin ve İşaretler' sayfasında gösterilen "
          'bilgiler. Hepsi taslaktır; özellikle rivayet, resm ve sayım '
          'ifadelerine ve işaret açıklamalarına bakmanızı rica ederiz.',
      [
        for (final o in _liste(kuranMetni, 'ozellikler'))
          _Satir(
            o['baslik'] as String,
            turkce: [('', o['deger']), ('', o['aciklama'])],
            kaynak: o['kaynak'] as String?,
            not: o['not'] as String?,
          ),
        for (final i in _liste(kuranMetni, 'isaretler'))
          _Satir(
            i['ad'] as String,
            arapca: 'ـ${i['isaret']}',
            turkce: [('', i['aciklama'])],
            kaynak: i['kaynak'] as String?,
            not: i['not'] as String?,
          ),
      ],
      kuran: true,
    ),
    _Bolum('Dualar ve namaz sureleri', taslakNotu, [
      for (final d in _liste(dualar, 'dualar'))
        _Satir(
          d['ad'] as String,
          arapca: d['ayetler'] != null
              ? kuran.metin(d['ayetler'] as String)
              : d['arapca'] as String?,
          arapcaNotu: d['ayetler'] != null
              ? 'Ayet metni (${d['ayetler']}) Tanzil dosyasından gelir, '
                    'değiştirilmez; okunuşla karşılaştırmak için basılmıştır.'
              : null,
          turkce: [('Okunuş', d['okunus']), ('Anlam', d['anlam'])],
          kaynak: d['kaynak'] as String?,
          not: d['not'] as String?,
        ),
    ], kuran: true),
    _Bolum('Zikirler', taslakNotu, [
      for (final z in _liste(_oku('zikirler'), 'zikirler'))
        _Satir(
          z['ad'] as String,
          arapca: z['arapca'] as String?,
          turkce: [('Anlam', z['anlam'])],
          kaynak: z['kaynak'] as String?,
          not: z['not'] as String?,
        ),
    ], kuran: true),
    _Bolum(
      'Namaz rehberi: adımlar',
      'Hanefî mezhebine göre yazılmış taslak. Sure ve dua metinleri "Dualar '
          've namaz sureleri" bölümündedir; burada yalnızca tarif ve kısa '
          'tesbihler vardır.',
      _liste(adimlar, 'adimlar').map(adim).toList(),
    ),
    _Bolum(
      'Namaz rehberi: namazlar, rekat sayıları ve niyetler',
      'Her namazın bölümleri. Cuma namazı içerik gelene kadar boştur.',
      [
        for (final v in _liste(namazlar, 'vakitler'))
          for (final b in _liste(v, 'bolumler'))
            _Satir(
              '${v['ad']} – ${b['ad']} (${b['rekat']} rekat)',
              turkce: [('Niyet', b['niyet'])],
              kaynak: b['kaynak'] as String?,
              not: b['not'] as String?,
            ),
      ],
    ),
    _Bolum(
      'Abdest rehberi: adımlar',
      'Hanefî mezhebine göre yazılmış taslak.',
      _liste(abdest, 'adimlar').map(adim).toList(),
    ),
    _Bolum('Abdesti bozan durumlar', taslakNotu, [
      for (final b in _liste(abdest, 'bozanlar'))
        _Satir(
          b['id'] as String,
          turkce: [('', b['metin'])],
          kaynak: b['kaynak'] as String?,
          not: b['not'] as String?,
        ),
    ]),
    _Bolum(
      'Kerahat, işrak ve teheccüd vakitleri',
      'Süreler ve açıklamalar taslaktır (bkz. danışılacak konular).',
      [
        () {
          final s = ekVakit['sureler'] as Map<String, dynamic>;
          return _Satir(
            'Kerahat süreleri',
            turkce: [
              ('Güneş doğduktan sonra', '${s['dogus_dakika']} dakika'),
              ('Öğle vaktinden önce', '${s['istiva_dakika']} dakika'),
              ('Akşamdan önce', '${s['batis_dakika']} dakika'),
            ],
            kaynak: s['kaynak'] as String?,
            not: s['not'] as String?,
          );
        }(),
        () {
          final n = ekVakit['kerahat_notu'] as Map<String, dynamic>;
          return _Satir(
            'Kerahat vakitlerinin altındaki not',
            turkce: [('', n['metin'])],
            kaynak: n['kaynak'] as String?,
            not: n['not'] as String?,
          );
        }(),
        for (final v in _liste(ekVakit, 'vakitler'))
          _Satir(
            v['ad'] as String,
            turkce: [('', v['aciklama'])],
            kaynak: v['kaynak'] as String?,
            not: v['not'] as String?,
          ),
      ],
    ),
    _Bolum(
      'Kaza takibi: kısa fıkıh bilgileri',
      'Kaza borcu sihirbazında gösterilen maddeler.',
      [
        for (final (i, m) in (kaza['maddeler'] as List).indexed)
          _Satir(
            'Madde ${i + 1}',
            turkce: [('', m)],
            kaynak: kaza['kaynak'] as String?,
          ),
      ],
    ),
    _Bolum(
      'Günün ayeti listesi',
      'Ana sayfada her gün bu ayetlerden biri gösterilir. Metin Tanzil '
          'dosyasından gelir; burada yalnızca seçimin uygunluğu sorulur.',
      [
        for (final a in (_oku('gunun_ayetleri')['ayetler'] as List))
          _Satir('Ayet $a', arapca: kuran.metin(a as String)),
      ],
      kuran: true,
    ),
    _Bolum(
      'Kırk Hadis (İmam Nevevî)',
      'Arapça metin harekesizdir ve basılı bir nüshayla karşılaştırılmamıştır; '
          'tercümeler ve açıklamalar taslaktır.',
      [
        for (final h in _liste(hadisler, 'hadisler'))
          _Satir(
            '${h['no']}. ${h['baslik']}',
            arapca: h['arapca'] as String?,
            turkce: [
              ('Râvi', h['ravi']),
              ('Tercüme', h['anlam']),
              ('Açıklama', h['aciklama']),
            ],
            kaynak: h['kaynak'] as String?,
            not: h['not'] as String?,
          ),
      ],
    ),
    _Bolum(
      'Esmâ-ül Hüsnâ',
      'Liste Tirmizî rivayetindeki sıradadır; anlamlar kısa özet olarak '
          'yazılmış taslaktır. Kaynak: ${esma['kaynak']}',
      [
        for (final e in _liste(esma, 'isimler'))
          _Satir(
            e['ad'] as String,
            arapca: e['arapca'] as String?,
            turkce: [('Anlam', e['anlam'])],
            not: e['not'] as String?,
          ),
      ],
      kuran: true,
    ),
    _Bolum(
      'Önemli günler (${(gunler['donem'] as Map)['miladi']})',
      'Bu tarihler tasarım taslağındaki örneklerdir; Diyanet\'in resmî dinî '
          'günler takvimiyle karşılaştırılacaktır.',
      [
        for (final g in _liste(gunler, 'gunler'))
          _Satir(
            g['ad'] as String,
            turkce: [
              ('Tarih', g['tarih']),
              ('Bitiş', g['bitis']),
              ('', g['aciklama']),
            ],
            kaynak: g['kaynak'] as String?,
          ),
      ],
    ),
  ];
  final kuranBolumleri = tumBolumler.where((b) => b.kuran).toList();
  final bolumler = [...kuranBolumleri, ...tumBolumler.where((b) => !b.kuran)];

  final toplam = bolumler.fold(0, (t, b) => t + b.satirlar.length);
  final bugun = DateTime.now();
  final tarih =
      '${bugun.day.toString().padLeft(2, '0')}.'
      '${bugun.month.toString().padLeft(2, '0')}.${bugun.year}';

  final govde = StringBuffer()
    ..writeln('<section class="kapak">')
    ..writeln('<h1>Abyad – İçerik İnceleme Belgesi</h1>')
    ..writeln('<p class="aciklama">Hazırlanma tarihi: $tarih</p>')
    ..writeln(
      '<p>Abyad; reklamsız, ücretsiz, hesap istemeyen ve hiçbir veri '
      'toplamayan bir namaz vakti ve Kur\'an uygulamasıdır. İnternete '
      'bağlanmaz; bütün içerik telefonun içindedir.</p>',
    )
    ..writeln(
      '<p>Bu belgedeki dinî metinlerin hiçbiri henüz bir hoca tarafından '
      'incelenmemiştir. Siz onaylamadan hiçbir metin uygulamada "incelendi" '
      'olarak işaretlenmeyecektir.</p>',
    )
    ..writeln(
      '<p><b>Sizden ricamız:</b> A grubundaki bölümler Kur\'an metni ve '
      'Arapça yazımla ilgilidir; öncelikle bunlara bakmanızı rica ederiz. '
      'B grubundaki bölümler fıkıh ve hadis alanındadır; uygun gördüğünüz '
      'bir hocaya yönlendirmeniz bizim için yeterlidir.</p>',
    )
    ..writeln(
      '<p><b>Nasıl işaretlenir:</b> her satırın sonunda üç kutu vardır. '
      'Uygun bulduğunuz metinde "Uygun"u işaretlemeniz yeterlidir. '
      'Düzeltme gerekiyorsa metnin üstüne ya da not sütununa yazabilirsiniz. '
      'Kaynak sütununda eksik ya da yanlış gördüğünüzü de düzeltebilirsiniz.</p>',
    )
    ..writeln('<table>');
  for (final (i, b) in bolumler.indexed) {
    if (i == 0 || i == kuranBolumleri.length) {
      govde.writeln(
        '<tr><td colspan="2"><b>${i == 0 ? 'A. Kur\'an ve Arapça metin' : 'B. Fıkıh, hadis ve diğer içerik'}</b></td></tr>',
      );
    }
    govde.writeln(
      '<tr><td>${i + 1}. ${_kacis(b.baslik)}</td>'
      '<td>${b.satirlar.length} kayıt</td></tr>',
    );
  }
  govde
    ..writeln('<tr><td><b>Toplam</b></td><td><b>$toplam kayıt</b></td></tr>')
    ..writeln('</table>')
    ..writeln(
      '<p class="aciklama">Bölümler ayrı sayfalarda başlar; öğrencilerinizle '
      'paylaştırmak isterseniz bölüm bölüm ayrılabilir.</p>',
    )
    ..writeln('</section>')
    ..writeln('<section class="danisma">')
    ..writeln('<h2>Danışmak istediğimiz konular</h2>')
    ..writeln(
      _sorular(File('docs/hoca/danisilacak_konular.md').readAsStringSync()),
    )
    ..writeln('</section>');
  for (final (i, b) in bolumler.indexed) {
    govde.writeln(_tablo(b, i + 1));
  }

  Directory('docs/hoca').createSync(recursive: true);
  File(
    'docs/hoca/inceleme_belgesi.html',
  ).writeAsStringSync(_sayfa('Abyad – İçerik İnceleme Belgesi', '$govde'));

  final hikayeler = StringBuffer()
    ..writeln('<section class="hikayeler">')
    ..writeln('<h1>Ek: Temsilî hikâyeler</h1>')
    ..writeln(
      '<p>Aşağıdaki hikâyeler Kırk Hadis\'teki her hadisin anlaşılmasına '
      'yardımcı olsun diye yazılmış <b>kurgusal</b> anlatılardır; rivayet '
      'ya da yaşanmış olay değildir. Uygulamada şu an <b>kapalıdır</b> ve '
      'kararınıza göre ya tamamen çıkarılacak ya da "temsilî anlatım" '
      'etiketiyle gösterilecektir.</p>',
    )
    ..writeln(
      '<p>☐ Hiç yer almasın &nbsp;&nbsp; ☐ Etiketiyle yer alabilir '
      '&nbsp;&nbsp; ☐ Yalnızca işaretlediklerim yer alsın</p>',
    );
  for (final h in _liste(hadisler, 'hadisler')) {
    hikayeler
      ..writeln('<div class="hikaye">')
      ..writeln('<h3>${h['no']}. ${_kacis(h['baslik'])}</h3>')
      ..writeln('<p class="kucuk">Hadis: ${_kacis(h['anlam'])}</p>')
      ..writeln('<p class="ad">${_kacis(h['hikaye_baslik'])}</p>')
      ..writeln('<p>${_kacis(h['hikaye'])}</p>')
      ..writeln('<p>☐ Uygun &nbsp; ☐ Düzeltilecek &nbsp; ☐ Çıkarılsın</p>')
      ..writeln('</div>');
  }
  hikayeler.writeln('</section>');
  File(
    'docs/hoca/ek_temsili_hikayeler.html',
  ).writeAsStringSync(_sayfa('Abyad – Temsilî hikâyeler', '$hikayeler'));

  print(
    'docs/hoca/inceleme_belgesi.html: $toplam kayıt, '
    '${bolumler.length} bölüm',
  );
  print(
    'docs/hoca/ek_temsili_hikayeler.html: '
    '${_liste(hadisler, 'hadisler').length} hikâye',
  );
}
