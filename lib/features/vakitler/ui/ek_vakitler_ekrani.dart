import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/tarih/tarih_metni.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';
import '../data/ek_vakit_saglayici.dart';
import '../data/vakit_saglayicilari.dart';
import '../domain/ek_vakitler.dart';

/// Kerahat vakitleri, işrak/duhâ ve gecenin son üçte biri. Saatler altı
/// vakitten türetilir; süreler ve açıklamalar gömülü veriden gelir.
class EkVakitlerEkrani extends ConsumerWidget {
  const EkVakitlerEkrani({super.key, this.gun});

  /// Verilmezse bugün
  final DateTime? gun;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final saat = ref.watch(saatProvider);
    final servis = ref.watch(vakitServisiProvider);
    final konum = ref.watch(konumProvider);
    final veri = ref.watch(ekVakitVerisiProvider);
    final simdi = saat();
    final g = gun ?? simdi;
    final bugunMu =
        g.year == simdi.year && g.month == simdi.month && g.day == simdi.day;

    return AbyadSayfa(
      children: [
        SayfaBasligi(
          baslik: l10n.ekVakitlerBaslik,
          altBaslik: '${konum.ad} · ${miladiKisa(context, g)}',
        ),
        const SizedBox(height: 16),
        ...veri.when(
          loading: () => const [Yukleniyor()],
          error: (_, _) => const [YuklemeHatasi()],
          data: (veri) {
            final ek = ekVakitleriHesapla(
              servis.gunluk(g),
              servis.gunluk(DateTime(g.year, g.month, g.day + 1)),
              sureler: veri.sureler,
            );
            Widget satir(String id, ZamanAraligi? aralik, {bool? simdiki}) =>
                _EkSatir(
                  bilgi: veri.bilgiler[id]!,
                  aralik: aralik,
                  rozet: simdiki == true ? l10n.suAnKerahat : null,
                );
            return [
              BolumBasligi(l10n.ekNafileBolum),
              const SizedBox(height: 10),
              AbyadKart(
                padding: const EdgeInsets.all(6),
                yaricap: AbyadRadius.buyukKart,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    satir('duha', ek.duha),
                    satir('teheccud', ek.gecenSonUcteBiri),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              BolumBasligi(l10n.ekKerahatBolum),
              const SizedBox(height: 10),
              ZamanIzleyici(
                saat: saat,
                builder: (context, an) => AbyadKart(
                  padding: const EdgeInsets.all(6),
                  yaricap: AbyadRadius.buyukKart,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (id, aralik) in [
                        ('kerahat_dogus', ek.dogusKerahati),
                        ('kerahat_istiva', ek.istivaKerahati),
                        ('kerahat_batis', ek.batisKerahati),
                      ])
                        satir(
                          id,
                          aralik,
                          simdiki: bugunMu && aralik.icinde(an),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(veri.kerahatNotu, style: AbyadText.kucuk),
              const SizedBox(height: 20),
              AbyadKart(
                renk: AbyadColors.pirincAcik,
                kenarRengi: AbyadColors.pirincKenar,
                child: Text(
                  veri.incelendi
                      ? l10n.ekVakitlerYaklasik
                      : '${l10n.ekVakitlerYaklasik} '
                            '${l10n.ekVakitlerIncelenmedi}',
                  style: AbyadText.kucuk.copyWith(color: AbyadColors.metin),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }
}

class _EkSatir extends StatelessWidget {
  const _EkSatir({required this.bilgi, required this.aralik, this.rozet});

  final EkVakitBilgisi bilgi;

  /// O gün hesaplanamıyorsa `null`
  final ZamanAraligi? aralik;
  final String? rozet;

  static String _saat(DateTime t) => '${ikiHane(t.hour)}:${ikiHane(t.minute)}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final a = aralik;
    final saatler = a == null
        ? l10n.ekVakitYok
        : l10n.saatAraligi(_saat(a.baslangic), _saat(a.bitis));
    return Semantics(
      container: true,
      label: [
        bilgi.ad,
        a == null
            ? l10n.ekVakitYok
            : l10n.saatAraligiOkuma(_saat(a.baslangic), _saat(a.bitis)),
        ?rozet,
        bilgi.aciklama,
      ].join(', '),
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        decoration: BoxDecoration(
          color: rozet != null ? AbyadColors.pirincZemin : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bilgi.ad, style: abyadStil(AbyadFonts.metin, 16, 700)),
            if (rozet != null)
              Text(
                rozet!,
                style: abyadStil(
                  AbyadFonts.metin,
                  12,
                  600,
                  color: AbyadColors.pirincYazi,
                ),
              ),
            const SizedBox(height: 2),
            Text(saatler, style: abyadStil(AbyadFonts.baslik, 22, 600)),
            const SizedBox(height: 4),
            Text(bilgi.aciklama, style: AbyadText.kucuk),
          ],
        ),
      ),
    );
  }
}
