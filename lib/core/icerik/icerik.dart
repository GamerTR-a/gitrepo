import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/konum/domain/konum.dart';

export '../../features/konum/domain/konum.dart' show aramaAnahtari;

/// Gömülü veri dosyalarının okunduğu paket. Testlerde ezilebilir.
final varlikPaketiProvider = Provider<AssetBundle>((ref) => rootBundle);

Future<Map<String, dynamic>> _json(Ref ref, String yol) async =>
    jsonDecode(await ref.watch(varlikPaketiProvider).loadString(yol))
        as Map<String, dynamic>;

List<Map<String, dynamic>> _liste(Map<String, dynamic> j, String alan) =>
    (j[alan] as List).cast<Map<String, dynamic>>();

// ---------------------------------------------------------------------------
// Şehirler
// ---------------------------------------------------------------------------
final sehirlerProvider = FutureProvider<List<Konum>>((ref) async {
  final j = await _json(ref, 'assets/data/sehirler.json');
  return [for (final s in _liste(j, 'sehirler')) Konum.fromJson(s)];
});

// ---------------------------------------------------------------------------
// Dualar
// ---------------------------------------------------------------------------
class DuaKategorisi {
  const DuaKategorisi(this.id, this.ad, this.aciklama, this.ikon);
  final String id;
  final String ad;
  final String aciklama;
  final String ikon;
}

class Dua {
  const Dua({
    required this.id,
    required this.kategori,
    required this.ad,
    required this.arapcaKisa,
    required this.kaynak,
    this.arapca,
    this.ayetler,
    this.okunus,
    this.anlam,
  });

  final String id;
  final String kategori;
  final String ad;
  final String arapcaKisa;

  /// Ayet olmayan duanın Arapça metni
  final String? arapca;

  /// Ayet ise Tanzil başvurusu ("2:255", "112:1-4")
  final String? ayetler;
  final String? okunus;
  final String? anlam;
  final String kaynak;
}

class DuaVerisi {
  const DuaVerisi(this.kategoriler, this.dualar);
  final List<DuaKategorisi> kategoriler;
  final List<Dua> dualar;

  List<Dua> kategoride(String id) =>
      dualar.where((d) => d.kategori == id).toList();
}

final dualarProvider = FutureProvider<DuaVerisi>((ref) async {
  final j = await _json(ref, 'assets/data/dualar.json');
  return DuaVerisi(
    [
      for (final k in _liste(j, 'kategoriler'))
        DuaKategorisi(
          k['id'] as String,
          k['ad'] as String,
          k['aciklama'] as String,
          k['ikon'] as String,
        ),
    ],
    [
      for (final d in _liste(j, 'dualar'))
        Dua(
          id: d['id'] as String,
          kategori: d['kategori'] as String,
          ad: d['ad'] as String,
          arapcaKisa: d['arapcaKisa'] as String,
          arapca: d['arapca'] as String?,
          ayetler: d['ayetler'] as String?,
          okunus: d['okunus'] as String?,
          anlam: d['anlam'] as String?,
          kaynak: d['kaynak'] as String,
        ),
    ],
  );
});

// ---------------------------------------------------------------------------
// Zikirler
// ---------------------------------------------------------------------------
class Zikir {
  const Zikir(this.id, this.ad, this.arapca, this.anlam);
  final String id;
  final String ad;
  final String arapca;
  final String anlam;
}

final zikirlerProvider = FutureProvider<List<Zikir>>((ref) async {
  final j = await _json(ref, 'assets/data/zikirler.json');
  return [
    for (final z in _liste(j, 'zikirler'))
      Zikir(
        z['id'] as String,
        z['ad'] as String,
        z['arapca'] as String,
        z['anlam'] as String,
      ),
  ];
});

// ---------------------------------------------------------------------------
// Esmâ-ül Hüsnâ
// ---------------------------------------------------------------------------
class EsmaIsmi {
  const EsmaIsmi(this.no, this.ad, this.arapca, this.anlam);
  final int no;
  final String ad;
  final String arapca;
  final String anlam;
}

final esmaProvider = FutureProvider<List<EsmaIsmi>>((ref) async {
  final j = await _json(ref, 'assets/data/esma.json');
  return [
    for (final e in _liste(j, 'isimler'))
      EsmaIsmi(
        e['no'] as int,
        e['ad'] as String,
        e['arapca'] as String,
        e['anlam'] as String,
      ),
  ];
});

