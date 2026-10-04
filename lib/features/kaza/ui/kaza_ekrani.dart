import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/storage/veritabani.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_icon.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';
import '../../ayarlar/data/ayarlar_saglayici.dart';
import '../../vakitler/data/vakit_saglayicilari.dart';
import '../domain/kaza.dart';
import 'kaza_sihirbazi.dart';

const _gunlukAnahtar = 'kaza';

final kazaSayaclariProvider = StreamProvider<Map<KazaTuru, int>>(
  (ref) => ref
      .watch(veritabaniProvider)
      .kazaSayaclariniIzle()
      .map((kayit) => {for (final t in KazaTuru.values) t: kayit[t.name] ?? 0}),
);

final _bugunKilinanProvider = StreamProvider.autoDispose<int>((ref) {
  final gun = gunAnahtari(ref.watch(saatProvider)());
  return ref.watch(veritabaniProvider).gunlukSayaciIzle(gun, _gunlukAnahtar);
});

extension KazaAdlari on AppLocalizations {
  String kazaAdi(KazaTuru tur) => switch (tur) {
    KazaTuru.sabah => kazaSabah,
    KazaTuru.ogle => vakitOgle,
    KazaTuru.ikindi => vakitIkindi,
    KazaTuru.aksam => vakitAksam,
    KazaTuru.yatsi => vakitYatsi,
    KazaTuru.vitir => kazaVitir,
    KazaTuru.oruc => kazaOruc,
  };

  /// "3 yıl 2 ay" gibi; teşvik edici, kesinlik iddia etmeyen dil.
  String sureMetni(int gunSayisi) {
    final s = sureyeBol(gunSayisi);
    if (s.yil > 0) return s.ay > 0 ? sureYilAy(s.yil, s.ay) : sureYil(s.yil);
    if (s.ay > 0) return s.gun > 0 ? sureAyGun(s.ay, s.gun) : sureAy(s.ay);
    return sureGun(s.gun);
  }
}

/// Tasarım: docs/tasarim/05_kaza_takibi
class KazaEkrani extends ConsumerWidget {
  const KazaEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sayaclar = ref.watch(kazaSayaclariProvider).valueOrNull;
    final bugun = ref.watch(_bugunKilinanProvider).valueOrNull ?? 0;
    final gizli = ref.watch(ayarlarProvider.select((a) => a.kazaGizli));
    final tempo = ref.watch(ayarlarProvider.select((a) => a.kazaTempo));
    final vt = ref.read(veritabaniProvider);
    final guncelle = ref.read(ayarlarProvider.notifier).guncelle;

    if (sayaclar == null) {
      return const Scaffold(
        backgroundColor: AbyadColors.zemin,
        body: Yukleniyor(),
      );
    }

