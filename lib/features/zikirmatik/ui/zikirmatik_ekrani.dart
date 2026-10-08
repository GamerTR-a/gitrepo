import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/icerik/icerik.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/storage/veritabani.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';
import '../../ayarlar/data/ayarlar_saglayici.dart';
import '../../vakitler/data/vakit_saglayicilari.dart';
import 'zikir_arka_plani.dart';

const _gunlukAnahtar = 'zikir';

final _bugunkuZikirProvider = StreamProvider.autoDispose<int>((ref) {
  final gun = gunAnahtari(ref.watch(saatProvider)());
  return ref.watch(veritabaniProvider).gunlukSayaciIzle(gun, _gunlukAnahtar);
});

/// Ekranı açık tutma. Testlerde eklentiye gitmemesi için ezilir.
final ekranAcikTutProvider = Provider<void Function(bool)>(
  (ref) =>
      (acik) => WakelockPlus.toggle(enable: acik),
);

/// Sayaç mantığı: hedefe ulaşınca tur artar, sayaç sıfırlanır.
/// Hedef 0 ise serbest sayım (tur yok).
class ZikirSayaci {
  const ZikirSayaci({this.sayi = 0, this.tur = 0, this.hedef = 33});
  final int sayi;
  final int tur;
  final int hedef;

  /// Bir artırır; tur tamamlandıysa ikinci değer `true`.
  (ZikirSayaci, bool) artir() {
    if (hedef > 0 && sayi + 1 >= hedef) {
      return (ZikirSayaci(tur: tur + 1, hedef: hedef), true);
    }
    return (ZikirSayaci(sayi: sayi + 1, tur: tur, hedef: hedef), false);
  }

  ZikirSayaci sifirla() => ZikirSayaci(hedef: hedef);
  ZikirSayaci hedefle(int yeni) => ZikirSayaci(hedef: yeni);

  double get oran => hedef > 0 ? sayi / hedef : 0;
}

/// Tasarım: docs/tasarim/08_zikirmatik
class ZikirmatikEkrani extends ConsumerStatefulWidget {
  const ZikirmatikEkrani({super.key, this.ozel});

  /// Esmâ-ül Hüsnâ gibi başka bir ekrandan gelen, listede olmayan zikir
  final Zikir? ozel;

  @override
  ConsumerState<ZikirmatikEkrani> createState() => _ZikirmatikEkraniState();
}

class _ZikirmatikEkraniState extends ConsumerState<ZikirmatikEkrani> {
  String? _seciliId;
  var _sayac = const ZikirSayaci();
  late final void Function(bool) _ekranAcikTut;

  @override
  void initState() {
    super.initState();
    _seciliId = widget.ozel?.id;
    _ekranAcikTut = ref.read(ekranAcikTutProvider);
    if (ref.read(ayarlarProvider).zikirEkranAcik) _ekranAcikTut(true);
  }

  @override
  void dispose() {
    _ekranAcikTut(false);
    super.dispose();
  }

  void _say() {
    final ayarlar = ref.read(ayarlarProvider);
    final (yeni, turBitti) = _sayac.artir();
    setState(() => _sayac = yeni);
    if (ayarlar.zikirTitresim) {
      turBitti ? HapticFeedback.heavyImpact() : HapticFeedback.lightImpact();
    }
    ref
        .read(veritabaniProvider)
        .gunlukSayaciArtir(
          gunAnahtari(ref.read(saatProvider)()),
          _gunlukAnahtar,
          1,
        );
  }

