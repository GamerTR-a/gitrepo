import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/widgets/abyad_icon.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';
import '../../ayarlar/data/ayarlar_saglayici.dart';
import '../../vakitler/data/vakit_saglayicilari.dart';
import '../../vakitler/ui/vakit_adlari.dart';
import '../domain/kible.dart';

/// Pusula okuması: telefonun üst kenarının baktığı yön (derece) ve
/// sensörün bildirdiği tahmini hata. Sensör yoksa akış `null` verir.
typedef PusulaOkumasi = ({double yon, double? hata});

final pusulaProvider = StreamProvider.autoDispose<PusulaOkumasi?>((ref) {
  final akis = FlutterCompass.events;
  if (akis == null) return Stream.value(null);
  return akis.map(
    (e) => e.heading == null ? null : (yon: e.heading!, hata: e.accuracy),
  );
});

/// Kıbleye bu kadar derece yaklaşınca "kıbleye döndünüz" sayılır.
const _hizaToleransi = 3.0;

/// Sensör hatası bundan büyükse kalibrasyon uyarısı gösterilir.
const _kalibrasyonEsigi = 25.0;

class KibleEkrani extends ConsumerStatefulWidget {
  const KibleEkrani({super.key});

  @override
  ConsumerState<KibleEkrani> createState() => _KibleEkraniState();
}

class _KibleEkraniState extends ConsumerState<KibleEkrani> {
  bool _hizada = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final konum = ref.watch(konumProvider);
    final titresim = ref.watch(ayarlarProvider.select((a) => a.kibleTitresim));
    final kible = kibleAcisi(konum.enlem, konum.boylam);
    final pusula = ref.watch(pusulaProvider);

    final okuma = pusula.valueOrNull;
    final fark = okuma == null ? null : aciFarki(kible, okuma.yon);
    final hizada = fark != null && fark.abs() <= _hizaToleransi;
    if (hizada != _hizada) {
      _hizada = hizada;
      if (hizada && titresim) HapticFeedback.mediumImpact();
    }
    final kalibrasyonGerek = (okuma?.hata ?? 0) > _kalibrasyonEsigi;

