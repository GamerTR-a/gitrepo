import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/tarih/hicri.dart';
import '../../../core/tarih/tarih_metni.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_icon.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';
import '../../../core/widgets/sekiz_kose_yildiz.dart';
import '../../ayarlar/data/ayarlar_saglayici.dart';
import '../../bildirim/domain/bildirim_plani.dart';
import '../../kible/domain/kible.dart';
import '../../kible/ui/kible_ekrani.dart';
import '../../konum/ui/sehir_sec_ekrani.dart';
import '../data/vakit_saglayicilari.dart';
import '../domain/gunluk_vakitler.dart';
import 'imsakiye_ekrani.dart';
import 'vakit_adlari.dart';

/// Tasarım: docs/tasarim/02_vakitler
class VakitlerEkrani extends ConsumerStatefulWidget {
  const VakitlerEkrani({super.key});

  @override
  ConsumerState<VakitlerEkrani> createState() => _VakitlerEkraniState();
}

class _VakitlerEkraniState extends ConsumerState<VakitlerEkrani> {
  /// Bugüne göre kaç gün ileri/geri bakılıyor
  int _gunFarki = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final saat = ref.watch(saatProvider);
    final servis = ref.watch(vakitServisiProvider);
    final konum = ref.watch(konumProvider);
    final ayarlar = ref.watch(ayarlarProvider);
    final bugun = saat();
    final gun = DateTime(bugun.year, bugun.month, bugun.day + _gunFarki);
    final vakitler = servis.gunluk(gun);
    final kible = kibleAcisi(konum.enlem, konum.boylam);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Semantics(
                header: true,
                child: Text(
                  l10n.ekranVakitler,
                  style: AbyadText.ekranBasligi.copyWith(height: 1.15),
                ),
              ),
              _SehirDugmesi(
                ad: konum.ad,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SehirSecEkrani(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _GunSecici(
            gun: gun,
            hicri: hicriTarih(gun, duzeltme: ayarlar.hicriDuzeltme),
            onceki: () => setState(() => _gunFarki--),
            sonraki: () => setState(() => _gunFarki++),
            bugune: _gunFarki == 0 ? null : () => setState(() => _gunFarki = 0),
          ),
          const SizedBox(height: 18),
          if (_gunFarki == 0) ...[
            ZamanIzleyici(
              saat: saat,
              aralik: const Duration(seconds: 1),
              builder: (context, simdi) =>
                  _GeriSayim(durum: servis.durum(simdi), simdi: simdi),
            ),
            const SizedBox(height: 18),
          ],
          ZamanIzleyici(
            saat: saat,
            builder: (context, simdi) => _VakitListesi(
              vakitler: vakitler,
              durum: _gunFarki == 0 ? servis.durum(simdi) : null,
              simdi: simdi,
              bildirim: ayarlar.bildirim,
              onBildirim: _bildirimDegistir,
            ),
          ),
          const SizedBox(height: 18),
          AbyadKart(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ImsakiyeEkrani()),
            ),
            child: Row(
              children: [
                const AbyadIcon('calendar', renk: AbyadColors.zumrut),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(l10n.aylikImsakiye, style: AbyadText.kartBasligi),
                ),
                const AbyadIcon(
                  'chevron_right',
                  renk: AbyadColors.metinIkincil,
                  boyut: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AbyadKart(
            semanticLabel: l10n.kibleKartOkuma(
              kible.round(),
              l10n.yonAdi(yon(kible)),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const KibleEkrani()),
            ),
            child: ExcludeSemantics(
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AbyadColors.yesilZemin,
                      borderRadius: BorderRadius.circular(AbyadRadius.dugme),
                    ),
                    alignment: Alignment.center,
                    child: const AbyadIcon(
                      'compass',
                      renk: AbyadColors.zumrut,
                      boyut: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.kibleYonu, style: AbyadText.etiket),
                        const SizedBox(height: 3),
                        Text(
                          l10n.kibleDerece(
                            kible.round(),
                            l10n.yonAdi(yon(kible)),
                          ),
                          style: AbyadText.kartBasligi,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.pusulayiAc,
                    style: abyadStil(
                      AbyadFonts.metin,
                      13,
                      700,
                      color: AbyadColors.zumrut,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.hesaplamaYontemiNotu(l10n.yontemAdi(ayarlar.yontem)),
            style: AbyadText.etiket,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _bildirimDegistir(VakitTuru tur) {
    ref.read(ayarlarProvider.notifier).guncelle((a) {
      final vakitler = Map.of(a.bildirim.vakitler);
      final mevcut = vakitler[tur]!;
      vakitler[tur] = mevcut.copyWith(acik: !mevcut.acik);
      return a.copyWith(
        bildirim: BildirimAyarlari(
          vakitler: vakitler,
          onceDakika: a.bildirim.onceDakika,
          cumaSessiz: a.bildirim.cumaSessiz,
        ),
      );
    });
  }
}

class _SehirDugmesi extends StatelessWidget {
  const _SehirDugmesi({required this.ad, required this.onTap});
  final String ad;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: AppLocalizations.of(context).konumDegistirOkuma(ad),
      excludeSemantics: true,
      child: Material(
        color: AbyadColors.yuzey,
        shape: const StadiumBorder(
          side: BorderSide(color: AbyadColors.kenarlik),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AbyadSize.minDokunma,
              maxWidth: 260,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AbyadIcon('pin', renk: AbyadColors.zumrut, boyut: 16),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      ad,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: abyadStil(
                        AbyadFonts.metin,
                        13,
                        600,
                        color: AbyadColors.zumrut,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GunSecici extends StatelessWidget {
  const _GunSecici({
    required this.gun,
    required this.hicri,
    required this.onceki,
    required this.sonraki,
    required this.bugune,
  });

  final DateTime gun;
  final HicriTarih hicri;
  final VoidCallback onceki;
  final VoidCallback sonraki;
  final VoidCallback? bugune;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
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
            etiket: l10n.oncekiGun,
            onTap: onceki,
            zemin: AbyadColors.zemin,
            kenarlik: false,
          ),
          Expanded(
            child: Semantics(
              button: bugune != null,
              hint: bugune != null ? l10n.buguneDon : null,
              child: InkWell(
                onTap: bugune,
                borderRadius: BorderRadius.circular(AbyadRadius.cip),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: Column(
                    children: [
                      Text(
                        miladiUzun(context, gun),
                        textAlign: TextAlign.center,
                        style: abyadStil(AbyadFonts.metin, 15, 700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hicriMetin(l10n, hicri),
                        textAlign: TextAlign.center,
                        style: abyadStil(
                          AbyadFonts.metin,
                          12,
                          600,
                          color: AbyadColors.pirincYazi,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          KareIkonDugme(
            ikon: 'chevron_right',
            etiket: l10n.sonrakiGun,
            onTap: sonraki,
            zemin: AbyadColors.zemin,
            kenarlik: false,
          ),
        ],
      ),
    );
  }
}

class _GeriSayim extends StatelessWidget {
  const _GeriSayim({required this.durum, required this.simdi});
  final VakitDurumu durum;
  final DateTime simdi;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ad = l10n.vakitAdi(durum.sonraki);
    final kalan = durum.kalan(simdi);
    return KoyuKart(
      semanticLabel: l10n.vakteKalanOkuma(ad, l10n.kalanMetni(kalan)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.vakteKalan(ad),
                  style: abyadStil(
                    AbyadFonts.metin,
                    13,
                    500,
                    color: AbyadColors.koyuUstuIkincil,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    sureSaatDakikaSaniye(kalan),
                    style: abyadStil(
                      AbyadFonts.baslik,
                      40,
                      500,
                      color: AbyadColors.yuzey,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SekizKoseYildiz(
            boyut: 56,
            renk: AbyadColors.pirinc,
            cizgiKalinligi: 1.4,
          ),
        ],
      ),
    );
  }
}

class _VakitListesi extends StatelessWidget {
  const _VakitListesi({
    required this.vakitler,
    required this.durum,
    required this.simdi,
    required this.bildirim,
    required this.onBildirim,
  });

  final GunlukVakitler vakitler;

  /// Yalnızca bugüne bakılırken dolu
  final VakitDurumu? durum;
  final DateTime simdi;
  final BildirimAyarlari bildirim;
  final ValueChanged<VakitTuru> onBildirim;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bugunSirada = durum != null && !durum!.yarinMi(simdi);
    return AbyadKart(
      padding: const EdgeInsets.all(6),
      yaricap: AbyadRadius.buyukKart,
      child: Column(
        children: [
          for (final v in vakitler.vakitler)
            _VakitSatiri(
              ad: l10n.vakitAdi(v.tur),
              saat: v.metin,
              sirada: bugunSirada && durum!.sonraki == v.tur,
              simdiki: durum != null && durum!.simdiki == v.tur,
              gecti: durum != null && simdi.isAfter(v.gunde(vakitler.gun)),
              bildirimAcik: bildirim.vakitler[v.tur]?.acik ?? false,
              onBildirim: () => onBildirim(v.tur),
            ),
        ],
      ),
    );
  }
}

class _VakitSatiri extends StatelessWidget {
  const _VakitSatiri({
    required this.ad,
    required this.saat,
    required this.sirada,
    required this.simdiki,
    required this.gecti,
    required this.bildirimAcik,
    required this.onBildirim,
  });

  final String ad;
  final String saat;
  final bool sirada;
  final bool simdiki;
  final bool gecti;
  final bool bildirimAcik;
  final VoidCallback onBildirim;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final soluk = gecti && !simdiki;
    final renk = soluk ? AbyadColors.metinPasif : AbyadColors.metin;
    final rozet = sirada
        ? l10n.siradakiVakitRozet
        : (simdiki ? l10n.suAnkiVakitRozet : null);

    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
      decoration: BoxDecoration(
        color: sirada ? AbyadColors.pirincZemin : null,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              container: true,
              label: [ad, saat, ?rozet].join(', '),
              excludeSemantics: true,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ad,
                          style: abyadStil(
                            AbyadFonts.metin,
                            16,
                            700,
                            color: renk,
                          ),
                        ),
                        if (rozet != null)
                          Text(
                            rozet,
                            style: abyadStil(
                              AbyadFonts.metin,
                              12,
                              600,
                              color: sirada
                                  ? AbyadColors.pirincYazi
                                  : AbyadColors.zumrut,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    saat,
                    style: abyadStil(AbyadFonts.baslik, 22, 600, color: renk),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          KareIkonDugme(
            ikon: bildirimAcik ? 'bell' : 'bell_off',
            etiket: bildirimAcik
                ? l10n.ezanBildirimiAcik(ad)
                : l10n.ezanBildirimiKapali(ad),
            onTap: onBildirim,
            zemin: bildirimAcik ? AbyadColors.yesilZemin : AbyadColors.zemin,
            renk: bildirimAcik ? AbyadColors.zumrut : AbyadColors.metinPasif,
            kenarlik: false,
          ),
        ],
      ),
    );
  }
}
