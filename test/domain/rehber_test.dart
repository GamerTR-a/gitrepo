import 'dart:convert';
import 'dart:io';

import 'package:abyad/features/rehber/domain/rehber.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _oku(String ad) =>
    jsonDecode(File('assets/data/rehber/$ad.json').readAsStringSync())
        as Map<String, dynamic>;

/// Derin kopya: testler veriyi bozarak doğrulayıcıyı dener.
Map<String, dynamic> _kopya(Map<String, dynamic> j) =>
    jsonDecode(jsonEncode(j)) as Map<String, dynamic>;

void main() {
  late Map<String, dynamic> abdest;
  late Map<String, dynamic> namazAdimlari;
  late Map<String, dynamic> namazVakitleri;
  late Set<String> dualar;
  late NamazRehberi rehber;

  setUpAll(() {
    abdest = _oku('abdest');
    namazAdimlari = _oku('namaz_adimlari');
    namazVakitleri = _oku('namaz_vakitleri');
    dualar = {
      for (final d
          in (jsonDecode(File('assets/data/dualar.json').readAsStringSync())
                  as Map<String, dynamic>)['dualar']
              as List)
        (d as Map)['id'] as String,
    };
    rehber = NamazRehberi.fromJson(namazAdimlari, namazVakitleri);
  });

  List<String> dogrula({
    Map<String, dynamic>? a,
    Map<String, dynamic>? n,
    Map<String, dynamic>? v,
  }) => rehberiDogrula(
    abdest: a ?? abdest,
    namazAdimlari: n ?? namazAdimlari,
    namazVakitleri: v ?? namazVakitleri,
    duaKimlikleri: dualar,
  );

  NamazBolumu bolum(String vakit, String id) => rehber.vakitler
      .firstWhere((v) => v.id == vakit)
      .bolumler
      .firstWhere((b) => b.id == id);

  List<String> sira(String vakit, String id) => [
    for (final a in rehber.adimlariUret(bolum(vakit, id))) a.adim.id,
  ];

  group('rehber veri dosyaları', () {
    test('şema geçerli', () {
      expect(dogrula(), isEmpty);
    });

    test('her metin incelenmemiş olarak işaretli', () {
      for (final a in [
        ...abdest['adimlar'] as List,
        ...abdest['bozanlar'] as List,
        ...namazAdimlari['adimlar'] as List,
      ]) {
        expect((a as Map)['incelendi'], isFalse, reason: '${a['id']}');
      }
    });

    test('çizim dosyaları yerinde, ses dosyaları adlandırma kuralında', () {
      for (final a in [
        ...abdest['adimlar'] as List,
        ...namazAdimlari['adimlar'] as List,
      ]) {
        final cizim = (a as Map)['cizim'] as String?;
        expect(cizim, isNotNull, reason: '${a['id']}');
        expect(
          File('assets/rehber/$cizim').existsSync(),
          isTrue,
          reason: '$cizim',
        );
      }
    });

    test('Cuma yer tutucu; beş vaktin bölümleri ve rekatları', () {
      expect(rehber.vakitler.last.id, 'cuma');
      expect(rehber.vakitler.last.yerTutucu, isTrue);
      expect(rehber.vakitler.last.bolumler, isEmpty);
      expect(
        {
          for (final v in rehber.vakitler.where((v) => !v.yerTutucu))
            v.id: [for (final b in v.bolumler) b.rekat],
        },
        {
          'sabah': [2, 2],
          'ogle': [4, 4, 2],
          'ikindi': [4, 4],
          'aksam': [3, 2],
          'yatsi': [4, 4, 2, 3],
        },
      );
    });

    test('doğrulayıcı bozuk veriyi yakalar', () {
      final a = _kopya(abdest);
      ((a['adimlar'] as List).first as Map).remove('incelendi');
      expect(dogrula(a: a), isNotEmpty);

      final n = _kopya(namazAdimlari);
      ((n['adimlar'] as List)[2] as Map)['dualar'] = ['olmayan_dua'];
      expect(dogrula(n: n).single, contains('olmayan_dua'));

      final eksik = _kopya(namazAdimlari);
      (eksik['adimlar'] as List).removeWhere((x) => (x as Map)['id'] == 'ruku');
      expect(dogrula(n: eksik).single, contains('ruku'));

      final cizim = _kopya(namazAdimlari);
      ((cizim['adimlar'] as List).first as Map)['cizim'] = 'Niyet Çizimi.png';
      expect(dogrula(n: cizim).single, contains('çizim adı'));

      List<Map<String, dynamic>> sabahBolumleri(Map<String, dynamic> j) =>
          (((j['vakitler'] as List).first as Map)['bolumler'] as List)
              .cast<Map<String, dynamic>>();

      final v = _kopya(namazVakitleri);
      sabahBolumleri(v).first['rekat'] = 5;
      expect(dogrula(v: v).single, contains('rekat'));

      final cuma = _kopya(namazVakitleri);
      ((cuma['vakitler'] as List).last as Map)['bolumler'] = [
        sabahBolumleri(cuma).first,
      ];
      expect(dogrula(v: cuma).single, contains('yer tutucu'));

      final onayli = _kopya(abdest);
      ((onayli['bozanlar'] as List).first as Map)['incelendi'] = true;
      expect(dogrula(a: onayli).single, contains('inceleyen'));
    });
  });

  group('namaz adımlarının üretimi', () {
    test('her bölümde rekat sayısı kadar rükû ve iki katı secde', () {
      for (final v in rehber.vakitler) {
        for (final b in v.bolumler) {
          final adimlar = rehber.adimlariUret(b);
          int say(String id) => adimlar.where((a) => a.adim.id == id).length;
          final neden = '${v.id}/${b.id}';
          expect(say('ruku'), b.rekat, reason: neden);
          expect(say('kavme'), b.rekat, reason: neden);
          expect(
            say('secde') + say('ikinci_secde'),
            b.rekat * 2,
            reason: neden,
          );
          expect(say('celse'), b.rekat, reason: neden);
          expect(say('niyet'), 1, reason: neden);
          expect(say('iftitah_tekbiri'), 1, reason: neden);
          expect(say('kade_ahire'), 1, reason: neden);
          expect(
            say('kade_ula') + say('kade_ula_salavatli'),
            b.rekat > 2 ? 1 : 0,
            reason: neden,
          );
          expect(adimlar.first.adim.id, 'niyet', reason: neden);
          expect(adimlar.first.okunus, b.niyet, reason: neden);
          expect(adimlar.first.rekat, isNull, reason: neden);
          expect(adimlar.last.adim.id, 'selam', reason: neden);
          // Rekat numaraları 1'den başlar, sırayla artar
          final rekatlar = [for (final a in adimlar.skip(1)) a.rekat!];
          expect(rekatlar.first, 1, reason: neden);
          expect(rekatlar.last, b.rekat, reason: neden);
          expect(rekatlar, [...rekatlar]..sort(), reason: neden);
        }
      }
    });

    test('sabahın farzı: iki rekat, tek oturuş', () {
      expect(sira('sabah', 'farz'), [
        'niyet',
        'iftitah_tekbiri',
        'kiyam',
        'kiraat_ilk',
        'ruku',
        'kavme',
        'secde',
        'celse',
        'ikinci_secde',
        'kiraat',
        'ruku',
        'kavme',
        'secde',
        'celse',
        'ikinci_secde',
        'kade_ahire',
        'selam',
      ]);
    });

    test('dört rekatlı farz: ilk oturuş ikinci rekatta, son iki rekatta '
        'yalnız Fâtiha', () {
      final adimlar = rehber.adimlariUret(bolum('ogle', 'farz'));
      final ilkOturus = adimlar.firstWhere((a) => a.adim.id == 'kade_ula');
      expect(ilkOturus.rekat, 2);
      expect(
        [
          for (final a in adimlar)
            if (a.adim.id.startsWith('kiraat')) (a.rekat, a.adim.id, a.sure),
        ],
        [
          (1, 'kiraat_ilk', 'kevser'),
          (2, 'kiraat', 'ihlas'),
          (3, 'kiraat_fatiha', null),
          (4, 'kiraat_fatiha', null),
        ],
      );
      // Sübhâneke yalnızca ilk rekatta
      expect(adimlar.where((a) => a.adim.id == 'kiyam').single.rekat, 1);
      expect(adimlar.last.rekat, 4);
    });

    test('dört rekatlı müekked sünnet: her rekatta sure', () {
      final adimlar = rehber.adimlariUret(bolum('ogle', 'ilk_sunnet'));
      expect(
        [
          for (final a in adimlar)
            if (a.adim.id.startsWith('kiraat')) a.sure,
        ],
        ['kevser', 'ihlas', 'felak', 'nas'],
      );
      expect(adimlar.where((a) => a.adim.id == 'kade_ula'), hasLength(1));
    });

    test('ikindinin sünneti: ilk oturuşta salavat, üçüncü rekatta '
        'Sübhâneke', () {
      for (final (v, b) in [('ikindi', 'sunnet'), ('yatsi', 'ilk_sunnet')]) {
        final adimlar = rehber.adimlariUret(bolum(v, b));
        expect(
          [
            for (final a in adimlar)
              if (a.adim.id == 'kiyam') a.rekat,
          ],
          [1, 3],
        );
        expect(
          adimlar.where((a) => a.adim.id == 'kade_ula_salavatli').single.rekat,
          2,
        );
        expect(adimlar.where((a) => a.adim.id == 'kade_ula'), isEmpty);
      }
    });

    test('akşamın farzı: üç rekat, üçüncüde yalnız Fâtiha', () {
      final s = sira('aksam', 'farz');
      expect(s.where((id) => id == 'ruku'), hasLength(3));
      expect(s.indexOf('kade_ula'), lessThan(s.indexOf('kiraat_fatiha')));
      expect(s.where((id) => id == 'kiraat_fatiha'), hasLength(1));
      expect(s.sublist(s.length - 2), ['kade_ahire', 'selam']);
    });

    test('vitir: üçüncü rekatta sureden sonra tekbir ve Kunut, sonra rükû', () {
      final adimlar = rehber.adimlariUret(bolum('yatsi', 'vitir'));
      final ucuncu = [
        for (final a in adimlar)
          if (a.rekat == 3) a.adim.id,
      ];
      expect(ucuncu.take(4), ['kiraat', 'kunut_tekbiri', 'kunut', 'ruku']);
      expect(adimlar.where((a) => a.adim.id == 'kade_ula').single.rekat, 2);
      // Vitrin her rekatında sure okunur
      expect(
        adimlar.where((a) => a.adim.id.startsWith('kiraat') && a.sure == null),
        isEmpty,
      );
    });
  });

  test('abdest: dokuz adım ve bozan durumlar', () {
    final a = AbdestRehberi.fromJson(abdest);
    expect(
      [for (final s in a.adimlar) s.adim.id],
      [
        'niyet_besmele',
        'eller',
        'agiz',
        'burun',
        'yuz',
        'kollar',
        'bas',
        'kulak_boyun',
        'ayaklar',
      ],
    );
    expect(a.adimlar.every((s) => s.rekat == null), isTrue);
    expect(a.adimlar[1].adim.tekrar, 3);
    expect(a.bozanlar, isNotEmpty);
  });
}
