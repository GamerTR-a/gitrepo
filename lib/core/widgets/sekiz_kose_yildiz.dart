import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// Tasarımdaki sekiz köşeli yıldız (rub'ul-hizb) süslemesi.
/// Paket gerektirmez, her boyutta keskin çizilir.
class SekizKoseYildiz extends StatelessWidget {
  const SekizKoseYildiz({
    super.key,
    required this.boyut,
    required this.renk,
    this.cizgiKalinligi = 1.2,
    this.halkalar = true,
  });

  final double boyut;
  final Color renk;
  final double cizgiKalinligi;

  /// İç ve dış daireleri de çiz
  final bool halkalar;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(boyut),
        painter: _YildizRessami(renk, cizgiKalinligi, halkalar),
      ),
    );
  }
}

class _YildizRessami extends CustomPainter {
  _YildizRessami(this.renk, this.kalinlik, this.halkalar);
  final Color renk;
  final double kalinlik;
  final bool halkalar;

  @override
  void paint(Canvas canvas, Size size) {
    final b = size.width;
    final merkez = Offset(b / 2, b / 2);
    final kalem = Paint()
      ..color = renk
      ..style = PaintingStyle.stroke
      ..strokeWidth = kalinlik;

    final kenar = b * 14 / 24;
    final kare = Rect.fromCenter(center: merkez, width: kenar, height: kenar);
    canvas.drawRect(kare, kalem);

    canvas.save();
    canvas.translate(merkez.dx, merkez.dy);
    canvas.rotate(math.pi / 4);
    canvas.translate(-merkez.dx, -merkez.dy);
    canvas.drawRect(kare, kalem);
    canvas.restore();

    if (halkalar) {
      canvas.drawCircle(merkez, b * 4.2 / 24, kalem);
      canvas.drawCircle(merkez, b * 9.9 / 24, kalem);
    }
  }

  @override
  bool shouldRepaint(_YildizRessami eski) =>
      eski.renk != renk ||
      eski.kalinlik != kalinlik ||
      eski.halkalar != halkalar;
}
