import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/ayarlar_deposu.dart';
import '../../vakitler/data/vakit_saglayicilari.dart';
import '../domain/hatim.dart';

const _hatimlerAnahtari = 'hatim.liste';
const _katilimciAnahtari = 'hatim.katilimci';

final _rastgeleProvider = Provider<Random>((ref) => Random.secure());

/// Bu cihazın rastgele katılımcı anahtarı; ilk kullanımda üretilir ve
/// yalnızca cihazda durur.
final katilimciAnahtariProvider = Provider<String>((ref) {
  final depo = ref.watch(ayarlarDeposuProvider);
  final kayitli = depo.metinOku(_katilimciAnahtari);
  if (kayitli != null) return kayitli;
  final yeni = katilimciAnahtariUret(ref.watch(_rastgeleProvider));
  depo.metinYaz(_katilimciAnahtari, yeni);
  return yeni;
});

final hatimlerProvider = NotifierProvider<HatimlerNotifier, List<Hatim>>(
  HatimlerNotifier.new,
);

/// Hatimler şimdilik yalnızca cihazda tutulur: sunucu kararı
/// (docs/surum3_kararlar.md) verilmeden hiçbir veri cihazdan çıkmaz.
/// Paylaşım eklendiğinde bu sınıfın işlemleri sunucuya bağlanır.
class HatimlerNotifier extends Notifier<List<Hatim>> {
  AyarlarDeposu get _depo => ref.read(ayarlarDeposuProvider);
  DateTime get _simdi => ref.read(saatProvider)();
  String get _ben => ref.read(katilimciAnahtariProvider);

  @override
  List<Hatim> build() {
    final ham = ref.watch(ayarlarDeposuProvider).metinOku(_hatimlerAnahtari);
    if (ham == null) return const [];
    return [
      for (final h in (jsonDecode(ham) as List).cast<Map<String, dynamic>>())
        Hatim.fromJson(h),
    ];
  }

  void _kaydet(List<Hatim> hatimler) {
    state = hatimler;
    _depo.metinYaz(
      _hatimlerAnahtari,
      jsonEncode([for (final h in hatimler) h.toJson()]),
    );
  }

  Hatim olustur({
    required String baslik,
    required BolmeSekli bolmeSekli,
    String? not,
    DateTime? hedefTarih,
  }) {
    final hatim = Hatim.yeni(
      kod: hatimKoduUret(ref.read(_rastgeleProvider)),
      baslik: baslik.trim(),
      not: (not == null || not.trim().isEmpty) ? null : not.trim(),
      bolmeSekli: bolmeSekli,
      hedefTarih: hedefTarih,
      simdi: _simdi,
    );
    _kaydet([hatim, ...state]);
    return hatim;
  }

  void sil(String kod) => _kaydet([
    for (final h in state)
      if (h.kod != kod) h,
  ]);

  PaySonucu _uygula(String kod, (Hatim, PaySonucu) Function(Hatim) islem) {
    final hatim = state.where((h) => h.kod == kod).firstOrNull;
    if (hatim == null) return PaySonucu.gecersiz;
    final (yeni, sonuc) = islem(hatim);
    if (sonuc == PaySonucu.tamam) {
      _kaydet([for (final h in state) h.kod == kod ? yeni : h]);
    }
    return sonuc;
  }

  PaySonucu payAl(String kod, int no) =>
      _uygula(kod, (h) => h.payAl(no, _ben, _simdi));
  PaySonucu payBirak(String kod, int no) =>
      _uygula(kod, (h) => h.payBirak(no, _ben, _simdi));
  PaySonucu okundu(String kod, int no) =>
      _uygula(kod, (h) => h.okundu(no, _ben, _simdi));
  PaySonucu okunmadi(String kod, int no) =>
      _uygula(kod, (h) => h.okunmadi(no, _ben, _simdi));
}
