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
import '../../kuran/data/kuran_deposu.dart';
import '../../kuran/ui/kuran_oku_ekrani.dart' show MealYerTutucu;
import '../../zikirmatik/ui/zikirmatik_ekrani.dart';

/// Tasarım: docs/tasarim/07_dualar
class DualarEkrani extends ConsumerWidget {
  const DualarEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final veri = ref.watch(dualarProvider);
    final buyukYazi = MediaQuery.textScalerOf(context).scale(10) > 13.5;

    return SafeArea(
      bottom: false,
      child: veri.when(
        loading: () => const Yukleniyor(),
        error: (_, _) => const YuklemeHatasi(),
        data: (veri) {
          final namaz = veri.kategoriler.firstWhere((k) => k.id == 'namaz');
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              SayfaBasligi(baslik: l10n.ekranDualar, buyuk: true, geri: false),
              const SizedBox(height: 16),
              _ZikirmatikKarti(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ZikirmatikEkrani(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              BolumBasligi(l10n.kategoriler),
              const SizedBox(height: 12),
              _Izgara(
                sutun: buyukYazi ? 1 : 2,
                children: [
                  for (final (i, k) in veri.kategoriler.indexed)
                    _KategoriKarti(
                      kategori: k,
                      vurgu: i.isEven,
                      onTap: () => _kategoriAc(context, k),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: BolumBasligi(namaz.ad)),
                  TextButton(
                    onPressed: () => _kategoriAc(context, namaz),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      foregroundColor: AbyadColors.zumrut,
                    ),
                    child: Text(
                      l10n.tumu,
                      style: abyadStil(
                        AbyadFonts.metin,
                        13,
                        700,
                        color: AbyadColors.zumrut,
                      ).copyWith(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              DuaListesi(dualar: veri.kategoride('namaz').take(5).toList()),
            ],
          );
        },
      ),
    );
  }

  void _kategoriAc(BuildContext context, DuaKategorisi kategori) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DuaKategoriEkrani(kategori: kategori),
      ),
    );
  }
}

class _Izgara extends StatelessWidget {
  const _Izgara({required this.sutun, required this.children});
  final int sutun;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < children.length; i += sutun) ...[
          if (i > 0) const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var j = i; j < i + sutun; j++) ...[
                  if (j > i) const SizedBox(width: 12),
                  Expanded(
                    child: j < children.length
                        ? children[j]
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ZikirmatikKarti extends StatelessWidget {
  const _ZikirmatikKarti({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return KoyuKart(
      onTap: onTap,
      semanticLabel: '${l10n.zikirmatik}, ${l10n.namazSonrasiTesbihat}',
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AbyadColors.pirinc, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              '33',
              textScaler: TextScaler.noScaling,
              style: abyadStil(
                AbyadFonts.baslik,
                20,
                600,
                color: AbyadColors.yuzey,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.zikirmatik,
                  style: abyadStil(
                    AbyadFonts.metin,
                    12,
                    700,
                    color: AbyadColors.pirinc,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.namazSonrasiTesbihat,
                  style: abyadStil(
                    AbyadFonts.metin,
                    16,
                    700,
                    color: AbyadColors.yuzey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.tesbihatOzet,
                  style: abyadStil(
                    AbyadFonts.metin,
                    12,
                    500,
                    color: AbyadColors.koyuUstuIkincil,
                  ),
                ),
              ],
            ),
          ),
          const AbyadIcon('chevron_right', renk: AbyadColors.yuzey, boyut: 20),
        ],
      ),
    );
  }
}

class _KategoriKarti extends StatelessWidget {
  const _KategoriKarti({
    required this.kategori,
    required this.vurgu,
    required this.onTap,
  });

  final DuaKategorisi kategori;

  /// Pirinç tonlu ikon kutusu (tasarımda dönüşümlü)
  final bool vurgu;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AbyadKart(
      onTap: onTap,
      semanticLabel: '${kategori.ad}, ${kategori.aciklama}',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: vurgu ? AbyadColors.pirincZemin : AbyadColors.yesilZemin,
                borderRadius: BorderRadius.circular(AbyadRadius.cip),
              ),
              alignment: Alignment.center,
              child: AbyadIcon(
                kategori.ikon,
                renk: vurgu ? AbyadColors.pirincYazi : AbyadColors.zumrut,
                boyut: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(kategori.ad, style: abyadStil(AbyadFonts.metin, 15, 700)),
            const SizedBox(height: 6),
            Text(kategori.aciklama, style: AbyadText.etiket),
          ],
        ),
      ),
    );
  }
}

