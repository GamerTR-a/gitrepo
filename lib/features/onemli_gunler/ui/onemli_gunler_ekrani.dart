import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icerik/icerik.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/tarih/tarih_metni.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';
import '../../ayarlar/data/ayarlar_saglayici.dart';
import '../../vakitler/data/vakit_saglayicilari.dart';

/// Tasarım: docs/tasarim/09_onemli_gunler
class OnemliGunlerEkrani extends ConsumerWidget {
  const OnemliGunlerEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final veri = ref.watch(onemliGunlerProvider);
    final bugun = ref.watch(saatProvider)();
    final hatirlatilan = ref.watch(
      ayarlarProvider.select((a) => a.hatirlatilanGunler),
    );

    void hatirlatmaDegistir(String id) {
      ref.read(ayarlarProvider.notifier).guncelle((a) {
        final yeni = Set.of(a.hatirlatilanGunler);
        if (!yeni.remove(id)) yeni.add(id);
        return a.copyWith(hatirlatilanGunler: yeni);
      });
    }

    return SafeArea(
      bottom: false,
      child: veri.when(
        loading: () => const Yukleniyor(),
        error: (_, _) => const YuklemeHatasi(),
        data: (veri) {
          final siradaki = veri.siradaki(bugun);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              SayfaBasligi(
                baslik: l10n.ekranGunler,
                altBaslik: l10n.gunlerDonem(veri.hicriYil, veri.miladiDonem),
                buyuk: true,
                geri: false,
              ),
              const SizedBox(height: 16),
              if (siradaki != null) ...[
                _SiradakiKart(
                  gun: siradaki,
                  kalan: siradaki.kalanGun(bugun),
                  hatirlat: hatirlatilan.contains(siradaki.id),
                  onHatirlat: () => hatirlatmaDegistir(siradaki.id),
                ),
                const SizedBox(height: 16),
              ],
              AbyadKart(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                yaricap: AbyadRadius.buyukKart,
                child: Column(
                  children: [
                    for (final (i, g) in veri.gunler.indexed) ...[
                      if (i > 0)
                        const Divider(height: 1, color: AbyadColors.ayrac),
                      _GunSatiri(
                        gun: g,
                        kalan: g.kalanGun(bugun),
                        siradaki: g.id == siradaki?.id,
                        hatirlat: hatirlatilan.contains(g.id),
                        onHatirlat: () => hatirlatmaDegistir(g.id),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.gunlerNot,
                textAlign: TextAlign.center,
                style: AbyadText.etiket,
              ),
            ],
          );
        },
      ),
    );
  }
}

String _kalanMetni(AppLocalizations l10n, int kalan) =>
    kalan < 0 ? l10n.gecti : (kalan == 0 ? l10n.bugun : l10n.kalanGun(kalan));

class _SiradakiKart extends StatelessWidget {
  const _SiradakiKart({
    required this.gun,
    required this.kalan,
    required this.hatirlat,
    required this.onHatirlat,
  });

  final OnemliGun gun;
  final int kalan;
  final bool hatirlat;
  final VoidCallback onHatirlat;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return KoyuKart(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            container: true,
            label: l10n.yaklasanGunOkuma(
              gun.ad,
              miladiUzun(context, gun.tarih),
              kalan,
            ),
            excludeSemantics: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.siradakiMubarekGun,
                        style: abyadStil(
                          AbyadFonts.metin,
                          12,
                          700,
                          color: AbyadColors.pirinc,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        gun.ad,
                        style: abyadStil(
                          AbyadFonts.baslik,
                          24,
                          600,
                          color: AbyadColors.yuzey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        miladiUzun(context, gun.tarih),
                        style: abyadStil(
                          AbyadFonts.metin,
                          13,
                          500,
                          color: AbyadColors.koyuUstuIkincil,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Text(
                      kalan == 0 ? l10n.bugun : '$kalan',
                      style: abyadStil(
                        AbyadFonts.baslik,
                        kalan == 0 ? 20 : 34,
                        600,
                        color: AbyadColors.pirinc,
                        height: 1,
                      ),
                    ),
                    if (kalan > 0)
                      Text(
                        l10n.gunKaldi,
                        style: abyadStil(
                          AbyadFonts.metin,
                          12,
                          500,
                          color: AbyadColors.koyuUstuIkincil,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Semantics(
            toggled: hatirlat,
            child: AbyadDugme(
              metin: hatirlat ? l10n.hatirlatmaAcik : l10n.hatirlat,
              ikon: hatirlat ? 'check' : 'bell',
              koyuZeminde: true,
              onTap: onHatirlat,
            ),
          ),
        ],
      ),
    );
  }
}

class _GunSatiri extends StatelessWidget {
  const _GunSatiri({
    required this.gun,
    required this.kalan,
    required this.siradaki,
    required this.hatirlat,
    required this.onHatirlat,
  });

  final OnemliGun gun;
  final int kalan;
  final bool siradaki;
  final bool hatirlat;
  final VoidCallback onHatirlat;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final gecti = kalan < 0;
    final renk = gecti ? AbyadColors.metinPasif : AbyadColors.metin;
    final vurgu = siradaki
        ? AbyadColors.pirincYazi
        : (gecti ? AbyadColors.metinPasif : AbyadColors.zumrut);

    final alt = gun.bitis != null
        ? l10n.tarihAraligi(
            gun.tarih.day,
            gun.bitis!.day,
            ayYil(context, gun.bitis!),
          )
        : [
            haftaGunu(context, gun.tarih),
            gun.aciklama ?? '${gun.tarih.year}',
          ].join(' · ');
    final kalanMetni = _kalanMetni(l10n, kalan);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 68),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              container: true,
              label: [
                gun.ad,
                miladiUzun(context, gun.tarih),
                kalanMetni,
              ].join(', '),
              excludeSemantics: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 52,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: siradaki
                            ? AbyadColors.pirincZemin
                            : (gecti
                                  ? AbyadColors.zemin
                                  : AbyadColors.yesilZemin),
                        borderRadius: BorderRadius.circular(AbyadRadius.dugme),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${gun.tarih.day}',
                            style: abyadStil(
                              AbyadFonts.metin,
                              17,
                              800,
                              color: vurgu,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            ayKisa(context, gun.tarih),
                            style: abyadStil(
                              AbyadFonts.metin,
                              11,
                              600,
                              color: vurgu,
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
                          Text(
                            gun.ad,
                            style: abyadStil(
                              AbyadFonts.metin,
                              15,
                              700,
                              color: renk,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(alt, style: AbyadText.etiket),
                          const SizedBox(height: 2),
                          Text(
                            kalanMetni,
                            style: abyadStil(
                              AbyadFonts.metin,
                              12,
                              700,
                              color: vurgu,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!gecti)
            KareIkonDugme(
              ikon: hatirlat ? 'bell' : 'bell_off',
              etiket: hatirlat
                  ? l10n.gunHatirlatmaAcik(gun.ad)
                  : l10n.gunHatirlatmaKapali(gun.ad),
              onTap: onHatirlat,
              zemin: hatirlat ? AbyadColors.yesilZemin : AbyadColors.zemin,
              renk: hatirlat ? AbyadColors.zumrut : AbyadColors.metinPasif,
              kenarlik: false,
            ),
        ],
      ),
    );
  }
}
