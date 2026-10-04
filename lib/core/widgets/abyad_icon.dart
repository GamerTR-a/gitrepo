import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// assets/icons/ altındaki çizgi ikonları istenen renge boyar.
/// Örnek: AbyadIcon('bell', renk: Colors.white)
class AbyadIcon extends StatelessWidget {
  const AbyadIcon(this.ad, {super.key, required this.renk, this.boyut = 24});

  final String ad;
  final Color renk;
  final double boyut;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$ad.svg',
      width: boyut,
      height: boyut,
      colorFilter: ColorFilter.mode(renk, BlendMode.srcIn),
      excludeFromSemantics: true, // anlamı çevreleyen düğmenin etiketi verir
    );
  }
}
