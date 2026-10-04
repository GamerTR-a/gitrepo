import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/abyad_colors.dart';
import '../theme/abyad_text.dart';
import 'abyad_icon.dart';

/// Tasarımdaki 5 sekmeli alt menü.
class AbyadAltMenu extends StatelessWidget {
  const AbyadAltMenu({
    super.key,
    required this.seciliIndex,
    required this.onSec,
  });

  final int seciliIndex;
  final ValueChanged<int> onSec;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ogeler = [
      ('home', l10n.menuAnaSayfa),
      ('clock', l10n.menuVakitler),
      ('book', l10n.menuKuran),
      ('moon', l10n.menuDualar),
      ('calendar', l10n.menuGunler),
    ];
    return Semantics(
      container: true,
      label: l10n.menuEtiketi,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AbyadColors.yuzey,
          border: Border(top: BorderSide(color: AbyadColors.kenarlik)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
            child: Row(
              children: [
                for (final (i, (ikon, etiket)) in ogeler.indexed)
                  Expanded(
                    child: _oge(ikon, etiket, i == seciliIndex, () => onSec(i)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _oge(String ikon, String etiket, bool secili, VoidCallback onTap) {
    final renk = secili ? AbyadColors.zumrut : AbyadColors.menuPasif;
    return Semantics(
      button: true,
      selected: secili,
      label: etiket,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AbyadIcon(ikon, renk: renk),
              const SizedBox(height: 4),
              // Büyük yazıda etiket kesilmek yerine sığacak kadar küçülür.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  etiket,
                  maxLines: 1,
                  style: abyadStil(
                    AbyadFonts.metin,
                    11,
                    secili ? 700 : 600,
                    color: renk,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
