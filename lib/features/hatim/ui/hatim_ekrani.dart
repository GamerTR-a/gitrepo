import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/tarih/tarih_metni.dart';
import '../../../core/theme/abyad_colors.dart';
import '../../../core/theme/abyad_text.dart';
import '../../../core/theme/abyad_tokens.dart';
import '../../../core/widgets/abyad_kart.dart';
import '../../../core/widgets/ortak.dart';
import '../../kuran/data/kuran_deposu.dart';
import '../../kuran/ui/kuran_sayfa_ekrani.dart' show kuranAc;
import '../../vakitler/data/vakit_saglayicilari.dart';
import '../data/hatim_saglayici.dart';
import '../domain/hatim.dart';

String _payAdi(AppLocalizations l10n, Hatim hatim, Pay pay) =>
    hatim.bolmeSekli == BolmeSekli.cuz
    ? l10n.hatimCuzAdi(pay.no)
    : l10n.hatimSayfaAdi(pay.baslangic, pay.bitis);

String _ilerleme(AppLocalizations l10n, Hatim hatim) =>
    hatim.bolmeSekli == BolmeSekli.cuz
    ? l10n.hatimIlerlemeCuz(hatim.okunan, hatim.paylar.length)
    : l10n.hatimIlerlemePay(hatim.okunan, hatim.paylar.length);

/// Hatimlerin listesi. Tasarım: docs/tasarim/12_toplu_hatim
///
/// Linkle paylaşım sunucu kararını bekliyor (docs/surum3_kararlar.md);
/// o zamana kadar hatim yalnızca bu cihazda tutulur.
class HatimEkrani extends ConsumerWidget {
  const HatimEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hatimler = ref.watch(hatimlerProvider);
    void yeni() => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const HatimOlusturEkrani()));

    return AbyadSayfa(
      children: [
        SayfaBasligi(
          baslik: l10n.hatimBaslik,
          sagda: [
            KareIkonDugme(ikon: 'plus', etiket: l10n.hatimYeni, onTap: yeni),
          ],
        ),
        const SizedBox(height: 16),
        if (hatimler.isEmpty)
          AbyadKart(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.hatimBosBaslik, style: AbyadText.kartBasligi),
                const SizedBox(height: 6),
                Text(l10n.hatimBosMetin, style: AbyadText.govde),
                const SizedBox(height: 14),
                AbyadDugme(metin: l10n.hatimBaslat, onTap: yeni),
              ],
            ),
          ),
        for (final hatim in hatimler) ...[
          _HatimOzeti(
            hatim: hatim,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => HatimDetayEkrani(kod: hatim.kod),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 6),
        AbyadKart(
          renk: AbyadColors.pirincAcik,
          kenarRengi: AbyadColors.pirincKenar,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.hatimYerelNotBaslik, style: AbyadText.kartBasligi),
              const SizedBox(height: 6),
              Text(l10n.hatimYerelNot, style: AbyadText.kucuk),
            ],
          ),
        ),
      ],
    );
  }
}

