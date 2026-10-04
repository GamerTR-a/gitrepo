import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/app_localizations.dart';
import '../core/theme/abyad_theme.dart';
import '../features/ayarlar/data/ayarlar_saglayici.dart';
import '../features/bildirim/data/bildirim_servisi.dart';
import '../features/ilk_acilis/ui/ilk_acilis_ekrani.dart';
import '../features/widget/data/widget_servisi.dart';
import 'abyad_kabuk.dart';

class AbyadApp extends ConsumerWidget {
  const AbyadApp({super.key, this.arkaPlanIsleri = true});

  /// Bildirim ve widget yenilemeyi kapatır (testler için).
  final bool arkaPlanIsleri;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carpan = ref.watch(
      ayarlarProvider.select((a) => a.yaziBoyutu.carpan),
    );
    final kontrast = ref.watch(ayarlarProvider.select((a) => a.yuksekKontrast));
    final ilkAcilisTamam = ref.watch(
      ayarlarProvider.select((a) => a.ilkAcilisTamam),
    );

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).uygulamaAdi,
      debugShowCheckedModeBanner: false,
      theme: AbyadTheme.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        Widget icerik = MediaQuery(
          data: mq.copyWith(
            // Uygulamanın yazı boyutu, telefonun ayarıyla çarpılır.
            textScaler: carpan == 1
                ? mq.textScaler
                : CarpanliOlcek(mq.textScaler, carpan),
            highContrast: mq.highContrast || kontrast,
          ),
          child: child!,
        );
        if (kontrast) {
          icerik = ColorFiltered(
            colorFilter: yuksekKontrastFiltresi,
            child: icerik,
          );
        }
        return icerik;
      },
      home: arkaPlanIsleri
          ? ArkaPlanIsleri(
              child: ilkAcilisTamam
                  ? const AbyadKabuk()
                  : const IlkAcilisEkrani(),
            )
          : (ilkAcilisTamam ? const AbyadKabuk() : const IlkAcilisEkrani()),
    );
  }
}

/// Sistemin yazı ölçeğini uygulama içi seçimle çarpar.
class CarpanliOlcek extends TextScaler {
  const CarpanliOlcek(this.sistem, this.carpan);

  final TextScaler sistem;
  final double carpan;

  @override
  double scale(double fontSize) => sistem.scale(fontSize) * carpan;

  @override
  double get textScaleFactor => scale(14) / 14;

  @override
  bool operator ==(Object other) =>
      other is CarpanliOlcek &&
      other.sistem == sistem &&
      other.carpan == carpan;

  @override
  int get hashCode => Object.hash(sistem, carpan);
}

/// Yüksek kontrast: orta tonları koyulaştırıp açık tonları beyaza yaklaştırır
/// (parlaklık ekseninde kontrast artırımı). Renkler token olarak kaldığı
/// için bütün ekranlara tek yerden uygulanır.
const _k = 1.35;
const _kaydirma = (1 - _k) * 128;
const yuksekKontrastFiltresi = ColorFilter.matrix([
  _k, 0, 0, 0, _kaydirma, //
  0, _k, 0, 0, _kaydirma, //
  0, 0, _k, 0, _kaydirma, //
  0, 0, 0, 1, 0, //
]);

/// Uygulama açıldığında, öne geldiğinde ve vakitleri etkileyen bir ayar
/// değiştiğinde ezan bildirimlerini ve ana ekran widget'larını yeniler.
class ArkaPlanIsleri extends ConsumerStatefulWidget {
  const ArkaPlanIsleri({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<ArkaPlanIsleri> createState() => _ArkaPlanIsleriState();
}

class _ArkaPlanIsleriState extends ConsumerState<ArkaPlanIsleri>
    with WidgetsBindingObserver {
  Timer? _bekleyen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _planla();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bekleyen?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState durum) {
    // Saat, saat dilimi ya da gün değişmiş olabilir
    if (durum == AppLifecycleState.resumed) _planla();
  }

  /// Art arda gelen ayar değişikliklerinde tek sefer çalışsın diye bekletir.
  void _planla() {
    _bekleyen?.cancel();
    _bekleyen = Timer(const Duration(milliseconds: 600), _yenile);
  }

  Future<void> _yenile() async {
    try {
      await ref.read(bildirimServisiProvider).yenidenKur();
    } on Object catch (hata) {
      debugPrint('Bildirimler kurulamadı: $hata');
    }
    try {
      await ref.read(widgetServisiProvider).guncelle();
    } on Object catch (hata) {
      debugPrint('Widget güncellenemedi: $hata');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      ayarlarProvider.select(
        (a) => (
          a.konum,
          a.yontem,
          a.duzeltmeler,
          a.bildirim,
          a.alarmOlarakCal,
          a.hatirlatilanGunler,
        ),
      ),
      (_, _) => _planla(),
    );
    return widget.child;
  }
}
