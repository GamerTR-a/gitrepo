import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_icon.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';
import '../../bildirim/data/bildirim_servisi.dart';
import '../../bildirim/domain/bildirim_plani.dart';
import '../../konum/ui/sehir_sec_ekrani.dart';
import '../../kuran/data/kuran_deposu.dart';
import '../../vakitler/domain/gunluk_vakitler.dart';
import '../../vakitler/domain/vakit_hesaplama.dart';
import '../../vakitler/ui/vakit_adlari.dart';
import '../data/ayarlar_saglayici.dart';
import '../domain/ayarlar.dart';
import 'lisanslar_ekrani.dart';

/// Uygulama sürümü (pubspec.yaml ile birlikte güncellenir)
const uygulamaSurumu = '1.3.0';

/// Sistem uygulama ayarlarını açar. Testlerde ezilir.
final sistemAyarlariProvider = Provider<Future<void> Function()>(
  (ref) => () async {
    await Geolocator.openAppSettings();
  },
);

void _git(BuildContext context, Widget ekran) =>
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ekran));

const _kartIci = EdgeInsets.symmetric(horizontal: 16, vertical: 4);

Widget _ayrac() => Divider(height: 1, color: AbyadColors.ayrac);

/// Ayarların ana sayfası: en sık değişen görünüm seçenekleri ve
/// ayrıntı sayfalarına giden kısa bir menü.
class AyarlarEkrani extends ConsumerWidget {
  const AyarlarEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ayarlar = ref.watch(ayarlarProvider);
    final guncelle = ref.read(ayarlarProvider.notifier).guncelle;

