import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/storage/veritabani.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_icon.dart';
import '../../../core/widgets/ortak.dart';
import '../../../core/widgets/sekiz_kose_yildiz.dart';
import '../../konum/ui/sehir_sec_ekrani.dart' show AramaKutusu;
import '../data/kuran_deposu.dart';
import 'kuran_metni_ekrani.dart';
import 'kuran_sayfa_ekrani.dart';

final okumaDurumuProvider = StreamProvider<OkumaDurumuData?>(
  (ref) => ref.watch(veritabaniProvider).okumaDurumunuIzle(),
);

final yerImleriProvider = StreamProvider<List<YerImleriData>>(
  (ref) => ref.watch(veritabaniProvider).yerImleriniIzle(),
);

enum _Sekme { sure, cuz, sayfa, imler }

/// Tasarım: docs/tasarim/03_kuran_liste
class KuranListeEkrani extends ConsumerStatefulWidget {
  const KuranListeEkrani({super.key});

  @override
  ConsumerState<KuranListeEkrani> createState() => _KuranListeEkraniState();
}

class _KuranListeEkraniState extends ConsumerState<KuranListeEkrani> {
  _Sekme _sekme = _Sekme.sure;
  String _sorgu = '';

  void _ac(int sure, int ayet) {
    kuranAc(context, ref, sure: sure, ayet: ayet);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kuran = ref.watch(kuranProvider);
    final durum = ref.watch(okumaDurumuProvider).valueOrNull;

    return SafeArea(
      bottom: false,
      child: kuran.when(
        loading: () => const Yukleniyor(),
        error: (_, _) => const YuklemeHatasi(),
        data: (veri) {
          final satirlar = _satirlar(l10n, veri);
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverList.list(
                  children: [
                    SayfaBasligi(
                      baslik: l10n.ekranKuran,
                      buyuk: true,
                      geri: false,
                      sagda: [
                        KareIkonDugme(
                          ikon: 'info',
                          etiket: l10n.kuranMetniDugme,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const KuranMetniEkrani(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AramaKutusu(
                      ipucu: l10n.kuranAraIpucu,
                      onDegis: (s) => setState(() => _sorgu = s),
                    ),
                    const SizedBox(height: 14),
                    if (_sorgu.trim().isEmpty) ...[
                      AbyadSegment<_Sekme>(
                        secenekler: {
                          _Sekme.sure: l10n.sekmeSure,
                          _Sekme.cuz: l10n.sekmeCuz,
                          _Sekme.sayfa: l10n.sekmeSayfa,
                          _Sekme.imler: l10n.sekmeImlerim,
                        },
                        secili: _sekme,
                        onSec: (s) => setState(() => _sekme = s),
                      ),
                      const SizedBox(height: 14),
                      if (durum != null) ...[
                        _KaldiginYer(veri: veri, durum: durum, onAc: _ac),
                        const SizedBox(height: 14),
                      ],
                    ],
                  ],
                ),
              ),
              if (satirlar.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      _sekme == _Sekme.imler && _sorgu.trim().isEmpty
                          ? l10n.yerImiYok
                          : l10n.sonucYok,
                      textAlign: TextAlign.center,
                      style: AbyadText.govde,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: DecoratedSliver(
                    decoration: BoxDecoration(
                      color: AbyadColors.yuzey,
                      borderRadius: BorderRadius.circular(
                        AbyadRadius.buyukKart,
                      ),
                      border: Border.all(color: AbyadColors.kenarlik),
                    ),
                    sliver: SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      sliver: SliverList.separated(
                        itemCount: satirlar.length,
                        separatorBuilder: (_, _) =>
                            Divider(height: 1, color: AbyadColors.ayrac),
                        itemBuilder: (context, i) => satirlar[i],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _satirlar(AppLocalizations l10n, KuranVerisi veri) {
    String sureBilgisi(Sure s) =>
        l10n.sureBilgisi(s.mekki ? l10n.mekki : l10n.medeni, s.ayetSayisi);

    if (_sorgu.trim().isNotEmpty) {
      return [
        for (final sonuc in veri.ara(_sorgu))
          _Satir(
            no: sonuc.sure.no,
            baslik: sonuc.ayet == null
                ? sonuc.sure.ad
                : l10n.sureAyet(sonuc.sure.ad, sonuc.ayet!),
            alt: sureBilgisi(sonuc.sure),
            arapca: sonuc.sure.arapca,
            onTap: () => _ac(sonuc.sure.no, sonuc.ayet ?? 1),
          ),
      ];
    }

    switch (_sekme) {
      case _Sekme.sure:
        return [
          for (final s in veri.sureler)
            _Satir(
              no: s.no,
              baslik: s.ad,
              alt: sureBilgisi(s),
              arapca: s.arapca,
              onTap: () => _ac(s.no, 1),
            ),
        ];
      case _Sekme.cuz:
        return [
          for (final (i, k) in veri.cuzler.indexed)
            _Satir(
              no: i + 1,
              baslik: l10n.cuzNo(i + 1),
              alt: l10n.sureAyet(veri.sure(k.sure).ad, k.ayet),
              onTap: () => _ac(k.sure, k.ayet),
            ),
        ];
      case _Sekme.sayfa:
        return [
          for (final (i, k) in veri.sayfalar.indexed)
            _Satir(
              no: i + 1,
              baslik: l10n.sayfaNo(i + 1),
              alt: l10n.sureAyet(veri.sure(k.sure).ad, k.ayet),
              onTap: () => _ac(k.sure, k.ayet),
            ),
        ];
      case _Sekme.imler:
        final imler = ref.watch(yerImleriProvider).valueOrNull ?? const [];
        return [
          for (final im in imler)
            _Satir(
              no: im.sure,
              baslik: l10n.sureAyet(veri.sure(im.sure).ad, im.ayet),
              alt: l10n.sayfaNo(veri.sayfaNo(im.sure, im.ayet)),
              arapca: veri.sure(im.sure).arapca,
              onTap: () => _ac(im.sure, im.ayet),
            ),
        ];
    }
  }
}

class _KaldiginYer extends StatelessWidget {
  const _KaldiginYer({
    required this.veri,
    required this.durum,
    required this.onAc,
  });

  final KuranVerisi veri;
  final OkumaDurumuData durum;
  final void Function(int sure, int ayet) onAc;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sure = veri.sure(durum.sure);
    final sayfa = veri.sayfaNo(durum.sure, durum.ayet);
    final cuz = veri.cuzNo(durum.sure, durum.ayet);
    final yuzde = (sayfa / toplamSayfa * 100).round();
    return KoyuKart(
      onTap: () => onAc(durum.sure, durum.ayet),
      semanticLabel: l10n.devamOkuma(sure.ad, durum.ayet, yuzde),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kaldiginYer,
            style: abyadStil(
              AbyadFonts.metin,
              12,
              700,
              color: AbyadColors.pirinc,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.sureAyetUzun(sure.ad, durum.ayet),
            style: abyadStil(
              AbyadFonts.metin,
              18,
              700,
              color: AbyadColors.koyuUstu,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.sayfaCuz(sayfa, cuz),
            style: abyadStil(
              AbyadFonts.metin,
              13,
              500,
              color: AbyadColors.koyuUstuIkincil,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: sayfa / toplamSayfa,
              minHeight: 8,
              backgroundColor: AbyadColors.koyuUstuSecili,
              color: AbyadColors.pirinc,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.hatimYuzde(yuzde),
            style: abyadStil(
              AbyadFonts.metin,
              12,
              600,
              color: AbyadColors.koyuUstuIkincil,
            ),
          ),
        ],
      ),
    );
  }
}

class _Satir extends StatelessWidget {
  const _Satir({
    required this.no,
    required this.baslik,
    required this.alt,
    required this.onTap,
    this.arapca,
  });

  final int no;
  final String baslik;
  final String alt;
  final String? arapca;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$baslik, $alt',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SekizKoseYildiz(
                        boyut: 40,
                        renk: AbyadColors.pirincSus,
                        cizgiKalinligi: 1.2,
                        halkalar: false,
                      ),
                      // Numara yıldızın içine sığmalı; yazı ölçeğiyle büyümez.
                      Text(
                        '$no',
                        textScaler: TextScaler.noScaling,
                        style: abyadStil(
                          AbyadFonts.metin,
                          no > 99 ? 10 : 12,
                          700,
                          color: AbyadColors.zumrut,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(baslik, style: AbyadText.kartBasligi),
                      const SizedBox(height: 2),
                      Text(alt, style: AbyadText.etiket),
                    ],
                  ),
                ),
                if (arapca != null) ...[
                  const SizedBox(width: 8),
                  ArapcaMetin(arapca!, boyut: 22, satirYuksekligi: 1.4),
                ] else
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
