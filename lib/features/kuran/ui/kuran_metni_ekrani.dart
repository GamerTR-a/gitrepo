import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icerik/icerik.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';

/// Metnin bir özelliği: kaynağı, rivayeti, yazımı…
class MetinOzelligi {
  const MetinOzelligi(this.baslik, this.deger, this.aciklama);
  final String baslik;
  final String deger;
  final String? aciklama;
}

/// Metinde geçen bir durak ya da secde işareti
class MetinIsareti {
  const MetinIsareti(this.isaret, this.ad, this.aciklama);

  /// İşaretin kendisi (tek Unicode karakteri)
  final String isaret;
  final String ad;
  final String aciklama;
}

class KuranMetniBilgisi {
  const KuranMetniBilgisi({
    required this.ozellikler,
    required this.isaretler,
    required this.incelendi,
  });

  final List<MetinOzelligi> ozellikler;
  final List<MetinIsareti> isaretler;

  /// Bütün kayıtlar bir hoca tarafından incelendi mi?
  final bool incelendi;
}

final kuranMetniProvider = FutureProvider<KuranMetniBilgisi>((ref) async {
  final j =
      jsonDecode(
            await ref
                .watch(varlikPaketiProvider)
                .loadString('assets/data/kuran_metni.json'),
          )
          as Map<String, dynamic>;
  final ozellikler = (j['ozellikler'] as List).cast<Map<String, dynamic>>();
  final isaretler = (j['isaretler'] as List).cast<Map<String, dynamic>>();
  return KuranMetniBilgisi(
    incelendi: [
      ...ozellikler,
      ...isaretler,
    ].every((k) => k['incelendi'] == true),
    ozellikler: [
      for (final o in ozellikler)
        MetinOzelligi(
          o['baslik'] as String,
          o['deger'] as String,
          o['aciklama'] as String?,
        ),
    ],
    isaretler: [
      for (final i in isaretler)
        MetinIsareti(
          i['isaret'] as String,
          i['ad'] as String,
          i['aciklama'] as String,
        ),
    ],
  );
});

/// Uygulamadaki Kur'an metninin kaynağı, rivayeti ve yazımı ile metinde
/// geçen durak ve secde işaretlerinin açıklaması.
class KuranMetniEkrani extends ConsumerWidget {
  const KuranMetniEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final veri = ref.watch(kuranMetniProvider);
    return AbyadSayfa(
      children: [
        SayfaBasligi(baslik: l10n.kuranMetniBaslik),
        const SizedBox(height: 16),
        ...veri.when(
          loading: () => const [Yukleniyor()],
          error: (_, _) => const [YuklemeHatasi()],
          data: (veri) => [
            BolumBasligi(l10n.kuranMetniBolum),
            const SizedBox(height: 10),
            AbyadKart(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              yaricap: AbyadRadius.buyukKart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (i, o) in veri.ozellikler.indexed) ...[
                    if (i > 0) Divider(height: 1, color: AbyadColors.ayrac),
                    _OzellikSatiri(ozellik: o),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            BolumBasligi(l10n.kuranIsaretBolum),
            const SizedBox(height: 10),
            AbyadKart(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              yaricap: AbyadRadius.buyukKart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (i, isaret) in veri.isaretler.indexed) ...[
                    if (i > 0) Divider(height: 1, color: AbyadColors.ayrac),
                    _IsaretSatiri(isaret: isaret),
                  ],
                ],
              ),
            ),
            if (!veri.incelendi) ...[
              const SizedBox(height: 20),
              AbyadKart(
                renk: AbyadColors.pirincAcik,
                kenarRengi: AbyadColors.pirincKenar,
                child: Text(
                  l10n.icerikIncelenmedi,
                  style: AbyadText.kucuk.copyWith(color: AbyadColors.metin),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _OzellikSatiri extends StatelessWidget {
  const _OzellikSatiri({required this.ozellik});
  final MetinOzelligi ozellik;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ozellik.baslik, style: AbyadText.etiket),
            const SizedBox(height: 3),
            Text(ozellik.deger, style: AbyadText.kartBasligi),
            if (ozellik.aciklama != null) ...[
              const SizedBox(height: 3),
              Text(ozellik.aciklama!, style: AbyadText.kucuk),
            ],
          ],
        ),
      ),
    );
  }
}

class _IsaretSatiri extends StatelessWidget {
  const _IsaretSatiri({required this.isaret});
  final MetinIsareti isaret;

  /// Durak işaretleri harfin üstüne konan işaretlerdir
  bool get _harfUstu {
    final kod = isaret.isaret.runes.first;
    return kod >= 0x06D6 && kod <= 0x06DC;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '${isaret.ad}: ${isaret.aciklama}',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox.square(
              dimension: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AbyadColors.yesilZemin,
                  borderRadius: BorderRadius.circular(AbyadRadius.dugme),
                ),
                // İşaret kutusu sabit boyuttadır; yazı ölçeğiyle büyümez
                child: Center(
                  child: MediaQuery.withNoTextScaling(
                    // Harf üstü işaret tek başına çizilemez: görünmeyen bir
                    // boşluğa bindirilir ve kutunun ortasına indirilir.
                    child: Transform.translate(
                      offset: Offset(0, _harfUstu ? 40 : 0),
                      child: ArapcaMetin(
                        _harfUstu ? '\u00A0${isaret.isaret}' : isaret.isaret,
                        boyut: 34,
                        satirYuksekligi: 1.4,
                        hizalama: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isaret.ad, style: AbyadText.kartBasligi),
                  const SizedBox(height: 3),
                  Text(isaret.aciklama, style: AbyadText.kucuk),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
