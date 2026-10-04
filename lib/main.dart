import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;

import 'app/abyad_app.dart';
import 'core/storage/ayarlar_deposu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Saat dilimi verisi pakete gömülüdür; internet gerekmez.
  tzdata.initializeTimeZones();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const AbyadApp(),
    ),
  );
}
