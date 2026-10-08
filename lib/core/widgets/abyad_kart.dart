import 'package:flutter/material.dart';
import '../theme/abyad_colors.dart';
import '../theme/abyad_tokens.dart';

/// Beyaz, ince kenarlıklı standart kart. onTap verilirse dokunulabilir olur.
class AbyadKart extends StatelessWidget {
  const AbyadKart({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AbyadSpace.l),
    this.renk,
    this.kenarRengi,
    this.yaricap = AbyadRadius.kart,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  /// Verilmezse kart yüzeyi ve standart kenarlık
  final Color? renk;
  final Color? kenarRengi;
  final double yaricap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final sekil = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(yaricap),
      side: BorderSide(color: kenarRengi ?? AbyadColors.kenarlik),
    );
    Widget icerik = Padding(padding: padding, child: child);
    if (onTap != null) {
      icerik = InkWell(onTap: onTap, customBorder: sekil, child: icerik);
    }
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      container: true,
      child: Material(
        color: renk ?? AbyadColors.yuzey,
        shape: sekil,
        clipBehavior: Clip.antiAlias,
        child: icerik,
      ),
    );
  }
}
