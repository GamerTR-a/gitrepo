import '../../../core/l10n/app_localizations.dart';
import '../../kible/domain/kible.dart';
import '../domain/gunluk_vakitler.dart';
import '../domain/vakit_hesaplama.dart';

extension VakitAdlari on AppLocalizations {
  String vakitAdi(VakitTuru tur) => switch (tur) {
    VakitTuru.imsak => vakitImsak,
    VakitTuru.gunes => vakitGunes,
    VakitTuru.ogle => vakitOgle,
    VakitTuru.ikindi => vakitIkindi,
    VakitTuru.aksam => vakitAksam,
    VakitTuru.yatsi => vakitYatsi,
  };

  String kalanMetni(Duration d) {
    final sure = d.isNegative ? Duration.zero : d;
    final saat = sure.inHours;
    final dakika = sure.inMinutes % 60;
    return saat == 0 ? kalanDakika(dakika) : kalanSaatDakika(saat, dakika);
  }

  String yonAdi(Yon yon) => switch (yon) {
    Yon.kuzey => yonKuzey,
    Yon.kuzeydogu => yonKuzeydogu,
    Yon.dogu => yonDogu,
    Yon.guneydogu => yonGuneydogu,
    Yon.guney => yonGuney,
    Yon.guneybati => yonGuneybati,
    Yon.bati => yonBati,
    Yon.kuzeybati => yonKuzeybati,
  };

  String yontemAdi(HesapYontemi yontem) => switch (yontem) {
    HesapYontemi.diyanet => yontemDiyanet,
    HesapYontemi.dunyaIslamBirligi => yontemDunyaIslamBirligi,
    HesapYontemi.kuzeyAmerika => yontemKuzeyAmerika,
    HesapYontemi.misir => yontemMisir,
  };
}