/// Zümrüt kart: hatmin adı, ilerlemesi ve hedef tarihi.
class _HatimOzeti extends StatelessWidget {
  const _HatimOzeti({required this.hatim, this.onTap});
  final Hatim hatim;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final durum = hatim.tamamlandi ? l10n.hatimTamamlandi : l10n.hatimDevamEden;
    final ilerleme = _ilerleme(l10n, hatim);
    final hedef = hatim.hedefTarih == null
        ? null
        : l10n.hatimHedef(miladiGunAyYil(context, hatim.hedefTarih!));
    return KoyuKart(
      onTap: onTap,
      semanticLabel: [
        durum,
        hatim.baslik,
        ?hatim.not,
        ilerleme,
        ?hedef,
      ].join(', '),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            durum,
            style: abyadStil(
              AbyadFonts.metin,
              12,
              700,
              color: AbyadColors.pirinc,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hatim.baslik,
            style: abyadStil(
              AbyadFonts.baslik,
              22,
              600,
              color: AbyadColors.koyuUstu,
              height: 1.2,
            ),
          ),
          if (hatim.not != null) ...[
            const SizedBox(height: 4),
            Text(
              hatim.not!,
              style: abyadStil(
                AbyadFonts.metin,
                13,
                400,
                color: AbyadColors.koyuUstuIkincil,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: hatim.oran,
              minHeight: 8,
              backgroundColor: AbyadColors.koyuUstuSecili,
              color: AbyadColors.pirinc,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            [ilerleme, ?hedef].join(' · '),
            style: abyadStil(
              AbyadFonts.metin,
              13,
              600,
              color: AbyadColors.koyuUstuIkincil,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Yeni hatim
// ---------------------------------------------------------------------------
class HatimOlusturEkrani extends ConsumerStatefulWidget {
  const HatimOlusturEkrani({super.key});

  @override
  ConsumerState<HatimOlusturEkrani> createState() => _HatimOlusturState();
}

class _HatimOlusturState extends ConsumerState<HatimOlusturEkrani> {
  final _baslik = TextEditingController();
  final _not = TextEditingController();
  BolmeSekli _bolme = BolmeSekli.cuz;
  DateTime? _hedef;
  bool _denendi = false;

  @override
  void dispose() {
    _baslik.dispose();
    _not.dispose();
    super.dispose();
  }

  String? _hataMetni(AppLocalizations l10n, MetinHatasi? hata, int sinir) =>
      switch (hata) {
        null => null,
        MetinHatasi.bos => l10n.hataBos,
        MetinHatasi.uzun => l10n.hataUzun(sinir),
        MetinHatasi.link => l10n.hataLink,
      };

  Future<void> _tarihSec() async {
    final bugun = ref.read(saatProvider)();
    final secilen = await showDatePicker(
      context: context,
      initialDate: _hedef ?? bugun.add(const Duration(days: 30)),
      firstDate: bugun,
      lastDate: DateTime(bugun.year + 3, bugun.month, bugun.day),
    );
    if (secilen != null) setState(() => _hedef = secilen);
  }

  void _olustur(MetinHatasi? baslikHatasi, MetinHatasi? notHatasi) {
    if (baslikHatasi != null || notHatasi != null) {
      setState(() => _denendi = true);
      return;
    }
    final hatim = ref
        .read(hatimlerProvider.notifier)
        .olustur(
          baslik: _baslik.text,
          not: _not.text,
          bolmeSekli: _bolme,
          hedefTarih: _hedef,
        );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => HatimDetayEkrani(kod: hatim.kod)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final baslikHatasi = hatimMetniDenetle(
      _baslik.text,
      sinir: hatimBaslikSiniri,
      zorunlu: true,
    );
    final notHatasi = hatimMetniDenetle(_not.text, sinir: hatimNotSiniri);

    return AbyadSayfa(
      children: [
        SayfaBasligi(baslik: l10n.hatimYeni),
        const SizedBox(height: 16),
        _MetinAlani(
          denetleyici: _baslik,
          etiket: l10n.hatimAdi,
          ipucu: l10n.hatimAdiIpucu,
          hata: _denendi || baslikHatasi != MetinHatasi.bos
              ? _hataMetni(l10n, baslikHatasi, hatimBaslikSiniri)
              : null,
          onDegis: () => setState(() {}),
        ),
        const SizedBox(height: 14),
        _MetinAlani(
          denetleyici: _not,
          etiket: l10n.hatimNotu,
          ipucu: l10n.hatimNotuIpucu,
          hata: _hataMetni(l10n, notHatasi, hatimNotSiniri),
          onDegis: () => setState(() {}),
        ),
        const SizedBox(height: 18),
        BolumBasligi(l10n.hatimBolme),
        const SizedBox(height: 8),
        AbyadSegment<BolmeSekli>(
          secenekler: {
            BolmeSekli.cuz: l10n.hatimCuzCuz,
            BolmeSekli.sayfa: l10n.hatimSayfaSayfa,
          },
          secili: _bolme,
          onSec: (b) => setState(() => _bolme = b),
        ),
        const SizedBox(height: 6),
        Text(
          _bolme == BolmeSekli.cuz
              ? l10n.hatimBolmeCuzAciklama(hatimCuzSayisi)
              : l10n.hatimBolmeSayfaAciklama(
                  (hatimSayfaSayisi / sayfaPayBoyu).ceil(),
                  sayfaPayBoyu,
                ),
          style: AbyadText.kucuk,
        ),
        const SizedBox(height: 14),
        AbyadKart(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GezinmeSatiri(
                ikon: 'calendar',
                baslik: l10n.hatimHedefTarih,
                deger: _hedef == null
                    ? l10n.hatimHedefYok
                    : miladiGunAyYil(context, _hedef!),
                onTap: _tarihSec,
              ),
              if (_hedef != null)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () => setState(() => _hedef = null),
                    child: Text(l10n.hatimHedefKaldir),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        AbyadDugme(
          metin: l10n.hatimBaslat,
          onTap: () => _olustur(baslikHatasi, notHatasi),
        ),
      ],
    );
  }
}

class _MetinAlani extends StatelessWidget {
  const _MetinAlani({
    required this.denetleyici,
    required this.etiket,
    required this.ipucu,
    required this.hata,
    required this.onDegis,
  });

  final TextEditingController denetleyici;
  final String etiket;
  final String ipucu;
  final String? hata;
  final VoidCallback onDegis;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder kenar(Color renk) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AbyadRadius.ikonKutu),
      borderSide: BorderSide(color: renk),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BolumBasligi(etiket),
        const SizedBox(height: 8),
        TextField(
          controller: denetleyici,
          onChanged: (_) => onDegis(),
          minLines: 1,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          style: abyadStil(AbyadFonts.metin, 15, 500),
          decoration: InputDecoration(
            hintText: ipucu,
            hintStyle: abyadStil(
              AbyadFonts.metin,
              15,
              400,
              color: AbyadColors.metinIkincil,
            ),
            hintMaxLines: 2,
            errorText: hata,
            errorMaxLines: 3,
            filled: true,
            fillColor: AbyadColors.yuzey,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: kenar(AbyadColors.kenarlik),
            focusedBorder: kenar(AbyadColors.zumrut),
            errorBorder: kenar(Theme.of(context).colorScheme.error),
            focusedErrorBorder: kenar(Theme.of(context).colorScheme.error),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Hatim: pay ızgarası
// ---------------------------------------------------------------------------
class HatimDetayEkrani extends ConsumerStatefulWidget {
  const HatimDetayEkrani({super.key, required this.kod});
  final String kod;

  @override
  ConsumerState<HatimDetayEkrani> createState() => _HatimDetayState();
}

class _HatimDetayState extends ConsumerState<HatimDetayEkrani> {
  int? _secili;

  HatimlerNotifier get _hatimler => ref.read(hatimlerProvider.notifier);

  void _dokun(Hatim hatim, Pay pay, String ben) {
    final l10n = AppLocalizations.of(context);
    if (pay.durum == PayDurumu.bos) {
      final sonuc = _hatimler.payAl(hatim.kod, pay.no);
      if (sonuc == PaySonucu.tamam) {
        setState(() => _secili = pay.no);
        return;
      }
    } else if (pay.katilimci == ben) {
      setState(() => _secili = pay.no);
      return;
    }
    // Pay bir başkasında: yanlış "aldım" hissi oluşmasın
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.hatimAlinmis)));
  }

  Future<void> _oku(Hatim hatim, Pay pay) async {
    final kuran = await ref.read(kuranProvider.future);
    if (!mounted) return;
    final konum = hatim.bolmeSekli == BolmeSekli.cuz
        ? kuran.cuzler[pay.baslangic - 1]
        : kuran.sayfalar[pay.baslangic - 1];
    kuranAc(context, ref, sure: konum.sure, ayet: konum.ayet);
  }

  Future<void> _sil(Hatim hatim) async {
    final l10n = AppLocalizations.of(context);
    final onay = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.hatimSil),
        content: Text(l10n.hatimSilOnay),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.vazgec),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.hatimSil),
          ),
        ],
      ),
    );
    if (onay != true || !mounted) return;
    Navigator.of(context).pop();
    _hatimler.sil(hatim.kod);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hatim = ref
        .watch(hatimlerProvider)
        .where((h) => h.kod == widget.kod)
        .firstOrNull;
    if (hatim == null) {
      // Silindikten sonra ekran kapanırken
      return Scaffold(backgroundColor: AbyadColors.zemin);
    }
    final ben = ref.watch(katilimciAnahtariProvider);
    final cuz = hatim.bolmeSekli == BolmeSekli.cuz;
    final secili = _secili == null ? null : hatim.pay(_secili!);

