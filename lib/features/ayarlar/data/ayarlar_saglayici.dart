import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/ayarlar_deposu.dart';
import '../domain/ayarlar.dart';

const _anahtar = 'ayarlar_v1';

/// Bütün tercihler tek bir JSON kaydı olarak cihazda tutulur.
class AyarlarNotifier extends Notifier<Ayarlar> {
  @override
  Ayarlar build() {
    final kayit = ref.watch(ayarlarDeposuProvider).metinOku(_anahtar);
    if (kayit == null) return const Ayarlar();
    try {
      return Ayarlar.fromJson(jsonDecode(kayit) as Map<String, dynamic>);
    } on Object {
      // Bozuk kayıt uygulamayı açılmaz hâle getirmesin
      return const Ayarlar();
    }
  }

  Future<void> guncelle(Ayarlar Function(Ayarlar) degistir) async {
    state = degistir(state);
    await ref
        .read(ayarlarDeposuProvider)
        .metinYaz(_anahtar, jsonEncode(state.toJson()));
  }
}

final ayarlarProvider = NotifierProvider<AyarlarNotifier, Ayarlar>(
  AyarlarNotifier.new,
);
