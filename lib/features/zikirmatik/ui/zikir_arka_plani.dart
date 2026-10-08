import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/abyad_colors.dart';

/// Arka planda sırayla gösterilen manzaralar
/// (assets/zikir_arkaplan/, tool/manzara_uret.py ile üretilir).
const zikirManzaralari = [
  'kabe',
  'medine',
  'kudus',
  'mekke',
  'selimiye',
  'ayasofya',
  'ulucami',
];

/// Değişme aralığı seçenekleri (saniye)
const zikirManzaraSureleri = [15, 30, 60, 300];

/// Zikirmatik sayacının arkasında duran silik manzara çizimi.
/// [saniye] aralığıyla bir sonrakine yumuşakça geçer. Yalnızca süstür:
/// dokunmaları almaz, ekran okuyucuya görünmez.
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
        child: Opacity(
          opacity: AbyadColors.palet.koyu ? 0.3 : 0.22,
          // Çizimlerin oranı 400x240
          child: AspectRatio(
            aspectRatio: 400 / 240,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1200),
              child: SvgPicture.asset(
                'assets/zikir_arkaplan/$ad.svg',
                key: ValueKey(ad),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                  AbyadColors.zumrut,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
