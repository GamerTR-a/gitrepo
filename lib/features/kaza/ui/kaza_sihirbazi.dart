import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icerik/icerik.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/storage/veritabani.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';
import '../domain/kaza.dart';

/// Kaza borcu hesaplama sihirbazı. Varsayımlar [KazaHesabi] içinde
/// belgelenmiştir; sonuç tahmindir ve kullanıcı sayaçları elle düzeltebilir.
class KazaSihirbazi extends ConsumerStatefulWidget {
  const KazaSihirbazi({super.key});

  @override
  ConsumerState<KazaSihirbazi> createState() => _KazaSihirbaziState();
}

class _KazaSihirbaziState extends ConsumerState<KazaSihirbazi> {
  int _yil = 0;
  int _ay = 0;
  int _orucYil = 0;
  int _ozurGun = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hesap = KazaHesabi(
      namazKilinmayanYil: _yil,
      namazKilinmayanAy: _ay,
      orucTutulmayanYil: _orucYil,
      ozurluGunAylik: _ozurGun,
    );
    final sonuc = hesap.sonuc;

    return AbyadSayfa(
      children: [
        SayfaBasligi(baslik: l10n.kazaHesaplama),
        const SizedBox(height: 10),
        Text(l10n.kazaHesaplamaGiris, style: AbyadText.govde),
        const SizedBox(height: 16),
        AbyadKart(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          yaricap: AbyadRadius.buyukKart,
          child: Column(
            children: [
              _Adimlayici(
                baslik: l10n.sihirbazNamazYil,
                aciklama: l10n.sihirbazNamazYilAciklama,
                deger: _yil,
                azami: 80,
                onDegis: (v) => setState(() => _yil = v),
              ),
              Divider(height: 1, color: AbyadColors.ayrac),
              _Adimlayici(
                baslik: l10n.sihirbazNamazAy,
                deger: _ay,
                azami: 11,
                onDegis: (v) => setState(() => _ay = v),
              ),
              Divider(height: 1, color: AbyadColors.ayrac),
              _Adimlayici(
                baslik: l10n.sihirbazOzurGun,
                aciklama: l10n.sihirbazOzurGunAciklama,
                deger: _ozurGun,
                azami: 10,
                onDegis: (v) => setState(() => _ozurGun = v),
              ),
              Divider(height: 1, color: AbyadColors.ayrac),
              _Adimlayici(
                baslik: l10n.sihirbazOrucYil,
                aciklama: l10n.sihirbazOrucYilAciklama,
                deger: _orucYil,
                azami: 80,
                onDegis: (v) => setState(() => _orucYil = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AbyadKart(
          renk: AbyadColors.pirincAcik,
          kenarRengi: AbyadColors.pirincKenar,
          yaricap: AbyadRadius.buyukKart,
          child: Semantics(
            liveRegion: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.sihirbazSonuc, style: AbyadText.kartBasligi),
                const SizedBox(height: 8),
                Text(
                  l10n.sihirbazSonucNamaz(sonuc[KazaTuru.sabah]!),
                  style: AbyadText.govde,
                ),
                Text(
                  l10n.sihirbazSonucOruc(sonuc[KazaTuru.oruc]!),
                  style: AbyadText.govde,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        AbyadDugme(metin: l10n.sihirbazUygula, onTap: () => _uygula(sonuc)),
        const SizedBox(height: 20),
        BolumBasligi(l10n.kisaFikihBilgisi),
        const SizedBox(height: 8),
        for (final madde
            in ref.watch(kazaBilgileriProvider).valueOrNull ?? const <String>[])
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('•  ', style: AbyadText.govde),
                Expanded(child: Text(madde, style: AbyadText.govde)),
              ],
            ),
          ),
        const SizedBox(height: 6),
        Text(l10n.fikihNot, style: AbyadText.etiket),
      ],
    );
  }

  Future<void> _uygula(Map<KazaTuru, int> sonuc) async {
    final l10n = AppLocalizations.of(context);
    final onay = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sihirbazOnayBaslik),
        content: Text(l10n.sihirbazOnayMetin),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.vazgec),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.tamam),
          ),
        ],
      ),
    );
    if (onay != true) return;
    final vt = ref.read(veritabaniProvider);
    for (final e in sonuc.entries) {
      await vt.kazaAyarla(e.key.name, e.value);
    }
    if (mounted) Navigator.of(context).pop();
  }
}

class _Adimlayici extends StatelessWidget {
  const _Adimlayici({
    required this.baslik,
    required this.deger,
    required this.azami,
    required this.onDegis,
    this.aciklama,
  });

  final String baslik;
  final String? aciklama;
  final int deger;
  final int azami;
  final ValueChanged<int> onDegis;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(baslik, style: abyadStil(AbyadFonts.metin, 15, 700)),
          if (aciklama != null) ...[
            const SizedBox(height: 3),
            Text(aciklama!, style: AbyadText.kucuk),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              KareIkonDugme(
                ikon: 'minus',
                etiket: l10n.azalt(baslik),
                onTap: deger > 0 ? () => onDegis(deger - 1) : null,
              ),
              Expanded(
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    '$deger',
                    textAlign: TextAlign.center,
                    style: abyadStil(
                      AbyadFonts.baslik,
                      24,
                      600,
                      color: AbyadColors.zumrut,
                    ),
                  ),
                ),
              ),
              KareIkonDugme(
                ikon: 'plus',
                etiket: l10n.artir(baslik),
                onTap: deger < azami ? () => onDegis(deger + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
