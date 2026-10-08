import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icerik/icerik.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_icon.dart';
import '../../../core/widgets/ortak.dart';
import '../../ayarlar/data/ayarlar_saglayici.dart';
import '../data/konum_servisi.dart';
import '../domain/konum.dart';

/// İnternetsiz şehir arama ve "konumumu kullan".
class SehirSecEkrani extends ConsumerStatefulWidget {
  const SehirSecEkrani({super.key});

  @override
  ConsumerState<SehirSecEkrani> createState() => _SehirSecEkraniState();
}

class _SehirSecEkraniState extends ConsumerState<SehirSecEkrani> {
  String _sorgu = '';
  bool _araniyor = false;
  KonumHatasi? _hata;

  Future<void> _sec(Konum konum) async {
    await ref
        .read(ayarlarProvider.notifier)
        .guncelle((a) => a.copyWith(konum: konum));
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _konumumuKullan() async {
    setState(() {
      _araniyor = true;
      _hata = null;
    });
    final sonuc = await ref.read(konumServisiProvider).bul();
    if (!mounted) return;
    if (sonuc.konum != null) {
      await _sec(sonuc.konum!);
    } else {
      setState(() {
        _araniyor = false;
        _hata = sonuc.hata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sehirler = ref.watch(sehirlerProvider);
    final secili = ref.watch(ayarlarProvider.select((a) => a.konum));

    return Scaffold(
      backgroundColor: AbyadColors.zemin,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SayfaBasligi(baslik: l10n.konumSec),
                  const SizedBox(height: 16),
                  AramaKutusu(
                    ipucu: l10n.sehirAraIpucu,
                    onDegis: (s) => setState(() => _sorgu = s),
                  ),
                  const SizedBox(height: 12),
                  AbyadDugme(
                    metin: _araniyor ? l10n.konumAraniyor : l10n.konumumuKullan,
                    ikon: 'pin',
                    ikincil: true,
                    onTap: _araniyor ? null : _konumumuKullan,
                  ),
                  if (_hata != null) ...[
                    const SizedBox(height: 8),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        switch (_hata!) {
                          KonumHatasi.servisKapali => l10n.konumServisKapali,
                          KonumHatasi.izinYok => l10n.konumIzinYok,
                          KonumHatasi.izinKaliciRed => l10n.konumIzinKalici,
                          KonumHatasi.bulunamadi => l10n.konumBulunamadi,
                        },
                        style: abyadStil(
                          AbyadFonts.metin,
                          13,
                          600,
                          color: AbyadColors.pirincYazi,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(l10n.konumMahremiyet, style: AbyadText.etiket),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: sehirler.when(
                loading: () => const Yukleniyor(),
                error: (_, _) => const YuklemeHatasi(),
                data: (liste) {
                  final sonuc = sehirAra(liste, _sorgu, azami: 200);
                  if (sonuc.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        l10n.sehirBulunamadi,
                        textAlign: TextAlign.center,
                        style: AbyadText.govde,
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: sonuc.length,
                    itemBuilder: (context, i) {
                      final k = sonuc[i];
                      final alt = [
                        k.ust,
                        k.ulke,
                      ].where((s) => s.isNotEmpty).join(' · ');
                      final seciliMi =
                          !secili.otomatik &&
                          k.ad == secili.ad &&
                          k.ust == secili.ust;
                      return Semantics(
                        button: true,
                        selected: seciliMi,
                        child: InkWell(
                          onTap: () => _sec(k),
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 56),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AbyadColors.ayrac),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        k.ad,
                                        style: abyadStil(
                                          AbyadFonts.metin,
                                          16,
                                          700,
                                        ),
                                      ),
                                      if (alt.isNotEmpty)
                                        Text(alt, style: AbyadText.kucuk),
                                    ],
                                  ),
                                ),
                                if (seciliMi)
                                  AbyadIcon('check', renk: AbyadColors.zumrut),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Arama alanı (Kur'an, şehir ve Esmâ ekranlarında ortak)
class AramaKutusu extends StatelessWidget {
  const AramaKutusu({super.key, required this.ipucu, required this.onDegis});

  final String ipucu;
  final ValueChanged<String> onDegis;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder kenar(Color renk) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AbyadRadius.ikonKutu),
      borderSide: BorderSide(color: renk),
    );
    return TextField(
      onChanged: onDegis,
      textInputAction: TextInputAction.search,
      style: abyadStil(AbyadFonts.metin, 15, 500),
      decoration: InputDecoration(
        hintText: ipucu,
        hintStyle: abyadStil(
          AbyadFonts.metin,
          15,
          400,
          color: AbyadColors.metinIkincil,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 14, right: 8),
          child: AbyadIcon('search', renk: AbyadColors.metinIkincil, boyut: 20),
        ),
        prefixIconConstraints: const BoxConstraints(minHeight: 48),
        filled: true,
        fillColor: AbyadColors.yuzey,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: kenar(AbyadColors.kenarlik),
        focusedBorder: kenar(AbyadColors.zumrut),
      ),
    );
  }
}
