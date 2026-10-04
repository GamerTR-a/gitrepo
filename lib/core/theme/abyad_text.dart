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
  Color color = AbyadColors.metin,
  double? height,
  double? letterSpacing,
}) {
  return TextStyle(
    fontFamily: aile,
    fontSize: boyut,
    fontWeight: FontWeight.values[(kalinlik ~/ 100) - 1],
    fontVariations: [FontVariation('wght', kalinlik.toDouble())],
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}

/// Tasarımdaki yazı stilleri. Boyutlar telefonun yazı boyutu ayarına
/// göre Flutter tarafından otomatik büyütülür (MediaQuery.textScaler).
class AbyadText {
  AbyadText._();

  static final saatDev = abyadStil(
    AbyadFonts.baslik,
    68,
    500,
    color: AbyadColors.yuzey,
    height: 1.05,
    letterSpacing: -1,
  );
  static final sayiBuyuk = abyadStil(
    AbyadFonts.baslik,
    28,
    600,
    color: AbyadColors.zumrut,
    height: 1,
  );
  static final ekranBasligi = abyadStil(
    AbyadFonts.baslik,
    30,
    600,
    color: AbyadColors.zumrut,
  );

  static final kartBasligi = abyadStil(AbyadFonts.metin, 16, 700);
  static final govde = abyadStil(AbyadFonts.metin, 15, 400, height: 1.55);
  static final kucuk = abyadStil(
    AbyadFonts.metin,
    13,
    400,
    color: AbyadColors.metinIkincil,
  );
  static final etiket = abyadStil(
    AbyadFonts.metin,
    12,
    600,
    color: AbyadColors.metinIkincil,
  );
  static final menu = abyadStil(AbyadFonts.metin, 11, 600);

  static final arapcaAyet = abyadStil(
    AbyadFonts.arapca,
    28,
    400,
    color: AbyadColors.zumrut,
    height: 1.9,
  );
  static final arapcaOkuma = abyadStil(
    AbyadFonts.arapca,
    27,
    400,
    color: AbyadColors.zumrut,
    height: 2.0,
  );
}
