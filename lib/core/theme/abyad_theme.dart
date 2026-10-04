import 'package:flutter/material.dart';
import 'abyad_colors.dart';
import 'abyad_text.dart';

class AbyadTheme {
  AbyadTheme._();

  static ThemeData light() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AbyadColors.zumrut,
          brightness: Brightness.light,
        ).copyWith(
          primary: AbyadColors.zumrut,
          onPrimary: AbyadColors.yuzey,
          secondary: AbyadColors.pirinc,
          onSecondary: AbyadColors.zumrut,
          surface: AbyadColors.yuzey,
          onSurface: AbyadColors.metin,
          outline: AbyadColors.kenarlik,
        );

    return ThemeData(
      useMaterial3: true,
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
}
