import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icerik/icerik.dart';
import '../domain/ek_vakitler.dart';

/// Ek vakitlerin adı ve kısa açıklaması (assets/data/ek_vakitler.json)
class EkVakitBilgisi {
  const EkVakitBilgisi(this.ad, this.aciklama);
  final String ad;
  final String aciklama;
}

class EkVakitVerisi {
  const EkVakitVerisi({
    required this.sureler,
    required this.kerahatNotu,
    required this.bilgiler,
    required this.incelendi,
  });

  /// Süreler ve bütün metinler bir hoca tarafından incelendi mi?
  final bool incelendi;
  final EkVakitSureleri sureler;
  final String kerahatNotu;

  /// Kimliğe göre: duha, teheccud, kerahat_dogus, kerahat_istiva,
  /// kerahat_batis
  final Map<String, EkVakitBilgisi> bilgiler;
}

final ekVakitVerisiProvider = FutureProvider<EkVakitVerisi>((ref) async {
  final j =
      jsonDecode(
            await ref
                .watch(varlikPaketiProvider)
                .loadString('assets/data/ek_vakitler.json'),
          )
          as Map<String, dynamic>;
  final sureler = j['sureler'] as Map<String, dynamic>;
  final not = j['kerahat_notu'] as Map<String, dynamic>;
  final vakitler = (j['vakitler'] as List).cast<Map<String, dynamic>>();
  return EkVakitVerisi(
    incelendi: [sureler, not, ...vakitler].every((k) => k['incelendi'] == true),
    sureler: EkVakitSureleri.fromJson(sureler),
    kerahatNotu: not['metin'] as String,
    bilgiler: {
      for (final v in vakitler)
        v['id'] as String: EkVakitBilgisi(
          v['ad'] as String,
          v['aciklama'] as String,
        ),
    },
  );
});
