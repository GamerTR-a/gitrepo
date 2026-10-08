import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_tokens.dart';

/// Arka planda sırayla gösterilen manzaralar
/// (assets/zikir_arkaplan/AD.webp, tool/manzara_uret.py ile hazırlanır).
const zikirManzaralari = [
  'kabe',
  'medine',
  'kudus',
  'ayasofya',
  'selimiye',
  'istanbul',
  'bursa',
  'divrigi',
  'diyarbakir',
  'sam',
  'kahire',
  'kayrevan',
  'semerkant',
  'buhara',
  'isfahan',
  'halep',
];

/// Değişme aralığı seçenekleri (saniye)
const zikirManzaraSureleri = [15, 30, 60, 300];

/// Zikirmatik sayacının arkasında duran manzara görseli. Verilen alanı
/// doldurur ve [saniye] aralığıyla bir sonrakine yumuşakça geçer. Yalnızca
/// süstür: dokunmaları almaz, ekran okuyucuya görünmez.
class ZikirArkaPlani extends StatefulWidget {
  const ZikirArkaPlani({super.key, required this.saniye});
  final int saniye;

  @override
  State<ZikirArkaPlani> createState() => _ZikirArkaPlaniState();
}

class _ZikirArkaPlaniState extends State<ZikirArkaPlani> {
  int _sira = 0;
  late Timer _zamanlayici;

  @override
  void initState() {
    super.initState();
    _kur();
  }

  @override
  void didUpdateWidget(ZikirArkaPlani eski) {
    super.didUpdateWidget(eski);
    if (eski.saniye != widget.saniye) {
      _zamanlayici.cancel();
      _kur();
    }
  }

  void _kur() => _zamanlayici = Timer.periodic(
    Duration(seconds: widget.saniye),
    (_) => setState(() => _sira = (_sira + 1) % zikirManzaralari.length),
  );

  @override
  void dispose() {
    _zamanlayici.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = zikirManzaralari[_sira];
    return IgnorePointer(
      child: ExcludeSemantics(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AbyadRadius.buyukKart),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(color: AbyadColors.yesilZemin),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1200),
                    layoutBuilder: (simdiki, oncekiler) => Stack(
                      fit: StackFit.expand,
                      children: [...oncekiler, ?simdiki],
                    ),
                    child: Image.asset(
                      'assets/zikir_arkaplan/$ad.webp',
                      key: ValueKey(ad),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                  // Koyu temada görsel göz almasın
                  if (AbyadColors.palet.koyu)
                    const ColoredBox(color: Color(0x66000000)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
