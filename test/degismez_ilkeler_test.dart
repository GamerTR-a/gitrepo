import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// CLAUDE.md §2'deki Değişmez İlkelerin yanlışlıkla bozulmasını yakalar.
void main() {
  test('ana AndroidManifest.xml INTERNET izni içermez', () {
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    // Yorumlarda geçebilir; önemli olan izin olarak istenmemesi
    final izin = RegExp(
      r'<uses-permission[^>]*android\.permission\.INTERNET"(?![^>]*tools:node="remove")',
    );
    expect(izin.hasMatch(manifest), isFalse);
  });

  test('yasaklı (analitik, reklam, çökme raporlama) paket yok', () {
    const yasakli = [
      'firebase',
      'crashlytics',
      'sentry',
      'google_mobile_ads',
      'admob',
      'facebook',
      'appsflyer',
      'amplitude',
      'mixpanel',
      'onesignal',
    ];
    final kilit = File('pubspec.lock').readAsStringSync().toLowerCase();
    for (final ad in yasakli) {
      expect(kilit, isNot(contains(ad)), reason: '"$ad" pubspec.lock içinde');
    }
  });
}