    return AbyadSayfa(
      children: [
        SayfaBasligi(
          baslik: l10n.hatimBaslik,
          sagda: [
            KareIkonDugme(
              ikon: 'close',
              etiket: l10n.hatimSil,
              onTap: () => _sil(hatim),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _HatimOzeti(hatim: hatim),
        if (hatim.tamamlandi) ...[
          const SizedBox(height: 12),
          AbyadKart(
            renk: AbyadColors.pirincAcik,
            kenarRengi: AbyadColors.pirincKenar,
            child: Semantics(
              liveRegion: true,
              child: Text(l10n.hatimTamamMetin, style: AbyadText.govde),
            ),
          ),
        ],
        const SizedBox(height: 12),
        AbyadKart(
          yaricap: AbyadRadius.buyukKart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(
                  cuz ? l10n.hatimCuzSec : l10n.hatimSayfaSec,
                  style: AbyadText.kartBasligi,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                cuz ? l10n.hatimCuzSecAciklama : l10n.hatimSayfaSecAciklama,
                style: AbyadText.kucuk,
              ),
              const SizedBox(height: 14),
              _PayIzgarasi(
                hatim: hatim,
                ben: ben,
                secili: _secili,
                onDokun: (pay) => _dokun(hatim, pay, ben),
              ),
              const SizedBox(height: 14),
              ExcludeSemantics(
                child: Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: [
                    for (final (durum, ad) in [
                      (_Gorunum.okundu, l10n.durumOkundu),
                      (_Gorunum.alindi, l10n.durumAlindi),
                      (_Gorunum.senin, l10n.durumSenin),
                      (_Gorunum.bos, l10n.durumBos),
                    ])
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: durum.zemin,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: durum.kenar),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(ad, style: AbyadText.etiket),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (secili != null && secili.katilimci == ben) ...[
          const SizedBox(height: 12),
          AbyadKart(
            renk: AbyadColors.pirincAcik,
            kenarRengi: AbyadColors.pirincKenar,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  secili.durum == PayDurumu.okundu
                      ? l10n.durumOkundu
                      : l10n.seninPayin,
                  style: abyadStil(
                    AbyadFonts.metin,
                    12,
                    700,
                    color: AbyadColors.pirincYazi,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _payAdi(l10n, hatim, secili),
                  style: abyadStil(AbyadFonts.metin, 18, 700),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AbyadDugme(
                      metin: l10n.okumayaBasla,
                      onTap: () => _oku(hatim, secili),
                    ),
                    if (secili.durum == PayDurumu.alindi) ...[
                      AbyadDugme(
                        metin: l10n.okudum,
                        ikon: 'check',
                        ikincil: true,
                        onTap: () => _hatimler.okundu(hatim.kod, secili.no),
                      ),
                      AbyadDugme(
                        metin: l10n.payiBirak,
                        ikincil: true,
                        onTap: () {
                          _hatimler.payBirak(hatim.kod, secili.no);
                          setState(() => _secili = null);
                        },
                      ),
                    ] else
                      AbyadDugme(
                        metin: l10n.geriAl,
                        ikincil: true,
                        onTap: () => _hatimler.okunmadi(hatim.kod, secili.no),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 14),
        Text(
          l10n.hatimAltNot,
          textAlign: TextAlign.center,
          style: AbyadText.kucuk,
        ),
      ],
    );
  }
}

/// Bir payın ızgaradaki görünümü. Durum yalnızca renkle değil, ekran
/// okuyucu etiketiyle ve seçili pay kartındaki yazıyla da verilir.
enum _Gorunum {
  okundu,
  alindi,
  senin,
  bos;

  Color get zemin => switch (this) {
    okundu => AbyadColors.zumrut,
    alindi => AbyadColors.segmentZemin,
    senin => AbyadColors.pirinc,
    bos => AbyadColors.yuzey,
  };

  Color get kenar => switch (this) {
    okundu => AbyadColors.zumrut,
    alindi => AbyadColors.segmentZemin,
    senin => AbyadColors.pirincSus,
    bos => AbyadColors.kenarlik,
  };

  Color get yazi => switch (this) {
    okundu => AbyadColors.yuzey,
    alindi => AbyadColors.metinIkincil,
    senin => AbyadColors.pirincUstu,
    bos => AbyadColors.metin,
  };
}

class _PayIzgarasi extends StatelessWidget {
  const _PayIzgarasi({
    required this.hatim,
    required this.ben,
    required this.secili,
    required this.onDokun,
  });

  final Hatim hatim;
  final String ben;
  final int? secili;
  final ValueChanged<Pay> onDokun;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cuz = hatim.bolmeSekli == BolmeSekli.cuz;
    const bosluk = 8.0;
    return LayoutBuilder(
      builder: (context, kisit) {
        // Büyük yazıda kutular genişler, sütun sayısı azalır
        final enAz = math.max(
          AbyadSize.minDokunma,
          MediaQuery.textScalerOf(context).scale(cuz ? 34 : 76),
        );
        final sutun = ((kisit.maxWidth + bosluk) / (enAz + bosluk))
            .floor()
            .clamp(1, cuz ? 5 : 4);
        final en = (kisit.maxWidth - bosluk * (sutun - 1)) / sutun;
        return Wrap(
          spacing: bosluk,
          runSpacing: bosluk,
          children: [
            for (final pay in hatim.paylar)
              _PayKutusu(
                en: en,
                etiket: cuz ? '${pay.no}' : '${pay.baslangic}–${pay.bitis}',
                okuma: _payAdi(l10n, hatim, pay),
                gorunum: switch (pay.durum) {
                  PayDurumu.bos => _Gorunum.bos,
                  PayDurumu.okundu => _Gorunum.okundu,
                  PayDurumu.alindi =>
                    pay.katilimci == ben ? _Gorunum.senin : _Gorunum.alindi,
                },
                durumAdi: switch (pay.durum) {
                  PayDurumu.bos => l10n.durumBos,
                  PayDurumu.okundu => l10n.durumOkundu,
                  PayDurumu.alindi =>
                    pay.katilimci == ben ? l10n.durumSenin : l10n.durumAlindi,
                },
                secili: pay.no == secili,
                onTap: () => onDokun(pay),
              ),
          ],
        );
      },
    );
  }
}

class _PayKutusu extends StatelessWidget {
  const _PayKutusu({
    required this.en,
    required this.etiket,
    required this.okuma,
    required this.gorunum,
    required this.durumAdi,
    required this.secili,
    required this.onTap,
  });

  final double en;
  final String etiket;
  final String okuma;
  final _Gorunum gorunum;
  final String durumAdi;
  final bool secili;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: secili,
      label: '$okuma, $durumAdi',
      excludeSemantics: true,
      child: Material(
        color: gorunum.zemin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AbyadRadius.dugme),
          side: BorderSide(
            color: secili ? AbyadColors.pirincYazi : gorunum.kenar,
            width: secili ? 2.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: en,
            height: math.max(
              AbyadSize.minDokunma,
              MediaQuery.textScalerOf(context).scale(30),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    etiket,
                    maxLines: 1,
                    style: abyadStil(
                      AbyadFonts.metin,
                      15,
                      700,
                      color: gorunum.yazi,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