// ---------------------------------------------------------------------------
// Namaz ve abdest rehberi
// ---------------------------------------------------------------------------
class RehberAdimi {
  const RehberAdimi({
    required this.baslik,
    required this.aciklama,
    this.arapca,
    this.okunus,
    this.anlam,
    this.cizim,
  });
  final String baslik;
  final String aciklama;
  final String? arapca;
  final String? okunus;
  final String? anlam;
  final String? cizim;
}

class Rehber {
  const Rehber(this.id, this.ad, this.altBaslik, this.adimlar);
  final String id;
  final String ad;
  final String altBaslik;
  final List<RehberAdimi> adimlar;
}

final rehberlerProvider = FutureProvider<List<Rehber>>((ref) async {
  final j = await _json(ref, 'assets/data/rehber.json');
  return [
    for (final r in _liste(j, 'rehberler'))
      Rehber(r['id'] as String, r['ad'] as String, r['altBaslik'] as String, [
        for (final a in _liste(r, 'adimlar'))
          RehberAdimi(
            baslik: a['baslik'] as String,
            aciklama: a['aciklama'] as String,
            arapca: a['arapca'] as String?,
            okunus: a['okunus'] as String?,
            anlam: a['anlam'] as String?,
            cizim: a['cizim'] as String?,
          ),
      ]),
  ];
});

// ---------------------------------------------------------------------------
// Önemli günler
// ---------------------------------------------------------------------------
class OnemliGun {
  const OnemliGun({
    required this.id,
    required this.ad,
    required this.tarih,
    this.bitis,
    this.aciklama,
  });
  final String id;
  final String ad;
  final DateTime tarih;

  /// Birden fazla gün süren bayramlarda son gün
  final DateTime? bitis;
  final String? aciklama;

  /// [bugun]'e göre kalan gün; geçtiyse negatif.
  int kalanGun(DateTime bugun) => DateTime.utc(
    tarih.year,
    tarih.month,
    tarih.day,
  ).difference(DateTime.utc(bugun.year, bugun.month, bugun.day)).inDays;
}

class OnemliGunVerisi {
  const OnemliGunVerisi(this.hicriYil, this.miladiDonem, this.gunler);
  final int hicriYil;
  final String miladiDonem;
  final List<OnemliGun> gunler;

  /// Bugün ya da sonrasındaki ilk gün
  OnemliGun? siradaki(DateTime bugun) =>
      gunler.where((g) => g.kalanGun(bugun) >= 0).firstOrNull;
}

final onemliGunlerProvider = FutureProvider<OnemliGunVerisi>((ref) async {
  final j = await _json(ref, 'assets/data/onemli_gunler.json');
  final donem = j['donem'] as Map<String, dynamic>;
  final gunler = [
    for (final g in _liste(j, 'gunler'))
      OnemliGun(
        id: g['id'] as String,
        ad: g['ad'] as String,
        tarih: DateTime.parse(g['tarih'] as String),
        bitis: g['bitis'] == null ? null : DateTime.parse(g['bitis'] as String),
        aciklama: g['aciklama'] as String?,
      ),
  ]..sort((a, b) => a.tarih.compareTo(b.tarih));
  return OnemliGunVerisi(
    donem['hicri'] as int,
    donem['miladi'] as String,
    gunler,
  );
});

// ---------------------------------------------------------------------------
// Günün ayeti
// ---------------------------------------------------------------------------
final gununAyetleriProvider = FutureProvider<List<String>>((ref) async {
  final j = await _json(ref, 'assets/data/gunun_ayetleri.json');
  return (j['ayetler'] as List).cast<String>();
});

/// Tarihe göre deterministik seçim: aynı gün herkes aynı ayeti görür.
String gununAyeti(List<String> liste, DateTime gun) {
  final yilinGunu = gun.difference(DateTime(gun.year)).inDays;
  return liste[(gun.year * 366 + yilinGunu) % liste.length];
}

// ---------------------------------------------------------------------------
// Kaza: kısa fıkıh bilgileri
// ---------------------------------------------------------------------------
final kazaBilgileriProvider = FutureProvider<List<String>>((ref) async {
  final j = await _json(ref, 'assets/data/kaza_bilgi.json');
  return (j['maddeler'] as List).cast<String>();
});
