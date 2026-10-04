import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/abyad_colors.dart';
import '../theme/abyad_text.dart';
import '../theme/abyad_tokens.dart';
import 'abyad_icon.dart';
import 'sekiz_kose_yildiz.dart';

/// Alt sayfaların üstündeki satır: geri düğmesi, başlık ve isteğe bağlı
/// sağdaki öğeler.
class SayfaBasligi extends StatelessWidget {
  const SayfaBasligi({
    super.key,
    required this.baslik,
    this.altBaslik,
    this.geri = true,
    this.sagda = const [],
    this.buyuk = false,
  });

  final String baslik;
  final String? altBaslik;
  final bool geri;
  final List<Widget> sagda;

  /// Sekme ekranlarındaki 30 punto başlık
  final bool buyuk;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (geri && Navigator.of(context).canPop()) ...[
          KareIkonDugme(
            ikon: 'chevron_left',
            etiket: AppLocalizations.of(context).geri,
            onTap: () => Navigator.of(context).maybePop(),
            zemin: Colors.transparent,
            kenarlik: false,
          ),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  baslik,
                  style: abyadStil(
                    AbyadFonts.baslik,
                    buyuk ? 30 : 26,
                    600,
                    color: AbyadColors.zumrut,
                    height: 1.15,
                  ),
                ),
              ),
              if (altBaslik != null) ...[
                const SizedBox(height: 2),
                Text(altBaslik!, style: AbyadText.etiket),
              ],
            ],
          ),
        ),
        for (final w in sagda) ...[const SizedBox(width: 8), w],
      ],
    );
  }
}

/// 48x48 dokunma alanlı, köşeleri yuvarlatılmış ikon düğmesi.
class KareIkonDugme extends StatelessWidget {
  const KareIkonDugme({
    super.key,
    required this.ikon,
    required this.etiket,
    required this.onTap,
    this.zemin = AbyadColors.yuzey,
    this.renk = AbyadColors.zumrut,
    this.kenarlik = true,
    this.ikonBoyutu = 20,
  });

  final String ikon;
  final String etiket;
  final VoidCallback? onTap;
  final Color zemin;
  final Color renk;
  final bool kenarlik;
  final double ikonBoyutu;

