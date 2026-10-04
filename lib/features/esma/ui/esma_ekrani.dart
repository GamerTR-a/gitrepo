import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icerik/icerik.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/ortak.dart';
import '../../konum/ui/sehir_sec_ekrani.dart' show AramaKutusu;
import '../../vakitler/data/vakit_saglayicilari.dart';
import '../../zikirmatik/ui/zikirmatik_ekrani.dart';

/// Günün ismi: yılın gününe göre deterministik.
EsmaIsmi gununIsmi(List<EsmaIsmi> isimler, DateTime gun) {
  final yilinGunu = gun.difference(DateTime(gun.year)).inDays;
  return isimler[yilinGunu % isimler.length];
}

/// Tasarım: docs/tasarim/13_esma
class EsmaEkrani extends ConsumerStatefulWidget {
  const EsmaEkrani({super.key});

  @override
  ConsumerState<EsmaEkrani> createState() => _EsmaEkraniState();
}

class _EsmaEkraniState extends ConsumerState<EsmaEkrani> {
  String _sorgu = '';
  int? _seciliNo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isimler = ref.watch(esmaProvider);
    final bugun = ref.watch(saatProvider)();
    final genis = MediaQuery.textScalerOf(context).scale(10) <= 13.5;

    return Scaffold(
      backgroundColor: AbyadColors.zemin,
      body: SafeArea(
        bottom: false,
        child: isimler.when(
          loading: () => const Yukleniyor(),
          error: (_, _) => const YuklemeHatasi(),
          data: (isimler) {
            final gunun = gununIsmi(isimler, bugun);
            final one = _seciliNo == null ? gunun : isimler[_seciliNo! - 1];
            final anahtar = aramaAnahtari(_sorgu);
            final suzulmus = anahtar.isEmpty
                ? isimler
                : isimler
                      .where(
                        (i) =>
                            aramaAnahtari(i.ad).contains(anahtar) ||
                            aramaAnahtari(i.anlam).contains(anahtar),
                      )
                      .toList();
            final sutun = genis ? 2 : 1;
            final satirSayisi = (suzulmus.length / sutun).ceil();

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                  sliver: SliverList.list(
                    children: [
                      SayfaBasligi(
                        baslik: l10n.esmaBaslik,
                        altBaslik: l10n.esmaAltBaslik,
                      ),
                      const SizedBox(height: 16),
                      KoyuKart(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              one.no == gunun.no
                                  ? l10n.gununIsmi
                                  : l10n.isimNo(one.no),
                              textAlign: TextAlign.center,
                              style: abyadStil(
                                AbyadFonts.metin,
                                12,
                                700,
                                color: AbyadColors.pirinc,
                              ),
                            ),
                            ArapcaMetin(
                              one.arapca,
                              boyut: 40,
                              renk: AbyadColors.yuzey,
                              satirYuksekligi: 1.6,
                              hizalama: TextAlign.center,
                            ),
                            Text(
                              one.ad,
                              textAlign: TextAlign.center,
                              style: abyadStil(
                                AbyadFonts.baslik,
                                22,
                                600,
                                color: AbyadColors.yuzey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              one.anlam,
                              textAlign: TextAlign.center,
                              style: abyadStil(
                                AbyadFonts.metin,
                                14,
                                400,
                                color: AbyadColors.koyuUstuIkincil,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 14),
                            AbyadDugme(
                              metin: l10n.zikirmatikteZikret,
                              koyuZeminde: true,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => ZikirmatikEkrani(
                                    ozel: Zikir(
                                      'esma_${one.no}',
                                      // "Yâ Rahmân" biçiminde zikir için
                                      // isim olduğu gibi verilir
                                      one.ad,
                                      one.arapca,
                                      one.anlam,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      AramaKutusu(
                        ipucu: l10n.esmaAraIpucu,
                        onDegis: (s) => setState(() => _sorgu = s),
                      ),
                    ],
                  ),
                ),
                if (suzulmus.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        l10n.sonucYok,
                        textAlign: TextAlign.center,
                        style: AbyadText.govde,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverList.builder(
                      itemCount: satirSayisi,
                      itemBuilder: (context, satir) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (var j = 0; j < sutun; j++) ...[
                                if (j > 0) const SizedBox(width: 10),
                                Expanded(
                                  child: satir * sutun + j < suzulmus.length
                                      ? _IsimKarti(
                                          isim: suzulmus[satir * sutun + j],
                                          secili:
                                              suzulmus[satir * sutun + j].no ==
                                              one.no,
                                          onTap: () => setState(
                                            () => _seciliNo =
                                                suzulmus[satir * sutun + j].no,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _IsimKarti extends StatelessWidget {
  const _IsimKarti({
    required this.isim,
    required this.secili,
    required this.onTap,
  });

  final EsmaIsmi isim;
  final bool secili;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sekil = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AbyadRadius.ikonKutu),
      side: BorderSide(
        color: secili ? AbyadColors.pirincSus : AbyadColors.kenarlik,
        width: 1.5,
      ),
    );
    return Semantics(
      button: true,
      selected: secili,
      label: '${isim.no}. ${isim.ad}, ${isim.anlam}',
      excludeSemantics: true,
      child: Material(
        color: secili ? AbyadColors.pirincAcik : AbyadColors.yuzey,
        shape: sekil,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      '${isim.no}',
                      style: abyadStil(
                        AbyadFonts.metin,
                        12,
                        700,
                        color: AbyadColors.pirincYazi,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ArapcaMetin(
                        isim.arapca,
                        boyut: 26,
                        satirYuksekligi: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(isim.ad, style: abyadStil(AbyadFonts.metin, 15, 700)),
                const SizedBox(height: 4),
                Text(isim.anlam, style: AbyadText.etiket),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
