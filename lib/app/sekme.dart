import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Alt menüdeki sekmeler; sıra kabuktaki `IndexedStack` ve alt menü ile aynıdır.
enum Sekme { anaSayfa, vakitler, kuran, dualar, gunler }

class SeciliSekme extends Notifier<Sekme> {
  @override
  Sekme build() => Sekme.anaSayfa;

  void git(Sekme sekme) => state = sekme;
}

final seciliSekmeProvider = NotifierProvider<SeciliSekme, Sekme>(
  SeciliSekme.new,
);
