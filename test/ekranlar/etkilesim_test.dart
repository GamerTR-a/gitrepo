import 'dart:convert';

import 'package:abyad/app/abyad_app.dart';
import 'package:abyad/app/abyad_kabuk.dart';
import 'package:abyad/core/theme/abyad_colors.dart';
import 'package:abyad/features/ayarlar/data/ayarlar_saglayici.dart';
import 'package:abyad/features/ayarlar/domain/ayarlar.dart';
import 'package:abyad/features/ayarlar/ui/ayarlar_ekrani.dart';
import 'package:abyad/features/hatim/data/hatim_saglayici.dart';
import 'package:abyad/features/hatim/domain/hatim.dart';
import 'package:abyad/features/hatim/ui/hatim_ekrani.dart';
import 'package:abyad/features/kaza/ui/kaza_ekrani.dart';
import 'package:abyad/features/konum/ui/sehir_sec_ekrani.dart';
import 'package:abyad/features/kuran/ui/kuran_oku_ekrani.dart';
import 'package:abyad/features/kuran/ui/kuran_sayfa_ekrani.dart';
import 'package:abyad/features/rehber/ui/rehber_ekrani.dart';
import 'package:abyad/features/vakitler/domain/gunluk_vakitler.dart';
import 'package:abyad/features/vakitler/ui/vakitler_ekrani.dart';
import 'package:abyad/features/zikirmatik/ui/zikir_arka_plani.dart';
import 'package:abyad/features/zikirmatik/ui/zikirmatik_ekrani.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../yardimci.dart';

ProviderContainer _kap(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));

