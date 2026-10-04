import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// `main()` içinde gerçek örnekle, testlerde sahte örnekle ezilir.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider ezilmedi'),
);

final ayarlarDeposuProvider = Provider<AyarlarDeposu>(
  (ref) => AyarlarDeposu(ref.watch(sharedPreferencesProvider)),
);

/// Basit ayarların (aç/kapa, seçim, sayı) cihazdaki deposu.
/// Veri yalnızca cihazda kalır; hiçbir yere gönderilmez.
class AyarlarDeposu {
  AyarlarDeposu(this._prefs);

  final SharedPreferences _prefs;

  bool boolOku(String anahtar, {required bool varsayilan}) =>
      _prefs.getBool(anahtar) ?? varsayilan;
  Future<void> boolYaz(String anahtar, bool deger) =>
      _prefs.setBool(anahtar, deger);

  int intOku(String anahtar, {required int varsayilan}) =>
      _prefs.getInt(anahtar) ?? varsayilan;
  Future<void> intYaz(String anahtar, int deger) =>
      _prefs.setInt(anahtar, deger);

  double doubleOku(String anahtar, {required double varsayilan}) =>
      _prefs.getDouble(anahtar) ?? varsayilan;
  Future<void> doubleYaz(String anahtar, double deger) =>
      _prefs.setDouble(anahtar, deger);

  String? metinOku(String anahtar) => _prefs.getString(anahtar);
  Future<void> metinYaz(String anahtar, String deger) =>
      _prefs.setString(anahtar, deger);

  Future<void> sil(String anahtar) => _prefs.remove(anahtar);
}
