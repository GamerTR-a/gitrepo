import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/icerik/icerik.dart';
import '../domain/konum.dart';

enum KonumHatasi { servisKapali, izinYok, izinKaliciRed, bulunamadi }

class KonumSonucu {
  const KonumSonucu.basarili(Konum this.konum) : hata = null;
  const KonumSonucu.hatali(KonumHatasi this.hata) : konum = null;
  final Konum? konum;
  final KonumHatasi? hata;
}

/// Cihazın konumunu alır. Konum yalnızca vakit hesaplamak için kullanılır,
/// cihazda kalır; ad, gömülü şehir listesindeki en yakın yerleşimden gelir
/// (internetsiz).
class KonumServisi {
  KonumServisi(this._ref);
  final Ref _ref;

  Future<KonumSonucu> bul() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const KonumSonucu.hatali(KonumHatasi.servisKapali);
      }
      var izin = await Geolocator.checkPermission();
      if (izin == LocationPermission.denied) {
        izin = await Geolocator.requestPermission();
      }
      if (izin == LocationPermission.deniedForever) {
        return const KonumSonucu.hatali(KonumHatasi.izinKaliciRed);
      }
      if (izin == LocationPermission.denied) {
        return const KonumSonucu.hatali(KonumHatasi.izinYok);
      }

      // Vakit hesabı için şehir düzeyinde hassasiyet yeterli; son bilinen
      // konum varsa pil harcamadan o kullanılır.
      final yer =
          await Geolocator.getLastKnownPosition() ??
          await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.low,
              timeLimit: Duration(seconds: 25),
            ),
          );

      final sehirler = await _ref.read(sehirlerProvider.future);
      final yakin = enYakinSehir(sehirler, yer.latitude, yer.longitude);
      final dilim = (await FlutterTimezone.getLocalTimezone()).identifier;
      final yakinMi =
          yakin != null &&
          mesafeKm(yer.latitude, yer.longitude, yakin.enlem, yakin.boylam) <
              150;
      return KonumSonucu.basarili(
        Konum(
          ad: yakinMi
              ? yakin.ad
              : '${yer.latitude.toStringAsFixed(2)}, '
                    '${yer.longitude.toStringAsFixed(2)}',
          ust: yakinMi ? yakin.ust : '',
          ulke: yakinMi ? yakin.ulke : '',
          enlem: yer.latitude,
          boylam: yer.longitude,
          dilim: dilim,
          otomatik: true,
        ),
      );
    } on Object {
      return const KonumSonucu.hatali(KonumHatasi.bulunamadi);
    }
  }
}

final konumServisiProvider = Provider<KonumServisi>(KonumServisi.new);