  Future<void> _ozelZikirGir() async {
    final l10n = AppLocalizations.of(context);
    final denetleyici = TextEditingController(
      text: ref.read(ayarlarProvider).ozelZikir,
    );
    final metin = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.ozelZikir),
        content: TextField(
          controller: denetleyici,
          autofocus: true,
          maxLength: 60,
          decoration: InputDecoration(hintText: l10n.ozelZikirIpucu),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.vazgec),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(denetleyici.text.trim()),
            child: Text(l10n.tamam),
          ),
        ],
      ),
    );
    if (metin == null || metin.isEmpty) return;
    await ref
        .read(ayarlarProvider.notifier)
        .guncelle((a) => a.copyWith(ozelZikir: metin));
    setState(() {
      _seciliId = _ozelId;
      _sayac = _sayac.sifirla();
    });
  }

  static const _ozelId = '_ozel';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hazir = ref.watch(zikirlerProvider).valueOrNull;
    final ayarlar = ref.watch(ayarlarProvider);
    final toplam = ref.watch(_bugunkuZikirProvider).valueOrNull ?? 0;
    if (hazir == null) {
      return Scaffold(backgroundColor: AbyadColors.zemin, body: Yukleniyor());
    }

    final zikirler = [
      ?widget.ozel,
      ...hazir,
      if (ayarlar.ozelZikir.isNotEmpty)
        Zikir(_ozelId, ayarlar.ozelZikir, '', ''),
    ];
    final secili = zikirler.firstWhere(
      (z) => z.id == _seciliId,
      orElse: () => zikirler.first,
    );

    final manzara = ayarlar.zikirArkaPlan;

    final govde = ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        SayfaBasligi(
          baslik: l10n.zikirmatik,
          sagda: [
            KareIkonDugme(
              ikon: 'reset',
              etiket: l10n.sayaciSifirla,
              onTap: () => setState(() => _sayac = _sayac.sifirla()),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: math.max(48, MediaQuery.textScalerOf(context).scale(14) + 30),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final z in zikirler) ...[
                _Cip(
                  metin: z.ad,
                  secili: z.id == secili.id,
                  onTap: () => setState(() {
                    _seciliId = z.id;
                    _sayac = _sayac.sifirla();
                  }),
                ),
                const SizedBox(width: 8),
              ],
              _Cip(
                metin: l10n.ozelZikirEkle,
                secili: false,
                onTap: _ozelZikirGir,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (secili.arapca.isNotEmpty)
          ArapcaMetin(
            secili.arapca,
            boyut: 34,
            satirYuksekligi: 1.7,
            hizalama: TextAlign.center,
          )
        else
          Text(
            secili.ad,
            textAlign: TextAlign.center,
            style: abyadStil(
              AbyadFonts.baslik,
              26,
              600,
              color: AbyadColors.zumrut,
            ),
          ),
        if (secili.anlam.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            secili.anlam,
            textAlign: TextAlign.center,
            style: AbyadText.kucuk.copyWith(fontSize: 14),
          ),
        ],
        const SizedBox(height: 20),
        // Manzara, sayacı çerçeveleyen bir kart gibi arkasında durur;
        // sayaç hafif saydamlaşır ki görsel içinden de seçilsin.
        Stack(
          alignment: Alignment.center,
          children: [
            if (manzara)
              Positioned.fill(
                child: ZikirArkaPlani(saniye: ayarlar.zikirArkaPlanSaniye),
              ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: manzara ? 20 : 0),
              child: Center(
                child: _SayacDugmesi(
                  sayac: _sayac,
                  etiket: l10n.zikirSayOkuma(secili.ad, _sayac.sayi),
                  saydam: manzara,
                  onTap: _say,
                ),
              ),
            ),
          ],
        ),
        if (_sayac.tur > 0) ...[
          const SizedBox(height: 12),
          Semantics(
            liveRegion: true,
            child: Text(
              l10n.turTamamlandi(_sayac.tur),
              textAlign: TextAlign.center,
              style: abyadStil(
                AbyadFonts.metin,
                13,
                700,
                color: AbyadColors.pirincYazi,
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        BolumBasligi(l10n.hedef),
        const SizedBox(height: 8),
        AbyadSegment<int>(
          secenekler: {33: '33', 99: '99', 100: '100', 0: l10n.hedefSerbest},
          secili: _sayac.hedef,
          onSec: (h) => setState(() => _sayac = _sayac.hedefle(h)),
        ),
        const SizedBox(height: 14),
        AbyadKart(
          semanticLabel: l10n.bugunkuToplamOkuma(toplam),
          child: ExcludeSemantics(
            child: Row(
              children: [
                Expanded(
                  child: Text(l10n.bugunkuToplam, style: AbyadText.govde),
                ),
                Text('$toplam', style: abyadStil(AbyadFonts.metin, 16, 800)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        AbyadKart(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnahtarSatiri(
                baslik: l10n.zikirTitresim,
                deger: ayarlar.zikirTitresim,
                onDegis: (v) => ref
                    .read(ayarlarProvider.notifier)
                    .guncelle((a) => a.copyWith(zikirTitresim: v)),
              ),
              Divider(height: 1, color: AbyadColors.ayrac),
              AnahtarSatiri(
                baslik: l10n.zikirTumEkran,
                aciklama: l10n.zikirTumEkranAciklama,
                deger: ayarlar.zikirTumEkran,
                onDegis: (v) => ref
                    .read(ayarlarProvider.notifier)
                    .guncelle((a) => a.copyWith(zikirTumEkran: v)),
              ),
              Divider(height: 1, color: AbyadColors.ayrac),
              AnahtarSatiri(
                baslik: l10n.zikirEkranAcik,
                deger: ayarlar.zikirEkranAcik,
                onDegis: (v) {
                  _ekranAcikTut(v);
                  ref
                      .read(ayarlarProvider.notifier)
                      .guncelle((a) => a.copyWith(zikirEkranAcik: v));
                },
              ),
              Divider(height: 1, color: AbyadColors.ayrac),
              AnahtarSatiri(
                baslik: l10n.zikirArkaPlan,
                aciklama: l10n.zikirArkaPlanAciklama,
                deger: manzara,
                onDegis: (v) => ref
                    .read(ayarlarProvider.notifier)
                    .guncelle((a) => a.copyWith(zikirArkaPlan: v)),
              ),
              if (manzara) ...[
                Text(
                  l10n.zikirArkaPlanSure,
                  style: abyadStil(AbyadFonts.metin, 13, 700),
                ),
                const SizedBox(height: 8),
                AbyadSegment<int>(
                  secenekler: {
                    for (final sn in zikirManzaraSureleri)
                      sn: sn < 60
                          ? l10n.saniyeKisa(sn)
                          : l10n.dakikaKisa(sn ~/ 60),
                  },
                  secili:
                      zikirManzaraSureleri.contains(ayarlar.zikirArkaPlanSaniye)
                      ? ayarlar.zikirArkaPlanSaniye
                      : 30,
                  onSec: (sn) => ref
                      .read(ayarlarProvider.notifier)
                      .guncelle((a) => a.copyWith(zikirArkaPlanSaniye: sn)),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: AbyadColors.zemin,
      body: SafeArea(
        bottom: false,
        // "Her yere dokunarak say": düğme ve anahtarların dışındaki boş
        // alanlara dokunmak da sayar.
        child: ayarlar.zikirTumEkran
            ? GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _say,
                excludeFromSemantics: true,
                child: govde,
              )
            : govde,
      ),
    );
  }
}

class _Cip extends StatelessWidget {
  const _Cip({required this.metin, required this.secili, required this.onTap});
  final String metin;
  final bool secili;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: secili,
      label: metin,
      excludeSemantics: true,
      child: Material(
        color: secili ? AbyadColors.zumrut : AbyadColors.yuzey,
        shape: StadiumBorder(
          side: BorderSide(
            color: secili ? AbyadColors.zumrut : AbyadColors.kenarlik,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AbyadSize.minDokunma),
            child: Center(
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  metin,
                  maxLines: 1,
                  style: abyadStil(
                    AbyadFonts.metin,
                    14,
                    secili ? 700 : 600,
                    color: secili ? AbyadColors.yuzey : AbyadColors.metin,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SayacDugmesi extends StatelessWidget {
  const _SayacDugmesi({
    required this.sayac,
    required this.etiket,
    required this.onTap,
    this.saydam = false,
  });

  final ZikirSayaci sayac;
  final String etiket;
  final VoidCallback onTap;

  /// Arkadaki manzara görünsün diye zemin hafif saydam
  final bool saydam;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      label: etiket,
      liveRegion: true,
      excludeSemantics: true,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280, maxHeight: 280),
        child: AspectRatio(
          aspectRatio: 1,
          child: Material(
            color: AbyadColors.yuzey.withValues(alpha: saydam ? 0.86 : 1),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: CustomPaint(
                painter: _HalkaRessami(sayac.oran),
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${sayac.sayi}',
                          style: abyadStil(
                            AbyadFonts.baslik,
                            72,
                            500,
                            color: AbyadColors.zumrut,
                            height: 1,
                          ),
                        ),
                        if (sayac.hedef > 0)
                          Text(
                            '/ ${sayac.hedef}',
                            style: abyadStil(
                              AbyadFonts.metin,
                              14,
                              700,
                              color: AbyadColors.metinIkincil,
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.dokunVeSay,
                          style: abyadStil(
                            AbyadFonts.metin,
                            13,
                            700,
                            color: AbyadColors.pirincYazi,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HalkaRessami extends CustomPainter {
  _HalkaRessami(this.oran);
  final double oran;

  @override
  void paint(Canvas canvas, Size size) {
    final merkez = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 16;
    final kalem = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..color = AbyadColors.yesilZemin;
    canvas.drawCircle(merkez, r, kalem);
    if (oran > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: merkez, radius: r),
        -math.pi / 2,
        2 * math.pi * oran,
        false,
        kalem..color = AbyadColors.zumrut,
      );
    }
  }

  @override
  bool shouldRepaint(_HalkaRessami eski) => eski.oran != oran;
}
