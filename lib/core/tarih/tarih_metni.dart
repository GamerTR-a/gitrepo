import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import 'hicri.dart';

String _dil(BuildContext context) =>
    Localizations.localeOf(context).toLanguageTag();

/// "2 Ekim 2026 Cuma"
String miladiUzun(BuildContext context, DateTime gun) =>
    DateFormat('d MMMM y EEEE', _dil(context)).format(gun);

/// "2 Ekim Cuma"
String miladiKisa(BuildContext context, DateTime gun) =>
    DateFormat('d MMMM EEEE', _dil(context)).format(gun);

/// "2 Ekim 2026"
String miladiGunAyYil(BuildContext context, DateTime gun) =>
    DateFormat('d MMMM y', _dil(context)).format(gun);

/// "Ekim 2026"
String ayYil(BuildContext context, DateTime gun) =>
    DateFormat('MMMM y', _dil(context)).format(gun);

/// "Eki"
String ayKisa(BuildContext context, DateTime gun) =>
    DateFormat('MMM', _dil(context)).format(gun);

/// "Cuma"
String haftaGunu(BuildContext context, DateTime gun) =>
    DateFormat('EEEE', _dil(context)).format(gun);

/// "Cum"
String haftaGunuKisa(BuildContext context, DateTime gun) =>
    DateFormat('EEE', _dil(context)).format(gun);

/// "20 Rebiülâhir 1448"
String hicriMetin(AppLocalizations l10n, HicriTarih h) {
  final aylar = l10n.hicriAylar.split(',');
  return l10n.hicriTarih(h.gun, aylar[h.ay - 1], h.yil);
}

String ikiHane(int n) => n.toString().padLeft(2, '0');

/// "02:14:36"
String sureSaatDakikaSaniye(Duration d) {
  final s = d.isNegative ? Duration.zero : d;
  return '${ikiHane(s.inHours)}:${ikiHane(s.inMinutes % 60)}:'
      '${ikiHane(s.inSeconds % 60)}';
}
