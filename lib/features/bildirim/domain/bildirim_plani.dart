import '../../vakitler/domain/gunluk_vakitler.dart';

/// Bir vaktin nasıl duyurulacağı
enum BildirimSesi { ezan, kisa, titresim }

class VakitBildirimAyari {
  const VakitBildirimAyari({required this.acik, this.ses = BildirimSesi.ezan});
  final bool acik;
  final BildirimSesi ses;

  VakitBildirimAyari copyWith({bool? acik, BildirimSesi? ses}) =>
      VakitBildirimAyari(acik: acik ?? this.acik, ses: ses ?? this.ses);
}

class BildirimAyarlari {
  const BildirimAyarlari({
    required this.vakitler,
    this.onceDakika = 0,
    this.cumaSessiz = false,
  });

  final Map<VakitTuru, VakitBildirimAyari> vakitler;

  /// Vakitten kaç dakika önce hatırlatılacağı; 0: kapalı
  final int onceDakika;

  /// Cuma günü öğle vaktinde ezan yerine titreşim
  final bool cumaSessiz;

  /// Güneş dışında bütün vakitler açık, ezan sesiyle
  static const varsayilan = BildirimAyarlari(
    vakitler: {
      VakitTuru.imsak: VakitBildirimAyari(acik: true),
      VakitTuru.gunes: VakitBildirimAyari(acik: false, ses: BildirimSesi.kisa),
      VakitTuru.ogle: VakitBildirimAyari(acik: true),
      VakitTuru.ikindi: VakitBildirimAyari(acik: true),
      VakitTuru.aksam: VakitBildirimAyari(acik: true),
      VakitTuru.yatsi: VakitBildirimAyari(acik: true),
    },
    onceDakika: 15,
  );
}

enum BildirimTuru { vakit, onHatirlatma, onemliGun }

/// İşletim sistemine planlanacak tek bir bildirim
class PlanliBildirim {
  const PlanliBildirim({
    required this.id,
    required this.zaman,
    required this.tur,
    required this.ses,
    this.vakit,
    this.gunAdi,
  });

  final int id;

  /// Konumun saat dilimindeki duvar saati
  final DateTime zaman;
  final BildirimTuru tur;
  final BildirimSesi ses;
  final VakitTuru? vakit;
  final String? gunAdi;
}

/// Hatırlatması açık bir önemli gün
class HatirlatilacakGun {
  const HatirlatilacakGun({required this.ad, required this.tarih});
  final String ad;
  final DateTime tarih;
}

/// Önemli gün hatırlatmalarının gönderildiği saat
const onemliGunHatirlatmaSaati = 10;

/// [simdi]'den sonraki bildirimleri zaman sırasıyla üretir.
///
/// [gunler] art arda günlerin vakitleridir (bugün dahil). [azami],
/// işletim sisteminin bekleyen bildirim sınırıdır (iOS: 64); sınıra
/// sığmayan en uzak bildirimler atılır (kayan pencere), uygulama her
/// açıldığında plan yenilenir.
List<PlanliBildirim> bildirimPlani({
  required DateTime simdi,
  required List<GunlukVakitler> gunler,
  required BildirimAyarlari ayar,
  List<HatirlatilacakGun> onemliGunler = const [],
  int? azami,
}) {
  final plan = <PlanliBildirim>[];

  for (final gun in gunler) {
    final gunNo = _gunNo(gun.gun);
    for (final v in gun.vakitler) {
      final vakitAyari = ayar.vakitler[v.tur];
      if (vakitAyari == null || !vakitAyari.acik) continue;
      final zaman = v.gunde(gun.gun);

      final cumaOgle =
          v.tur == VakitTuru.ogle && gun.gun.weekday == DateTime.friday;
      plan.add(
        PlanliBildirim(
          id: gunNo * 20 + v.tur.index * 2,
          zaman: zaman,
          tur: BildirimTuru.vakit,
          vakit: v.tur,
          ses: ayar.cumaSessiz && cumaOgle
              ? BildirimSesi.titresim
              : vakitAyari.ses,
        ),
      );

      if (ayar.onceDakika > 0) {
        plan.add(
          PlanliBildirim(
            id: gunNo * 20 + v.tur.index * 2 + 1,
            zaman: zaman.subtract(Duration(minutes: ayar.onceDakika)),
            tur: BildirimTuru.onHatirlatma,
            vakit: v.tur,
            ses: BildirimSesi.kisa,
          ),
        );
      }
    }
  }

  for (final g in onemliGunler) {
    plan.add(
      PlanliBildirim(
        // Vakit kimlikleriyle çakışmaması için 12–19 arası son hane
        id: _gunNo(g.tarih) * 20 + 12 + g.ad.hashCode.abs() % 8,
        zaman: DateTime(
          g.tarih.year,
          g.tarih.month,
          g.tarih.day,
          onemliGunHatirlatmaSaati,
        ),
        tur: BildirimTuru.onemliGun,
        ses: BildirimSesi.kisa,
        gunAdi: g.ad,
      ),
    );
  }

  final gelecek = plan.where((b) => b.zaman.isAfter(simdi)).toList()
    ..sort((a, b) => a.zaman.compareTo(b.zaman));
  if (azami != null && gelecek.length > azami) {
    return gelecek.sublist(0, azami);
  }
  return gelecek;
}

/// 2020-01-01'den itibaren gün sayısı (bildirim kimliği için)
int _gunNo(DateTime gun) => DateTime.utc(
  gun.year,
  gun.month,
  gun.day,
).difference(DateTime.utc(2020)).inDays;
