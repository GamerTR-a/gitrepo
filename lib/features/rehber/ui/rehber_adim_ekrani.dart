import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/icerik/icerik.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_icon.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';
import '../../kuran/data/kuran_deposu.dart';
import '../data/rehber_saglayici.dart';
import '../domain/rehber.dart';

/// Adım adım ilerleyen rehber. Tasarım: docs/tasarim/06_rehber
///
/// Adımlar düğmelerle ya da yana kaydırarak değişir. Ezber modunda Arapça
/// metin ve okunuş gizlenir, dokununca açılır.
class RehberAdimEkrani extends ConsumerStatefulWidget {
  const RehberAdimEkrani({
    super.key,
    required this.baslik,
    required this.altBaslik,
    required this.adimlar,
  });

  final String baslik;
  final String altBaslik;
  final List<SiraliAdim> adimlar;

  @override
  ConsumerState<RehberAdimEkrani> createState() => _RehberAdimEkraniState();
}

class _RehberAdimEkraniState extends ConsumerState<RehberAdimEkrani> {
  final _sayfalar = PageController();
  int _adim = 0;
  bool _ezber = false;

  @override
  void dispose() {
    _sayfalar.dispose();
    super.dispose();
  }

  void _git(int adim) => _sayfalar.animateToPage(
    adim,
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeOut,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final toplam = widget.adimlar.length;
    final sonAdim = _adim == toplam - 1;
    // Çok adımlı namazlarda çubuklar daralır
    final bosluk = toplam > 12 ? 2.0 : 4.0;

    return Scaffold(
      backgroundColor: AbyadColors.zemin,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: AbyadColors.yuzey,
          border: Border(top: BorderSide(color: AbyadColors.kenarlik)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Opacity(
                  opacity: _adim == 0 ? 0.45 : 1,
                  child: AbyadDugme(
                    metin: l10n.onceki,
                    ikincil: true,
                    onTap: _adim == 0 ? null : () => _git(_adim - 1),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AbyadDugme(
                    metin: sonAdim ? l10n.bastanBasla : l10n.sonrakiAdim,
                    onTap: () => _git(sonAdim ? 0 : _adim + 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AbyadSpace.ekranKenar,
                16,
                AbyadSpace.ekranKenar,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SayfaBasligi(
                    baslik: widget.baslik,
                    altBaslik: widget.altBaslik,
                    sagda: [
                      KareIkonDugme(
                        ikon: _ezber ? 'eye_off' : 'eye',
                        etiket: _ezber ? l10n.ezberKapat : l10n.ezberAc,
                        onTap: () => setState(() => _ezber = !_ezber),
                        zemin: _ezber
                            ? AbyadColors.pirincZemin
                            : AbyadColors.yuzey,
                      ),
                    ],
                  ),
                  if (_ezber) ...[
                    const SizedBox(height: 6),
                    Text(l10n.ezberAcik, style: AbyadText.kucuk),
                  ],
                  const SizedBox(height: 12),
                  ExcludeSemantics(
                    child: Row(
                      children: [
                        for (var i = 0; i < toplam; i++) ...[
                          if (i > 0) SizedBox(width: bosluk),
                          Expanded(
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                color: i < _adim
                                    ? AbyadColors.zumrut
                                    : (i == _adim
                                          ? AbyadColors.pirincSus
                                          : AbyadColors.segmentZemin),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _sayfalar,
                itemCount: toplam,
                onPageChanged: (i) => setState(() => _adim = i),
                itemBuilder: (context, i) => ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AbyadSpace.ekranKenar,
                    0,
                    AbyadSpace.ekranKenar,
                    AbyadSpace.xxl,
                  ),
                  children: [
                    _AdimKarti(
                      sirali: widget.adimlar[i],
                      no: i + 1,
                      toplam: toplam,
                      ezber: _ezber,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bir adımda okunan tek metin (tesbih, dua ya da sure).
typedef _Okuma = ({
  String? baslik,
  String? arapca,
  String? okunus,
  String? anlam,
});

class _AdimKarti extends ConsumerWidget {
  const _AdimKarti({
    required this.sirali,
    required this.no,
    required this.toplam,
    required this.ezber,
  });

  final SiraliAdim sirali;
  final int no;
  final int toplam;
  final bool ezber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final adim = sirali.adim;
    final dualar = ref.watch(dualarProvider).valueOrNull;
    final kuran = ref.watch(kuranProvider).valueOrNull;
    final meal = ref.watch(mealKaynagiProvider);

    // Sure ve dua metni Dualar verisinden, ayet metni Tanzil'den gelir.
    _Okuma? duadan(String id, {bool ornek = false}) {
      final dua = dualar?.dualar.where((d) => d.id == id).firstOrNull;
      if (dua == null) return null;
      var arapca = dua.arapca;
      var anlam = dua.anlam;
      if (dua.ayetler != null && kuran != null) {
        final ayetler = kuran.aralik(dua.ayetler!);
        arapca = [
          for (final a in ayetler)
            '${kuran.ayetMetni(a.sure, a.ayet)} ${ayetIsareti(a.ayet)}',
        ].join(' ');
        final mealler = [
          for (final a in ayetler) meal.meal(a.sure, a.ayet),
        ].nonNulls;
        anlam = mealler.isEmpty ? null : mealler.join(' ');
      }
      return (
        baslik: ornek ? l10n.ornekSure(dua.ad) : dua.ad,
        arapca: arapca,
        okunus: dua.okunus,
        anlam: anlam,
      );
    }

    final okunus = sirali.okunus ?? adim.okunus;
    final okumalar = <_Okuma>[
      if (adim.arapca != null || okunus != null)
        (baslik: null, arapca: adim.arapca, okunus: okunus, anlam: adim.anlam),
      for (final id in adim.dualar) ?duadan(id),
      if (sirali.sure != null) ?duadan(sirali.sure!, ornek: true),
    ];

    final sesVar =
        adim.ses != null &&
        (ref.watch(rehberSesleriProvider).valueOrNull ?? const {}).contains(
          adim.ses,
        );
    final sesCal = ref.watch(rehberSesCalarProvider);

    return AbyadKart(
      yaricap: AbyadRadius.buyukKart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Cizim(adim: adim),
          const SizedBox(height: 14),
          Semantics(
            liveRegion: true,
            child: Text(
              sirali.rekat == null
                  ? l10n.adimNo(no, toplam)
                  : '${l10n.adimNo(no, toplam)} · '
                        '${l10n.rekatAdim(sirali.rekat!, adim.baslik)}',
              style: abyadStil(
                AbyadFonts.metin,
                12,
                700,
                color: AbyadColors.pirincYazi,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Semantics(
            header: true,
            child: Text(
              adim.baslik,
              style: abyadStil(AbyadFonts.metin, 22, 700),
            ),
          ),
          const SizedBox(height: 6),
          Text(adim.aciklama, style: AbyadText.govde),
          if (adim.tekrar > 1) ...[
            const SizedBox(height: 10),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AbyadColors.yesilZemin,
                  borderRadius: BorderRadius.circular(AbyadRadius.cip),
                ),
                child: Text(
                  l10n.tekrarSayisi(adim.tekrar),
                  style: abyadStil(
                    AbyadFonts.metin,
                    12,
                    700,
                    color: AbyadColors.zumrut,
                  ),
                ),
              ),
            ),
          ],
          for (final okuma in okumalar) ...[
            const SizedBox(height: 14),
            _OkumaKutusu(okuma: okuma, ezber: ezber),
          ],
          if (sesVar && sesCal != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: AbyadDugme(
                metin: l10n.okunusuDinle,
                ikon: 'play',
                onTap: () => sesCal('$rehberSesKlasoru/${adim.ses}'),
              ),
            ),
          ],
          if (adim.kadinNotu != null) ...[
            const SizedBox(height: 14),
            MergeSemantics(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AbyadColors.yesilZemin,
                  borderRadius: BorderRadius.circular(AbyadRadius.dugme),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AbyadIcon('info', renk: AbyadColors.zumrut, boyut: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.kadinlarIcin,
                            style: abyadStil(
                              AbyadFonts.metin,
                              12,
                              700,
                              color: AbyadColors.zumrut,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            adim.kadinNotu!,
                            style: AbyadText.kucuk.copyWith(
                              color: AbyadColors.metin,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Duruş çizimi; ekran okuyucuya duruşu tarif eder.
class _Cizim extends StatelessWidget {
  const _Cizim({required this.adim});
  final RehberAdimi adim;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final yerTutucu = ExcludeSemantics(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AbyadIcon('person', renk: AbyadColors.metinIkincil, boyut: 36),
          const SizedBox(height: 8),
          Text(
            l10n.cizimAlani(adim.baslik),
            textAlign: TextAlign.center,
            style: AbyadText.etiket,
          ),
        ],
      ),
    );
    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AbyadColors.cizimZemini,
        borderRadius: BorderRadius.circular(AbyadRadius.dugme),
        border: Border.all(color: AbyadColors.kenarlik),
      ),
      child: adim.cizim == null
          ? yerTutucu
          : SvgPicture.asset(
              '$rehberCizimKlasoru/${adim.cizim}',
              height: 150,
              semanticsLabel: adim.cizimTarifi,
              errorBuilder: (_, _, _) => yerTutucu,
            ),
    );
  }
}

class _OkumaKutusu extends StatefulWidget {
  const _OkumaKutusu({required this.okuma, required this.ezber});
  final _Okuma okuma;
  final bool ezber;

  @override
  State<_OkumaKutusu> createState() => _OkumaKutusuState();
}

class _OkumaKutusuState extends State<_OkumaKutusu> {
  bool _acildi = false;

  @override
  void didUpdateWidget(_OkumaKutusu eski) {
    super.didUpdateWidget(eski);
    if (eski.ezber != widget.ezber || eski.okuma != widget.okuma) {
      _acildi = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final okuma = widget.okuma;
    final gizli = widget.ezber && !_acildi;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AbyadColors.pirincAcik,
        borderRadius: BorderRadius.circular(AbyadRadius.dugme),
        border: Border.all(color: AbyadColors.pirincKenar),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (okuma.baslik != null)
            Text(
              okuma.baslik!,
              style: abyadStil(
                AbyadFonts.metin,
                12,
                700,
                color: AbyadColors.pirincYazi,
              ),
            ),
          if (gizli)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: AbyadDugme(
                metin: l10n.ezberGoster,
                ikon: 'eye',
                ikincil: true,
                onTap: () => setState(() => _acildi = true),
              ),
            )
          else ...[
            if (okuma.arapca != null)
              // Ekran okuyucu Arapça harfleri değil okunuşu okur
              ExcludeSemantics(
                child: ArapcaMetin(
                  okuma.arapca!,
                  boyut: 28,
                  satirYuksekligi: 1.8,
                ),
              ),
            if (okuma.okunus != null)
              Text(okuma.okunus!, style: AbyadText.kartBasligi),
          ],
          if (okuma.anlam != null) ...[
            const SizedBox(height: 4),
            Text(okuma.anlam!, style: AbyadText.kucuk.copyWith(fontSize: 14)),
          ],
        ],
      ),
    );
  }
}