    return AbyadSayfa(
      children: [
        SayfaBasligi(baslik: l10n.ayarlar),
        const SizedBox(height: 18),
        AbyadKart(
          yaricap: AbyadRadius.buyukKart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.yaziBoyutu, style: AbyadText.kartBasligi),
              const SizedBox(height: 10),
              AbyadSegment<YaziBoyutu>(
                secenekler: {
                  YaziBoyutu.normal: l10n.yaziNormal,
                  YaziBoyutu.buyuk: l10n.yaziBuyuk,
                  YaziBoyutu.cokBuyuk: l10n.yaziCokBuyuk,
                },
                secili: ayarlar.yaziBoyutu,
                onSec: (y) => guncelle((a) => a.copyWith(yaziBoyutu: y)),
              ),
              const SizedBox(height: 16),
              Text(l10n.tema, style: AbyadText.kartBasligi),
              const SizedBox(height: 10),
              AbyadSegment<bool>(
                secenekler: {false: l10n.temaAcik, true: l10n.temaKoyu},
                secili: ayarlar.koyuTema,
                onSec: (v) => guncelle((a) => a.copyWith(koyuTema: v)),
              ),
              const SizedBox(height: 6),
              _ayrac(),
              AnahtarSatiri(
                baslik: l10n.yuksekKontrast,
                aciklama: l10n.yuksekKontrastAciklama,
                deger: ayarlar.yuksekKontrast,
                onDegis: (v) => guncelle((a) => a.copyWith(yuksekKontrast: v)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AbyadKart(
          padding: _kartIci,
          yaricap: AbyadRadius.buyukKart,
          child: Column(
            children: [
              GezinmeSatiri(
                ikon: 'bell',
                baslik: l10n.ezanVeBildirimler,
                aciklama: l10n.ezanVeBildirimlerOzet,
                onTap: () => _git(context, const BildirimAyarEkrani()),
              ),
              _ayrac(),
              GezinmeSatiri(
                ikon: 'pin',
                baslik: l10n.konumVeVakitler,
                aciklama: ayarlar.konum.ad,
                onTap: () => _git(context, const VakitAyarEkrani()),
              ),
              _ayrac(),
              GezinmeSatiri(
                ikon: 'book',
                baslik: l10n.ekranKuran,
                aciklama: l10n.kuranAyarOzet,
                onTap: () => _git(context, const KuranAyarEkrani()),
              ),
              _ayrac(),
              GezinmeSatiri(
                ikon: 'info',
                baslik: l10n.kaynaklarVeLisanslar,
                onTap: () => _git(context, const LisanslarEkrani()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AbyadKart(
          renk: AbyadColors.yesilZemin,
          kenarRengi: AbyadColors.yesilZemin,
          yaricap: AbyadRadius.buyukKart,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AbyadIcon('shield', renk: AbyadColors.zumrut),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.mahremiyetBaslik, style: AbyadText.kartBasligi),
                    const SizedBox(height: 4),
                    Text(
                      l10n.mahremiyetMetin,
                      style: abyadStil(AbyadFonts.metin, 13, 400, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.surumBilgisi(uygulamaSurumu),
          textAlign: TextAlign.center,
          style: AbyadText.etiket,
        ),
      ],
    );
  }
}

/// Ezan ve bildirim seçenekleri, izin durumu ve pil ayarı.
class BildirimAyarEkrani extends ConsumerWidget {
  const BildirimAyarEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ayarlar = ref.watch(ayarlarProvider);
    final guncelle = ref.read(ayarlarProvider.notifier).guncelle;

    BildirimAyarlari bildirim({int? onceDakika, bool? cumaSessiz}) =>
        BildirimAyarlari(
          vakitler: ayarlar.bildirim.vakitler,
          onceDakika: onceDakika ?? ayarlar.bildirim.onceDakika,
          cumaSessiz: cumaSessiz ?? ayarlar.bildirim.cumaSessiz,
        );

    return AbyadSayfa(
      children: [
        SayfaBasligi(baslik: l10n.ezanVeBildirimler),
        const SizedBox(height: 16),
        AbyadKart(
          padding: _kartIci,
          yaricap: AbyadRadius.buyukKart,
          child: Column(
            children: [
              GezinmeSatiri(
                baslik: l10n.vakitBildirimleri,
                aciklama: l10n.vakitBildirimleriAciklama,
                onTap: () => _git(context, const VakitBildirimEkrani()),
              ),
              _ayrac(),
              AnahtarSatiri(
                baslik: l10n.alarmOlarakCal,
                aciklama: l10n.alarmOlarakCalAciklama,
                deger: ayarlar.alarmOlarakCal,
                onDegis: (v) => guncelle((a) => a.copyWith(alarmOlarakCal: v)),
              ),
              _ayrac(),
              AnahtarSatiri(
                baslik: l10n.onceHatirlat,
                aciklama: l10n.onceHatirlatAciklama,
                deger: ayarlar.bildirim.onceDakika > 0,
                onDegis: (v) => guncelle(
                  (a) => a.copyWith(bildirim: bildirim(onceDakika: v ? 15 : 0)),
                ),
              ),
              _ayrac(),
              AnahtarSatiri(
                baslik: l10n.cumaSessiz,
                aciklama: l10n.cumaSessizAciklama,
                deger: ayarlar.bildirim.cumaSessiz,
                onDegis: (v) => guncelle(
                  (a) => a.copyWith(bildirim: bildirim(cumaSessiz: v)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const _BildirimDurumu(),
        const SizedBox(height: 12),
        const _PilKarti(),
      ],
    );
  }
}

/// Konum, hesaplama yöntemi ve düzeltmeler.
class VakitAyarEkrani extends ConsumerWidget {
  const VakitAyarEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ayarlar = ref.watch(ayarlarProvider);
    final guncelle = ref.read(ayarlarProvider.notifier).guncelle;

    return AbyadSayfa(
      children: [
        SayfaBasligi(baslik: l10n.konumVeVakitler),
        const SizedBox(height: 16),
        AbyadKart(
          padding: _kartIci,
          yaricap: AbyadRadius.buyukKart,
          child: Column(
            children: [
              GezinmeSatiri(
                baslik: l10n.konum,
                deger: ayarlar.konum.otomatik
                    ? l10n.konumOtomatik(ayarlar.konum.ad)
                    : ayarlar.konum.ad,
                onTap: () => _git(context, const SehirSecEkrani()),
              ),
              _ayrac(),
              GezinmeSatiri(
                baslik: l10n.hesaplamaYontemi,
                deger: l10n.yontemAdi(ayarlar.yontem),
                onTap: () => _yontemSec(context, ref),
              ),
              _ayrac(),
              GezinmeSatiri(
                baslik: l10n.dakikaDuzeltme,
                deger: ayarlar.duzeltmeler.isEmpty ? l10n.kapali : l10n.acik,
                onTap: () => _git(context, const DuzeltmeEkrani()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AbyadKart(
          yaricap: AbyadRadius.buyukKart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.hicriDuzeltme,
                style: abyadStil(AbyadFonts.metin, 15, 700),
              ),
              const SizedBox(height: 3),
              Text(l10n.hicriDuzeltmeAciklama, style: AbyadText.kucuk),
              const SizedBox(height: 10),
              AbyadSegment<int>(
                secenekler: {
                  -1: l10n.gunEksiBir,
                  0: l10n.gunFarkiYok,
                  1: l10n.gunArtiBir,
                },
                secili: ayarlar.hicriDuzeltme,
                onSec: (g) => guncelle((a) => a.copyWith(hicriDuzeltme: g)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Kur'an okuma görünümü ve meal seçimi.
class KuranAyarEkrani extends ConsumerWidget {
  const KuranAyarEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ayarlar = ref.watch(ayarlarProvider);
    final guncelle = ref.read(ayarlarProvider.notifier).guncelle;
    final meal = ref.watch(mealKaynagiProvider);
    final mealler =
        ref.watch(meallerProvider).valueOrNull ?? const <MealBilgisi>[];

    return AbyadSayfa(
      children: [
        SayfaBasligi(baslik: l10n.ekranKuran),
        const SizedBox(height: 16),
        AbyadKart(
          padding: _kartIci,
          yaricap: AbyadRadius.buyukKart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Text(
                l10n.kuranGorunumu,
                style: abyadStil(AbyadFonts.metin, 15, 700),
              ),
              const SizedBox(height: 10),
              AbyadSegment<bool>(
                secenekler: {
                  true: l10n.sayfaGorunumu,
                  false: l10n.ayetGorunumu,
                },
                secili: ayarlar.kuranSayfaGorunumu,
                onSec: (v) =>
                    guncelle((a) => a.copyWith(kuranSayfaGorunumu: v)),
              ),
              const SizedBox(height: 12),
              _ayrac(),
              GezinmeSatiri(
                baslik: l10n.mealSecimi,
                deger: meal.ad ?? l10n.mealEklenmedi,
                onTap: () => mealler.length > 1
                    ? _mealSec(context, ref, mealler)
                    : _git(context, const LisanslarEkrani()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void _mealSec(BuildContext context, WidgetRef ref, List<MealBilgisi> mealler) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AbyadColors.yuzey,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      final seciliAd = ref.read(mealKaynagiProvider).ad;
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.mealSecimi, style: AbyadText.kartBasligi),
              const SizedBox(height: 8),
              for (final m in mealler)
                Semantics(
                  button: true,
                  selected: m.ad == seciliAd,
                  child: InkWell(
                    onTap: () {
                      ref
                          .read(ayarlarProvider.notifier)
                          .guncelle((a) => a.copyWith(mealId: m.id));
                      Navigator.of(context).pop();
                    },
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 56),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  m.ad,
                                  style: abyadStil(
                                    AbyadFonts.metin,
                                    15,
                                    m.ad == seciliAd ? 700 : 500,
                                  ),
                                ),
                                Text(m.sahip, style: AbyadText.kucuk),
                              ],
                            ),
                          ),
                          if (m.ad == seciliAd)
                            AbyadIcon('check', renk: AbyadColors.zumrut),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

void _yontemSec(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AbyadColors.yuzey,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      final secili = ref.read(ayarlarProvider).yontem;
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.hesaplamaYontemi, style: AbyadText.kartBasligi),
              const SizedBox(height: 8),
              for (final y in HesapYontemi.values)
                Semantics(
                  button: true,
                  selected: y == secili,
                  child: InkWell(
                    onTap: () {
                      ref
                          .read(ayarlarProvider.notifier)
                          .guncelle((a) => a.copyWith(yontem: y));
                      Navigator.of(context).pop();
                    },
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 52),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.yontemAdi(y),
                              style: abyadStil(
                                AbyadFonts.metin,
                                15,
                                y == secili ? 700 : 500,
                              ),
                            ),
                          ),
                          if (y == secili)
                            AbyadIcon('check', renk: AbyadColors.zumrut),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

/// Bildirim izni, tam zamanlı alarm izni ve test bildirimi.
class _BildirimDurumu extends ConsumerStatefulWidget {
  const _BildirimDurumu();

  @override
  ConsumerState<_BildirimDurumu> createState() => _BildirimDurumuState();
}

class _BildirimDurumuState extends ConsumerState<_BildirimDurumu>
    with WidgetsBindingObserver {
  bool? _izin;
  bool? _tamZamanli;
  bool _testGonderildi = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _yenile();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState durum) {
    // Kullanıcı sistem ayarlarından dönünce durumu tazele
    if (durum == AppLifecycleState.resumed) _yenile();
  }

  Future<void> _yenile() async {
    try {
      final servis = ref.read(bildirimServisiProvider);
      final izin = await servis.izinVarMi();
      final tam = await servis.tamZamanliMi();
      if (mounted) {
        setState(() {
          _izin = izin;
          _tamZamanli = tam;
        });
      }
    } on Object {
      // Eklenti yoksa (ör. test ortamı) durum satırları gösterilmez
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final servis = ref.read(bildirimServisiProvider);
    return AbyadKart(
      yaricap: AbyadRadius.buyukKart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_izin == false) ...[
            Text(l10n.bildirimIzniYok, style: AbyadText.govde),
            const SizedBox(height: 10),
            AbyadDugme(
              metin: l10n.bildirimIzniVer,
              ikincil: true,
              onTap: () async {
                await servis.izinIste();
                await _yenile();
              },
            ),
            const SizedBox(height: 14),
          ],
          if (_tamZamanli == false) ...[
            Text(l10n.tamZamanliYok, style: AbyadText.govde),
            const SizedBox(height: 10),
            AbyadDugme(
              metin: l10n.tamZamanliIzinVer,
              ikincil: true,
              onTap: () async {
                await servis.tamZamanliIzniIste();
                await _yenile();
              },
            ),
            const SizedBox(height: 14),
          ],
          Text(l10n.testBildirimiAciklama, style: AbyadText.kucuk),
          const SizedBox(height: 10),
          AbyadDugme(
            metin: l10n.testBildirimiGonder,
            ikon: 'bell',
            onTap: () async {
              try {
                await servis.testGonder();
                if (mounted) setState(() => _testGonderildi = true);
              } on Object {
                if (mounted) setState(() => _testGonderildi = false);
              }
            },
          ),
          if (_testGonderildi) ...[
            const SizedBox(height: 8),
            Semantics(
              liveRegion: true,
              child: Text(
                l10n.testBildirimiGonderildi,
                textAlign: TextAlign.center,
                style: abyadStil(
                  AbyadFonts.metin,
                  13,
                  600,
                  color: AbyadColors.zumrut,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// "Ezanın her durumda çalması için" pil optimizasyonu kartı.
class _PilKarti extends ConsumerWidget {
  const _PilKarti();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (defaultTargetPlatform != TargetPlatform.android) {
      return const SizedBox.shrink();
    }
    return AbyadKart(
      renk: AbyadColors.pirincAcik,
      kenarRengi: AbyadColors.pirincKenar,
      yaricap: AbyadRadius.buyukKart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AbyadIcon('battery', renk: AbyadColors.pirincYazi),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.pilBaslik, style: AbyadText.kartBasligi),
                    const SizedBox(height: 4),
                    Text(
                      l10n.pilMetin,
                      style: abyadStil(AbyadFonts.metin, 13, 400, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AbyadDugme(
            metin: l10n.ayariAc,
            onTap: () => ref.read(sistemAyarlariProvider)(),
          ),
          const SizedBox(height: 12),
          for (final (marka, yol) in [
            (l10n.markaSamsung, l10n.markaSamsungYol),
            (l10n.markaXiaomi, l10n.markaXiaomiYol),
            (l10n.markaHuawei, l10n.markaHuaweiYol),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$marka: ',
                      style: abyadStil(AbyadFonts.metin, 13, 700),
                    ),
                    TextSpan(text: yol),
                  ],
                ),
                style: abyadStil(AbyadFonts.metin, 13, 400, height: 1.5),
              ),
            ),
        ],
      ),
    );
  }
}

/// Her vakit için bildirim aç/kapa ve ses seçimi.
class VakitBildirimEkrani extends ConsumerWidget {
  const VakitBildirimEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bildirim = ref.watch(ayarlarProvider.select((a) => a.bildirim));

    void degistir(VakitTuru tur, VakitBildirimAyari yeni) {
      ref.read(ayarlarProvider.notifier).guncelle((a) {
        final vakitler = Map.of(a.bildirim.vakitler)..[tur] = yeni;
        return a.copyWith(
          bildirim: BildirimAyarlari(
            vakitler: vakitler,
            onceDakika: a.bildirim.onceDakika,
            cumaSessiz: a.bildirim.cumaSessiz,
          ),
        );
      });
    }

    return AbyadSayfa(
      children: [
        SayfaBasligi(baslik: l10n.vakitBildirimleri),
        const SizedBox(height: 16),
        for (final tur in VakitTuru.values) ...[
          AbyadKart(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnahtarSatiri(
                  baslik: l10n.vakitAdi(tur),
                  deger: bildirim.vakitler[tur]!.acik,
                  onDegis: (v) =>
                      degistir(tur, bildirim.vakitler[tur]!.copyWith(acik: v)),
                ),
                if (bildirim.vakitler[tur]!.acik)
                  AbyadSegment<BildirimSesi>(
                    secenekler: {
                      BildirimSesi.ezan: l10n.sesEzan,
                      BildirimSesi.kisa: l10n.sesKisa,
                      BildirimSesi.titresim: l10n.sesTitresim,
                    },
                    secili: bildirim.vakitler[tur]!.ses,
                    onSec: (s) =>
                        degistir(tur, bildirim.vakitler[tur]!.copyWith(ses: s)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (!ezanSesiVar) Text(l10n.ezanSesiYokNot, style: AbyadText.etiket),
      ],
    );
  }
}

/// Vakit başına ± dakika düzeltme.
class DuzeltmeEkrani extends ConsumerWidget {
  const DuzeltmeEkrani({super.key});

  static const _sinir = 30;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final duzeltmeler = ref.watch(ayarlarProvider.select((a) => a.duzeltmeler));

    void ayarla(VakitTuru tur, int dakika) {
      ref.read(ayarlarProvider.notifier).guncelle((a) {
        final yeni = Map.of(a.duzeltmeler);
        if (dakika == 0) {
          yeni.remove(tur);
        } else {
          yeni[tur] = dakika.clamp(-_sinir, _sinir);
        }
        return a.copyWith(duzeltmeler: yeni);
      });
    }

    return AbyadSayfa(
      children: [
        SayfaBasligi(baslik: l10n.dakikaDuzeltme),
        const SizedBox(height: 8),
        Text(l10n.dakikaDuzeltmeAciklama, style: AbyadText.kucuk),
        const SizedBox(height: 16),
        AbyadKart(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          yaricap: AbyadRadius.buyukKart,
          child: Column(
            children: [
              for (final (i, tur) in VakitTuru.values.indexed) ...[
                if (i > 0) Divider(height: 1, color: AbyadColors.ayrac),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.vakitAdi(tur),
                          style: abyadStil(AbyadFonts.metin, 15, 700),
                        ),
                      ),
                      KareIkonDugme(
                        ikon: 'minus',
                        etiket: l10n.dakikaAzalt(l10n.vakitAdi(tur)),
                        onTap: () => ayarla(tur, (duzeltmeler[tur] ?? 0) - 1),
                      ),
                      Semantics(
                        liveRegion: true,
                        label: l10n.dakikaDeger(duzeltmeler[tur] ?? 0),
                        excludeSemantics: true,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 64),
                          child: Text(
                            _isaretli(duzeltmeler[tur] ?? 0),
                            textAlign: TextAlign.center,
                            style: abyadStil(AbyadFonts.metin, 16, 800),
                          ),
                        ),
                      ),
                      KareIkonDugme(
                        ikon: 'plus',
                        etiket: l10n.dakikaArtir(l10n.vakitAdi(tur)),
                        onTap: () => ayarla(tur, (duzeltmeler[tur] ?? 0) + 1),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  static String _isaretli(int n) => n > 0 ? '+$n' : '$n';
}
