import 'package:flutter/widgets.dart';
import 'abyad_colors.dart';

/// Yazı tipi aileleri
class AbyadFonts {
  AbyadFonts._();
  static const metin = 'Manrope';
  static const baslik = 'Fraunces';
  static const arapca = 'Amiri';
}

/// Değişken (variable) yazı tiplerinde kalınlığın doğru görünmesi için
/// hem fontWeight hem de 'wght' ekseni birlikte verilir.
TextStyle abyadStil(
  String aile,
  double boyut,
  int kalinlik, {
  Color? color,
  double? height,
  double? letterSpacing,
}) {
  return TextStyle(
    fontFamily: aile,
    fontSize: boyut,
    fontWeight: FontWeight.values[(kalinlik ~/ 100) - 1],
    fontVariations: [FontVariation('wght', kalinlik.toDouble())],
    color: color ?? AbyadColors.metin,
    height: height,
    letterSpacing: letterSpacing,
  );
}

/// Tasarımdaki yazı stilleri. Boyutlar telefonun yazı boyutu ayarına
/// göre Flutter tarafından otomatik büyütülür (MediaQuery.textScaler).
class AbyadText {
  AbyadText._();

  static TextStyle get saatDev => abyadStil(
    AbyadFonts.baslik,
    68,
    500,
    color: AbyadColors.koyuUstu,
    height: 1.05,
    letterSpacing: -1,
  );
  static TextStyle get sayiBuyuk => abyadStil(
    AbyadFonts.baslik,
    28,
    600,
    color: AbyadColors.zumrut,
    height: 1,
  );
  static TextStyle get ekranBasligi =>
      abyadStil(AbyadFonts.baslik, 30, 600, color: AbyadColors.zumrut);

  static TextStyle get kartBasligi => abyadStil(AbyadFonts.metin, 16, 700);
  static TextStyle get govde =>
      abyadStil(AbyadFonts.metin, 15, 400, height: 1.55);
  static TextStyle get kucuk =>
      abyadStil(AbyadFonts.metin, 13, 400, color: AbyadColors.metinIkincil);
  static TextStyle get etiket =>
      abyadStil(AbyadFonts.metin, 12, 600, color: AbyadColors.metinIkincil);
  static TextStyle get menu => abyadStil(AbyadFonts.metin, 11, 600);

  static TextStyle get arapcaAyet => abyadStil(
    AbyadFonts.arapca,
    28,
    400,
    color: AbyadColors.zumrut,
    height: 1.9,
  );
  static TextStyle get arapcaOkuma => abyadStil(
    AbyadFonts.arapca,
    27,
    400,
    color: AbyadColors.zumrut,
    height: 2.0,
  );
}
