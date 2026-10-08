import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';
import '../data/rehber_saglayici.dart';
import '../domain/rehber.dart';
import 'rehber_adim_ekrani.dart';

/// Rehberin girişi: abdest ya da namaz, namazda vakit ve bölüm seçimi.
class RehberEkrani extends ConsumerStatefulWidget {
  const RehberEkrani({super.key});

  @override
  ConsumerState<RehberEkrani> createState() => _RehberEkraniState();
}

class _RehberEkraniState extends ConsumerState<RehberEkrani> {
  bool _abdest = false;

  void _ac(String baslik, String altBaslik, List<SiraliAdim> adimlar) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => RehberAdimEkrani(
            baslik: baslik,
            altBaslik: altBaslik,
            adimlar: adimlar,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AbyadSayfa(
      children: [
        SayfaBasligi(baslik: l10n.rehberBaslik, altBaslik: l10n.rehberAciklama),
        const SizedBox(height: 14),
        AbyadSegment<bool>(
          secenekler: {false: l10n.namaz, true: l10n.abdest},
          secili: _abdest,
          onSec: (v) => setState(() => _abdest = v),
        ),
        const SizedBox(height: 14),
        if (_abdest) ..._abdestBolumu(l10n) else ..._namazBolumu(l10n),
        const SizedBox(height: 14),
        Text(l10n.fikihNot, style: AbyadText.kucuk),
      ],
    );
  }

  List<Widget> _namazBolumu(AppLocalizations l10n) {
    final rehber = ref.watch(namazRehberiProvider);
    if (rehber.hasError) return const [YuklemeHatasi()];
    final veri = rehber.valueOrNull;
    if (veri == null) return const [Yukleniyor()];
    return [
      Text(l10n.rehberNamazSec, style: AbyadText.govde),
      const SizedBox(height: 12),
      for (final vakit in veri.vakitler) ...[
        AbyadKart(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(vakit.ad, style: AbyadText.kartBasligi),
              ),
              if (vakit.yerTutucu)
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 10),
                  child: Text(
                    l10n.rehberIcerikBekleniyor,
                    style: AbyadText.kucuk,
                  ),
                ),
              for (final (i, bolum) in vakit.bolumler.indexed) ...[
                if (i > 0) Divider(height: 1, color: AbyadColors.ayrac),
                GezinmeSatiri(
                  baslik: bolum.ad,
                  deger: l10n.rekatSayisi(bolum.rekat),
                  onTap: () => _ac(
                    l10n.rehberBolumBasligi(vakit.ad, bolum.ad),
                    l10n.rekatSayisi(bolum.rekat),
                    veri.adimlariUret(bolum),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    ];
  }

  List<Widget> _abdestBolumu(AppLocalizations l10n) {
    final rehber = ref.watch(abdestRehberiProvider);
    if (rehber.hasError) return const [YuklemeHatasi()];
    final veri = rehber.valueOrNull;
    if (veri == null) return const [Yukleniyor()];
    return [
      AbyadKart(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(l10n.abdestRehberi, style: AbyadText.kartBasligi),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.abdestRehberiAciklama(veri.adimlar.length),
              style: AbyadText.kucuk,
            ),
            const SizedBox(height: 12),
            AbyadDugme(
              metin: l10n.abdestBasla,
              onTap: () =>
                  _ac(l10n.abdestRehberi, l10n.abdestAltBaslik, veri.adimlar),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      AbyadKart(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(l10n.abdestiBozanlar, style: AbyadText.kartBasligi),
            ),
            const SizedBox(height: 8),
            for (final madde in veri.bozanlar)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExcludeSemantics(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.textScalerOf(context).scale(7),
                          right: 10,
                        ),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AbyadColors.pirincSus,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        madde,
                        style: abyadStil(
                          AbyadFonts.metin,
                          14,
                          400,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ];
  }
}