/// Dua satırlarından oluşan kart.
class DuaListesi extends StatelessWidget {
  const DuaListesi({super.key, required this.dualar});
  final List<Dua> dualar;

  @override
  Widget build(BuildContext context) {
    return AbyadKart(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      yaricap: AbyadRadius.buyukKart,
      child: Column(
        children: [
          for (final (i, d) in dualar.indexed) ...[
            if (i > 0) const Divider(height: 1, color: AbyadColors.ayrac),
            Semantics(
              button: true,
              label: d.ad,
              excludeSemantics: true,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => DuaDetayEkrani(dua: d),
                  ),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 64),
                  child: Row(
                    children: [
                      Expanded(child: Text(d.ad, style: AbyadText.kartBasligi)),
                      const SizedBox(width: 8),
                      ArapcaMetin(
                        d.arapcaKisa,
                        boyut: 22,
                        satirYuksekligi: 1.6,
                      ),
                      const SizedBox(width: 8),
                      const AbyadIcon(
                        'chevron_right',
                        renk: AbyadColors.metinIkincil,
                        boyut: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class DuaKategoriEkrani extends ConsumerWidget {
  const DuaKategoriEkrani({super.key, required this.kategori});
  final DuaKategorisi kategori;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final veri = ref.watch(dualarProvider).valueOrNull;
    return AbyadSayfa(
      children: [
        SayfaBasligi(baslik: kategori.ad, altBaslik: kategori.aciklama),
        const SizedBox(height: 16),
        if (veri == null)
          const Yukleniyor()
        else
          DuaListesi(dualar: veri.kategoride(kategori.id)),
      ],
    );
  }
}

class DuaDetayEkrani extends ConsumerWidget {
  const DuaDetayEkrani({super.key, required this.dua});
  final Dua dua;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kuran = ref.watch(kuranProvider).valueOrNull;
    final meal = ref.watch(mealKaynagiProvider);

    // Ayet ise metin yalnızca gömülü Tanzil dosyasından gelir.
    String? arapca = dua.arapca;
    String? anlam = dua.anlam;
    var mealEksik = false;
    if (dua.ayetler != null) {
      if (kuran == null) {
        arapca = null;
      } else {
        final ayetler = kuran.aralik(dua.ayetler!);
        arapca = [
          for (final a in ayetler)
            '${kuran.ayetMetni(a.sure, a.ayet)} ${ayetIsareti(a.ayet)}',
        ].join(' ');
        final mealler = [
          for (final a in ayetler) meal.meal(a.sure, a.ayet),
        ].nonNulls;
        anlam = mealler.isEmpty ? null : mealler.join(' ');
        mealEksik = mealler.isEmpty;
      }
    }

    return AbyadSayfa(
      zemin: AbyadColors.okumaZemini,
      children: [
        SayfaBasligi(baslik: dua.ad),
        const SizedBox(height: 16),
        if (arapca == null)
          const Yukleniyor()
        else
          AbyadKart(
            padding: const EdgeInsets.all(AbyadSpace.xl),
            child: ArapcaMetin(arapca, boyut: 26),
          ),
        if (dua.okunus != null) ...[
          const SizedBox(height: 16),
          BolumBasligi(l10n.okunus),
          const SizedBox(height: 6),
          Text(dua.okunus!, style: AbyadText.govde),
        ],
        const SizedBox(height: 16),
        BolumBasligi(l10n.anlam),
        const SizedBox(height: 6),
        if (anlam != null)
          Text(anlam, style: AbyadText.govde)
        else if (mealEksik)
          const MealYerTutucu(),
        const SizedBox(height: 16),
        Text(l10n.kaynakSatiri(dua.kaynak), style: AbyadText.kucuk),
      ],
    );
  }
}