void main() {
  setUpAll(testOrtaminiKur);

  testWidgets('ana sayfa: hesaplanan sıradaki vakit ve ekran okuyucu metni', (
    tester,
  ) async {
    final tutamac = tester.ensureSemantics();
    final ortam = await ekraniKur(tester, const AbyadKabuk());
    // 2 Ekim 2026 13:52 İstanbul: öğle girmiş, sıradaki ikindi
    expect(find.text('Sıradaki vakit · İkindi'), findsOneWidget);
    expect(find.textContaining('dakika kaldı'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp(r'^Sıradaki vakit İkindi, saat 16:\d\d, ')),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(RegExp(r'^Öğle 12:\d\d, şu anki vakit$')),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(RegExp(r'^İkindi 16:\d\d, sıradaki vakit$')),
      findsOneWidget,
    );
    expect(find.text('İstanbul'), findsOneWidget);
    expect(find.textContaining('Rebiülâhir 1448'), findsOneWidget);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    tutamac.dispose();
    await ekraniKapat(tester, ortam);
  });

  testWidgets('alt menü sekme değiştirir', (tester) async {
    final ortam = await ekraniKur(tester, const AbyadKabuk());
    await tester.tap(find.text('Vakitler'));
    await yuklenmeyiBekle(tester);
    expect(find.text('Namaz Vakitleri'), findsOneWidget);
    await tester.tap(find.text('Günler'));
    await yuklenmeyiBekle(tester);
    expect(find.text('Önemli Günler'), findsOneWidget);
    expect(find.text('Regaip Kandili'), findsWidgets);
    await ekraniKapat(tester, ortam);
  });

  testWidgets('vakitler: zil düğmesi o vaktin bildirimini kapatıp açar', (
    tester,
  ) async {
    final ortam = await ekraniKur(
      tester,
      const Scaffold(body: VakitlerEkrani()),
    );
    final kap = _kap(tester);
    bool acik() =>
        kap.read(ayarlarProvider).bildirim.vakitler[VakitTuru.ogle]!.acik;
    expect(acik(), isTrue);
    await tester.tap(find.byTooltip('Öğle ezan bildirimi açık'));
    await tester.pump();
    expect(acik(), isFalse);
    expect(find.byTooltip('Öğle ezan bildirimi kapalı'), findsOneWidget);
    // Güneş varsayılan olarak kapalıdır
    expect(find.byTooltip('Güneş ezan bildirimi kapalı'), findsOneWidget);
    await ekraniKapat(tester, ortam);
  });

  testWidgets('vakitler: ileri gidince geri sayım gizlenir, tarih değişir', (
    tester,
  ) async {
    final ortam = await ekraniKur(
      tester,
      const Scaffold(body: VakitlerEkrani()),
    );
    expect(find.text('İkindi vaktine kalan'), findsOneWidget);
    expect(find.text('2 Ekim 2026 Cuma'), findsOneWidget);
    await tester.tap(find.byTooltip('Sonraki gün'));
    await tester.pump();
    expect(find.text('3 Ekim 2026 Cumartesi'), findsOneWidget);
    expect(find.text('İkindi vaktine kalan'), findsNothing);
    await ekraniKapat(tester, ortam);
  });

  testWidgets('şehir seçimi: arama ve seçim konumu değiştirir', (tester) async {
    final ortam = await ekraniKur(
      tester,
      Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SehirSecEkrani()),
            ),
            child: const Text('aç'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('aç'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'uskudar');
    await tester.pump();
    expect(find.text('Üsküdar'), findsOneWidget);
    await tester.tap(find.text('Üsküdar'));
    await tester.pumpAndSettle();
    final konum = _kap(tester).read(ayarlarProvider).konum;
    expect(
      (konum.ad, konum.ust, konum.otomatik),
      ('Üsküdar', 'İstanbul', false),
    );
    await ekraniKapat(tester, ortam);
  });

  testWidgets('zikirmatik: dokunuş sayar, 33’te tur tamamlanır, günlük '
      'toplam artar', (tester) async {
    final ortam = await ekraniKur(tester, const ZikirmatikEkrani());
    final dugme = find.bySemanticsLabel(RegExp('^Sübhânallah say'));
    for (var i = 0; i < 33; i++) {
      await tester.tap(dugme);
      await tester.pump(const Duration(milliseconds: 20));
    }
    await yuklenmeyiBekle(tester);
    expect(find.textContaining('1 tur tamamlandı'), findsOneWidget);
    expect(find.text('33'), findsWidgets); // günlük toplam ve hedef
    expect(
      await tester.runAsync(
        () => ortam.veritabani.gunlukSayaciIzle('2026-10-02', 'zikir').first,
      ),
      33,
    );
    await tester.tap(find.byTooltip('Sayacı sıfırla'));
    await tester.pump();
    expect(find.textContaining('tur tamamlandı'), findsNothing);
    await ekraniKapat(tester, ortam);
  });

  testWidgets('kaza: ekle ve kıldım sayaçları günceller, gizle maskeler', (
    tester,
  ) async {
    final ortam = await TestOrtami.olustur();
    await tester.runAsync(() => ortam.veritabani.kazaAyarla('sabah', 212));
    await ekraniKur(tester, const KazaEkrani(), ortam: ortam);
    expect(find.text('212 kaldı'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Bir Sabah kazası kıldım'));
    await yuklenmeyiBekle(tester);
    expect(find.text('211 kaldı'), findsOneWidget);
    expect(find.textContaining('Bugün 1 kaza kıldınız'), findsOneWidget);

    await tester.tap(find.byTooltip('Sabah kazası ekle'));
    await yuklenmeyiBekle(tester);
    expect(find.text('212 kaldı'), findsOneWidget);

    await tester.tap(find.text('Gizle'));
    await tester.pump();
    expect(find.text('212 kaldı'), findsNothing);
    expect(find.text('•••'), findsWidgets);
    expect(find.text('Göster'), findsOneWidget);
    await ekraniKapat(tester, ortam);
  });

  testWidgets("Kur'an: yer imi eklenir, kalınan yer kaydedilir, meal yer "
      'tutucusu görünür', (tester) async {
    final ortam = await ekraniKur(tester, const KuranOkuEkrani(sure: 1));
    expect(find.textContaining('Meal kaynağı eklenecek'), findsOneWidget);
    await tester.tap(find.byTooltip('2. ayete yer imi ekle'));
    await yuklenmeyiBekle(tester);
    expect(find.byTooltip('2. ayetin yer imini kaldır'), findsOneWidget);
    final imler = await tester.runAsync(
      () => ortam.veritabani.yerImleriniIzle().first,
    );
    expect((imler!.single.sure, imler.single.ayet), (1, 2));
    final durum = await tester.runAsync(
      () => ortam.veritabani.okumaDurumunuIzle().first,
    );
    expect(durum!.sure, 1);
    await ekraniKapat(tester, ortam);
  });

  testWidgets('ayarlar: yazı boyutu ve kontrast seçimi kaydedilir', (
    tester,
  ) async {
    final ortam = await ekraniKur(tester, const AyarlarEkrani());
    await tester.tap(find.text('Çok büyük'));
    await tester.pump();
    expect(_kap(tester).read(ayarlarProvider).yaziBoyutu, YaziBoyutu.cokBuyuk);
    final kayit =
        jsonDecode(ortam.prefs.getString('ayarlar_v1')!)
            as Map<String, dynamic>;
    expect(kayit['yaziBoyutu'], 'cokBuyuk');
    await ekraniKapat(tester, ortam);
  });

  testWidgets('uygulama: ilk açılış atlanınca ana ekrana geçer; yazı boyutu '
      've yüksek kontrast bütün uygulamaya uygulanır', (tester) async {
    final ortam = await TestOrtami.olustur();
    tester.view.physicalSize = tasarimBoyutu;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: ortam.overrides(),
        child: const AbyadApp(arkaPlanIsleri: false),
      ),
    );
    await yuklenmeyiBekle(tester);
    expect(find.text('Reklam yok, veri yok, hesap yok.'), findsOneWidget);
    await tester.tap(find.text('Devam'));
    await tester.pump();
    await tester.tap(find.textContaining('Şimdilik atla'));
    await tester.pump();
    expect(find.text('Ezan vaktinde haber verelim'), findsOneWidget);
    await tester.tap(find.text('Atla'));
    await yuklenmeyiBekle(tester);
    expect(find.textContaining('Sıradaki vakit'), findsOneWidget);

    final kap = ProviderScope.containerOf(
      tester.element(find.byType(AbyadApp)),
    );
    expect(kap.read(ayarlarProvider).ilkAcilisTamam, isTrue);
    double olcek() => MediaQuery.textScalerOf(
      tester.element(find.byType(AbyadKabuk)),
    ).scale(10);
    expect(olcek(), 10);
    await kap
        .read(ayarlarProvider.notifier)
        .guncelle(
          (a) =>
              a.copyWith(yaziBoyutu: YaziBoyutu.cokBuyuk, yuksekKontrast: true),
        );
    await tester.pump();
    expect(olcek(), 15);
    expect(find.byType(ColorFiltered), findsOneWidget);
    expect(tester.takeException(), isNull);
    await ekraniKapat(tester, ortam);
  });

  testWidgets('rehber: bölüm seçilir, adımlar düğmeyle ve kaydırarak ilerler', (
    tester,
  ) async {
    final tutamac = tester.ensureSemantics();
    final ortam = await ekraniKur(tester, const RehberEkrani());
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

    // Sabah kartının ikinci satırı: farz
    await tester.tap(find.text('Farz').first);
    await tester.pumpAndSettle();
    expect(find.text('Sabah – Farz'), findsOneWidget);
    expect(find.text('Adım 1 / 17'), findsOneWidget);
    expect(
      find.text(
        'Niyet ettim Allah rızası için bugünkü sabah namazının farzını '
        'kılmaya.',
      ),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Niyet: kıbleye dönük, ayakta, kollar iki yanda'),
      findsOneWidget,
    );

    await tester.tap(find.text('Sonraki adım'));
    await tester.pumpAndSettle();
    expect(
      find.text('Adım 2 / 17 · 1. rekat · İftitah Tekbiri'),
      findsOneWidget,
    );
    expect(find.text('Allâhu Ekber'), findsOneWidget);
    expect(find.text('Kadınlar için'), findsOneWidget);

    // Kaydırarak üçüncü adım: Sübhâneke, Dualar verisinden gelir
    await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('Adım 3 / 17 · 1. rekat · Kıyam'), findsOneWidget);
    expect(find.text('Sübhâneke'), findsOneWidget);
    expect(find.textContaining('Sübhânekellâhümme'), findsOneWidget);

    // Ezber modu: Arapça ve okunuş gizlenir, dokununca açılır
    await tester.tap(find.byTooltip('Ezber modunu aç'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Sübhânekellâhümme'), findsNothing);
    expect(find.textContaining('Seni her türlü noksanlıktan'), findsOneWidget);
    await tester.ensureVisible(find.text('Göstermek için dokunun'));
    await tester.tap(find.text('Göstermek için dokunun'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Sübhânekellâhümme'), findsOneWidget);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    // Ses dosyası yokken dinleme düğmesi gösterilmez
    expect(find.text('Okunuşu dinle'), findsNothing);
    tutamac.dispose();
    await ekraniKapat(tester, ortam);
  });

  testWidgets('rehber: abdest sekmesi bozan durumları ve adımları gösterir', (
    tester,
  ) async {
    final ortam = await ekraniKur(tester, const RehberEkrani());
    // Cuma namazı içerik gelene kadar yer tutucu
    await tester.scrollUntilVisible(
      find.text('Bu bölümün içeriği hazırlanıyor.'),
      300,
    );
    await tester.drag(find.byType(ListView), const Offset(0, 3000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Abdest'));
    await tester.pumpAndSettle();
    expect(find.text('Abdesti bozan durumlar'), findsOneWidget);
    await tester.tap(find.text('Abdest adımlarına başla'));
    await tester.pumpAndSettle();
    expect(find.text('Adım 1 / 9'), findsOneWidget);
    expect(find.text('Niyet ve Besmele'), findsOneWidget);
    await tester.tap(find.text('Sonraki adım'));
    await tester.pumpAndSettle();
    expect(find.text('Eller'), findsOneWidget);
    expect(find.text('3 kez'), findsOneWidget);
    await ekraniKapat(tester, ortam);
  });

  testWidgets('hatim: oluşturma, pay alma, okudum ve bırakma', (tester) async {
    final tutamac = tester.ensureSemantics();
    final ortam = await ekraniKur(tester, const HatimEkrani());
    expect(find.text('Henüz hatim yok'), findsOneWidget);
    expect(find.text('Linkle paylaşım henüz açık değil'), findsOneWidget);

    await tester.tap(find.text('Hatim başlat'));
    await tester.pumpAndSettle();
    // Başlıksız hatim oluşturulmaz
    await tester.ensureVisible(find.text('Hatim başlat'));
    await tester.tap(find.text('Hatim başlat'));
    await tester.pumpAndSettle();
    expect(find.text('Bu alan boş bırakılamaz.'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'bkz www.ornek.com');
    await tester.pumpAndSettle();
    expect(find.text('Bu alana link yazılamaz.'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Aile Hatmi');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Hatim başlat'));
    await tester.tap(find.text('Hatim başlat'));
    await tester.pumpAndSettle();

    expect(find.text('Aile Hatmi'), findsOneWidget);
    expect(find.text('0 / 30 cüz okundu'), findsOneWidget);
    expect(find.bySemanticsLabel('20. cüz, Boş'), findsOneWidget);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

    await tester.ensureVisible(find.text('20'));
    await tester.tap(find.text('20'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('20. cüz, Senin'), findsOneWidget);
    expect(find.text('Senin payın'), findsOneWidget);
    expect(find.text('20. cüz'), findsOneWidget);

    await tester.ensureVisible(find.text('Okudum'));
    await tester.tap(find.text('Okudum'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 30 cüz okundu'), findsOneWidget);
    expect(find.bySemanticsLabel('20. cüz, Okundu'), findsOneWidget);
    final hatim = _kap(tester).read(hatimlerProvider).single;
    expect(hatim.pay(20).durum, PayDurumu.okundu);

    await tester.ensureVisible(find.text('Geri al'));
    await tester.tap(find.text('Geri al'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Bırak'));
    await tester.tap(find.text('Bırak'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('20. cüz, Boş'), findsOneWidget);
    expect(find.text('Senin payın'), findsNothing);
    tutamac.dispose();
    await ekraniKapat(tester, ortam);
  });

  testWidgets('hatim: başkasının aldığı pay alınamaz, okumaya başla '
      "Kur'an'ı o cüzden açar", (tester) async {
    final ortam = await ekraniKur(
      tester,
      const HatimDetayEkrani(kod: ornekHatimKodu),
      ortam: await TestOrtami.olustur(
        ayarlar: ornekHatimAyarlari(BolmeSekli.cuz),
      ),
    );
    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();
    expect(find.text('Bu pay az önce alındı.'), findsOneWidget);
    expect(
      _kap(tester).read(hatimlerProvider).single.pay(5).katilimci,
      'baskasi',
    );

    await tester.tap(find.text('4'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Okumaya başla'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Okumaya başla'));
    await yuklenmeyiBekle(tester);
    await yuklenmeyiBekle(tester);
    // 4. cüz Âl-i İmrân 93'te başlar
    final kuran = tester.widget<KuranSayfaEkrani>(
      find.byType(KuranSayfaEkrani),
    );
    expect((kuran.sure, kuran.ayet), (3, 93));
    await ekraniKapat(tester, ortam);
  });

  testWidgets('ayarlar: ana sayfa kısa menüdür, ayrıntılar alt sayfalarda', (
    tester,
  ) async {
    final ortam = await ekraniKur(tester, const AyarlarEkrani());
    // Sık kullanılanlar doğrudan ana sayfada
    expect(find.text('Yazı boyutu'), findsOneWidget);
    expect(find.text('Tema'), findsOneWidget);
    // Ayrıntılar ana sayfada değil
    expect(find.text('Ezanı alarm olarak çal'), findsNothing);
    expect(find.text('Hesaplama yöntemi'), findsNothing);

    await tester.tap(find.text('Ezan ve bildirimler'));
    await tester.pumpAndSettle();
    expect(find.text('Ezanı alarm olarak çal'), findsOneWidget);
    expect(find.text('Vakit bildirimleri'), findsOneWidget);
    await tester.tap(find.byTooltip('Geri'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Konum ve vakitler'));
    await tester.tap(find.text('Konum ve vakitler'));
    await tester.pumpAndSettle();
    expect(find.text('Hesaplama yöntemi'), findsOneWidget);
    await ekraniKapat(tester, ortam);
  });

  testWidgets('koyu tema: seçilince bütün uygulama koyu renklere geçer, '
      'bulunulan ekran değişmez ve seçim kaydedilir', (tester) async {
    addTearDown(() => AbyadColors.palet = AbyadPalet.acik);
    final ortam = await TestOrtami.olustur(
      ayarlar: {'ayarlar_v1': '{"ilkAcilisTamam": true}'},
    );
    tester.view.physicalSize = tasarimBoyutu;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: ortam.overrides(),
        child: const AbyadApp(arkaPlanIsleri: false),
      ),
    );
    await yuklenmeyiBekle(tester);
    Color zemin() =>
        tester.widget<Scaffold>(find.byType(Scaffold).last).backgroundColor!;

    await tester.tap(find.byTooltip('Ayarlar'));
    await tester.pumpAndSettle();
    expect(zemin(), AbyadPalet.acik.zemin);

    await tester.tap(find.text('Koyu'));
    await tester.pumpAndSettle();
    expect(AbyadColors.palet.koyu, isTrue);
    expect(find.text('Yazı boyutu'), findsOneWidget, reason: 'ekran değişmedi');
    expect(zemin(), AbyadPalet.karanlik.zemin);
    expect(
      Theme.of(tester.element(find.text('Tema'))).brightness,
      Brightness.dark,
    );
    expect(_kap(tester).read(ayarlarProvider).koyuTema, isTrue);
    expect(ortam.prefs.getString('ayarlar_v1'), contains('"koyuTema":true'));

    await tester.tap(find.text('Açık'));
    await tester.pumpAndSettle();
    expect(AbyadColors.palet.koyu, isFalse);
    expect(zemin(), AbyadPalet.acik.zemin);
    await ekraniKapat(tester, ortam);
  });

  testWidgets('zikirmatik: manzara varsayılan olarak kapalı; açılınca '
      'çizimler seçilen aralıkla değişir ve saymayı engellemez', (
    tester,
  ) async {
    final ortam = await ekraniKur(tester, const ZikirmatikEkrani());
    expect(find.byType(ZikirArkaPlani), findsNothing);

    await tester.ensureVisible(find.text('Arka planda manzara'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Arka planda manzara'));
    await tester.pumpAndSettle();
    expect(_kap(tester).read(ayarlarProvider).zikirArkaPlan, isTrue);
    expect(find.byType(ZikirArkaPlani), findsOneWidget);
    expect(find.byKey(const ValueKey('kabe')), findsOneWidget);

    await tester.ensureVisible(find.text('15 sn'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15 sn'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 15));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('kabe')), findsNothing);
    expect(find.byKey(const ValueKey('medine')), findsOneWidget);
    // Bütün manzaralar dolaşılır ve başa dönülür
    for (var i = 1; i < zikirManzaralari.length; i++) {
      await tester.pump(const Duration(seconds: 15));
      await tester.pumpAndSettle();
    }
    expect(find.byKey(const ValueKey('kabe')), findsOneWidget);

    // Sayaç manzara açıkken de çalışır
    await tester.drag(find.byType(ListView).first, const Offset(0, 3000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dokun ve say'));
    await tester.pump();
    expect(find.text('1'), findsWidgets);
    await ekraniKapat(tester, ortam);
  });
}
