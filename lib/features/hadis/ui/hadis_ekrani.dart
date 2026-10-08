import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icerik/icerik.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_icon.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';

/// Hadis listesi. İçerik (assets/data/hadisler.json) derleme ve tercüme
/// kaynağı netleşince eklenir; o zamana kadar açıklama gösterilir.
class HadisEkrani extends ConsumerWidget {
  const HadisEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final veri = ref.watch(hadislerProvider);
    return AbyadSayfa(
      children: [
        SayfaBasligi(
          baslik: l10n.hadisBaslik,
          altBaslik: veri.valueOrNull?.derleme ?? l10n.hadisAltBaslik,
        ),
        const SizedBox(height: 16),
        ...veri.when(
          loading: () => const [Yukleniyor()],
          error: (_, _) => const [YuklemeHatasi()],
          data: (veri) => veri.hadisler.isEmpty
              ? [
                  AbyadKart(
                    renk: AbyadColors.pirincAcik,
                    kenarRengi: AbyadColors.pirincKenar,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.hadisBekleniyorBaslik,
                          style: AbyadText.kartBasligi,
                        ),
                        const SizedBox(height: 6),
                        Text(l10n.hadisBekleniyorMetin, style: AbyadText.govde),
                      ],
                    ),
                  ),
                ]
              : [
                  AbyadKart(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    yaricap: AbyadRadius.buyukKart,
                    child: Column(
                      children: [
                        for (final (i, h) in veri.hadisler.indexed) ...[
                          if (i > 0)
                            Divider(height: 1, color: AbyadColors.ayrac),
                          _HadisSatiri(hadis: h),
                        ],
                      ],
                    ),
                  ),
                  if (veri.tercume != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.hadisTercume(veri.tercume!),
                      style: AbyadText.kucuk,
                    ),
                  ],
                ],
        ),
      ],
    );
  }
}

class _HadisSatiri extends StatelessWidget {
  const _HadisSatiri({required this.hadis});
  final Hadis hadis;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${hadis.no}. ${hadis.baslik}',
      excludeSemantics: true,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => HadisDetayEkrani(hadis: hadis),
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Text(
                  '${hadis.no}',
                  style: abyadStil(
                    AbyadFonts.metin,
                    13,
                    700,
                    color: AbyadColors.pirincYazi,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(hadis.baslik, style: AbyadText.kartBasligi),
                ),
                const SizedBox(width: 8),
                AbyadIcon(
                  'chevron_right',
                  renk: AbyadColors.metinIkincil,
                  boyut: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HadisDetayEkrani extends StatelessWidget {
  const HadisDetayEkrani({super.key, required this.hadis});
  final Hadis hadis;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AbyadSayfa(
      zemin: AbyadColors.okumaZemini,
      children: [
        SayfaBasligi(baslik: hadis.baslik, altBaslik: l10n.hadisNo(hadis.no)),
        const SizedBox(height: 16),
        if (hadis.arapca != null) ...[
          AbyadKart(
            padding: const EdgeInsets.all(AbyadSpace.xl),
            child: ExcludeSemantics(
              child: ArapcaMetin(hadis.arapca!, boyut: 24),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (hadis.ravi != null) ...[
          Text(l10n.hadisRavi(hadis.ravi!), style: AbyadText.kucuk),
          const SizedBox(height: 6),
        ],
        Text(hadis.anlam, style: AbyadText.govde),
        if (hadis.aciklama != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AbyadColors.yesilZemin,
              borderRadius: BorderRadius.circular(AbyadRadius.dugme),
            ),
            child: Text(
              hadis.aciklama!,
              style: AbyadText.kucuk.copyWith(color: AbyadColors.metin),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Text(l10n.kaynakSatiri(hadis.kaynak), style: AbyadText.kucuk),
        if (hadis.hikaye != null) ...[
          const SizedBox(height: 20),
          AbyadKart(
            renk: AbyadColors.pirincAcik,
            kenarRengi: AbyadColors.pirincKenar,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.hadisHikayeEtiket,
                  style: abyadStil(
                    AbyadFonts.metin,
                    12,
                    700,
                    color: AbyadColors.pirincYazi,
                  ),
                ),
                if (hadis.hikayeBaslik != null) ...[
                  const SizedBox(height: 4),
                  Semantics(
                    header: true,
                    child: Text(
                      hadis.hikayeBaslik!,
                      style: abyadStil(AbyadFonts.baslik, 20, 600),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(hadis.hikaye!, style: AbyadText.govde),
                const SizedBox(height: 10),
                Text(l10n.hadisHikayeNot, style: AbyadText.kucuk),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
