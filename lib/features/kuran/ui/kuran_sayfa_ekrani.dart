import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/storage/veritabani.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/ortak.dart';
import '../../ayarlar/data/ayarlar_saglayici.dart';
import '../data/kuran_deposu.dart';
import 'kuran_liste_ekrani.dart' show yerImleriProvider;
import 'kuran_oku_ekrani.dart';

/// Kur'an'ı ayarlardaki görünümle açar: sayfa sayfa ya da ayet ayet.
void kuranAc(
  BuildContext context,
  WidgetRef ref, {
  required int sure,
  int ayet = 1,
  bool yerineKoy = false,
}) {
  final sayfaGorunumu = ref.read(ayarlarProvider).kuranSayfaGorunumu;
  final rota = MaterialPageRoute<void>(
    builder: (_) => sayfaGorunumu
        ? KuranSayfaEkrani(sure: sure, ayet: ayet)
        : KuranOkuEkrani(sure: sure, ayet: ayet),
  );
  if (yerineKoy) {
    Navigator.of(context).pushReplacement(rota);
  } else {
    Navigator.of(context).push(rota);
  }
}

/// Mushaf düzeninde, sayfa sayfa çevirerek okuma (604 sayfa).
///
/// Sayfaların içeriği Tanzil sayfa verisine göredir; satırlar serbest
/// akar, basılı Mushaf'ın satır sonlarıyla birebir aynı değildir.
class KuranSayfaEkrani extends ConsumerStatefulWidget {
  const KuranSayfaEkrani({super.key, required this.sure, this.ayet = 1});

  /// Açılışta gösterilecek sayfa, bu ayetin bulunduğu sayfadır.
  final int sure;
  final int ayet;

  @override
  ConsumerState<KuranSayfaEkrani> createState() => _KuranSayfaEkraniState();
}

class _KuranSayfaEkraniState extends ConsumerState<KuranSayfaEkrani> {
  PageController? _denetleyici;
  int? _sayfa;

  @override
  void dispose() {
    _denetleyici?.dispose();
    super.dispose();
  }

  void _sayfaDegisti(KuranVerisi veri, int sayfa) {
    setState(() => _sayfa = sayfa);
    final ilk = veri.sayfalar[sayfa - 1];
    ref.read(veritabaniProvider).okumaDurumunuKaydet(ilk.sure, ilk.ayet);
  }

