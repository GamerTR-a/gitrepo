import 'dart:math' as math;

/// Kâbe'nin koordinatları
const kabeEnlem = 21.4225;
const kabeBoylam = 39.8262;

/// Verilen konumdan Kâbe'ye büyük daire yönü: gerçek kuzeyden saat
/// yönünde derece (0–360).
double kibleAcisi(double enlem, double boylam) {
  double rad(double d) => d * math.pi / 180;
  final f1 = rad(enlem);
  final f2 = rad(kabeEnlem);
  final dl = rad(kabeBoylam - boylam);
  final y = math.sin(dl);
  final x = math.cos(f1) * math.tan(f2) - math.sin(f1) * math.cos(dl);
  final aci = math.atan2(y, x) * 180 / math.pi;
  return (aci + 360) % 360;
}

/// Sekiz ana/ara yön
enum Yon {
  kuzey,
  kuzeydogu,
  dogu,
  guneydogu,
  guney,
  guneybati,
  bati,
  kuzeybati,
}

Yon yon(double aci) => Yon.values[((aci % 360) / 45).round() % 8];

/// İki yön arasındaki en kısa fark (−180…180); pozitif: saat yönünde.
double aciFarki(double hedef, double mevcut) {
  final fark = (hedef - mevcut) % 360;
  return fark > 180 ? fark - 360 : fark;
}
