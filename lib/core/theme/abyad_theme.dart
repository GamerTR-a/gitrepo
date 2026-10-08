import 'package:flutter/material.dart';
import 'abyad_colors.dart';
import 'abyad_text.dart';

class AbyadTheme {
  AbyadTheme._();

  /// Seçili palete ([AbyadColors.palet]) göre Material teması. İletişim
  /// kutuları, tarih seçici ve metin düğmeleri renklerini buradan alır.
  static ThemeData olustur() {
    final parlaklik = AbyadColors.palet.koyu
        ? Brightness.dark
        : Brightness.light;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AbyadPalet.acik.zumrut,
          brightness: parlaklik,
        ).copyWith(
          primary: AbyadColors.zumrut,
          onPrimary: AbyadColors.yuzey,
          secondary: AbyadColors.pirinc,
          onSecondary: AbyadColors.pirincUstu,
          surface: AbyadColors.yuzey,
          onSurface: AbyadColors.metin,
          outline: AbyadColors.kenarlik,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: parlaklik,
      colorScheme: scheme,
      scaffoldBackgroundColor: AbyadColors.zemin,
      fontFamily: AbyadFonts.metin,
      textTheme: TextTheme(
        headlineMedium: AbyadText.ekranBasligi,
        titleMedium: AbyadText.kartBasligi,
        bodyMedium: AbyadText.govde,
        bodySmall: AbyadText.kucuk,
        labelSmall: AbyadText.etiket,
      ),
      dividerColor: AbyadColors.ayrac,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  static ThemeData light() => olustur();
}