  void _git(int sayfa) {
    _denetleyici?.animateToPage(
      sayfa.clamp(1, toplamSayfa) - 1,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _sayfayaGit() async {
    final l10n = AppLocalizations.of(context);
    final giris = TextEditingController();
    final sayfa = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sayfayaGit),
        content: TextField(
          controller: giris,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: l10n.sayfaNoIpucu),
          onSubmitted: (v) => Navigator.of(context).pop(int.tryParse(v)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.vazgec),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(int.tryParse(giris.text)),
            child: Text(l10n.tamam),
          ),
        ],
      ),
    );
    if (sayfa != null && sayfa >= 1 && sayfa <= toplamSayfa) {
      _denetleyici?.jumpToPage(sayfa - 1);
    }
  }

  void _ayetGorunumuneGec(KuranVerisi veri) {
    final ilk = veri.sayfalar[_sayfa! - 1];
    ref
        .read(ayarlarProvider.notifier)
        .guncelle((a) => a.copyWith(kuranSayfaGorunumu: false));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => KuranOkuEkrani(sure: ilk.sure, ayet: ilk.ayet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kuran = ref.watch(kuranProvider);

    return Scaffold(
      backgroundColor: AbyadColors.okumaZemini,
      body: SafeArea(
        child: kuran.when(
          loading: () => const Yukleniyor(),
          error: (_, _) => const YuklemeHatasi(),
          data: (veri) {
            if (_denetleyici == null) {
              final sure = widget.sure.clamp(1, veri.sureler.length);
              final ayet = widget.ayet.clamp(1, veri.sure(sure).ayetSayisi);
              final sayfa = veri.sayfaNo(sure, ayet);
              _sayfa = sayfa;
              _denetleyici = PageController(initialPage: sayfa - 1);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                ref.read(veritabaniProvider).okumaDurumunuKaydet(sure, ayet);
              });
            }
            final sayfa = _sayfa!;
            final ilk = veri.sayfalar[sayfa - 1];

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: SayfaBasligi(
                    baslik: l10n.sureAdi(veri.sure(ilk.sure).ad),
                    altBaslik: l10n.cuzNo(veri.cuzNo(ilk.sure, ilk.ayet)),
                    sagda: [
                      KareIkonDugme(
                        ikon: 'rows',
                        etiket: l10n.ayetGorunumu,
                        onTap: () => _ayetGorunumuneGec(veri),
                        zemin: Colors.transparent,
                        kenarlik: false,
                      ),
                      YaziBoyutuDugmesi(
                        onTap: () => kuranGorunumAyari(context),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: AbyadColors.kenarlik),
                Expanded(
                  // Mushaf sağdan sola çevrilir: sonraki sayfa soldadır.
                  child: PageView.builder(
                    controller: _denetleyici,
                    reverse: true,
                    itemCount: toplamSayfa,
                    onPageChanged: (i) => _sayfaDegisti(veri, i + 1),
                    itemBuilder: (context, i) =>
                        _MushafSayfasi(veri: veri, sayfa: i + 1),
                  ),
                ),
                Divider(height: 1, color: AbyadColors.kenarlik),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      // Kaydırmaya ek olarak düğmeyle de çevrilebilir
                      KareIkonDugme(
                        ikon: 'chevron_left',
                        etiket: l10n.sonrakiSayfa,
                        onTap: sayfa < toplamSayfa
                            ? () => _git(sayfa + 1)
                            : null,
                        zemin: Colors.transparent,
                        kenarlik: false,
                      ),
                      Expanded(
                        child: Semantics(
                          button: true,
                          hint: l10n.sayfayaGit,
                          child: InkWell(
                            onTap: _sayfayaGit,
                            borderRadius: BorderRadius.circular(
                              AbyadRadius.cip,
                            ),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: AbyadSize.minDokunma,
                              ),
                              child: Center(
                                child: Text(
                                  l10n.sayfaSayisi(sayfa, toplamSayfa),
                                  textAlign: TextAlign.center,
                                  style: abyadStil(
                                    AbyadFonts.metin,
                                    14,
                                    700,
                                    color: AbyadColors.zumrut,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      KareIkonDugme(
                        ikon: 'chevron_right',
                        etiket: l10n.oncekiSayfa,
                        onTap: sayfa > 1 ? () => _git(sayfa - 1) : null,
                        zemin: Colors.transparent,
                        kenarlik: false,
                      ),
                    ],
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

/// Tek bir Mushaf sayfası: sure başlıkları, besmele ve akan ayet metni.
/// Bir ayete dokununca meali ve yer imi seçenekleri açılır.
class _MushafSayfasi extends ConsumerStatefulWidget {
  const _MushafSayfasi({required this.veri, required this.sayfa});

  final KuranVerisi veri;
  final int sayfa;

  @override
  ConsumerState<_MushafSayfasi> createState() => _MushafSayfasiState();
}

class _MushafSayfasiState extends ConsumerState<_MushafSayfasi> {
  final _dokunuslar = <TapGestureRecognizer>[];

  void _temizle() {
    for (final d in _dokunuslar) {
      d.dispose();
    }
    _dokunuslar.clear();
  }

  @override
  void dispose() {
    _temizle();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final veri = widget.veri;
    final olcek = ref.watch(ayarlarProvider.select((a) => a.kuranYaziOlcegi));
    final imler = {
      for (final im
          in ref.watch(yerImleriProvider).valueOrNull ??
              const <YerImleriData>[])
        (sure: im.sure, ayet: im.ayet),
    };
    _temizle();

    final metinStili = abyadStil(
      AbyadFonts.arapca,
      25 * olcek,
      400,
      color: AbyadColors.zumrut,
      height: 2.05,
    );

    // Sayfayı sure sınırlarından bölümlere ayır: her bölüm tek bir akan metin
    final bolumler = <Widget>[];
    var parcalar = <InlineSpan>[];
    void bolumuKapat() {
      if (parcalar.isEmpty) return;
      bolumler.add(
        Text.rich(
          TextSpan(children: parcalar),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.justify,
          locale: const Locale('ar'),
          style: metinStili,
        ),
      );
      parcalar = <InlineSpan>[];
    }

    for (final a in veri.sayfaAyetleri(widget.sayfa)) {
      if (a.ayet == 1) {
        bolumuKapat();
        bolumler.add(_SureBasligi(sure: veri.sure(a.sure)));
        if (veri.besmeleBasligi(a.sure)) {
          bolumler.add(
            ArapcaMetin(
              veri.besmele,
              boyut: 24 * olcek,
              hizalama: TextAlign.center,
            ),
          );
        }
      }
      final dokunus = TapGestureRecognizer()..onTap = () => _ayetSecenekleri(a);
      _dokunuslar.add(dokunus);
      parcalar
        ..add(
          TextSpan(
            text: veri.ayetMetni(a.sure, a.ayet),
            recognizer: dokunus,
            style: imler.contains(a)
                ? TextStyle(backgroundColor: AbyadColors.pirincZemin)
                : null,
          ),
        )
        ..add(
          TextSpan(
            text: ' ${ayetIsareti(a.ayet)} ',
            recognizer: dokunus,
            style: TextStyle(color: AbyadColors.pirincYazi),
          ),
        );
    }
    bolumuKapat();

    // Yazı büyüdüğünde sayfa kendi içinde aşağı kayar
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: bolumler,
      ),
    );
  }

  void _ayetSecenekleri(AyetKonumu a) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AbyadColors.yuzey,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => _AyetSayfasi(veri: widget.veri, konum: a),
    );
  }
}

/// Dokunulan ayetin alt sayfası: Arapça metin, meal ve yer imi.
class _AyetSayfasi extends ConsumerWidget {
  const _AyetSayfasi({required this.veri, required this.konum});

  final KuranVerisi veri;
  final AyetKonumu konum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final meal = ref.watch(mealKaynagiProvider);
    final metin = meal.meal(konum.sure, konum.ayet);
    final imli = (ref.watch(yerImleriProvider).valueOrNull ?? const []).any(
      (im) => im.sure == konum.sure && im.ayet == konum.ayet,
    );

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(
                  l10n.sureAyetUzun(veri.sure(konum.sure).ad, konum.ayet),
                  style: AbyadText.kartBasligi,
                ),
              ),
              const SizedBox(height: 8),
              ArapcaMetin(
                '${veri.ayetMetni(konum.sure, konum.ayet)} '
                '${ayetIsareti(konum.ayet)}',
                boyut: 25,
              ),
              const SizedBox(height: 12),
              if (metin != null) ...[
                Text(metin, style: AbyadText.govde),
                const SizedBox(height: 6),
                Text(meal.ad ?? '', style: AbyadText.etiket),
              ] else
                const MealYerTutucu(),
              const SizedBox(height: 16),
              AbyadDugme(
                metin: imli ? l10n.yerImiKaldirKisa : l10n.yerImiEkleKisa,
                ikon: 'bookmark',
                ikincil: true,
                onTap: () => ref
                    .read(veritabaniProvider)
                    .yerImiDegistir(konum.sure, konum.ayet),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SureBasligi extends StatelessWidget {
  const _SureBasligi({required this.sure});
  final Sure sure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      header: true,
      label: l10n.sureAdi(sure.ad),
      excludeSemantics: true,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AbyadColors.pirincAcik,
          borderRadius: BorderRadius.circular(AbyadRadius.dugme),
          border: Border.all(color: AbyadColors.pirincKenar),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l10n.sureAdi(sure.ad),
                style: abyadStil(
                  AbyadFonts.metin,
                  13,
                  700,
                  color: AbyadColors.pirincYazi,
                ),
              ),
            ),
            ArapcaMetin(sure.arapca, boyut: 22, satirYuksekligi: 1.5),
          ],
        ),
      ),
    );
  }
}
