import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/widgets/abyad_icon.dart';
import '../../../core/widgets/ortak.dart';
import '../../../core/widgets/sekiz_kose_yildiz.dart';
import '../../ayarlar/data/ayarlar_saglayici.dart';
import '../../bildirim/data/bildirim_servisi.dart';
import '../../konum/data/konum_servisi.dart';
import '../../konum/ui/sehir_sec_ekrani.dart';

/// İlk açılış: (1) Abyad'ın vaadi, (2) konum, (3) bildirim izni.
/// Her adım atlanabilir; hiçbir izin zorunlu değildir.
class IlkAcilisEkrani extends ConsumerStatefulWidget {
  const IlkAcilisEkrani({super.key});

  @override
  ConsumerState<IlkAcilisEkrani> createState() => _IlkAcilisEkraniState();
}

class _IlkAcilisEkraniState extends ConsumerState<IlkAcilisEkrani> {
  int _adim = 0;
  bool _mesgul = false;
  String? _uyari;

  void _ileri() {
    if (_adim < 2) {
      setState(() {
        _adim++;
        _uyari = null;
      });
    } else {
      ref
          .read(ayarlarProvider.notifier)
          .guncelle((a) => a.copyWith(ilkAcilisTamam: true));
    }
  }

  Future<void> _konumumuKullan() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _mesgul = true);
    final sonuc = await ref.read(konumServisiProvider).bul();
    if (!mounted) return;
    setState(() => _mesgul = false);
    if (sonuc.konum != null) {
      await ref
          .read(ayarlarProvider.notifier)
          .guncelle((a) => a.copyWith(konum: sonuc.konum));
      _ileri();
    } else {
      setState(() => _uyari = l10n.ilkKonumAlinamadi);
    }
  }

  Future<void> _sehirSec() async {
    final onceki = ref.read(ayarlarProvider).konum;
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SehirSecEkrani()));
    if (mounted && ref.read(ayarlarProvider).konum != onceki) _ileri();
  }

  Future<void> _bildirimIzni() async {
    setState(() => _mesgul = true);
    try {
      final servis = ref.read(bildirimServisiProvider);
      await servis.izinIste();
      if (!await servis.tamZamanliMi()) await servis.tamZamanliIzniIste();
    } on Object catch (hata) {
      debugPrint('Bildirim izni istenemedi: $hata');
    }
    if (!mounted) return;
    setState(() => _mesgul = false);
    _ileri();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final android = defaultTargetPlatform == TargetPlatform.android;

    final (String ikon, String baslik, String metin) = switch (_adim) {
      0 => ('shield', l10n.ilkVaatBaslik, l10n.ilkVaatMetin),
      1 => ('pin', l10n.ilkKonumBaslik, l10n.ilkKonumMetin),
      _ => (
        'bell',
        l10n.ilkBildirimBaslik,
        android ? l10n.ilkBildirimMetinAndroid : l10n.ilkBildirimMetin,
      ),
    };

    return Scaffold(
      backgroundColor: AbyadColors.koyuZemin,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              right: -90,
              top: -70,
              child: Opacity(
                opacity: 0.3,
                child: SekizKoseYildiz(
                  boyut: 320,
                  renk: AbyadColors.pirinc,
                  cizgiKalinligi: 1.4,
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          label: l10n.ilkAdim(_adim + 1, 3),
                          excludeSemantics: true,
                          child: Row(
                            children: [
                              for (var i = 0; i < 3; i++) ...[
                                if (i > 0) const SizedBox(width: 6),
                                Container(
                                  width: i == _adim ? 28 : 10,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: i == _adim
                                        ? AbyadColors.pirinc
                                        : AbyadColors.koyuUstuKenar,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AbyadColors.koyuUstuSecili,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: AbyadIcon(
                            ikon,
                            renk: AbyadColors.pirinc,
                            boyut: 30,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Semantics(
                          header: true,
                          child: Text(
                            baslik,
                            style: abyadStil(
                              AbyadFonts.baslik,
                              32,
                              600,
                              color: AbyadColors.koyuUstu,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          metin,
                          style: abyadStil(
                            AbyadFonts.metin,
                            16,
                            400,
                            color: AbyadColors.koyuUstuIkincil,
                            height: 1.6,
                          ),
                        ),
                        if (_uyari != null) ...[
                          const SizedBox(height: 14),
                          Semantics(
                            liveRegion: true,
                            child: Text(
                              _uyari!,
                              style: abyadStil(
                                AbyadFonts.metin,
                                14,
                                600,
                                color: AbyadColors.pirinc,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_adim == 0)
                        AbyadDugme(
                          metin: l10n.devam,
                          koyuZeminde: true,
                          onTap: _ileri,
                        ),
                      if (_adim == 1) ...[
                        AbyadDugme(
                          metin: _mesgul
                              ? l10n.konumAraniyor
                              : l10n.konumumuKullan,
                          ikon: 'pin',
                          koyuZeminde: true,
                          onTap: _mesgul ? null : _konumumuKullan,
                        ),
                        const SizedBox(height: 10),
                        AbyadDugme(
                          metin: l10n.sehrimiSecerim,
                          ikincil: true,
                          onTap: _mesgul ? null : _sehirSec,
                        ),
                      ],
                      if (_adim == 2)
                        AbyadDugme(
                          metin: l10n.bildirimIzniVer,
                          ikon: 'bell',
                          koyuZeminde: true,
                          onTap: _mesgul ? null : _bildirimIzni,
                        ),
                      if (_adim > 0)
                        TextButton(
                          onPressed: _mesgul ? null : _ileri,
                          style: TextButton.styleFrom(
                            minimumSize: const Size(48, 48),
                            foregroundColor: AbyadColors.koyuUstu,
                          ),
                          child: Text(
                            _adim == 1 ? l10n.simdilikAtla : l10n.atla,
                            style: abyadStil(
                              AbyadFonts.metin,
                              15,
                              600,
                              color: AbyadColors.koyuUstu,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
