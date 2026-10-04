import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/tarih/hicri.dart';
import '../../../core/tarih/tarih_metni.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';
import '../../ayarlar/data/ayarlar_saglayici.dart';
import '../data/vakit_saglayicilari.dart';
import '../domain/gunluk_vakitler.dart';
import 'vakit_adlari.dart';

/// Aylık imsakiye: bir ayın bütün günlerinin vakitleri.
class ImsakiyeEkrani extends ConsumerStatefulWidget {
  const ImsakiyeEkrani({super.key});

  @override
  ConsumerState<ImsakiyeEkrani> createState() => _ImsakiyeEkraniState();
}

class _ImsakiyeEkraniState extends ConsumerState<ImsakiyeEkrani> {
  int _ayFarki = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bugun = ref.watch(saatProvider)();
    final servis = ref.watch(vakitServisiProvider);
    final konum = ref.watch(konumProvider);
    final hicriDuzeltme = ref.watch(
      ayarlarProvider.select((a) => a.hicriDuzeltme),
    );
    final ay = DateTime(bugun.year, bugun.month + _ayFarki);
    final gunSayisi = DateTime(ay.year, ay.month + 1, 0).day;

    return AbyadSayfa(
      children: [
        SayfaBasligi(baslik: l10n.aylikImsakiye, altBaslik: konum.ad),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AbyadColors.yuzey,
            borderRadius: BorderRadius.circular(AbyadRadius.ikonKutu),
            border: Border.all(color: AbyadColors.kenarlik),
          ),
          child: Row(
            children: [
              KareIkonDugme(
                ikon: 'chevron_left',
                etiket: l10n.oncekiAy,
                onTap: () => setState(() => _ayFarki--),
                zemin: AbyadColors.zemin,
                kenarlik: false,
              ),
              Expanded(
                child: Text(
                  ayYil(context, ay),
                  textAlign: TextAlign.center,
                  style: abyadStil(AbyadFonts.metin, 15, 700),
                ),
              ),
              KareIkonDugme(
                ikon: 'chevron_right',
                etiket: l10n.sonrakiAy,
                onTap: () => setState(() => _ayFarki++),
                zemin: AbyadColors.zemin,
                kenarlik: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (var g = 1; g <= gunSayisi; g++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _GunKarti(
              vakitler: servis.gunluk(DateTime(ay.year, ay.month, g)),
              hicri: hicriTarih(
                DateTime(ay.year, ay.month, g),
                duzeltme: hicriDuzeltme,
              ),
              bugun: _ayFarki == 0 && g == bugun.day,
            ),
          ),
      ],
    );
  }
}

/// Tablo yerine gün başına kart: büyük yazıda sütunlar sığmadığında
/// vakitler alt satıra kayar, yatay kaydırma gerekmez.
class _GunKarti extends StatelessWidget {
  const _GunKarti({
    required this.vakitler,
    required this.hicri,
    required this.bugun,
  });

  final GunlukVakitler vakitler;
  final HicriTarih hicri;
  final bool bugun;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tarih = miladiKisa(context, vakitler.gun);
    return AbyadKart(
      renk: bugun ? AbyadColors.pirincAcik : AbyadColors.yuzey,
      kenarRengi: bugun ? AbyadColors.pirincKenar : AbyadColors.kenarlik,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      semanticLabel: [
        tarih,
        if (bugun) l10n.bugun,
        for (final v in vakitler.vakitler) '${l10n.vakitAdi(v.tur)} ${v.metin}',
      ].join(', '),
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(tarih, style: abyadStil(AbyadFonts.metin, 14, 700)),
                Text(
                  hicriMetin(l10n, hicri),
                  style: abyadStil(
                    AbyadFonts.metin,
                    12,
                    600,
                    color: AbyadColors.pirincYazi,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 14,
              runSpacing: 6,
              children: [
                for (final v in vakitler.vakitler)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.vakitAdi(v.tur), style: AbyadText.etiket),
                      Text(
                        v.metin,
                        style: abyadStil(AbyadFonts.metin, 15, 700),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
