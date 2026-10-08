import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icerik/icerik.dart';
import '../domain/rehber.dart';

const rehberCizimKlasoru = 'assets/rehber';
const rehberSesKlasoru = 'assets/audio/rehber';

Future<Map<String, dynamic>> _oku(Ref ref, String ad) async =>
    jsonDecode(
          await ref
              .watch(varlikPaketiProvider)
              .loadString('assets/data/rehber/$ad.json'),
        )
        as Map<String, dynamic>;

final namazRehberiProvider = FutureProvider<NamazRehberi>(
  (ref) async => NamazRehberi.fromJson(
    await _oku(ref, 'namaz_adimlari'),
    await _oku(ref, 'namaz_vakitleri'),
  ),
);

final abdestRehberiProvider = FutureProvider<AbdestRehberi>(
  (ref) async => AbdestRehberi.fromJson(await _oku(ref, 'abdest')),
);

/// Uygulamaya gömülü rehber ses dosyalarının adları. Kayıtlar gelene kadar
/// boştur; olmayan sesin düğmesi gösterilmez.
final rehberSesleriProvider = FutureProvider<Set<String>>((ref) async {
  try {
    final liste = await AssetManifest.loadFromAssetBundle(
      ref.watch(varlikPaketiProvider),
    );
    return {
      for (final yol in liste.listAssets())
        if (yol.startsWith('$rehberSesKlasoru/') && yol.endsWith('.mp3'))
          yol.substring(rehberSesKlasoru.length + 1),
    };
  } on Object {
    return const {};
  }
});

/// Verilen varlık yolundaki sesi çalar. Ses kayıtları ve oynatıcı
/// eklenene kadar yoktur (bkz. docs/rehber_varliklari.md).
final rehberSesCalarProvider = Provider<void Function(String yol)?>(
  (ref) => null,
);
