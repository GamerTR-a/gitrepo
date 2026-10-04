import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';
import '../../kuran/data/kuran_deposu.dart';

/// Kaynaklar ve Lisanslar: Tanzil, şehir verisi, yazı tipleri, paketler.
class LisanslarEkrani extends ConsumerWidget {
  const LisanslarEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mealler =
        ref.watch(meallerProvider).valueOrNull ?? const <MealBilgisi>[];
    final kaynaklar = [
      (l10n.lisansKuranBaslik, l10n.lisansKuranMetin),
      (
        l10n.lisansMealBaslik,
        mealler.isEmpty
            ? l10n.lisansMealMetin
            : [
                for (final m in mealler)
                  l10n.lisansMealKaydi(m.ad, m.sahip, m.lisans),
              ].join('\n\n'),
      ),
      (l10n.lisansSehirBaslik, l10n.lisansSehirMetin),
      (l10n.lisansYaziBaslik, l10n.lisansYaziMetin),
      (l10n.lisansEzanBaslik, l10n.lisansEzanMetin),
      (l10n.lisansIcerikBaslik, l10n.lisansIcerikMetin),
    ];
    return AbyadSayfa(
      children: [
        SayfaBasligi(baslik: l10n.kaynaklarVeLisanslar),
        const SizedBox(height: 16),
        for (final (baslik, metin) in kaynaklar) ...[
          AbyadKart(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(baslik, style: AbyadText.kartBasligi),
                const SizedBox(height: 6),
                Text(
                  metin,
                  style: abyadStil(AbyadFonts.metin, 13, 400, height: 1.55),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 6),
        AbyadDugme(
          metin: l10n.lisansPaketler,
          ikincil: true,
          onTap: () => showLicensePage(
            context: context,
            applicationName: l10n.uygulamaAdi,
          ),
        ),
      ],
    );
  }
}
