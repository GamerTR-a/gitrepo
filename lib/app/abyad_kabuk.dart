import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/widgets/abyad_alt_menu.dart';
import '../features/ana_sayfa/ui/ana_sayfa.dart';
import '../features/dualar/ui/dualar_ekrani.dart';
import '../features/kuran/ui/kuran_liste_ekrani.dart';
import '../features/onemli_gunler/ui/onemli_gunler_ekrani.dart';
import '../features/vakitler/ui/vakitler_ekrani.dart';
import 'sekme.dart';

/// Alt menü ve sekmeleri tutan ana iskelet.
/// IndexedStack sayesinde sekme değişince ekranların durumu (kaydırma vb.) korunur.
class AbyadKabuk extends ConsumerWidget {
  const AbyadKabuk({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sekme = ref.watch(seciliSekmeProvider);
    void git(Sekme s) => ref.read(seciliSekmeProvider.notifier).git(s);

    return Scaffold(
      body: IndexedStack(
        index: sekme.index,
        children: [
          AnaSayfa(sekmeyeGit: git),
          const VakitlerEkrani(),
          const KuranListeEkrani(),
          const DualarEkrani(),
          const OnemliGunlerEkrani(),
        ],
      ),
      bottomNavigationBar: AbyadAltMenu(
        seciliIndex: sekme.index,
        onSec: (i) => git(Sekme.values[i]),
      ),
    );
  }
}