  @override
  Widget build(BuildContext context) {
    final sekil = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AbyadRadius.dugme),
      side: kenarlik
          ? const BorderSide(color: AbyadColors.kenarlik)
          : BorderSide.none,
    );
    return Tooltip(
      message: etiket,
      excludeFromSemantics: true,
      child: Semantics(
        button: true,
        label: etiket,
        excludeSemantics: true,
        child: Material(
          color: zemin,
          shape: sekil,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: AbyadSize.minDokunma,
              height: AbyadSize.minDokunma,
              child: Center(
                child: AbyadIcon(ikon, renk: renk, boyut: ikonBoyutu),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tasarımdaki parçalı seçim (Sure / Cüz / Sayfa …).
class AbyadSegment<T> extends StatelessWidget {
  const AbyadSegment({
    super.key,
    required this.secenekler,
    required this.secili,
    required this.onSec,
  });

  final Map<T, String> secenekler;
  final T secili;
  final ValueChanged<T> onSec;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AbyadColors.segmentZemin,
        borderRadius: BorderRadius.circular(AbyadRadius.dugme),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final e in secenekler.entries)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: e.key == secili,
                  inMutuallyExclusiveGroup: true,
                  label: e.value,
                  excludeSemantics: true,
                  child: Material(
                    color: e.key == secili
                        ? AbyadColors.yuzey
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => onSec(e.key),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: AbyadSize.minDokunma,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 6,
                            ),
                            // Büyük yazıda etiket kelime ortasından
                            // bölünmek yerine sığacak kadar küçülür.
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                e.value,
                                maxLines: 1,
                                softWrap: false,
                                style: abyadStil(
                                  AbyadFonts.metin,
                                  13,
                                  e.key == secili ? 700 : 600,
                                  color: e.key == secili
                                      ? AbyadColors.zumrut
                                      : AbyadColors.metinIkincil,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Zümrüt zeminli, köşesinde süsleme olan vurgu kartı.
class KoyuKart extends StatelessWidget {
  const KoyuKart({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.padding = const EdgeInsets.all(AbyadSpace.xl),
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final sekil = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AbyadRadius.buyukKart),
    );
    Widget icerik = Stack(
      children: [
        const Positioned(
          right: -40,
          top: -50,
          child: Opacity(
            opacity: 0.3,
            child: SekizKoseYildiz(
              boyut: 170,
              renk: AbyadColors.pirinc,
              cizgiKalinligi: 1.2,
            ),
          ),
        ),
        Padding(padding: padding, child: child),
      ],
    );
    if (onTap != null) {
      icerik = InkWell(onTap: onTap, customBorder: sekil, child: icerik);
    }
    return Semantics(
      container: true,
      label: semanticLabel,
      button: onTap != null,
      excludeSemantics: semanticLabel != null,
      child: Material(
        color: AbyadColors.zumrut,
        shape: sekil,
        clipBehavior: Clip.antiAlias,
        child: icerik,
      ),
    );
  }
}

/// Bölüm başlığı ("Namaz", "Okunabilirlik" …)
class BolumBasligi extends StatelessWidget {
  const BolumBasligi(this.metin, {super.key});
  final String metin;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(metin, style: abyadStil(AbyadFonts.metin, 15, 700)),
  );
}

/// Başlık, açıklama ve anahtar. Satırın tamamı dokunulabilir.
class AnahtarSatiri extends StatelessWidget {
  const AnahtarSatiri({
    super.key,
    required this.baslik,
    required this.deger,
    required this.onDegis,
    this.aciklama,
  });

  final String baslik;
  final String? aciklama;
  final bool deger;
  final ValueChanged<bool> onDegis;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: InkWell(
        onTap: () => onDegis(!deger),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(baslik, style: abyadStil(AbyadFonts.metin, 15, 700)),
                    if (aciklama != null) ...[
                      const SizedBox(height: 3),
                      Text(aciklama!, style: AbyadText.kucuk),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                value: deger,
                onChanged: onDegis,
                activeTrackColor: AbyadColors.zumrut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sağında ok olan, dokununca başka ekrana giden satır.
class GezinmeSatiri extends StatelessWidget {
  const GezinmeSatiri({
    super.key,
    required this.baslik,
    required this.onTap,
    this.aciklama,
    this.deger,
    this.ikon,
  });

  final String baslik;
  final String? aciklama;

  /// Sağda gösterilen mevcut değer ("Diyanet", "Otomatik" …)
  final String? deger;
  final String? ikon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                if (ikon != null) ...[
                  AbyadIcon(ikon!, renk: AbyadColors.zumrut, boyut: 22),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(baslik, style: abyadStil(AbyadFonts.metin, 15, 700)),
                      if (aciklama != null) ...[
                        const SizedBox(height: 3),
                        Text(aciklama!, style: AbyadText.kucuk),
                      ],
                    ],
                  ),
                ),
                if (deger != null) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      deger!,
                      textAlign: TextAlign.end,
                      style: abyadStil(
                        AbyadFonts.metin,
                        14,
                        600,
                        color: AbyadColors.metinIkincil,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 4),
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
    );
  }
}

/// Dolu ana düğme (zümrüt) ve çerçeveli ikincil düğme.
class AbyadDugme extends StatelessWidget {
  const AbyadDugme({
    super.key,
    required this.metin,
    required this.onTap,
    this.ikincil = false,
    this.ikon,
    this.koyuZeminde = false,
  });

  final String metin;
  final VoidCallback? onTap;
  final bool ikincil;
  final String? ikon;

  /// Zümrüt kart üstünde pirinç renkli düğme
  final bool koyuZeminde;

  @override
  Widget build(BuildContext context) {
    final zemin = koyuZeminde
        ? AbyadColors.pirinc
        : (ikincil ? AbyadColors.yuzey : AbyadColors.zumrut);
    final renk = koyuZeminde || ikincil
        ? AbyadColors.zumrut
        : AbyadColors.yuzey;
    return Material(
      color: zemin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AbyadRadius.dugme),
        side: ikincil
            ? const BorderSide(color: AbyadColors.kenarlik)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AbyadSize.minDokunma),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (ikon != null) ...[
                  AbyadIcon(ikon!, renk: renk, boyut: 18),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    metin,
                    textAlign: TextAlign.center,
                    style: abyadStil(AbyadFonts.metin, 15, 700, color: renk),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// [aralik] süresinde bir yeniden kurulur ve o anki zamanı verir.
class ZamanIzleyici extends StatefulWidget {
  const ZamanIzleyici({
    super.key,
    required this.saat,
    required this.builder,
    this.aralik = const Duration(seconds: 15),
  });

  final DateTime Function() saat;
  final Duration aralik;
  final Widget Function(BuildContext context, DateTime simdi) builder;

  @override
  State<ZamanIzleyici> createState() => _ZamanIzleyiciState();
}

class _ZamanIzleyiciState extends State<ZamanIzleyici> {
  late Timer _zamanlayici;
  late DateTime _simdi = widget.saat();

  @override
  void initState() {
    super.initState();
    _zamanlayici = Timer.periodic(widget.aralik, (_) {
      setState(() => _simdi = widget.saat());
    });
  }

  @override
  void didUpdateWidget(ZamanIzleyici eski) {
    super.didUpdateWidget(eski);
    _simdi = widget.saat();
  }

  @override
  void dispose() {
    _zamanlayici.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _simdi);
}

/// Arapça metin: sağdan sola, Amiri, geniş satır aralığı.
class ArapcaMetin extends StatelessWidget {
  const ArapcaMetin(
    this.metin, {
    super.key,
    this.boyut = 27,
    this.renk = AbyadColors.zumrut,
    this.satirYuksekligi = 2.0,
    this.hizalama = TextAlign.right,
  });

  final String metin;
  final double boyut;
  final Color renk;
  final double satirYuksekligi;
  final TextAlign hizalama;

  @override
  Widget build(BuildContext context) => Text(
    metin,
    textDirection: TextDirection.rtl,
    textAlign: hizalama,
    locale: const Locale('ar'),
    style: abyadStil(
      AbyadFonts.arapca,
      boyut,
      400,
      color: renk,
      height: satirYuksekligi,
    ),
  );
}

/// Veri yüklenirken ve yükleme hatasında gösterilen sade durumlar.
class Yukleniyor extends StatelessWidget {
  const Yukleniyor({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(32),
      child: CircularProgressIndicator(color: AbyadColors.zumrut),
    ),
  );
}

class YuklemeHatasi extends StatelessWidget {
  const YuklemeHatasi({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        AppLocalizations.of(context).veriOkunamadi,
        style: AbyadText.govde,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

/// Alt sayfaların ortak iskeleti: zemin, güvenli alan ve kaydırma.
class AbyadSayfa extends StatelessWidget {
  const AbyadSayfa({
    super.key,
    required this.children,
    this.altCubuk,
    this.zemin = AbyadColors.zemin,
  });

  final List<Widget> children;
  final Widget? altCubuk;
  final Color zemin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: zemin,
      bottomNavigationBar: altCubuk,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AbyadSpace.ekranKenar,
            16,
            AbyadSpace.ekranKenar,
            AbyadSpace.xxl,
          ),
          children: children,
        ),
      ),
    );
  }
}