    final toplam = kazaNamazlari.fold(0, (t, tur) => t + sayaclar[tur]!);
    final bitis = tahminiBitisGunu(toplam, tempo);
    final sayi = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    );
    String maske(String metin) => gizli ? '•••' : metin;

    Future<void> kildim(KazaTuru tur) async {
      if (sayaclar[tur]! <= 0) return;
      await vt.kazaDegistir(tur.name, -1);
      if (tur != KazaTuru.oruc) {
        await vt.gunlukSayaciArtir(
          gunAnahtari(ref.read(saatProvider)()),
          _gunlukAnahtar,
          1,
        );
      }
    }

    return AbyadSayfa(
      children: [
        SayfaBasligi(
          baslik: l10n.kazaTakibi,
          sagda: [
            Semantics(
              button: true,
              toggled: gizli,
              label: gizli ? l10n.sayilariGoster : l10n.sayilariGizle,
              excludeSemantics: true,
              child: Material(
                color: AbyadColors.yuzey,
                shape: const StadiumBorder(
                  side: BorderSide(color: AbyadColors.kenarlik),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => guncelle((a) => a.copyWith(kazaGizli: !gizli)),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: AbyadSize.minDokunma,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AbyadIcon(
                            gizli ? 'eye' : 'lock',
                            renk: AbyadColors.zumrut,
                            boyut: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            gizli ? l10n.goster : l10n.gizle,
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
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        KoyuKart(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                container: true,
                label: gizli
                    ? l10n.kazaOzetGizli
                    : l10n.kazaOzetOkuma(
                        toplam,
                        bitis == null ? l10n.kazaYok : l10n.sureMetni(bitis),
                      ),
                excludeSemantics: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _Ozet(
                        baslik: l10n.kalanKaza,
                        deger: maske(sayi.format(toplam)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _Ozet(
                        baslik: l10n.tahminiBitis,
                        deger: maske(
                          bitis == null ? l10n.kazaYok : l10n.sureMetni(bitis),
                        ),
                        kucuk: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.gundeKacVakit,
                style: abyadStil(
                  AbyadFonts.metin,
                  13,
                  500,
                  color: AbyadColors.koyuUstuIkincil,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final n in const [1, 2, 3, 5]) ...[
                    if (n > 1) const SizedBox(width: 8),
                    Expanded(
                      child: Semantics(
                        button: true,
                        selected: tempo == n,
                        label: l10n.gundeVakit(n),
                        excludeSemantics: true,
                        child: Material(
                          color: tempo == n
                              ? AbyadColors.pirinc
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AbyadRadius.cip,
                            ),
                            side: BorderSide(
                              color: tempo == n
                                  ? AbyadColors.pirinc
                                  : AbyadColors.koyuUstuKenar,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () =>
                                guncelle((a) => a.copyWith(kazaTempo: n)),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: AbyadSize.minDokunma,
                              ),
                              child: Center(
                                child: Text(
                                  '$n',
                                  style: abyadStil(
                                    AbyadFonts.metin,
                                    14,
                                    700,
                                    color: tempo == n
                                        ? AbyadColors.zumrut
                                        : AbyadColors.yuzey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (bugun > 0) ...[
                const SizedBox(height: 12),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    l10n.bugunKazaKildiniz(bugun),
                    style: abyadStil(
                      AbyadFonts.metin,
                      13,
                      600,
                      color: AbyadColors.pirinc,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        BolumBasligi(l10n.namaz),
        const SizedBox(height: 10),
        AbyadKart(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          yaricap: AbyadRadius.buyukKart,
          child: Column(
            children: [
              for (final (i, tur) in kazaNamazlari.indexed) ...[
                if (i > 0) const Divider(height: 1, color: AbyadColors.ayrac),
                _SayacSatiri(
                  ad: l10n.kazaAdi(tur),
                  durum: maske(l10n.kazaKaldi(sayaclar[tur]!)),
                  ekleEtiketi: l10n.kazaEkle(l10n.kazaAdi(tur)),
                  dusEtiketi: l10n.kazaKildimOkuma(l10n.kazaAdi(tur)),
                  dusMetni: l10n.kildim,
                  onEkle: () => vt.kazaDegistir(tur.name, 1),
                  onDus: sayaclar[tur]! > 0 ? () => kildim(tur) : null,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        BolumBasligi(l10n.oruc),
        const SizedBox(height: 10),
        AbyadKart(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          yaricap: AbyadRadius.buyukKart,
          child: _SayacSatiri(
            ad: l10n.kazaOruc,
            durum: maske(l10n.orucKaldi(sayaclar[KazaTuru.oruc]!)),
            ekleEtiketi: l10n.orucEkle,
            dusEtiketi: l10n.orucTuttumOkuma,
            dusMetni: l10n.tuttum,
            onEkle: () => vt.kazaDegistir(KazaTuru.oruc.name, 1),
            onDus: sayaclar[KazaTuru.oruc]! > 0
                ? () => kildim(KazaTuru.oruc)
                : null,
          ),
        ),
        const SizedBox(height: 14),
        AbyadKart(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const KazaSihirbazi()),
          ),
          semanticLabel: '${l10n.kazaNasilHesaplarim} ${l10n.kazaHesapAlt}',
          child: ExcludeSemantics(
            child: Row(
              children: [
                const AbyadIcon('info', renk: AbyadColors.pirincYazi),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.kazaNasilHesaplarim,
                        style: abyadStil(AbyadFonts.metin, 15, 700),
                      ),
                      const SizedBox(height: 3),
                      Text(l10n.kazaHesapAlt, style: AbyadText.etiket),
                    ],
                  ),
                ),
                const AbyadIcon(
                  'chevron_right',
                  renk: AbyadColors.metinIkincil,
                  boyut: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          l10n.kazaMahremiyet,
          textAlign: TextAlign.center,
          style: AbyadText.etiket,
        ),
      ],
    );
  }
}

class _Ozet extends StatelessWidget {
  const _Ozet({required this.baslik, required this.deger, this.kucuk = false});
  final String baslik;
  final String deger;
  final bool kucuk;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        baslik,
        style: abyadStil(
          AbyadFonts.metin,
          13,
          500,
          color: AbyadColors.koyuUstuIkincil,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        deger,
        style: abyadStil(
          AbyadFonts.baslik,
          kucuk ? 20 : 34,
          600,
          color: AbyadColors.yuzey,
          height: 1.15,
        ),
      ),
    ],
  );
}

class _SayacSatiri extends StatelessWidget {
  const _SayacSatiri({
    required this.ad,
    required this.durum,
    required this.ekleEtiketi,
    required this.dusEtiketi,
    required this.dusMetni,
    required this.onEkle,
    required this.onDus,
  });

  final String ad;
  final String durum;
  final String ekleEtiketi;
  final String dusEtiketi;
  final String dusMetni;
  final VoidCallback onEkle;
  final VoidCallback? onDus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              container: true,
              liveRegion: true,
              label: '$ad, $durum',
              excludeSemantics: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ad, style: AbyadText.kartBasligi),
                  const SizedBox(height: 2),
                  Text(durum, style: AbyadText.kucuk),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          KareIkonDugme(ikon: 'plus', etiket: ekleEtiketi, onTap: onEkle),
          const SizedBox(width: 8),
          Semantics(
            button: true,
            enabled: onDus != null,
            label: dusEtiketi,
            excludeSemantics: true,
            child: Opacity(
              opacity: onDus == null ? 0.45 : 1,
              child: AbyadDugme(metin: dusMetni, onTap: onDus),
            ),
          ),
        ],
      ),
    );
  }
}
