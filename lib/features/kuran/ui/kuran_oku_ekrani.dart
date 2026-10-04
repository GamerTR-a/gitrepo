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
import '../../ayarlar/data/ayarlar_saglayici.dart';
import '../data/kuran_deposu.dart';
import 'kuran_liste_ekrani.dart' show yerImleriProvider;
import 'kuran_sayfa_ekrani.dart';

enum OkumaModu { ikisi, arapca, meal }

/// Tasarım: docs/tasarim/04_kuran_oku
class KuranOkuEkrani extends ConsumerStatefulWidget {
  const KuranOkuEkrani({super.key, required this.sure, this.ayet = 1});

  final int sure;

  /// Açılışta en üstte görünecek ayet
  final int ayet;

  @override
  ConsumerState<KuranOkuEkrani> createState() => _KuranOkuEkraniState();
}

class _KuranOkuEkraniState extends ConsumerState<KuranOkuEkrani> {
  OkumaModu _mod = OkumaModu.ikisi;
  final _merkez = GlobalKey();
  final _ust = GlobalKey();
  final _gorunenler = <int, BuildContext>{};
  final _liste = GlobalKey();
  late int _kalinanAyet = widget.ayet;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _kaydet());
  }

  /// Ekranın üst kısmındaki ilk ayeti "kalınan yer" olarak kaydeder.
  void _konumuGuncelle() {
    final kutu = _liste.currentContext?.findRenderObject() as RenderBox?;
    if (kutu == null) return;
    final ust = kutu.localToGlobal(Offset.zero).dy;
    int? enUstteki;
    var enYakin = double.infinity;
    for (final e in _gorunenler.entries) {
      final r = e.value.findRenderObject();
      if (r is! RenderBox || !r.attached) continue;
      final alt = r.localToGlobal(Offset(0, r.size.height)).dy - ust;
      // Kartın alt kenarı görünür alanın içinde olan ilk ayet
      if (alt > 40 && alt < enYakin) {
        enYakin = alt;
        enUstteki = e.key;
      }
    }
    if (enUstteki != null && enUstteki != _kalinanAyet) {
      _kalinanAyet = enUstteki;
      _kaydet();
    }
  }

  void _kaydet() {
    ref.read(veritabaniProvider).okumaDurumunuKaydet(widget.sure, _kalinanAyet);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kuran = ref.watch(kuranProvider);
    final meal = ref.watch(mealKaynagiProvider);
    final olcek = ref.watch(ayarlarProvider.select((a) => a.kuranYaziOlcegi));
    final imler = {
      for (final im
          in ref.watch(yerImleriProvider).valueOrNull ??
              const <YerImleriData>[])
        if (im.sure == widget.sure) im.ayet,
    };

    return Scaffold(
      backgroundColor: AbyadColors.okumaZemini,
      body: SafeArea(
        bottom: false,
        child: kuran.when(
          loading: () => const Yukleniyor(),
          error: (_, _) => const YuklemeHatasi(),
          data: (veri) {
            final sure = veri.sure(widget.sure);
            final arapcaGoster = _mod != OkumaModu.meal;
            final mealGoster = _mod != OkumaModu.arapca;

            Widget ayetKarti(int ayet) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: _AyetKarti(
                no: ayet,
                arapca: arapcaGoster ? veri.ayetMetni(widget.sure, ayet) : null,
                meal: mealGoster ? meal.meal(widget.sure, ayet) : null,
                yaziOlcegi: olcek,
                imli: imler.contains(ayet),
                onIm: () => ref
                    .read(veritabaniProvider)
                    .yerImiDegistir(widget.sure, ayet),
                kayit: (c) => c == null
                    ? _gorunenler.remove(ayet)
                    : _gorunenler[ayet] = c,
              ),
            );

            final ilk = widget.ayet.clamp(1, sure.ayetSayisi);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: SayfaBasligi(
                    baslik: l10n.sureAdi(sure.ad),
                    altBaslik: l10n.sureUstBilgi(
                      sure.no,
                      sure.ayetSayisi,
                      sure.mekki ? l10n.mekki : l10n.medeni,
                      veri.sayfaNo(sure.no, _kalinanAyet),
                    ),
                    sagda: [
                      KareIkonDugme(
                        ikon: 'book',
                        etiket: l10n.sayfaGorunumu,
                        onTap: _sayfaGorunumuneGec,
                        zemin: Colors.transparent,
                        kenarlik: false,
                      ),
                      YaziBoyutuDugmesi(
                        onTap: () => kuranGorunumAyari(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AbyadColors.kenarlik),
                Expanded(
                  child: NotificationListener<ScrollEndNotification>(
                    onNotification: (_) {
                      _konumuGuncelle();
                      return false;
                    },
                    child: CustomScrollView(
                      key: _liste,
                      // İlk ayetle açılınca üst bölüm ekranın başında durur;
                      // ortadan açılınca seçilen ayet en üstte olur.
                      center: ilk == 1 ? _ust : _merkez,
                      slivers: [
                        SliverToBoxAdapter(
                          key: _ust,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 16),
                                AbyadSegment<OkumaModu>(
                                  secenekler: {
                                    OkumaModu.ikisi: l10n.modArapcaMeal,
                                    OkumaModu.arapca: l10n.modArapca,
                                    OkumaModu.meal: l10n.modMeal,
                                  },
                                  secili: _mod,
                                  onSec: (m) => setState(() => _mod = m),
                                ),
                                if (mealGoster && meal.ad == null) ...[
                                  const SizedBox(height: 12),
                                  const MealYerTutucu(),
                                ],
                                if (veri.besmeleBasligi(sure.no) &&
                                    arapcaGoster) ...[
                                  const SizedBox(height: 12),
                                  const _Ayrac(),
                                  ArapcaMetin(
                                    veri.besmele,
                                    boyut: 26 * olcek,
                                    hizalama: TextAlign.center,
                                  ),
                                ] else ...[
                                  const SizedBox(height: 12),
                                  const _Ayrac(),
                                ],
                              ],
                            ),
                          ),
                        ),
                        // Açılış ayetinden öncekiler (yukarı doğru büyür)
                        SliverList.builder(
                          itemCount: ilk - 1,
                          itemBuilder: (_, i) => ayetKarti(ilk - 1 - i),
                        ),
                        SliverList.builder(
                          key: _merkez,
                          itemCount: sure.ayetSayisi - ilk + 1,
                          itemBuilder: (_, i) => ayetKarti(ilk + i),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (sure.no < veri.sureler.length)
                                  AbyadDugme(
                                    metin: l10n.sonrakiSure(
                                      veri.sure(sure.no + 1).ad,
                                    ),
                                    onTap: () =>
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute<void>(
                                            builder: (_) => KuranOkuEkrani(
                                              sure: sure.no + 1,
                                            ),
                                          ),
                                        ),
                                  ),
                                const SizedBox(height: 14),
                                Text(
                                  l10n.tanzilKaynak,
                                  textAlign: TextAlign.center,
                                  style: AbyadText.etiket,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  void _sayfaGorunumuneGec() {
    ref
        .read(ayarlarProvider.notifier)
        .guncelle((a) => a.copyWith(kuranSayfaGorunumu: true));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => KuranSayfaEkrani(sure: widget.sure, ayet: _kalinanAyet),
      ),
    );
  }
}

/// Kur'an ekranlarının başlığındaki "Aa" düğmesi.
class YaziBoyutuDugmesi extends StatelessWidget {
  const YaziBoyutuDugmesi({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: AppLocalizations.of(context).yaziBoyutuVeGorunum,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AbyadRadius.dugme),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Text(
              'Aa',
              textScaler: TextScaler.noScaling,
              style: abyadStil(
                AbyadFonts.baslik,
                19,
                600,
                color: AbyadColors.zumrut,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Arapça yazı boyutu ayarı (iki Kur'an görünümünde ortak).
void kuranGorunumAyari(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AbyadColors.yuzey,
    showDragHandle: true,
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final l10n = AppLocalizations.of(context);
        final olcek = ref.watch(
          ayarlarProvider.select((a) => a.kuranYaziOlcegi),
        );
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.arapcaYaziBoyutu, style: AbyadText.kartBasligi),
                Slider(
                  value: olcek,
                  min: 0.8,
                  max: 2.0,
                  divisions: 12,
                  activeColor: AbyadColors.zumrut,
                  label: l10n.yuzdeDeger((olcek * 100).round()),
                  semanticFormatterCallback: (v) =>
                      l10n.yuzdeDeger((v * 100).round()),
                  onChanged: (v) => ref
                      .read(ayarlarProvider.notifier)
                      .guncelle((a) => a.copyWith(kuranYaziOlcegi: v)),
                ),
                Text(l10n.arapcaYaziBoyutuNot, style: AbyadText.kucuk),
              ],
            ),
          ),
        );
      },
    ),
  );
}

/// Lisanslı meal eklenene kadar gösterilen bilgi kutusu.
class MealYerTutucu extends StatelessWidget {
  const MealYerTutucu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AbyadColors.pirincAcik,
        borderRadius: BorderRadius.circular(AbyadRadius.dugme),
        border: Border.all(color: AbyadColors.pirincKenar),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AbyadIcon('info', renk: AbyadColors.pirincYazi, boyut: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppLocalizations.of(context).mealYok,
              style: abyadStil(AbyadFonts.metin, 13, 500, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _Ayrac extends StatelessWidget {
  const _Ayrac();

  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(child: Divider(color: AbyadColors.kenarlik)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SekizKoseYildiz(
          boyut: 18,
          renk: AbyadColors.pirincSus,
          cizgiKalinligi: 1.1,
        ),
      ),
      Expanded(child: Divider(color: AbyadColors.kenarlik)),
    ],
  );
}

class _AyetKarti extends StatefulWidget {
  const _AyetKarti({
    required this.no,
    required this.arapca,
    required this.meal,
    required this.yaziOlcegi,
    required this.imli,
    required this.onIm,
    required this.kayit,
  });

  final int no;
  final String? arapca;
  final String? meal;
  final double yaziOlcegi;
  final bool imli;
  final VoidCallback onIm;

  /// Kart ekrandayken bağlamını, ekrandan çıkınca `null` bildirir.
  final void Function(BuildContext?) kayit;

  @override
  State<_AyetKarti> createState() => _AyetKartiState();
}

class _AyetKartiState extends State<_AyetKarti> {
  @override
  void initState() {
    super.initState();
    widget.kayit(context);
  }

  @override
  void dispose() {
    widget.kayit(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
      decoration: BoxDecoration(
        color: widget.imli ? AbyadColors.pirincAcik : AbyadColors.yuzey,
        borderRadius: BorderRadius.circular(AbyadRadius.ikonKutu),
        border: Border.all(
          color: widget.imli ? AbyadColors.pirincKenar : AbyadColors.ayrac,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Semantics(
                label: l10n.ayetNo(widget.no),
                excludeSemantics: true,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 28),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.imli
                        ? AbyadColors.pirinc
                        : AbyadColors.yesilZemin,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${widget.no}',
                    textAlign: TextAlign.center,
                    style: abyadStil(
                      AbyadFonts.metin,
                      12,
                      700,
                      color: AbyadColors.zumrut,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              KareIkonDugme(
                ikon: 'bookmark',
                etiket: widget.imli
                    ? l10n.yerImiKaldir(widget.no)
                    : l10n.yerImiEkle(widget.no),
                onTap: widget.onIm,
                zemin: Colors.transparent,
                renk: widget.imli
                    ? AbyadColors.pirincYazi
                    : AbyadColors.metinPasif,
                kenarlik: false,
              ),
            ],
          ),
          if (widget.arapca != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ArapcaMetin(
                '${widget.arapca} ${ayetIsareti(widget.no)}',
                boyut: 27 * widget.yaziOlcegi,
              ),
            ),
          if (widget.meal != null) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(widget.meal!, style: AbyadText.govde),
            ),
          ],
        ],
      ),
    );
  }
}
