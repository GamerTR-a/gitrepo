import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../ayarlar/data/ayarlar_saglayici.dart';
import '../../konum/domain/konum.dart';
import '../domain/gunluk_vakitler.dart';
import '../domain/vakit_hesaplama.dart';

final konumProvider = Provider<Konum>(
  (ref) => ref.watch(ayarlarProvider.select((a) => a.konum)),
);

tz.Location _dilim(String ad) {
  try {
    return tz.getLocation(ad);
  } on Object {
    return tz.UTC;
  }
}

/// Konumun saat dilimindeki "şimdi" (duvar saati). Testlerde ezilir.
final saatProvider = Provider<DateTime Function()>((ref) {
  final dilim = _dilim(ref.watch(konumProvider).dilim);
  return () {
    final t = tz.TZDateTime.now(dilim);
    return DateTime(t.year, t.month, t.day, t.hour, t.minute, t.second);
  };
});

/// Konum, yöntem ve düzeltmelere göre vakitleri hesaplar.
class VakitServisi {
  VakitServisi(this.konum, this.ayar);

  final Konum konum;
  final HesapAyarlari ayar;
  final _onbellek = <int, GunlukVakitler>{};

  GunlukVakitler gunluk(DateTime gun) {
    final anahtar = gun.year * 10000 + gun.month * 100 + gun.day;
    return _onbellek[anahtar] ??= vakitleriHesapla(
      enlem: konum.enlem,
      boylam: konum.boylam,
      gun: gun,
      utcFarki: tz.TZDateTime(
        _dilim(konum.dilim),
        gun.year,
        gun.month,
        gun.day,
        12,
      ).timeZoneOffset,
      ayar: ayar,
    );
  }

  /// [gun]'den başlayarak [adet] günün vakitleri
  List<GunlukVakitler> gunler(DateTime gun, int adet) => [
    for (var i = 0; i < adet; i++)
      gunluk(DateTime(gun.year, gun.month, gun.day + i)),
  ];

  VakitDurumu durum(DateTime simdi) => vakitDurumu(
    simdi,
    gunluk(simdi),
    gunluk(DateTime(simdi.year, simdi.month, simdi.day + 1)),
  );

  /// Duvar saatini bildirim planlamak için saat dilimli zamana çevirir.
  tz.TZDateTime dilimli(DateTime duvarSaati) => tz.TZDateTime(
    _dilim(konum.dilim),
    duvarSaati.year,
    duvarSaati.month,
    duvarSaati.day,
    duvarSaati.hour,
    duvarSaati.minute,
    duvarSaati.second,
  );
}

final vakitServisiProvider = Provider<VakitServisi>((ref) {
  final konum = ref.watch(konumProvider);
  final ayar = ref.watch(ayarlarProvider.select((a) => a.hesap));
  return VakitServisi(konum, ayar);
});
