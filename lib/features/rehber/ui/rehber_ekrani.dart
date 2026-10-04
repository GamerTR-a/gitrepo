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

/// Tasarım: docs/tasarim/06_rehber
class RehberEkrani extends ConsumerStatefulWidget {
  const RehberEkrani({super.key});

  @override
  ConsumerState<RehberEkrani> createState() => _RehberEkraniState();
}

class _RehberEkraniState extends ConsumerState<RehberEkrani> {
  String _rehberId = 'namaz';
  int _adim = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rehberler = ref.watch(rehberlerProvider).valueOrNull;
    if (rehberler == null) {
      return const Scaffold(
        backgroundColor: AbyadColors.zemin,
        body: Yukleniyor(),
      );
    }
    final rehber = rehberler.firstWhere((r) => r.id == _rehberId);
    final adim = rehber.adimlar[_adim];
    final sonAdim = _adim == rehber.adimlar.length - 1;

    return AbyadSayfa(
      altCubuk: DecoratedBox(
        decoration: const BoxDecoration(
          color: AbyadColors.yuzey,
          border: Border(top: BorderSide(color: AbyadColors.kenarlik)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Opacity(
                  opacity: _adim == 0 ? 0.45 : 1,
                  child: AbyadDugme(
                    metin: l10n.onceki,
                    ikincil: true,
                    onTap: _adim == 0 ? null : () => setState(() => _adim--),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AbyadDugme(
                    metin: sonAdim ? l10n.bastanBasla : l10n.sonrakiAdim,
                    onTap: () =>
                        setState(() => _adim = sonAdim ? 0 : _adim + 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      children: [
        SayfaBasligi(baslik: rehber.ad, altBaslik: rehber.altBaslik),
        const SizedBox(height: 14),
        AbyadSegment<String>(
          secenekler: {'namaz': l10n.namaz, 'abdest': l10n.abdest},
          secili: _rehberId,
          onSec: (id) => setState(() {
            _rehberId = id;
            _adim = 0;
          }),
        ),
        const SizedBox(height: 12),
        ExcludeSemantics(
          child: Row(
            children: [
              for (var i = 0; i < rehber.adimlar.length; i++) ...[
                if (i > 0) const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: i < _adim
                          ? AbyadColors.zumrut
                          : (i == _adim
                                ? AbyadColors.pirincSus
                                : AbyadColors.segmentZemin),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        AbyadKart(
          yaricap: AbyadRadius.buyukKart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Çizimler assets/rehber/ altına eklenince burada gösterilecek
              ExcludeSemantics(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 150),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AbyadColors.segmentZemin,
                    borderRadius: BorderRadius.circular(AbyadRadius.dugme),
                    border: Border.all(color: AbyadColors.kenarlik),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AbyadIcon(
                        'person',
                        renk: AbyadColors.metinIkincil,
                        boyut: 36,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.cizimAlani(adim.baslik),
                        textAlign: TextAlign.center,
                        style: AbyadText.etiket,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Semantics(
                liveRegion: true,
                child: Text(
                  l10n.adimNo(_adim + 1, rehber.adimlar.length),
                  style: abyadStil(
                    AbyadFonts.metin,
                    12,
                    700,
                    color: AbyadColors.pirincYazi,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Semantics(
                header: true,
                child: Text(
                  adim.baslik,
                  style: abyadStil(AbyadFonts.metin, 22, 700),
                ),
              ),
              const SizedBox(height: 6),
              Text(adim.aciklama, style: AbyadText.govde),
              if (adim.arapca != null ||
                  adim.okunus != null ||
                  adim.anlam != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AbyadColors.pirincAcik,
                    borderRadius: BorderRadius.circular(AbyadRadius.dugme),
                    border: Border.all(color: AbyadColors.pirincKenar),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (adim.arapca != null)
                        ArapcaMetin(
                          adim.arapca!,
                          boyut: 28,
                          satirYuksekligi: 1.8,
                        ),
                      if (adim.okunus != null)
                        Text(adim.okunus!, style: AbyadText.kartBasligi),
                      if (adim.anlam != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          adim.anlam!,
                          style: AbyadText.kucuk.copyWith(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
