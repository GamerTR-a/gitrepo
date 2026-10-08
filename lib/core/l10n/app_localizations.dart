import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('tr')];

  /// No description provided for @uygulamaAdi.
  ///
  /// In tr, this message translates to:
  /// **'Abyad'**
  String get uygulamaAdi;

  /// No description provided for @geri.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get geri;

  /// No description provided for @tamam.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get tamam;

  /// No description provided for @vazgec.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get vazgec;

  /// No description provided for @devam.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get devam;

  /// No description provided for @atla.
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get atla;

  /// No description provided for @acik.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get acik;

  /// No description provided for @kapali.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı'**
  String get kapali;

  /// No description provided for @bugun.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get bugun;

  /// No description provided for @gecti.
  ///
  /// In tr, this message translates to:
  /// **'Geçti'**
  String get gecti;

  /// No description provided for @tumu.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get tumu;

  /// No description provided for @onceki.
  ///
  /// In tr, this message translates to:
  /// **'Önceki'**
  String get onceki;

  /// No description provided for @sonucYok.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç bulunamadı'**
  String get sonucYok;

  /// No description provided for @veriOkunamadi.
  ///
  /// In tr, this message translates to:
  /// **'İçerik yüklenemedi. Uygulamayı kapatıp yeniden açmayı deneyin.'**
  String get veriOkunamadi;

  /// No description provided for @artir.
  ///
  /// In tr, this message translates to:
  /// **'{ad}: artır'**
  String artir(String ad);

  /// No description provided for @azalt.
  ///
  /// In tr, this message translates to:
  /// **'{ad}: azalt'**
  String azalt(String ad);

  /// No description provided for @yuzdeDeger.
  ///
  /// In tr, this message translates to:
  /// **'%{yuzde}'**
  String yuzdeDeger(int yuzde);

  /// No description provided for @kaynakSatiri.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak: {kaynak}'**
  String kaynakSatiri(String kaynak);

  /// No description provided for @okunus.
  ///
  /// In tr, this message translates to:
  /// **'Okunuşu'**
  String get okunus;

  /// No description provided for @anlam.
  ///
  /// In tr, this message translates to:
  /// **'Anlamı'**
  String get anlam;

  /// No description provided for @namaz.
  ///
  /// In tr, this message translates to:
  /// **'Namaz'**
  String get namaz;

  /// No description provided for @abdest.
  ///
  /// In tr, this message translates to:
  /// **'Abdest'**
  String get abdest;

  /// No description provided for @oruc.
  ///
  /// In tr, this message translates to:
  /// **'Oruç'**
  String get oruc;

  /// No description provided for @menuEtiketi.
  ///
  /// In tr, this message translates to:
  /// **'Ana menü'**
  String get menuEtiketi;

  /// No description provided for @menuAnaSayfa.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get menuAnaSayfa;

  /// No description provided for @menuVakitler.
  ///
  /// In tr, this message translates to:
  /// **'Vakitler'**
  String get menuVakitler;

  /// No description provided for @menuKuran.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an'**
  String get menuKuran;

  /// No description provided for @menuDualar.
  ///
  /// In tr, this message translates to:
  /// **'Dualar'**
  String get menuDualar;

  /// No description provided for @menuGunler.
  ///
  /// In tr, this message translates to:
  /// **'Günler'**
  String get menuGunler;

  /// No description provided for @ekranVakitler.
  ///
  /// In tr, this message translates to:
  /// **'Namaz Vakitleri'**
  String get ekranVakitler;

  /// No description provided for @ekranKuran.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an-ı Kerim'**
  String get ekranKuran;

  /// No description provided for @ekranDualar.
  ///
  /// In tr, this message translates to:
  /// **'Dualar ve Zikir'**
  String get ekranDualar;

  /// No description provided for @ekranGunler.
  ///
  /// In tr, this message translates to:
  /// **'Önemli Günler'**
  String get ekranGunler;

  /// No description provided for @vakitImsak.
  ///
  /// In tr, this message translates to:
  /// **'İmsak'**
  String get vakitImsak;

  /// No description provided for @vakitGunes.
  ///
  /// In tr, this message translates to:
  /// **'Güneş'**
  String get vakitGunes;

  /// No description provided for @vakitOgle.
  ///
  /// In tr, this message translates to:
  /// **'Öğle'**
  String get vakitOgle;

  /// No description provided for @vakitIkindi.
  ///
  /// In tr, this message translates to:
  /// **'İkindi'**
  String get vakitIkindi;

  /// No description provided for @vakitAksam.
  ///
  /// In tr, this message translates to:
  /// **'Akşam'**
  String get vakitAksam;

  /// No description provided for @vakitYatsi.
  ///
  /// In tr, this message translates to:
  /// **'Yatsı'**
  String get vakitYatsi;

  /// No description provided for @siradakiVakit.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki vakit · {vakit}'**
  String siradakiVakit(String vakit);

  /// No description provided for @siradakiVakitOkuma.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki vakit {vakit}, saat {saat}, {kalan}'**
  String siradakiVakitOkuma(String vakit, String saat, String kalan);

  /// No description provided for @kalanSaatDakika.
  ///
  /// In tr, this message translates to:
  /// **'{saat} saat {dakika} dakika kaldı'**
  String kalanSaatDakika(int saat, int dakika);

  /// No description provided for @kalanDakika.
  ///
  /// In tr, this message translates to:
  /// **'{dakika} dakika kaldı'**
  String kalanDakika(int dakika);

  /// No description provided for @vakitCipiOkuma.
  ///
  /// In tr, this message translates to:
  /// **'{vakit} {saat}'**
  String vakitCipiOkuma(String vakit, String saat);

  /// No description provided for @vakitCipiSiradakiOkuma.
  ///
  /// In tr, this message translates to:
  /// **'{vakit} {saat}, sıradaki vakit'**
  String vakitCipiSiradakiOkuma(String vakit, String saat);

  /// No description provided for @vakitCipiSimdikiOkuma.
  ///
  /// In tr, this message translates to:
  /// **'{vakit} {saat}, şu anki vakit'**
  String vakitCipiSimdikiOkuma(String vakit, String saat);

  /// No description provided for @siradakiVakitRozet.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki vakit'**
  String get siradakiVakitRozet;

  /// No description provided for @suAnkiVakitRozet.
  ///
  /// In tr, this message translates to:
  /// **'Şu anki vakit'**
  String get suAnkiVakitRozet;

  /// No description provided for @tarihSatiri.
  ///
  /// In tr, this message translates to:
  /// **'{hicri} · {miladi}'**
  String tarihSatiri(String hicri, String miladi);

  /// No description provided for @hicriTarih.
  ///
  /// In tr, this message translates to:
  /// **'{gun} {ay} {yil}'**
  String hicriTarih(int gun, String ay, int yil);

  /// No description provided for @hicriAylar.
  ///
  /// In tr, this message translates to:
  /// **'Muharrem,Safer,Rebiülevvel,Rebiülâhir,Cemâziyelevvel,Cemâziyelâhir,Receb,Şâban,Ramazan,Şevval,Zilkade,Zilhicce'**
  String get hicriAylar;

  /// No description provided for @vakteKalan.
  ///
  /// In tr, this message translates to:
  /// **'{vakit} vaktine kalan'**
  String vakteKalan(String vakit);

  /// No description provided for @vakteKalanOkuma.
  ///
  /// In tr, this message translates to:
  /// **'{vakit} vaktine {kalan}'**
  String vakteKalanOkuma(String vakit, String kalan);

  /// No description provided for @oncekiGun.
  ///
  /// In tr, this message translates to:
  /// **'Önceki gün'**
  String get oncekiGun;

  /// No description provided for @sonrakiGun.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki gün'**
  String get sonrakiGun;

  /// No description provided for @buguneDon.
  ///
  /// In tr, this message translates to:
  /// **'Bugüne dönmek için dokunun'**
  String get buguneDon;

  /// No description provided for @oncekiAy.
  ///
  /// In tr, this message translates to:
  /// **'Önceki ay'**
  String get oncekiAy;

  /// No description provided for @sonrakiAy.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki ay'**
  String get sonrakiAy;

  /// No description provided for @aylikImsakiye.
  ///
  /// In tr, this message translates to:
  /// **'Aylık imsakiye'**
  String get aylikImsakiye;

  /// No description provided for @kuranMetniBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Metin ve İşaretler'**
  String get kuranMetniBaslik;

  /// No description provided for @kuranMetniDugme.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an metni ve işaretler hakkında'**
  String get kuranMetniDugme;

  /// No description provided for @kuranMetniBolum.
  ///
  /// In tr, this message translates to:
  /// **'Bu metin hakkında'**
  String get kuranMetniBolum;

  /// No description provided for @kuranIsaretBolum.
  ///
  /// In tr, this message translates to:
  /// **'Durak ve secde işaretleri'**
  String get kuranIsaretBolum;

  /// No description provided for @icerikIncelenmedi.
  ///
  /// In tr, this message translates to:
  /// **'Bu sayfadaki bilgiler henüz bir hoca tarafından incelenmedi.'**
  String get icerikIncelenmedi;

  /// No description provided for @ekVakitlerKart.
  ///
  /// In tr, this message translates to:
  /// **'Kerahat, işrak ve teheccüd vakitleri'**
  String get ekVakitlerKart;

  /// No description provided for @ekVakitlerBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kerahat, İşrak ve Teheccüd'**
  String get ekVakitlerBaslik;

  /// No description provided for @ekNafileBolum.
  ///
  /// In tr, this message translates to:
  /// **'Nafile namaz vakitleri'**
  String get ekNafileBolum;

  /// No description provided for @ekKerahatBolum.
  ///
  /// In tr, this message translates to:
  /// **'Kerahat vakitleri'**
  String get ekKerahatBolum;

  /// No description provided for @saatAraligi.
  ///
  /// In tr, this message translates to:
  /// **'{bas} – {bit}'**
  String saatAraligi(String bas, String bit);

  /// No description provided for @saatAraligiOkuma.
  ///
  /// In tr, this message translates to:
  /// **'{bas} ile {bit} arası'**
  String saatAraligiOkuma(String bas, String bit);

  /// No description provided for @ekVakitYok.
  ///
  /// In tr, this message translates to:
  /// **'Bu tarihte hesaplanamıyor'**
  String get ekVakitYok;

  /// No description provided for @suAnKerahat.
  ///
  /// In tr, this message translates to:
  /// **'Şu an kerahat vakti'**
  String get suAnKerahat;

  /// No description provided for @ekVakitlerYaklasik.
  ///
  /// In tr, this message translates to:
  /// **'Bu saatler namaz vakitlerinden türetilen yaklaşık değerlerdir.'**
  String get ekVakitlerYaklasik;

  /// No description provided for @ekVakitlerIncelenmedi.
  ///
  /// In tr, this message translates to:
  /// **'Süreler ve açıklamalar henüz bir hoca tarafından incelenmedi.'**
  String get ekVakitlerIncelenmedi;

  /// No description provided for @yuksekEnlemBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bu vakitler neden farklı olabilir?'**
  String get yuksekEnlemBaslik;

  /// No description provided for @yuksekEnlemMetin.
  ///
  /// In tr, this message translates to:
  /// **'Bulunduğunuz enlemde bu tarihte {vakitler} vakti astronomik olarak oluşmuyor; yüksek enlemlerde yaz gecelerinde gökyüzü tam kararmaz. Abyad bu günlerde \"gecenin yedide biri\" kuralını uygular: geceyi yediye böler, yatsıyı akşamdan bir pay sonra, imsakı güneş doğmadan bir pay önce alır. Diyanet bu enlemler için başka bir usul uyguladığından onun takvimiyle fark yarım saati aşabilir; oruç ve namaz için caminizin takvimini esas alın. Ayarlar\'dan her vakte dakika düzeltmesi ekleyebilirsiniz.'**
  String yuksekEnlemMetin(String vakitler);

  /// No description provided for @yazFarkiMetin.
  ///
  /// In tr, this message translates to:
  /// **'Diyanet, bu enlemde yaz aylarında imsak ve yatsıyı kısaltılmış bir süreyle yayımlıyor. Abyad ise güneşin açısına göre hesaplar; bu yüzden burada imsak Diyanet takviminden daha erken, yatsı daha geç görünebilir ve fark bir saati aşabilir. Caminizin takvimini esas alın; Ayarlar\'dan her vakte dakika düzeltmesi ekleyebilirsiniz.'**
  String get yazFarkiMetin;

  /// No description provided for @listeVe.
  ///
  /// In tr, this message translates to:
  /// **'{ilk} ve {son}'**
  String listeVe(String ilk, String son);

  /// No description provided for @ezanBildirimiAcik.
  ///
  /// In tr, this message translates to:
  /// **'{vakit} ezan bildirimi açık'**
  String ezanBildirimiAcik(String vakit);

  /// No description provided for @ezanBildirimiKapali.
  ///
  /// In tr, this message translates to:
  /// **'{vakit} ezan bildirimi kapalı'**
  String ezanBildirimiKapali(String vakit);

  /// No description provided for @hesaplamaYontemiNotu.
  ///
  /// In tr, this message translates to:
  /// **'Hesaplama yöntemi: {yontem} · Ayarlardan değiştirilebilir'**
  String hesaplamaYontemiNotu(String yontem);

  /// No description provided for @yontemDiyanet.
  ///
  /// In tr, this message translates to:
  /// **'Diyanet İşleri Başkanlığı'**
  String get yontemDiyanet;

  /// No description provided for @yontemDunyaIslamBirligi.
  ///
  /// In tr, this message translates to:
  /// **'Dünya İslam Birliği'**
  String get yontemDunyaIslamBirligi;

  /// No description provided for @yontemKuzeyAmerika.
  ///
  /// In tr, this message translates to:
  /// **'Kuzey Amerika (ISNA)'**
  String get yontemKuzeyAmerika;

  /// No description provided for @yontemMisir.
  ///
  /// In tr, this message translates to:
  /// **'Mısır'**
  String get yontemMisir;

  /// No description provided for @bildirimler.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get bildirimler;

  /// No description provided for @kibleBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kıble'**
  String get kibleBaslik;

  /// No description provided for @kibleYonu.
  ///
  /// In tr, this message translates to:
  /// **'Kıble yönü'**
  String get kibleYonu;

  /// No description provided for @kibleDerece.
  ///
  /// In tr, this message translates to:
  /// **'{derece}° {yon}'**
  String kibleDerece(int derece, String yon);

  /// No description provided for @kibleKartOkuma.
  ///
  /// In tr, this message translates to:
  /// **'Kıble yönü {derece} derece {yon}. Pusulayı açmak için dokunun'**
  String kibleKartOkuma(int derece, String yon);

  /// No description provided for @pusulayiAc.
  ///
  /// In tr, this message translates to:
  /// **'Pusulayı aç'**
  String get pusulayiAc;

  /// No description provided for @kibleHizada.
  ///
  /// In tr, this message translates to:
  /// **'Kıbleye döndünüz'**
  String get kibleHizada;

  /// No description provided for @kibleSagaDon.
  ///
  /// In tr, this message translates to:
  /// **'{derece}° sağa dönün'**
  String kibleSagaDon(int derece);

  /// No description provided for @kibleSolaDon.
  ///
  /// In tr, this message translates to:
  /// **'{derece}° sola dönün'**
  String kibleSolaDon(int derece);

  /// No description provided for @kibleTitresim.
  ///
  /// In tr, this message translates to:
  /// **'Kıbleye dönünce titreşim'**
  String get kibleTitresim;

  /// No description provided for @kibleTitresimAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Telefon kıbleye hizalanınca hafifçe titrer.'**
  String get kibleTitresimAciklama;

  /// No description provided for @pusulaIpucu.
  ///
  /// In tr, this message translates to:
  /// **'Telefonu yere paralel tutun. Yön şaşıyorsa telefonu havada 8 çizer gibi hareket ettirerek kalibre edin.'**
  String get pusulaIpucu;

  /// No description provided for @pusulaYokBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Pusula sensörü bulunamadı'**
  String get pusulaYokBaslik;

  /// No description provided for @pusulaYokMetin.
  ///
  /// In tr, this message translates to:
  /// **'Bu telefonda pusula kullanılamıyor. Kıble yönünüz kuzeyden saat yönünde {derece}° ({yon}).'**
  String pusulaYokMetin(int derece, String yon);

  /// No description provided for @kalibrasyonBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Pusula kalibrasyonu gerekiyor'**
  String get kalibrasyonBaslik;

  /// No description provided for @kalibrasyonMetin.
  ///
  /// In tr, this message translates to:
  /// **'Telefonu havada 8 çizer gibi birkaç kez hareket ettirin. Mıknatıs, hoparlör ve metal eşyalardan uzak tutun.'**
  String get kalibrasyonMetin;

  /// No description provided for @kuzeyKisaltma.
  ///
  /// In tr, this message translates to:
  /// **'K'**
  String get kuzeyKisaltma;

  /// No description provided for @yonKuzey.
  ///
  /// In tr, this message translates to:
  /// **'Kuzey'**
  String get yonKuzey;

  /// No description provided for @yonKuzeydogu.
  ///
  /// In tr, this message translates to:
  /// **'Kuzeydoğu'**
  String get yonKuzeydogu;

  /// No description provided for @yonDogu.
  ///
  /// In tr, this message translates to:
  /// **'Doğu'**
  String get yonDogu;

  /// No description provided for @yonGuneydogu.
  ///
  /// In tr, this message translates to:
  /// **'Güneydoğu'**
  String get yonGuneydogu;

  /// No description provided for @yonGuney.
  ///
  /// In tr, this message translates to:
  /// **'Güney'**
  String get yonGuney;

  /// No description provided for @yonGuneybati.
  ///
  /// In tr, this message translates to:
  /// **'Güneybatı'**
  String get yonGuneybati;

  /// No description provided for @yonBati.
  ///
  /// In tr, this message translates to:
  /// **'Batı'**
  String get yonBati;

  /// No description provided for @yonKuzeybati.
  ///
  /// In tr, this message translates to:
  /// **'Kuzeybatı'**
  String get yonKuzeybati;

  /// No description provided for @konum.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get konum;

  /// No description provided for @konumSec.
  ///
  /// In tr, this message translates to:
  /// **'Konum Seç'**
  String get konumSec;

  /// No description provided for @konumDegistirOkuma.
  ///
  /// In tr, this message translates to:
  /// **'Konum: {sehir}. Değiştirmek için dokunun'**
  String konumDegistirOkuma(String sehir);

  /// No description provided for @konumOtomatik.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik · {sehir}'**
  String konumOtomatik(String sehir);

  /// No description provided for @sehirAraIpucu.
  ///
  /// In tr, this message translates to:
  /// **'İl, ilçe veya şehir ara'**
  String get sehirAraIpucu;

  /// No description provided for @sehirBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Aradığınız yer bulunamadı. Yakındaki bir ilçeyi ya da ili deneyin.'**
  String get sehirBulunamadi;

  /// No description provided for @konumumuKullan.
  ///
  /// In tr, this message translates to:
  /// **'Konumumu kullan'**
  String get konumumuKullan;

  /// No description provided for @konumAraniyor.
  ///
  /// In tr, this message translates to:
  /// **'Konum aranıyor…'**
  String get konumAraniyor;

  /// No description provided for @konumMahremiyet.
  ///
  /// In tr, this message translates to:
  /// **'Konumunuz yalnızca vakitleri hesaplamak için kullanılır ve telefonunuzda kalır.'**
  String get konumMahremiyet;

  /// No description provided for @konumServisKapali.
  ///
  /// In tr, this message translates to:
  /// **'Telefonun konum servisi kapalı.'**
  String get konumServisKapali;

  /// No description provided for @konumIzinYok.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni verilmedi. Şehrinizi listeden seçebilirsiniz.'**
  String get konumIzinYok;

  /// No description provided for @konumIzinKalici.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni kapalı. Telefonun ayarlarından açabilir ya da şehrinizi listeden seçebilirsiniz.'**
  String get konumIzinKalici;

  /// No description provided for @konumBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Konum bulunamadı. Şehrinizi listeden seçebilirsiniz.'**
  String get konumBulunamadi;

  /// No description provided for @hizliKible.
  ///
  /// In tr, this message translates to:
  /// **'Kıble'**
  String get hizliKible;

  /// No description provided for @hizliKuran.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an'**
  String get hizliKuran;

  /// No description provided for @hizliZikirmatik.
  ///
  /// In tr, this message translates to:
  /// **'Zikirmatik'**
  String get hizliZikirmatik;

  /// No description provided for @hizliDualar.
  ///
  /// In tr, this message translates to:
  /// **'Dualar'**
  String get hizliDualar;

  /// No description provided for @devamEt.
  ///
  /// In tr, this message translates to:
  /// **'Kaldığın yerden devam et'**
  String get devamEt;

  /// No description provided for @devamKonum.
  ///
  /// In tr, this message translates to:
  /// **'{sure} · {ayet}. ayet'**
  String devamKonum(String sure, int ayet);

  /// No description provided for @hatimDurumu.
  ///
  /// In tr, this message translates to:
  /// **'Hatim %{yuzde} · Sayfa {sayfa} / {toplam}'**
  String hatimDurumu(int yuzde, int sayfa, int toplam);

  /// No description provided for @devamOkuma.
  ///
  /// In tr, this message translates to:
  /// **'Kaldığın yerden devam et: {sure}, {ayet}. ayet. Hatim yüzde {yuzde}'**
  String devamOkuma(String sure, int ayet, int yuzde);

  /// No description provided for @kuranaBasla.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an okumaya başla'**
  String get kuranaBasla;

  /// No description provided for @kuranaBaslaAlt.
  ///
  /// In tr, this message translates to:
  /// **'Kaldığınız yer burada görünecek'**
  String get kuranaBaslaAlt;

  /// No description provided for @gununAyeti.
  ///
  /// In tr, this message translates to:
  /// **'Günün Ayeti'**
  String get gununAyeti;

  /// No description provided for @ayetKaynagi.
  ///
  /// In tr, this message translates to:
  /// **'{sure} Suresi, {ayet}'**
  String ayetKaynagi(String sure, int ayet);

  /// No description provided for @yaklasanGun.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşan mübarek gün'**
  String get yaklasanGun;

  /// No description provided for @gunBirimi.
  ///
  /// In tr, this message translates to:
  /// **'gün'**
  String get gunBirimi;

  /// No description provided for @yaklasanGunOkuma.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşan mübarek gün: {ad}, {tarih}, {kalan} gün kaldı'**
  String yaklasanGunOkuma(String ad, String tarih, int kalan);

  /// No description provided for @dahaFazlasi.
  ///
  /// In tr, this message translates to:
  /// **'Daha fazlası'**
  String get dahaFazlasi;

  /// No description provided for @rehberBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Namaz ve Abdest Rehberi'**
  String get rehberBaslik;

  /// No description provided for @rehberAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Yeni başlayanlar için adım adım'**
  String get rehberAciklama;

  /// No description provided for @kazaAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Kaza namazı ve oruç sayaçları'**
  String get kazaAciklama;

  /// No description provided for @kuranAraIpucu.
  ///
  /// In tr, this message translates to:
  /// **'Sure adı veya sure:ayet ara'**
  String get kuranAraIpucu;

  /// No description provided for @sekmeSure.
  ///
  /// In tr, this message translates to:
  /// **'Sure'**
  String get sekmeSure;

  /// No description provided for @sekmeCuz.
  ///
  /// In tr, this message translates to:
  /// **'Cüz'**
  String get sekmeCuz;

  /// No description provided for @sekmeSayfa.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa'**
  String get sekmeSayfa;

  /// No description provided for @sekmeImlerim.
  ///
  /// In tr, this message translates to:
  /// **'İmlerim'**
  String get sekmeImlerim;

  /// No description provided for @kaldiginYer.
  ///
  /// In tr, this message translates to:
  /// **'Kaldığın yer'**
  String get kaldiginYer;

  /// No description provided for @mekki.
  ///
  /// In tr, this message translates to:
  /// **'Mekkî'**
  String get mekki;

  /// No description provided for @medeni.
  ///
  /// In tr, this message translates to:
  /// **'Medenî'**
  String get medeni;

  /// No description provided for @sureBilgisi.
  ///
  /// In tr, this message translates to:
  /// **'{tur} · {ayet} ayet'**
  String sureBilgisi(String tur, int ayet);

  /// No description provided for @sureAdi.
  ///
  /// In tr, this message translates to:
  /// **'{sure} Suresi'**
  String sureAdi(String sure);

  /// No description provided for @sureAyet.
  ///
  /// In tr, this message translates to:
  /// **'{sure} · {ayet}. ayet'**
  String sureAyet(String sure, int ayet);

  /// No description provided for @sureAyetUzun.
  ///
  /// In tr, this message translates to:
  /// **'{sure} Suresi · {ayet}. ayet'**
  String sureAyetUzun(String sure, int ayet);

  /// No description provided for @sureUstBilgi.
  ///
  /// In tr, this message translates to:
  /// **'{no}. sure · {ayet} ayet · {tur} · Sayfa {sayfa}'**
  String sureUstBilgi(int no, int ayet, String tur, int sayfa);

  /// No description provided for @cuzNo.
  ///
  /// In tr, this message translates to:
  /// **'{no}. Cüz'**
  String cuzNo(int no);

  /// No description provided for @sayfaNo.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa {no}'**
  String sayfaNo(int no);

  /// No description provided for @sayfaCuz.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa {sayfa} · {cuz}. cüz'**
  String sayfaCuz(int sayfa, int cuz);

  /// No description provided for @hatimYuzde.
  ///
  /// In tr, this message translates to:
  /// **'Hatim %{yuzde}'**
  String hatimYuzde(int yuzde);

  /// No description provided for @yerImiYok.
  ///
  /// In tr, this message translates to:
  /// **'Henüz yer imi yok. Okurken bir ayetin yanındaki işarete dokunarak ekleyebilirsiniz.'**
  String get yerImiYok;

  /// No description provided for @yerImiEkle.
  ///
  /// In tr, this message translates to:
  /// **'{ayet}. ayete yer imi ekle'**
  String yerImiEkle(int ayet);

  /// No description provided for @yerImiKaldir.
  ///
  /// In tr, this message translates to:
  /// **'{ayet}. ayetin yer imini kaldır'**
  String yerImiKaldir(int ayet);

  /// No description provided for @ayetNo.
  ///
  /// In tr, this message translates to:
  /// **'{no}. ayet'**
  String ayetNo(int no);

  /// No description provided for @modArapcaMeal.
  ///
  /// In tr, this message translates to:
  /// **'Arapça + Meal'**
  String get modArapcaMeal;

  /// No description provided for @modArapca.
  ///
  /// In tr, this message translates to:
  /// **'Arapça'**
  String get modArapca;

  /// No description provided for @modMeal.
  ///
  /// In tr, this message translates to:
  /// **'Meal'**
  String get modMeal;

  /// No description provided for @mealYok.
  ///
  /// In tr, this message translates to:
  /// **'Meal kaynağı eklenecek. Türkçe meal, lisans izni alındıktan sonra burada görünecek.'**
  String get mealYok;

  /// No description provided for @mealYokKisa.
  ///
  /// In tr, this message translates to:
  /// **'Meal kaynağı eklenecek'**
  String get mealYokKisa;

  /// No description provided for @sonrakiSure.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki sure: {sure}'**
  String sonrakiSure(String sure);

  /// No description provided for @tanzilKaynak.
  ///
  /// In tr, this message translates to:
  /// **'Arapça metin: Tanzil Projesi (tanzil.net)'**
  String get tanzilKaynak;

  /// No description provided for @yaziBoyutuVeGorunum.
  ///
  /// In tr, this message translates to:
  /// **'Yazı boyutu ve görünüm'**
  String get yaziBoyutuVeGorunum;

  /// No description provided for @sayfaGorunumu.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa görünümü'**
  String get sayfaGorunumu;

  /// No description provided for @ayetGorunumu.
  ///
  /// In tr, this message translates to:
  /// **'Ayet ayet görünüm'**
  String get ayetGorunumu;

  /// No description provided for @sayfaSayisi.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa {sayfa} / {toplam}'**
  String sayfaSayisi(int sayfa, int toplam);

  /// No description provided for @oncekiSayfa.
  ///
  /// In tr, this message translates to:
  /// **'Önceki sayfa'**
  String get oncekiSayfa;

  /// No description provided for @sonrakiSayfa.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki sayfa'**
  String get sonrakiSayfa;

  /// No description provided for @sayfayaGit.
  ///
  /// In tr, this message translates to:
  /// **'Sayfaya git'**
  String get sayfayaGit;

  /// No description provided for @sayfaNoIpucu.
  ///
  /// In tr, this message translates to:
  /// **'1–604'**
  String get sayfaNoIpucu;

  /// No description provided for @yerImiEkleKisa.
  ///
  /// In tr, this message translates to:
  /// **'Yer imi ekle'**
  String get yerImiEkleKisa;

  /// No description provided for @yerImiKaldirKisa.
  ///
  /// In tr, this message translates to:
  /// **'Yer imini kaldır'**
  String get yerImiKaldirKisa;

  /// No description provided for @mealSecimi.
  ///
  /// In tr, this message translates to:
  /// **'Meal'**
  String get mealSecimi;

  /// No description provided for @mealEklenmedi.
  ///
  /// In tr, this message translates to:
  /// **'Eklenmedi'**
  String get mealEklenmedi;

  /// No description provided for @kuranGorunumu.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an görünümü'**
  String get kuranGorunumu;

  /// No description provided for @lisansMealKaydi.
  ///
  /// In tr, this message translates to:
  /// **'{ad} — {sahip}. {lisans}'**
  String lisansMealKaydi(String ad, String sahip, String lisans);

  /// No description provided for @arapcaYaziBoyutu.
  ///
  /// In tr, this message translates to:
  /// **'Arapça yazı boyutu'**
  String get arapcaYaziBoyutu;

  /// No description provided for @arapcaYaziBoyutuNot.
  ///
  /// In tr, this message translates to:
  /// **'Yalnızca Kur\'an okuma ekranlarındaki Arapça metni etkiler. Genel yazı boyutu Ayarlar\'dan değiştirilir.'**
  String get arapcaYaziBoyutuNot;

  /// No description provided for @kategoriler.
  ///
  /// In tr, this message translates to:
  /// **'Kategoriler'**
  String get kategoriler;

  /// No description provided for @zikirmatik.
  ///
  /// In tr, this message translates to:
  /// **'Zikirmatik'**
  String get zikirmatik;

  /// No description provided for @namazSonrasiTesbihat.
  ///
  /// In tr, this message translates to:
  /// **'Namaz sonrası tesbihat'**
  String get namazSonrasiTesbihat;

  /// No description provided for @tesbihatOzet.
  ///
  /// In tr, this message translates to:
  /// **'Sübhânallah · Elhamdülillah · Allâhu Ekber'**
  String get tesbihatOzet;

  /// No description provided for @sayaciSifirla.
  ///
  /// In tr, this message translates to:
  /// **'Sayacı sıfırla'**
  String get sayaciSifirla;

  /// No description provided for @dokunVeSay.
  ///
  /// In tr, this message translates to:
  /// **'Dokun ve say'**
  String get dokunVeSay;

  /// No description provided for @zikirSayOkuma.
  ///
  /// In tr, this message translates to:
  /// **'{zikir} say, şu an {sayi}'**
  String zikirSayOkuma(String zikir, int sayi);

  /// No description provided for @turTamamlandi.
  ///
  /// In tr, this message translates to:
  /// **'{tur} tur tamamlandı · Allah kabul etsin'**
  String turTamamlandi(int tur);

  /// No description provided for @hedef.
  ///
  /// In tr, this message translates to:
  /// **'Hedef'**
  String get hedef;

  /// No description provided for @hedefSerbest.
  ///
  /// In tr, this message translates to:
  /// **'Serbest'**
  String get hedefSerbest;

  /// No description provided for @bugunkuToplam.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü toplam zikir'**
  String get bugunkuToplam;

  /// No description provided for @bugunkuToplamOkuma.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü toplam zikir: {adet}'**
  String bugunkuToplamOkuma(int adet);

  /// No description provided for @zikirTitresim.
  ///
  /// In tr, this message translates to:
  /// **'Dokununca titreşim'**
  String get zikirTitresim;

  /// No description provided for @zikirTumEkran.
  ///
  /// In tr, this message translates to:
  /// **'Ekranın her yerine dokunarak say'**
  String get zikirTumEkran;

  /// No description provided for @zikirTumEkranAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Telefona bakmadan sayabilirsiniz.'**
  String get zikirTumEkranAciklama;

  /// No description provided for @zikirEkranAcik.
  ///
  /// In tr, this message translates to:
  /// **'Ekran kapanmasın'**
  String get zikirEkranAcik;

  /// No description provided for @zikirArkaPlan.
  ///
  /// In tr, this message translates to:
  /// **'Arka planda manzara'**
  String get zikirArkaPlan;

  /// No description provided for @zikirArkaPlanAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Kâbe, Medine, Kudüs ve tarihî camilerin görselleri sayacın arkasında sırayla görünür.'**
  String get zikirArkaPlanAciklama;

  /// No description provided for @zikirArkaPlanSure.
  ///
  /// In tr, this message translates to:
  /// **'Değişme aralığı'**
  String get zikirArkaPlanSure;

  /// No description provided for @saniyeKisa.
  ///
  /// In tr, this message translates to:
  /// **'{saniye} sn'**
  String saniyeKisa(int saniye);

  /// No description provided for @dakikaKisa.
  ///
  /// In tr, this message translates to:
  /// **'{dakika} dk'**
  String dakikaKisa(int dakika);

  /// No description provided for @manzaraKabe.
  ///
  /// In tr, this message translates to:
  /// **'Kâbe'**
  String get manzaraKabe;

  /// No description provided for @manzaraMekke.
  ///
  /// In tr, this message translates to:
  /// **'Mekke'**
  String get manzaraMekke;

  /// No description provided for @manzaraMedine.
  ///
  /// In tr, this message translates to:
  /// **'Medine'**
  String get manzaraMedine;

  /// No description provided for @manzaraKudus.
  ///
  /// In tr, this message translates to:
  /// **'Kudüs'**
  String get manzaraKudus;

  /// No description provided for @manzaraSelimiye.
  ///
  /// In tr, this message translates to:
  /// **'Selimiye Camii'**
  String get manzaraSelimiye;

  /// No description provided for @manzaraAyasofya.
  ///
  /// In tr, this message translates to:
  /// **'Ayasofya'**
  String get manzaraAyasofya;

  /// No description provided for @manzaraUlucami.
  ///
  /// In tr, this message translates to:
  /// **'Ulu Cami'**
  String get manzaraUlucami;

  /// No description provided for @ozelZikir.
  ///
  /// In tr, this message translates to:
  /// **'Özel zikir'**
  String get ozelZikir;

  /// No description provided for @ozelZikirEkle.
  ///
  /// In tr, this message translates to:
  /// **'+ Özel zikir'**
  String get ozelZikirEkle;

  /// No description provided for @ozelZikirIpucu.
  ///
  /// In tr, this message translates to:
  /// **'Zikri yazın'**
  String get ozelZikirIpucu;

  /// No description provided for @gunlerDonem.
  ///
  /// In tr, this message translates to:
  /// **'Hicrî {yil} · {donem}'**
  String gunlerDonem(int yil, String donem);

  /// No description provided for @siradakiMubarekGun.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki mübarek gün'**
  String get siradakiMubarekGun;

  /// No description provided for @gunKaldi.
  ///
  /// In tr, this message translates to:
  /// **'gün kaldı'**
  String get gunKaldi;

  /// No description provided for @kalanGun.
  ///
  /// In tr, this message translates to:
  /// **'{gun} gün'**
  String kalanGun(int gun);

  /// No description provided for @hatirlat.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlat'**
  String get hatirlat;

  /// No description provided for @hatirlatmaAcik.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatma açık'**
  String get hatirlatmaAcik;

  /// No description provided for @gunHatirlatmaAcik.
  ///
  /// In tr, this message translates to:
  /// **'{gun} hatırlatması açık'**
  String gunHatirlatmaAcik(String gun);

  /// No description provided for @gunHatirlatmaKapali.
  ///
  /// In tr, this message translates to:
  /// **'{gun} hatırlatması kapalı'**
  String gunHatirlatmaKapali(String gun);

  /// No description provided for @tarihAraligi.
  ///
  /// In tr, this message translates to:
  /// **'{ilk}–{son} {ayYil}'**
  String tarihAraligi(int ilk, int son, String ayYil);

  /// No description provided for @gunlerNot.
  ///
  /// In tr, this message translates to:
  /// **'Tarihler resmî dinî günler takvimine göre güncellenir.'**
  String get gunlerNot;

  /// No description provided for @ayarlar.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get ayarlar;

  /// No description provided for @okunabilirlik.
  ///
  /// In tr, this message translates to:
  /// **'Okunabilirlik'**
  String get okunabilirlik;

  /// No description provided for @yaziBoyutu.
  ///
  /// In tr, this message translates to:
  /// **'Yazı boyutu'**
  String get yaziBoyutu;

  /// No description provided for @yaziNormal.
  ///
  /// In tr, this message translates to:
  /// **'Normal'**
  String get yaziNormal;

  /// No description provided for @yaziBuyuk.
  ///
  /// In tr, this message translates to:
  /// **'Büyük'**
  String get yaziBuyuk;

  /// No description provided for @yaziCokBuyuk.
  ///
  /// In tr, this message translates to:
  /// **'Çok büyük'**
  String get yaziCokBuyuk;

  /// No description provided for @yaziOrnegi.
  ///
  /// In tr, this message translates to:
  /// **'Bu metin, seçtiğiniz yazı boyutunun örneğidir.'**
  String get yaziOrnegi;

  /// No description provided for @yaziBoyutuNot.
  ///
  /// In tr, this message translates to:
  /// **'Seçtiğiniz boyut bütün ekranlarda, Kur\'an ve dualar dahil uygulanır. Telefonun kendi yazı boyutu ayarına da uyar.'**
  String get yaziBoyutuNot;

  /// No description provided for @yuksekKontrast.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek kontrast'**
  String get yuksekKontrast;

  /// No description provided for @yuksekKontrastAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Yazı ve zemin arasındaki farkı artırır.'**
  String get yuksekKontrastAciklama;

  /// No description provided for @ezanVeBildirimler.
  ///
  /// In tr, this message translates to:
  /// **'Ezan ve bildirimler'**
  String get ezanVeBildirimler;

  /// No description provided for @ezanVeBildirimlerOzet.
  ///
  /// In tr, this message translates to:
  /// **'Vakit sesleri, hatırlatma ve test bildirimi'**
  String get ezanVeBildirimlerOzet;

  /// No description provided for @konumVeVakitler.
  ///
  /// In tr, this message translates to:
  /// **'Konum ve vakitler'**
  String get konumVeVakitler;

  /// No description provided for @kuranAyarOzet.
  ///
  /// In tr, this message translates to:
  /// **'Okuma görünümü ve meal'**
  String get kuranAyarOzet;

  /// No description provided for @tema.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get tema;

  /// No description provided for @temaAcik.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get temaAcik;

  /// No description provided for @temaKoyu.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get temaKoyu;

  /// No description provided for @alarmOlarakCal.
  ///
  /// In tr, this message translates to:
  /// **'Ezanı alarm olarak çal'**
  String get alarmOlarakCal;

  /// No description provided for @alarmOlarakCalAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Medya sesi kısık olsa da, ekran kapalıyken de ezan duyulur.'**
  String get alarmOlarakCalAciklama;

  /// No description provided for @onceHatirlat.
  ///
  /// In tr, this message translates to:
  /// **'Vakitten 15 dk önce hatırlat'**
  String get onceHatirlat;

  /// No description provided for @onceHatirlatAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Özellikle sabah ve sahur için ikinci bir uyarı.'**
  String get onceHatirlatAciklama;

  /// No description provided for @cumaSessiz.
  ///
  /// In tr, this message translates to:
  /// **'Cuma namazında sessiz'**
  String get cumaSessiz;

  /// No description provided for @cumaSessizAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Cuma günü öğle vaktinde ezan yerine titreşim.'**
  String get cumaSessizAciklama;

  /// No description provided for @vakitBildirimleri.
  ///
  /// In tr, this message translates to:
  /// **'Vakit bildirimleri'**
  String get vakitBildirimleri;

  /// No description provided for @vakitBildirimleriAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Her vakit için aç/kapa ve ses seçimi'**
  String get vakitBildirimleriAciklama;

  /// No description provided for @sesEzan.
  ///
  /// In tr, this message translates to:
  /// **'Ezan'**
  String get sesEzan;

  /// No description provided for @sesKisa.
  ///
  /// In tr, this message translates to:
  /// **'Kısa uyarı'**
  String get sesKisa;

  /// No description provided for @sesTitresim.
  ///
  /// In tr, this message translates to:
  /// **'Titreşim'**
  String get sesTitresim;

  /// No description provided for @ezanSesiYokNot.
  ///
  /// In tr, this message translates to:
  /// **'Ezan kaydı henüz eklenmedi; \"Ezan\" seçili vakitlerde telefonun varsayılan bildirim sesi çalar.'**
  String get ezanSesiYokNot;

  /// No description provided for @bildirimIzniYok.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim izni verilmedi; ezan vakitlerinde bildirim gelmez.'**
  String get bildirimIzniYok;

  /// No description provided for @bildirimIzniVer.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimlere izin ver'**
  String get bildirimIzniVer;

  /// No description provided for @tamZamanliYok.
  ///
  /// In tr, this message translates to:
  /// **'Tam zamanlı alarm izni kapalı; ezan birkaç dakika gecikebilir.'**
  String get tamZamanliYok;

  /// No description provided for @tamZamanliIzinVer.
  ///
  /// In tr, this message translates to:
  /// **'Tam zamanlı alarma izin ver'**
  String get tamZamanliIzinVer;

  /// No description provided for @testBildirimiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Ezan bildiriminin telefonunuzda çaldığını hemen doğrulayın.'**
  String get testBildirimiAciklama;

  /// No description provided for @testBildirimiGonder.
  ///
  /// In tr, this message translates to:
  /// **'Test bildirimi gönder'**
  String get testBildirimiGonder;

  /// No description provided for @testBildirimiGonderildi.
  ///
  /// In tr, this message translates to:
  /// **'Birkaç saniye içinde bildirim gelecek.'**
  String get testBildirimiGonderildi;

  /// No description provided for @pilBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Ezanın her durumda çalması için'**
  String get pilBaslik;

  /// No description provided for @pilMetin.
  ///
  /// In tr, this message translates to:
  /// **'Telefonunuz pil tasarrufu için uygulamayı durdurabilir. Bu uygulama için pil optimizasyonunu kapatın.'**
  String get pilMetin;

  /// No description provided for @ayariAc.
  ///
  /// In tr, this message translates to:
  /// **'Ayarı aç'**
  String get ayariAc;

  /// No description provided for @markaSamsung.
  ///
  /// In tr, this message translates to:
  /// **'Samsung'**
  String get markaSamsung;

  /// No description provided for @markaSamsungYol.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar > Uygulamalar > Abyad > Pil > \"Kısıtlamasız\" seçin.'**
  String get markaSamsungYol;

  /// No description provided for @markaXiaomi.
  ///
  /// In tr, this message translates to:
  /// **'Xiaomi'**
  String get markaXiaomi;

  /// No description provided for @markaXiaomiYol.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar > Uygulamalar > Abyad > Pil tasarrufu > \"Kısıtlama yok\" seçin; ayrıca \"Otomatik başlatma\"yı açın.'**
  String get markaXiaomiYol;

  /// No description provided for @markaHuawei.
  ///
  /// In tr, this message translates to:
  /// **'Huawei / Honor'**
  String get markaHuawei;

  /// No description provided for @markaHuaweiYol.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar > Uygulamalar > Uygulama başlatma > Abyad > \"Elle yönet\" seçip üç seçeneği de açın.'**
  String get markaHuaweiYol;

  /// No description provided for @vakitHesaplama.
  ///
  /// In tr, this message translates to:
  /// **'Vakit hesaplama'**
  String get vakitHesaplama;

  /// No description provided for @hesaplamaYontemi.
  ///
  /// In tr, this message translates to:
  /// **'Hesaplama yöntemi'**
  String get hesaplamaYontemi;

  /// No description provided for @dakikaDuzeltme.
  ///
  /// In tr, this message translates to:
  /// **'Vakitlere dakika ekle/çıkar'**
  String get dakikaDuzeltme;

  /// No description provided for @dakikaDuzeltmeAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Camideki ezan vaktiyle fark varsa her vakit için dakika ekleyip çıkarabilirsiniz.'**
  String get dakikaDuzeltmeAciklama;

  /// No description provided for @dakikaArtir.
  ///
  /// In tr, this message translates to:
  /// **'{vakit}: bir dakika ekle'**
  String dakikaArtir(String vakit);

  /// No description provided for @dakikaAzalt.
  ///
  /// In tr, this message translates to:
  /// **'{vakit}: bir dakika çıkar'**
  String dakikaAzalt(String vakit);

  /// No description provided for @dakikaDeger.
  ///
  /// In tr, this message translates to:
  /// **'{dakika} dakika'**
  String dakikaDeger(int dakika);

  /// No description provided for @hicriDuzeltme.
  ///
  /// In tr, this message translates to:
  /// **'Hicrî tarih düzeltmesi'**
  String get hicriDuzeltme;

  /// No description provided for @hicriDuzeltmeAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Hicrî gün, bulunduğunuz yerdeki takvimden bir gün farklıysa düzeltin.'**
  String get hicriDuzeltmeAciklama;

  /// No description provided for @gunEksiBir.
  ///
  /// In tr, this message translates to:
  /// **'−1 gün'**
  String get gunEksiBir;

  /// No description provided for @gunFarkiYok.
  ///
  /// In tr, this message translates to:
  /// **'Düzeltme yok'**
  String get gunFarkiYok;

  /// No description provided for @gunArtiBir.
  ///
  /// In tr, this message translates to:
  /// **'+1 gün'**
  String get gunArtiBir;

  /// No description provided for @mahremiyetBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Mahremiyetiniz emanettir'**
  String get mahremiyetBaslik;

  /// No description provided for @mahremiyetMetin.
  ///
  /// In tr, this message translates to:
  /// **'Bu uygulama hiçbir veri toplamaz, reklam göstermez ve hesap istemez. Konumunuz sadece vakitleri hesaplamak için bu telefonda kullanılır, hiçbir yere gönderilmez.'**
  String get mahremiyetMetin;

  /// No description provided for @kaynaklarVeLisanslar.
  ///
  /// In tr, this message translates to:
  /// **'Kaynaklar ve Lisanslar'**
  String get kaynaklarVeLisanslar;

  /// No description provided for @surumBilgisi.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm {surum} · Ücretsizdir, ücretsiz kalacaktır.'**
  String surumBilgisi(String surum);

  /// No description provided for @lisansKuranBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an-ı Kerim metni'**
  String get lisansKuranBaslik;

  /// No description provided for @lisansKuranMetin.
  ///
  /// In tr, this message translates to:
  /// **'Arapça metin, Tanzil Projesi\'nin Uthmani metnidir (sürüm 1.1, tanzil.net). Creative Commons Attribution 3.0 lisansı gereği metin değiştirilmeden kullanılmıştır. Sure, cüz ve sayfa bilgileri de Tanzil üst verisinden gelir.'**
  String get lisansKuranMetin;

  /// No description provided for @lisansMealBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe meal'**
  String get lisansMealBaslik;

  /// No description provided for @lisansMealMetin.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bir meal eklenmedi. Meal, yalnızca hak sahibinden izin alındıktan sonra eklenecektir.'**
  String get lisansMealMetin;

  /// No description provided for @lisansSehirBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Şehir koordinatları'**
  String get lisansSehirBaslik;

  /// No description provided for @lisansSehirMetin.
  ///
  /// In tr, this message translates to:
  /// **'İl, ilçe ve yurt dışı şehir koordinatları GeoNames (geonames.org) verisinden alınmıştır. Creative Commons Attribution 4.0.'**
  String get lisansSehirMetin;

  /// No description provided for @lisansYaziBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Yazı tipleri'**
  String get lisansYaziBaslik;

  /// No description provided for @lisansYaziMetin.
  ///
  /// In tr, this message translates to:
  /// **'Manrope, Fraunces ve Amiri; SIL Open Font License 1.1 ile lisanslıdır.'**
  String get lisansYaziMetin;

  /// No description provided for @lisansEzanBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Ezan sesi'**
  String get lisansEzanBaslik;

  /// No description provided for @lisansEzanMetin.
  ///
  /// In tr, this message translates to:
  /// **'Henüz ezan kaydı eklenmedi; telefonun varsayılan bildirim sesi kullanılıyor. Kayıt, yalnızca izinli ya da lisanslı bir kaynaktan eklenecektir.'**
  String get lisansEzanMetin;

  /// No description provided for @lisansIcerikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Dua ve bilgi metinleri'**
  String get lisansIcerikBaslik;

  /// No description provided for @lisansIcerikMetin.
  ///
  /// In tr, this message translates to:
  /// **'Dualar, okunuşlar, Esmâ-ül Hüsnâ anlamları ve rehber metinleri yayın öncesinde bir hoca tarafından incelenecektir. Vakit hesaplama parametreleri açık kaynaklı Adhan kütüphanesindeki Türkiye yöntemine dayanır.'**
  String get lisansIcerikMetin;

  /// No description provided for @lisansHadisBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kırk Hadis'**
  String get lisansHadisBaslik;

  /// No description provided for @lisansHadisMetin.
  ///
  /// In tr, this message translates to:
  /// **'Hadislerin Arapça metni İmam Nevevî\'nin Kırk Hadis\'inden (el-Erbaûn) alınmıştır; eser kamu malıdır. Türkçe tercümeler Abyad için hazırlanmıştır ve yayın öncesinde bir hoca tarafından incelenecektir.'**
  String get lisansHadisMetin;

  /// No description provided for @lisansCizimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Çizimler ve görseller'**
  String get lisansCizimBaslik;

  /// No description provided for @lisansCizimMetin.
  ///
  /// In tr, this message translates to:
  /// **'Namaz ve abdest rehberindeki çizimler Abyad için hazırlanmıştır; başka bir kaynaktan alınmamıştır. Zikirmatik arka planındaki manzara görselleri yapay zekâ ile üretilmiştir; fotoğraf değildir, mekânları temsilen gösterir.'**
  String get lisansCizimMetin;

  /// No description provided for @lisansPaketler.
  ///
  /// In tr, this message translates to:
  /// **'Kullanılan yazılım paketleri'**
  String get lisansPaketler;

  /// No description provided for @kanalEzanAlarm.
  ///
  /// In tr, this message translates to:
  /// **'Ezan (alarm sesiyle)'**
  String get kanalEzanAlarm;

  /// No description provided for @kanalEzan.
  ///
  /// In tr, this message translates to:
  /// **'Ezan'**
  String get kanalEzan;

  /// No description provided for @kanalHatirlatma.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatmalar'**
  String get kanalHatirlatma;

  /// No description provided for @kanalTitresim.
  ///
  /// In tr, this message translates to:
  /// **'Sessiz (titreşim)'**
  String get kanalTitresim;

  /// No description provided for @kanalAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Namaz vakti bildirimleri'**
  String get kanalAciklama;

  /// No description provided for @bildirimVakitBaslik.
  ///
  /// In tr, this message translates to:
  /// **'{vakit} vakti'**
  String bildirimVakitBaslik(String vakit);

  /// No description provided for @bildirimVakitGovde.
  ///
  /// In tr, this message translates to:
  /// **'{sehir} · {saat}'**
  String bildirimVakitGovde(String sehir, String saat);

  /// No description provided for @bildirimOnceBaslik.
  ///
  /// In tr, this message translates to:
  /// **'{vakit} vaktine {dakika} dakika kaldı'**
  String bildirimOnceBaslik(String vakit, int dakika);

  /// No description provided for @bildirimGunGovde.
  ///
  /// In tr, this message translates to:
  /// **'Bugün mübarek bir gün. Hayırlara vesile olsun.'**
  String get bildirimGunGovde;

  /// No description provided for @bildirimTestBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Test bildirimi'**
  String get bildirimTestBaslik;

  /// No description provided for @bildirimTestGovde.
  ///
  /// In tr, this message translates to:
  /// **'Bu bildirimi duyduysanız ezan bildirimleri çalışıyor.'**
  String get bildirimTestGovde;

  /// No description provided for @ilkAdim.
  ///
  /// In tr, this message translates to:
  /// **'Adım {adim} / {toplam}'**
  String ilkAdim(int adim, int toplam);

  /// No description provided for @ilkVaatBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Reklam yok, veri yok, hesap yok.'**
  String get ilkVaatBaslik;

  /// No description provided for @ilkVaatMetin.
  ///
  /// In tr, this message translates to:
  /// **'Abyad tamamen ücretsizdir ve öyle kalacak. Hiçbir verinizi toplamaz, internete bağlanmaz, sizden hesap istemez. Vakitler, Kur\'an ve dualar telefonunuzun içindedir.'**
  String get ilkVaatMetin;

  /// No description provided for @ilkKonumBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Vakitler için konumunuz'**
  String get ilkKonumBaslik;

  /// No description provided for @ilkKonumMetin.
  ///
  /// In tr, this message translates to:
  /// **'Namaz vakitlerini bulunduğunuz yere göre hesaplamak için konumunuzu kullanırız. Konumunuz yalnızca vakitleri hesaplamak içindir, telefonunuzda kalır ve hiçbir yere gönderilmez. İsterseniz konum izni vermeden şehrinizi listeden seçebilirsiniz.'**
  String get ilkKonumMetin;

  /// No description provided for @ilkKonumAlinamadi.
  ///
  /// In tr, this message translates to:
  /// **'Konum alınamadı. Şehrinizi listeden seçebilirsiniz.'**
  String get ilkKonumAlinamadi;

  /// No description provided for @sehrimiSecerim.
  ///
  /// In tr, this message translates to:
  /// **'Şehrimi listeden seçeyim'**
  String get sehrimiSecerim;

  /// No description provided for @simdilikAtla.
  ///
  /// In tr, this message translates to:
  /// **'Şimdilik atla (İstanbul ile devam et)'**
  String get simdilikAtla;

  /// No description provided for @ilkBildirimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Ezan vaktinde haber verelim'**
  String get ilkBildirimBaslik;

  /// No description provided for @ilkBildirimMetin.
  ///
  /// In tr, this message translates to:
  /// **'Vakit girdiğinde ezan bildirimi gönderebilmemiz için bildirim iznine ihtiyacımız var. Hangi vakitlerde bildirim alacağınızı sonra Ayarlar\'dan değiştirebilirsiniz.'**
  String get ilkBildirimMetin;

  /// No description provided for @ilkBildirimMetinAndroid.
  ///
  /// In tr, this message translates to:
  /// **'Vakit girdiğinde ezan bildirimi gönderebilmemiz için bildirim iznine ihtiyacımız var. Ezanın tam vaktinde çalması için telefonunuz \"Alarmlar ve hatırlatıcılar\" iznini de sorabilir. Bazı telefonlar pil tasarrufu için uygulamayı durdurur; bunu Ayarlar\'daki yönergelerle kapatabilirsiniz.'**
  String get ilkBildirimMetinAndroid;

  /// No description provided for @kazaTakibi.
  ///
  /// In tr, this message translates to:
  /// **'Kaza Takibi'**
  String get kazaTakibi;

  /// No description provided for @gizle.
  ///
  /// In tr, this message translates to:
  /// **'Gizle'**
  String get gizle;

  /// No description provided for @goster.
  ///
  /// In tr, this message translates to:
  /// **'Göster'**
  String get goster;

  /// No description provided for @sayilariGizle.
  ///
  /// In tr, this message translates to:
  /// **'Sayıları gizle'**
  String get sayilariGizle;

  /// No description provided for @sayilariGoster.
  ///
  /// In tr, this message translates to:
  /// **'Sayıları göster'**
  String get sayilariGoster;

  /// No description provided for @kalanKaza.
  ///
  /// In tr, this message translates to:
  /// **'Kalan kaza namazı'**
  String get kalanKaza;

  /// No description provided for @tahminiBitis.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini bitiş'**
  String get tahminiBitis;

  /// No description provided for @kazaYok.
  ///
  /// In tr, this message translates to:
  /// **'Borç yok'**
  String get kazaYok;

  /// No description provided for @kazaOzetGizli.
  ///
  /// In tr, this message translates to:
  /// **'Kaza sayıları gizli'**
  String get kazaOzetGizli;

  /// No description provided for @kazaOzetOkuma.
  ///
  /// In tr, this message translates to:
  /// **'Kalan kaza namazı {adet}. Tahmini bitiş: {sure}'**
  String kazaOzetOkuma(int adet, String sure);

  /// No description provided for @gundeKacVakit.
  ///
  /// In tr, this message translates to:
  /// **'Günde kaç vakit kaza kılarım?'**
  String get gundeKacVakit;

  /// No description provided for @gundeVakit.
  ///
  /// In tr, this message translates to:
  /// **'Günde {adet} vakit'**
  String gundeVakit(int adet);

  /// No description provided for @bugunKazaKildiniz.
  ///
  /// In tr, this message translates to:
  /// **'Bugün {adet} kaza kıldınız. Allah kabul etsin.'**
  String bugunKazaKildiniz(int adet);

  /// No description provided for @kazaSabah.
  ///
  /// In tr, this message translates to:
  /// **'Sabah'**
  String get kazaSabah;

  /// No description provided for @kazaVitir.
  ///
  /// In tr, this message translates to:
  /// **'Vitir'**
  String get kazaVitir;

  /// No description provided for @kazaOruc.
  ///
  /// In tr, this message translates to:
  /// **'Ramazan kazası'**
  String get kazaOruc;

  /// No description provided for @kazaKaldi.
  ///
  /// In tr, this message translates to:
  /// **'{adet} kaldı'**
  String kazaKaldi(int adet);

  /// No description provided for @orucKaldi.
  ///
  /// In tr, this message translates to:
  /// **'{adet} gün kaldı'**
  String orucKaldi(int adet);

  /// No description provided for @kazaEkle.
  ///
  /// In tr, this message translates to:
  /// **'{namaz} kazası ekle'**
  String kazaEkle(String namaz);

  /// No description provided for @kazaKildimOkuma.
  ///
  /// In tr, this message translates to:
  /// **'Bir {namaz} kazası kıldım'**
  String kazaKildimOkuma(String namaz);

  /// No description provided for @kildim.
  ///
  /// In tr, this message translates to:
  /// **'Kıldım'**
  String get kildim;

  /// No description provided for @tuttum.
  ///
  /// In tr, this message translates to:
  /// **'Tuttum'**
  String get tuttum;

  /// No description provided for @orucEkle.
  ///
  /// In tr, this message translates to:
  /// **'Kaza orucu ekle'**
  String get orucEkle;

  /// No description provided for @orucTuttumOkuma.
  ///
  /// In tr, this message translates to:
  /// **'Bir kaza orucu tuttum'**
  String get orucTuttumOkuma;

  /// No description provided for @kazaNasilHesaplarim.
  ///
  /// In tr, this message translates to:
  /// **'Kaza borcumu nasıl hesaplarım?'**
  String get kazaNasilHesaplarim;

  /// No description provided for @kazaHesapAlt.
  ///
  /// In tr, this message translates to:
  /// **'Adım adım hesaplama ve kısa fıkıh bilgisi'**
  String get kazaHesapAlt;

  /// No description provided for @kazaMahremiyet.
  ///
  /// In tr, this message translates to:
  /// **'Bu bilgiler sadece bu telefonda saklanır.'**
  String get kazaMahremiyet;

  /// No description provided for @sureYilAy.
  ///
  /// In tr, this message translates to:
  /// **'yaklaşık {yil} yıl {ay} ay'**
  String sureYilAy(int yil, int ay);

  /// No description provided for @sureYil.
  ///
  /// In tr, this message translates to:
  /// **'yaklaşık {yil} yıl'**
  String sureYil(int yil);

  /// No description provided for @sureAyGun.
  ///
  /// In tr, this message translates to:
  /// **'yaklaşık {ay} ay {gun} gün'**
  String sureAyGun(int ay, int gun);

  /// No description provided for @sureAy.
  ///
  /// In tr, this message translates to:
  /// **'yaklaşık {ay} ay'**
  String sureAy(int ay);

  /// No description provided for @sureGun.
  ///
  /// In tr, this message translates to:
  /// **'{gun} gün'**
  String sureGun(int gun);

  /// No description provided for @kazaHesaplama.
  ///
  /// In tr, this message translates to:
  /// **'Kaza Borcu Hesaplama'**
  String get kazaHesaplama;

  /// No description provided for @kazaHesaplamaGiris.
  ///
  /// In tr, this message translates to:
  /// **'Kaç yıl namaz kılmadığınızı ve oruç tutmadığınızı girin; yaklaşık kaza sayınızı hesaplayalım. Sonuç bir tahmindir, sayaçları sonradan elle düzeltebilirsiniz.'**
  String get kazaHesaplamaGiris;

  /// No description provided for @sihirbazNamazYil.
  ///
  /// In tr, this message translates to:
  /// **'Namaz kılmadığım yıl'**
  String get sihirbazNamazYil;

  /// No description provided for @sihirbazNamazYilAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Buluğ çağından sonra namaz kılmadığınız süre.'**
  String get sihirbazNamazYilAciklama;

  /// No description provided for @sihirbazNamazAy.
  ///
  /// In tr, this message translates to:
  /// **'Ek ay'**
  String get sihirbazNamazAy;

  /// No description provided for @sihirbazOzurGun.
  ///
  /// In tr, this message translates to:
  /// **'Aylık özür günü (kadınlar)'**
  String get sihirbazOzurGun;

  /// No description provided for @sihirbazOzurGunAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Âdet günlerinde kılınmayan namazların kazası yoktur; bu günler hesaptan düşülür.'**
  String get sihirbazOzurGunAciklama;

  /// No description provided for @sihirbazOrucYil.
  ///
  /// In tr, this message translates to:
  /// **'Oruç tutmadığım Ramazan sayısı'**
  String get sihirbazOrucYil;

  /// No description provided for @sihirbazOrucYilAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Her Ramazan 30 gün sayılır.'**
  String get sihirbazOrucYilAciklama;

  /// No description provided for @sihirbazSonuc.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini kaza borcu'**
  String get sihirbazSonuc;

  /// No description provided for @sihirbazSonucNamaz.
  ///
  /// In tr, this message translates to:
  /// **'Her vakit ve vitir için {adet} namaz'**
  String sihirbazSonucNamaz(int adet);

  /// No description provided for @sihirbazSonucOruc.
  ///
  /// In tr, this message translates to:
  /// **'{adet} gün oruç'**
  String sihirbazSonucOruc(int adet);

  /// No description provided for @sihirbazUygula.
  ///
  /// In tr, this message translates to:
  /// **'Sayaçlara uygula'**
  String get sihirbazUygula;

  /// No description provided for @sihirbazOnayBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Sayaçlar değiştirilsin mi?'**
  String get sihirbazOnayBaslik;

  /// No description provided for @sihirbazOnayMetin.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut kaza sayılarınız bu hesaplamanın sonucuyla değiştirilecek.'**
  String get sihirbazOnayMetin;

  /// No description provided for @kisaFikihBilgisi.
  ///
  /// In tr, this message translates to:
  /// **'Kısa fıkıh bilgisi'**
  String get kisaFikihBilgisi;

  /// No description provided for @fikihNot.
  ///
  /// In tr, this message translates to:
  /// **'Bu bilgiler Hanefi mezhebine göre özettir. Özel durumunuz için bir din görevlisine danışın.'**
  String get fikihNot;

  /// No description provided for @adimNo.
  ///
  /// In tr, this message translates to:
  /// **'Adım {adim} / {toplam}'**
  String adimNo(int adim, int toplam);

  /// No description provided for @cizimAlani.
  ///
  /// In tr, this message translates to:
  /// **'Çizim alanı · {adim}'**
  String cizimAlani(String adim);

  /// No description provided for @sonrakiAdim.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki adım'**
  String get sonrakiAdim;

  /// No description provided for @hareketiTekrarla.
  ///
  /// In tr, this message translates to:
  /// **'Hareketi tekrar göster'**
  String get hareketiTekrarla;

  /// No description provided for @bastanBasla.
  ///
  /// In tr, this message translates to:
  /// **'Baştan başla'**
  String get bastanBasla;

  /// No description provided for @rehberNamazSec.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenmek istediğiniz namazı ve bölümünü seçin.'**
  String get rehberNamazSec;

  /// No description provided for @rehberIcerikBekleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Bu bölümün içeriği hazırlanıyor.'**
  String get rehberIcerikBekleniyor;

  /// No description provided for @rekatSayisi.
  ///
  /// In tr, this message translates to:
  /// **'{rekat} rekat'**
  String rekatSayisi(int rekat);

  /// No description provided for @rehberBolumBasligi.
  ///
  /// In tr, this message translates to:
  /// **'{vakit} – {bolum}'**
  String rehberBolumBasligi(String vakit, String bolum);

  /// No description provided for @rekatAdim.
  ///
  /// In tr, this message translates to:
  /// **'{rekat}. rekat · {adim}'**
  String rekatAdim(int rekat, String adim);

  /// No description provided for @tekrarSayisi.
  ///
  /// In tr, this message translates to:
  /// **'{adet} kez'**
  String tekrarSayisi(int adet);

  /// No description provided for @ornekSure.
  ///
  /// In tr, this message translates to:
  /// **'Örnek sure: {sure}'**
  String ornekSure(String sure);

  /// No description provided for @kadinlarIcin.
  ///
  /// In tr, this message translates to:
  /// **'Kadınlar için'**
  String get kadinlarIcin;

  /// No description provided for @okunusuDinle.
  ///
  /// In tr, this message translates to:
  /// **'Okunuşu dinle'**
  String get okunusuDinle;

  /// No description provided for @ezberAc.
  ///
  /// In tr, this message translates to:
  /// **'Ezber modunu aç'**
  String get ezberAc;

  /// No description provided for @ezberKapat.
  ///
  /// In tr, this message translates to:
  /// **'Ezber modunu kapat'**
  String get ezberKapat;

  /// No description provided for @ezberAcik.
  ///
  /// In tr, this message translates to:
  /// **'Ezber modu açık: Arapça metin ve okunuş gizli, görmek için dokunun.'**
  String get ezberAcik;

  /// No description provided for @ezberGoster.
  ///
  /// In tr, this message translates to:
  /// **'Göstermek için dokunun'**
  String get ezberGoster;

  /// No description provided for @abdestRehberi.
  ///
  /// In tr, this message translates to:
  /// **'Abdest Rehberi'**
  String get abdestRehberi;

  /// No description provided for @abdestAltBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Abdestin adım adım alınışı'**
  String get abdestAltBaslik;

  /// No description provided for @abdestRehberiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Abdestin alınışı {adet} adımda, çizimlerle anlatılır.'**
  String abdestRehberiAciklama(int adet);

  /// No description provided for @abdestBasla.
  ///
  /// In tr, this message translates to:
  /// **'Abdest adımlarına başla'**
  String get abdestBasla;

  /// No description provided for @abdestiBozanlar.
  ///
  /// In tr, this message translates to:
  /// **'Abdesti bozan durumlar'**
  String get abdestiBozanlar;

  /// No description provided for @hadisBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kırk Hadis'**
  String get hadisBaslik;

  /// No description provided for @hadisAltBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Hz. Peygamber\'in (s.a.v.) sözlerinden'**
  String get hadisAltBaslik;

  /// No description provided for @hadisAciklama.
  ///
  /// In tr, this message translates to:
  /// **'İmam Nevevî\'nin derlemesi'**
  String get hadisAciklama;

  /// No description provided for @hadisBekleniyorBaslik.
  ///
  /// In tr, this message translates to:
  /// **'İçerik hazırlanıyor'**
  String get hadisBekleniyorBaslik;

  /// No description provided for @hadisBekleniyorMetin.
  ///
  /// In tr, this message translates to:
  /// **'Hadisleri kaynağı ve tercümesi belli olmadan eklemiyoruz. Derleme seçilip bir hoca tarafından incelendikten sonra kırk hadis burada yer alacak.'**
  String get hadisBekleniyorMetin;

  /// No description provided for @hadisNo.
  ///
  /// In tr, this message translates to:
  /// **'{no}. hadis'**
  String hadisNo(int no);

  /// No description provided for @hadisRavi.
  ///
  /// In tr, this message translates to:
  /// **'Rivayet eden: {ravi}'**
  String hadisRavi(String ravi);

  /// No description provided for @hadisTercume.
  ///
  /// In tr, this message translates to:
  /// **'Tercüme: {kaynak}'**
  String hadisTercume(String kaynak);

  /// No description provided for @hadisHikayeEtiket.
  ///
  /// In tr, this message translates to:
  /// **'Temsilî hikâye'**
  String get hadisHikayeEtiket;

  /// No description provided for @hadisHikayeNot.
  ///
  /// In tr, this message translates to:
  /// **'Bu hikâye, hadisin daha iyi anlaşılması için yazılmış kurgusal bir anlatıdır; yaşanmış bir olay ya da rivayet değildir.'**
  String get hadisHikayeNot;

  /// No description provided for @hatimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Toplu Hatim'**
  String get hatimBaslik;

  /// No description provided for @hatimAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Hatmi cüz cüz, sayfa sayfa takip edin'**
  String get hatimAciklama;

  /// No description provided for @hatimYeni.
  ///
  /// In tr, this message translates to:
  /// **'Yeni hatim'**
  String get hatimYeni;

  /// No description provided for @hatimBaslat.
  ///
  /// In tr, this message translates to:
  /// **'Hatim başlat'**
  String get hatimBaslat;

  /// No description provided for @hatimBosBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Henüz hatim yok'**
  String get hatimBosBaslik;

  /// No description provided for @hatimBosMetin.
  ///
  /// In tr, this message translates to:
  /// **'Bir hatim başlatın; cüzleri ya da sayfaları pay pay alın, okudukça işaretleyin.'**
  String get hatimBosMetin;

  /// No description provided for @hatimYerelNotBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Linkle paylaşım henüz açık değil'**
  String get hatimYerelNotBaslik;

  /// No description provided for @hatimYerelNot.
  ///
  /// In tr, this message translates to:
  /// **'Hatmi aileniz ve arkadaşlarınızla linkle paylaşma özelliği hazırlanıyor. Şimdilik hatmi bu telefonda başlatıp payları kendiniz takip edebilirsiniz. Bilgileriniz telefonunuzda kalır, hiçbir yere gönderilmez.'**
  String get hatimYerelNot;

  /// No description provided for @hatimDevamEden.
  ///
  /// In tr, this message translates to:
  /// **'Devam eden hatim'**
  String get hatimDevamEden;

  /// No description provided for @hatimTamamlandi.
  ///
  /// In tr, this message translates to:
  /// **'Hatim tamamlandı'**
  String get hatimTamamlandi;

  /// No description provided for @hatimIlerlemeCuz.
  ///
  /// In tr, this message translates to:
  /// **'{okunan} / {toplam} cüz okundu'**
  String hatimIlerlemeCuz(int okunan, int toplam);

  /// No description provided for @hatimIlerlemePay.
  ///
  /// In tr, this message translates to:
  /// **'{okunan} / {toplam} pay okundu'**
  String hatimIlerlemePay(int okunan, int toplam);

  /// No description provided for @hatimHedef.
  ///
  /// In tr, this message translates to:
  /// **'Hedef: {tarih}'**
  String hatimHedef(String tarih);

  /// No description provided for @hatimAdi.
  ///
  /// In tr, this message translates to:
  /// **'Hatmin adı'**
  String get hatimAdi;

  /// No description provided for @hatimAdiIpucu.
  ///
  /// In tr, this message translates to:
  /// **'Örnek: Ramazan Aile Hatmi'**
  String get hatimAdiIpucu;

  /// No description provided for @hatimNotu.
  ///
  /// In tr, this message translates to:
  /// **'Niyet notu (isteğe bağlı)'**
  String get hatimNotu;

  /// No description provided for @hatimNotuIpucu.
  ///
  /// In tr, this message translates to:
  /// **'Örnek: Annemizin ruhu için'**
  String get hatimNotuIpucu;

  /// No description provided for @hatimBolme.
  ///
  /// In tr, this message translates to:
  /// **'Bölme şekli'**
  String get hatimBolme;

  /// No description provided for @hatimCuzCuz.
  ///
  /// In tr, this message translates to:
  /// **'Cüz cüz'**
  String get hatimCuzCuz;

  /// No description provided for @hatimSayfaSayfa.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa sayfa'**
  String get hatimSayfaSayfa;

  /// No description provided for @hatimBolmeCuzAciklama.
  ///
  /// In tr, this message translates to:
  /// **'{pay} pay; her pay bir cüz.'**
  String hatimBolmeCuzAciklama(int pay);

  /// No description provided for @hatimBolmeSayfaAciklama.
  ///
  /// In tr, this message translates to:
  /// **'{pay} pay; her pay {sayfa} sayfa.'**
  String hatimBolmeSayfaAciklama(int pay, int sayfa);

  /// No description provided for @hatimHedefTarih.
  ///
  /// In tr, this message translates to:
  /// **'Hedef tarih'**
  String get hatimHedefTarih;

  /// No description provided for @hatimHedefYok.
  ///
  /// In tr, this message translates to:
  /// **'Belirlenmedi'**
  String get hatimHedefYok;

  /// No description provided for @hatimHedefKaldir.
  ///
  /// In tr, this message translates to:
  /// **'Hedef tarihi kaldır'**
  String get hatimHedefKaldir;

  /// No description provided for @hataBos.
  ///
  /// In tr, this message translates to:
  /// **'Bu alan boş bırakılamaz.'**
  String get hataBos;

  /// No description provided for @hataUzun.
  ///
  /// In tr, this message translates to:
  /// **'En fazla {sinir} karakter yazabilirsiniz.'**
  String hataUzun(int sinir);

  /// No description provided for @hataLink.
  ///
  /// In tr, this message translates to:
  /// **'Bu alana link yazılamaz.'**
  String get hataLink;

  /// No description provided for @hatimCuzSec.
  ///
  /// In tr, this message translates to:
  /// **'Bir cüz seç'**
  String get hatimCuzSec;

  /// No description provided for @hatimCuzSecAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Boş bir cüze dokunarak sorumluluğu al.'**
  String get hatimCuzSecAciklama;

  /// No description provided for @hatimSayfaSec.
  ///
  /// In tr, this message translates to:
  /// **'Bir sayfa aralığı seç'**
  String get hatimSayfaSec;

  /// No description provided for @hatimSayfaSecAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Boş bir sayfa aralığına dokunarak sorumluluğu al.'**
  String get hatimSayfaSecAciklama;

  /// No description provided for @durumOkundu.
  ///
  /// In tr, this message translates to:
  /// **'Okundu'**
  String get durumOkundu;

  /// No description provided for @durumAlindi.
  ///
  /// In tr, this message translates to:
  /// **'Alındı'**
  String get durumAlindi;

  /// No description provided for @durumSenin.
  ///
  /// In tr, this message translates to:
  /// **'Senin'**
  String get durumSenin;

  /// No description provided for @durumBos.
  ///
  /// In tr, this message translates to:
  /// **'Boş'**
  String get durumBos;

  /// No description provided for @hatimCuzAdi.
  ///
  /// In tr, this message translates to:
  /// **'{no}. cüz'**
  String hatimCuzAdi(int no);

  /// No description provided for @hatimSayfaAdi.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa {bas}–{bit}'**
  String hatimSayfaAdi(int bas, int bit);

  /// No description provided for @seninPayin.
  ///
  /// In tr, this message translates to:
  /// **'Senin payın'**
  String get seninPayin;

  /// No description provided for @okumayaBasla.
  ///
  /// In tr, this message translates to:
  /// **'Okumaya başla'**
  String get okumayaBasla;

  /// No description provided for @okudum.
  ///
  /// In tr, this message translates to:
  /// **'Okudum'**
  String get okudum;

  /// No description provided for @payiBirak.
  ///
  /// In tr, this message translates to:
  /// **'Bırak'**
  String get payiBirak;

  /// No description provided for @geriAl.
  ///
  /// In tr, this message translates to:
  /// **'Geri al'**
  String get geriAl;

  /// No description provided for @hatimAlinmis.
  ///
  /// In tr, this message translates to:
  /// **'Bu pay az önce alındı.'**
  String get hatimAlinmis;

  /// No description provided for @hatimSil.
  ///
  /// In tr, this message translates to:
  /// **'Hatmi sil'**
  String get hatimSil;

  /// No description provided for @hatimSilOnay.
  ///
  /// In tr, this message translates to:
  /// **'Bu hatim ve işaretlediğiniz paylar bu telefondan silinecek.'**
  String get hatimSilOnay;

  /// No description provided for @hatimTamamMetin.
  ///
  /// In tr, this message translates to:
  /// **'Bütün paylar okundu. Allah kabul etsin.'**
  String get hatimTamamMetin;

  /// No description provided for @hatimAltNot.
  ///
  /// In tr, this message translates to:
  /// **'Hesap gerekmez. Hatim bilgileri yalnızca bu telefonda durur.'**
  String get hatimAltNot;

  /// No description provided for @esmaBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Esmâ-ül Hüsnâ'**
  String get esmaBaslik;

  /// No description provided for @esmaAltBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Allah\'ın en güzel 99 ismi'**
  String get esmaAltBaslik;

  /// No description provided for @esmaAraIpucu.
  ///
  /// In tr, this message translates to:
  /// **'İsim veya anlam ara'**
  String get esmaAraIpucu;

  /// No description provided for @gununIsmi.
  ///
  /// In tr, this message translates to:
  /// **'Günün ismi'**
  String get gununIsmi;

  /// No description provided for @isimNo.
  ///
  /// In tr, this message translates to:
  /// **'{no}. isim'**
  String isimNo(int no);

  /// No description provided for @zikirmatikteZikret.
  ///
  /// In tr, this message translates to:
  /// **'Zikirmatik\'te zikret'**
  String get zikirmatikteZikret;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