    return AbyadSayfa(
      children: [
        SayfaBasligi(baslik: l10n.kibleBaslik, altBaslik: konum.ad),
        const SizedBox(height: 20),
        if (pusula.isLoading)
          const Yukleniyor()
        else if (okuma == null)
          _Uyari(
            ikon: 'info',
            baslik: l10n.pusulaYokBaslik,
            metin: l10n.pusulaYokMetin(kible.round(), l10n.yonAdi(yon(kible))),
          )
        else ...[
          Semantics(
            container: true,
            liveRegion: true,
            label: hizada
                ? l10n.kibleHizada
                : (fark! > 0
                      ? l10n.kibleSagaDon(fark.abs().round())
                      : l10n.kibleSolaDon(fark.abs().round())),
            excludeSemantics: true,
            child: Column(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 320,
                      maxHeight: 320,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CustomPaint(
                        painter: _PusulaRessami(
                          telefonYonu: okuma.yon,
                          kible: kible,
                          hizada: hizada,
                          kuzeyHarfi: l10n.kuzeyKisaltma,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  hizada
                      ? l10n.kibleHizada
                      : (fark > 0
                            ? l10n.kibleSagaDon(fark.abs().round())
                            : l10n.kibleSolaDon(fark.abs().round())),
                  textAlign: TextAlign.center,
                  style: abyadStil(
                    AbyadFonts.metin,
                    18,
                    700,
                    color: hizada ? AbyadColors.zumrut : AbyadColors.metin,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.kibleDerece(kible.round(), l10n.yonAdi(yon(kible))),
            textAlign: TextAlign.center,
            style: AbyadText.kucuk,
          ),
          const SizedBox(height: 20),
          if (kalibrasyonGerek)
            _Uyari(
              ikon: 'reset',
              baslik: l10n.kalibrasyonBaslik,
              metin: l10n.kalibrasyonMetin,
              vurgulu: true,
            )
          else
            Text(
              l10n.pusulaIpucu,
              textAlign: TextAlign.center,
              style: AbyadText.kucuk,
            ),
        ],
        const SizedBox(height: 20),
        AbyadKart(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: AnahtarSatiri(
            baslik: l10n.kibleTitresim,
            aciklama: l10n.kibleTitresimAciklama,
            deger: titresim,
            onDegis: (v) => ref
                .read(ayarlarProvider.notifier)
                .guncelle((a) => a.copyWith(kibleTitresim: v)),
          ),
        ),
      ],
    );
  }
}

class _Uyari extends StatelessWidget {
  const _Uyari({
    required this.ikon,
    required this.baslik,
    required this.metin,
    this.vurgulu = false,
  });

  final String ikon;
  final String baslik;
  final String metin;
  final bool vurgulu;

  @override
  Widget build(BuildContext context) {
    return AbyadKart(
      renk: vurgulu ? AbyadColors.pirincAcik : AbyadColors.yuzey,
      kenarRengi: vurgulu ? AbyadColors.pirincKenar : AbyadColors.kenarlik,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AbyadIcon(ikon, renk: AbyadColors.pirincYazi),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(baslik, style: AbyadText.kartBasligi),
                const SizedBox(height: 4),
                Text(metin, style: AbyadText.govde),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kadran telefonla birlikte döner: "K" her zaman gerçek kuzeyi, pirinç
/// işaret Kâbe yönünü gösterir. Üstteki sabit çentik telefonun baktığı yöndür.
class _PusulaRessami extends CustomPainter {
  _PusulaRessami({
    required this.telefonYonu,
    required this.kible,
    required this.hizada,
    required this.kuzeyHarfi,
  });

  final double telefonYonu;
  final double kible;
  final bool hizada;
  final String kuzeyHarfi;

  @override
  void paint(Canvas canvas, Size size) {
    final merkez = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    double rad(double d) => d * math.pi / 180;

    canvas.drawCircle(merkez, r, Paint()..color = AbyadColors.yuzey);
    canvas.drawCircle(
      merkez,
      r - 1,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = hizada ? AbyadColors.zumrut : AbyadColors.kenarlik,
    );

    canvas.save();
    canvas.translate(merkez.dx, merkez.dy);
    canvas.rotate(rad(-telefonYonu));

    final cizgi = Paint()
      ..color = AbyadColors.metinPasif
      ..strokeCap = StrokeCap.round;
    for (var d = 0; d < 360; d += 15) {
      final ana = d % 90 == 0;
      cizgi.strokeWidth = ana ? 2.5 : 1.2;
      final ic = r * (ana ? 0.80 : 0.86);
      final yon = Offset(
        math.sin(rad(d.toDouble())),
        -math.cos(rad(d.toDouble())),
      );
      canvas.drawLine(yon * ic, yon * (r * 0.92), cizgi);
    }

    final harf = TextPainter(
      text: TextSpan(
        text: kuzeyHarfi,
        style: abyadStil(AbyadFonts.metin, r * 0.13, 800),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    harf.paint(canvas, Offset(-harf.width / 2, -r * 0.76));

    // Kıble işareti
    canvas.rotate(rad(kible));
    final ok = Path()
      ..moveTo(0, -r * 0.90)
      ..lineTo(r * 0.11, -r * 0.60)
      ..lineTo(0, -r * 0.66)
      ..lineTo(-r * 0.11, -r * 0.60)
      ..close();
    canvas.drawPath(
      ok,
      Paint()..color = hizada ? AbyadColors.zumrut : AbyadColors.pirincSus,
    );
    canvas.drawLine(
      Offset.zero,
      Offset(0, -r * 0.62),
      Paint()
        ..color = hizada ? AbyadColors.zumrut : AbyadColors.pirincSus
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();

    canvas.drawCircle(merkez, r * 0.05, Paint()..color = AbyadColors.zumrut);

    // Telefonun baktığı yön (sabit çentik)
    final centik = Path()
      ..moveTo(merkez.dx, merkez.dy - r + 2)
      ..lineTo(merkez.dx - r * 0.06, merkez.dy - r - r * 0.07)
      ..lineTo(merkez.dx + r * 0.06, merkez.dy - r - r * 0.07)
      ..close();
    canvas.drawPath(centik, Paint()..color = AbyadColors.zumrut);
  }

  @override
  bool shouldRepaint(_PusulaRessami eski) =>
      eski.telefonYonu != telefonYonu ||
      eski.kible != kible ||
      eski.hizada != hizada;
}
