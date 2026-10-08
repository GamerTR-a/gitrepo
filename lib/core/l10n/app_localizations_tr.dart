// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get uygulamaAdi => 'Abyad';

  @override
  String get geri => 'Geri';

  @override
  String get tamam => 'Tamam';

  @override
  String get vazgec => 'Vazgeç';

  @override
  String get devam => 'Devam';

  @override
  String get atla => 'Atla';

  @override
  String get acik => 'Açık';

  @override
  String get kapali => 'Kapalı';

  @override
  String get bugun => 'Bugün';

  @override
  String get gecti => 'Geçti';

  @override
  String get tumu => 'Tümü';

  @override
  String get onceki => 'Önceki';

  @override
  String get sonucYok => 'Sonuç bulunamadı';

  @override
  String get veriOkunamadi =>
      'İçerik yüklenemedi. Uygulamayı kapatıp yeniden açmayı deneyin.';

  @override
  String artir(String ad) {
    return '$ad: artır';
  }

  @override
  String azalt(String ad) {
    return '$ad: azalt';
  }

  @override
  String yuzdeDeger(int yuzde) {
    return '%$yuzde';
  }

  @override
  String kaynakSatiri(String kaynak) {
    return 'Kaynak: $kaynak';
  }

  @override
  String get okunus => 'Okunuşu';

  @override
  String get anlam => 'Anlamı';

  @override
  String get namaz => 'Namaz';

  @override
  String get abdest => 'Abdest';

  @override
  String get oruc => 'Oruç';

  @override
  String get menuEtiketi => 'Ana menü';

  @override
  String get menuAnaSayfa => 'Ana Sayfa';

  @override
  String get menuVakitler => 'Vakitler';

  @override
  String get menuKuran => 'Kur\'an';

  @override
  String get menuDualar => 'Dualar';

  @override
  String get menuGunler => 'Günler';

  @override
  String get ekranVakitler => 'Namaz Vakitleri';

  @override
  String get ekranKuran => 'Kur\'an-ı Kerim';

  @override
  String get ekranDualar => 'Dualar ve Zikir';

  @override
  String get ekranGunler => 'Önemli Günler';

  @override
  String get vakitImsak => 'İmsak';

  @override
  String get vakitGunes => 'Güneş';

  @override
  String get vakitOgle => 'Öğle';

  @override
  String get vakitIkindi => 'İkindi';

  @override
  String get vakitAksam => 'Akşam';

  @override
  String get vakitYatsi => 'Yatsı';

  @override
  String siradakiVakit(String vakit) {
    return 'Sıradaki vakit · $vakit';
  }

  @override
  String siradakiVakitOkuma(String vakit, String saat, String kalan) {
    return 'Sıradaki vakit $vakit, saat $saat, $kalan';
  }

  @override
  String kalanSaatDakika(int saat, int dakika) {
    return '$saat saat $dakika dakika kaldı';
  }

  @override
  String kalanDakika(int dakika) {
    return '$dakika dakika kaldı';
  }

  @override
  String vakitCipiOkuma(String vakit, String saat) {
    return '$vakit $saat';
  }

  @override
  String vakitCipiSiradakiOkuma(String vakit, String saat) {
    return '$vakit $saat, sıradaki vakit';
  }

  @override
  String vakitCipiSimdikiOkuma(String vakit, String saat) {
    return '$vakit $saat, şu anki vakit';
  }

  @override
  String get siradakiVakitRozet => 'Sıradaki vakit';

  @override
  String get suAnkiVakitRozet => 'Şu anki vakit';

  @override
  String tarihSatiri(String hicri, String miladi) {
    return '$hicri · $miladi';
  }

  @override
  String hicriTarih(int gun, String ay, int yil) {
    return '$gun $ay $yil';
  }

  @override
  String get hicriAylar =>
      'Muharrem,Safer,Rebiülevvel,Rebiülâhir,Cemâziyelevvel,Cemâziyelâhir,Receb,Şâban,Ramazan,Şevval,Zilkade,Zilhicce';

  @override
  String vakteKalan(String vakit) {
    return '$vakit vaktine kalan';
  }

  @override
  String vakteKalanOkuma(String vakit, String kalan) {
    return '$vakit vaktine $kalan';
  }

  @override
  String get oncekiGun => 'Önceki gün';

  @override
  String get sonrakiGun => 'Sonraki gün';

  @override
  String get buguneDon => 'Bugüne dönmek için dokunun';

  @override
  String get oncekiAy => 'Önceki ay';

  @override
  String get sonrakiAy => 'Sonraki ay';

  @override
  String get aylikImsakiye => 'Aylık imsakiye';

  @override
  String get ekVakitlerKart => 'Kerahat, işrak ve teheccüd vakitleri';

  @override
  String get ekVakitlerBaslik => 'Kerahat, İşrak ve Teheccüd';

  @override
  String get ekNafileBolum => 'Nafile namaz vakitleri';

  @override
  String get ekKerahatBolum => 'Kerahat vakitleri';

  @override
  String saatAraligi(String bas, String bit) {
    return '$bas – $bit';
  }

  @override
  String saatAraligiOkuma(String bas, String bit) {
    return '$bas ile $bit arası';
  }

  @override
  String get ekVakitYok => 'Bu tarihte hesaplanamıyor';

  @override
  String get suAnKerahat => 'Şu an kerahat vakti';

  @override
  String get ekVakitlerYaklasik =>
      'Bu saatler namaz vakitlerinden türetilen yaklaşık değerlerdir.';

  @override
  String get ekVakitlerIncelenmedi =>
      'Süreler ve açıklamalar henüz bir hoca tarafından incelenmedi.';

  @override
  String get yuksekEnlemBaslik => 'Bu vakitler neden farklı olabilir?';

  @override
  String yuksekEnlemMetin(String vakitler) {
    return 'Bulunduğunuz enlemde bu tarihte $vakitler vakti astronomik olarak oluşmuyor; yüksek enlemlerde yaz gecelerinde gökyüzü tam kararmaz. Abyad bu günlerde \"gecenin yedide biri\" kuralını uygular: geceyi yediye böler, yatsıyı akşamdan bir pay sonra, imsakı güneş doğmadan bir pay önce alır. Caminizin takvimi başka bir kural kullanıyorsa saatler farklı olabilir; Ayarlar\'dan her vakte dakika düzeltmesi ekleyebilirsiniz.';
  }

  @override
  String listeVe(String ilk, String son) {
    return '$ilk ve $son';
  }

  @override
  String ezanBildirimiAcik(String vakit) {
    return '$vakit ezan bildirimi açık';
  }

  @override
  String ezanBildirimiKapali(String vakit) {
    return '$vakit ezan bildirimi kapalı';
  }

  @override
  String hesaplamaYontemiNotu(String yontem) {
    return 'Hesaplama yöntemi: $yontem · Ayarlardan değiştirilebilir';
  }

  @override
  String get yontemDiyanet => 'Diyanet İşleri Başkanlığı';

  @override
  String get yontemDunyaIslamBirligi => 'Dünya İslam Birliği';

  @override
  String get yontemKuzeyAmerika => 'Kuzey Amerika (ISNA)';

  @override
  String get yontemMisir => 'Mısır';

  @override
  String get bildirimler => 'Bildirimler';

  @override
  String get kibleBaslik => 'Kıble';

  @override
  String get kibleYonu => 'Kıble yönü';

  @override
  String kibleDerece(int derece, String yon) {
    return '$derece° $yon';
  }

  @override
  String kibleKartOkuma(int derece, String yon) {
    return 'Kıble yönü $derece derece $yon. Pusulayı açmak için dokunun';
  }

  @override
  String get pusulayiAc => 'Pusulayı aç';

  @override
  String get kibleHizada => 'Kıbleye döndünüz';

  @override
  String kibleSagaDon(int derece) {
    return '$derece° sağa dönün';
  }

  @override
  String kibleSolaDon(int derece) {
    return '$derece° sola dönün';
  }

  @override
  String get kibleTitresim => 'Kıbleye dönünce titreşim';

  @override
  String get kibleTitresimAciklama =>
      'Telefon kıbleye hizalanınca hafifçe titrer.';

  @override
  String get pusulaIpucu =>
      'Telefonu yere paralel tutun. Yön şaşıyorsa telefonu havada 8 çizer gibi hareket ettirerek kalibre edin.';

  @override
  String get pusulaYokBaslik => 'Pusula sensörü bulunamadı';

  @override
  String pusulaYokMetin(int derece, String yon) {
    return 'Bu telefonda pusula kullanılamıyor. Kıble yönünüz kuzeyden saat yönünde $derece° ($yon).';
  }

  @override
  String get kalibrasyonBaslik => 'Pusula kalibrasyonu gerekiyor';

  @override
  String get kalibrasyonMetin =>
      'Telefonu havada 8 çizer gibi birkaç kez hareket ettirin. Mıknatıs, hoparlör ve metal eşyalardan uzak tutun.';

  @override
  String get kuzeyKisaltma => 'K';

  @override
  String get yonKuzey => 'Kuzey';

  @override
  String get yonKuzeydogu => 'Kuzeydoğu';

  @override
  String get yonDogu => 'Doğu';

  @override
  String get yonGuneydogu => 'Güneydoğu';

  @override
  String get yonGuney => 'Güney';

  @override
  String get yonGuneybati => 'Güneybatı';

  @override
  String get yonBati => 'Batı';

  @override
  String get yonKuzeybati => 'Kuzeybatı';

  @override
  String get konum => 'Konum';

  @override
  String get konumSec => 'Konum Seç';

  @override
  String konumDegistirOkuma(String sehir) {
    return 'Konum: $sehir. Değiştirmek için dokunun';
  }

  @override
  String konumOtomatik(String sehir) {
    return 'Otomatik · $sehir';
  }

  @override
  String get sehirAraIpucu => 'İl, ilçe veya şehir ara';

  @override
  String get sehirBulunamadi =>
      'Aradığınız yer bulunamadı. Yakındaki bir ilçeyi ya da ili deneyin.';

  @override
  String get konumumuKullan => 'Konumumu kullan';

  @override
  String get konumAraniyor => 'Konum aranıyor…';

  @override
  String get konumMahremiyet =>
      'Konumunuz yalnızca vakitleri hesaplamak için kullanılır ve telefonunuzda kalır.';

  @override
  String get konumServisKapali => 'Telefonun konum servisi kapalı.';

  @override
  String get konumIzinYok =>
      'Konum izni verilmedi. Şehrinizi listeden seçebilirsiniz.';

  @override
  String get konumIzinKalici =>
      'Konum izni kapalı. Telefonun ayarlarından açabilir ya da şehrinizi listeden seçebilirsiniz.';

  @override
  String get konumBulunamadi =>
      'Konum bulunamadı. Şehrinizi listeden seçebilirsiniz.';

  @override
  String get hizliKible => 'Kıble';

  @override
  String get hizliKuran => 'Kur\'an';

  @override
  String get hizliZikirmatik => 'Zikirmatik';

  @override
  String get hizliDualar => 'Dualar';

  @override
  String get devamEt => 'Kaldığın yerden devam et';

  @override
  String devamKonum(String sure, int ayet) {
    return '$sure · $ayet. ayet';
  }

  @override
  String hatimDurumu(int yuzde, int sayfa, int toplam) {
    return 'Hatim %$yuzde · Sayfa $sayfa / $toplam';
  }

  @override
  String devamOkuma(String sure, int ayet, int yuzde) {
    return 'Kaldığın yerden devam et: $sure, $ayet. ayet. Hatim yüzde $yuzde';
  }

  @override
  String get kuranaBasla => 'Kur\'an okumaya başla';

  @override
  String get kuranaBaslaAlt => 'Kaldığınız yer burada görünecek';

  @override
  String get gununAyeti => 'Günün Ayeti';

  @override
  String ayetKaynagi(String sure, int ayet) {
    return '$sure Suresi, $ayet';
  }

  @override
  String get yaklasanGun => 'Yaklaşan mübarek gün';

  @override
  String get gunBirimi => 'gün';

  @override
  String yaklasanGunOkuma(String ad, String tarih, int kalan) {
    return 'Yaklaşan mübarek gün: $ad, $tarih, $kalan gün kaldı';
  }

  @override
  String get dahaFazlasi => 'Daha fazlası';

  @override
  String get rehberBaslik => 'Namaz ve Abdest Rehberi';

  @override
  String get rehberAciklama => 'Yeni başlayanlar için adım adım';

  @override
  String get kazaAciklama => 'Kaza namazı ve oruç sayaçları';

  @override
  String get kuranAraIpucu => 'Sure adı veya sure:ayet ara';

  @override
  String get sekmeSure => 'Sure';

  @override
  String get sekmeCuz => 'Cüz';

  @override
  String get sekmeSayfa => 'Sayfa';

  @override
  String get sekmeImlerim => 'İmlerim';

  @override
  String get kaldiginYer => 'Kaldığın yer';

  @override
  String get mekki => 'Mekkî';

  @override
  String get medeni => 'Medenî';

  @override
  String sureBilgisi(String tur, int ayet) {
    return '$tur · $ayet ayet';
  }

  @override
  String sureAdi(String sure) {
    return '$sure Suresi';
  }

  @override
  String sureAyet(String sure, int ayet) {
    return '$sure · $ayet. ayet';
  }

  @override
  String sureAyetUzun(String sure, int ayet) {
    return '$sure Suresi · $ayet. ayet';
  }

  @override
  String sureUstBilgi(int no, int ayet, String tur, int sayfa) {
    return '$no. sure · $ayet ayet · $tur · Sayfa $sayfa';
  }

  @override
  String cuzNo(int no) {
    return '$no. Cüz';
  }

  @override
  String sayfaNo(int no) {
    return 'Sayfa $no';
  }

  @override
  String sayfaCuz(int sayfa, int cuz) {
    return 'Sayfa $sayfa · $cuz. cüz';
  }

  @override
  String hatimYuzde(int yuzde) {
    return 'Hatim %$yuzde';
  }

  @override
  String get yerImiYok =>
      'Henüz yer imi yok. Okurken bir ayetin yanındaki işarete dokunarak ekleyebilirsiniz.';

  @override
  String yerImiEkle(int ayet) {
    return '$ayet. ayete yer imi ekle';
  }

  @override
  String yerImiKaldir(int ayet) {
    return '$ayet. ayetin yer imini kaldır';
  }

  @override
  String ayetNo(int no) {
    return '$no. ayet';
  }

  @override
  String get modArapcaMeal => 'Arapça + Meal';

  @override
  String get modArapca => 'Arapça';

  @override
  String get modMeal => 'Meal';

  @override
  String get mealYok =>
      'Meal kaynağı eklenecek. Türkçe meal, lisans izni alındıktan sonra burada görünecek.';

  @override
  String get mealYokKisa => 'Meal kaynağı eklenecek';

  @override
  String sonrakiSure(String sure) {
    return 'Sonraki sure: $sure';
  }

  @override
  String get tanzilKaynak => 'Arapça metin: Tanzil Projesi (tanzil.net)';

  @override
  String get yaziBoyutuVeGorunum => 'Yazı boyutu ve görünüm';

  @override
  String get sayfaGorunumu => 'Sayfa görünümü';

  @override
  String get ayetGorunumu => 'Ayet ayet görünüm';

  @override
  String sayfaSayisi(int sayfa, int toplam) {
    return 'Sayfa $sayfa / $toplam';
  }

  @override
  String get oncekiSayfa => 'Önceki sayfa';

  @override
  String get sonrakiSayfa => 'Sonraki sayfa';

  @override
  String get sayfayaGit => 'Sayfaya git';

  @override
  String get sayfaNoIpucu => '1–604';

  @override
  String get yerImiEkleKisa => 'Yer imi ekle';

  @override
  String get yerImiKaldirKisa => 'Yer imini kaldır';

  @override
  String get mealSecimi => 'Meal';

  @override
  String get mealEklenmedi => 'Eklenmedi';

  @override
  String get kuranGorunumu => 'Kur\'an görünümü';

  @override
  String lisansMealKaydi(String ad, String sahip, String lisans) {
    return '$ad — $sahip. $lisans';
  }

  @override
  String get arapcaYaziBoyutu => 'Arapça yazı boyutu';

  @override
  String get arapcaYaziBoyutuNot =>
      'Yalnızca Kur\'an okuma ekranlarındaki Arapça metni etkiler. Genel yazı boyutu Ayarlar\'dan değiştirilir.';

  @override
  String get kategoriler => 'Kategoriler';

  @override
  String get zikirmatik => 'Zikirmatik';

  @override
  String get namazSonrasiTesbihat => 'Namaz sonrası tesbihat';

  @override
  String get tesbihatOzet => 'Sübhânallah · Elhamdülillah · Allâhu Ekber';

  @override
  String get sayaciSifirla => 'Sayacı sıfırla';

  @override
  String get dokunVeSay => 'Dokun ve say';

  @override
  String zikirSayOkuma(String zikir, int sayi) {
    return '$zikir say, şu an $sayi';
  }

  @override
  String turTamamlandi(int tur) {
    return '$tur tur tamamlandı · Allah kabul etsin';
  }

  @override
  String get hedef => 'Hedef';

  @override
  String get hedefSerbest => 'Serbest';

  @override
  String get bugunkuToplam => 'Bugünkü toplam zikir';

  @override
  String bugunkuToplamOkuma(int adet) {
    return 'Bugünkü toplam zikir: $adet';
  }

  @override
  String get zikirTitresim => 'Dokununca titreşim';

  @override
  String get zikirTumEkran => 'Ekranın her yerine dokunarak say';

  @override
  String get zikirTumEkranAciklama => 'Telefona bakmadan sayabilirsiniz.';

  @override
  String get zikirEkranAcik => 'Ekran kapanmasın';

  @override
  String get zikirArkaPlan => 'Arka planda manzara';

  @override
  String get zikirArkaPlanAciklama =>
      'Kâbe, Medine, Kudüs ve tarihî camilerin görselleri sayacın arkasında sırayla görünür.';

  @override
  String get zikirArkaPlanSure => 'Değişme aralığı';

  @override
  String saniyeKisa(int saniye) {
    return '$saniye sn';
  }

  @override
  String dakikaKisa(int dakika) {
    return '$dakika dk';
  }

  @override
  String get manzaraKabe => 'Kâbe';

  @override
  String get manzaraMekke => 'Mekke';

  @override
  String get manzaraMedine => 'Medine';

  @override
  String get manzaraKudus => 'Kudüs';

  @override
  String get manzaraSelimiye => 'Selimiye Camii';

  @override
  String get manzaraAyasofya => 'Ayasofya';

  @override
  String get manzaraUlucami => 'Ulu Cami';

  @override
  String get ozelZikir => 'Özel zikir';

  @override
  String get ozelZikirEkle => '+ Özel zikir';

  @override
  String get ozelZikirIpucu => 'Zikri yazın';

  @override
  String gunlerDonem(int yil, String donem) {
    return 'Hicrî $yil · $donem';
  }

  @override
  String get siradakiMubarekGun => 'Sıradaki mübarek gün';

  @override
  String get gunKaldi => 'gün kaldı';

  @override
  String kalanGun(int gun) {
    return '$gun gün';
  }

  @override
  String get hatirlat => 'Hatırlat';

  @override
  String get hatirlatmaAcik => 'Hatırlatma açık';

  @override
  String gunHatirlatmaAcik(String gun) {
    return '$gun hatırlatması açık';
  }

  @override
  String gunHatirlatmaKapali(String gun) {
    return '$gun hatırlatması kapalı';
  }

  @override
  String tarihAraligi(int ilk, int son, String ayYil) {
    return '$ilk–$son $ayYil';
  }

  @override
  String get gunlerNot =>
      'Tarihler resmî dinî günler takvimine göre güncellenir.';

  @override
  String get ayarlar => 'Ayarlar';

  @override
  String get okunabilirlik => 'Okunabilirlik';

  @override
  String get yaziBoyutu => 'Yazı boyutu';

  @override
  String get yaziNormal => 'Normal';

  @override
  String get yaziBuyuk => 'Büyük';

  @override
  String get yaziCokBuyuk => 'Çok büyük';

  @override
  String get yaziOrnegi => 'Bu metin, seçtiğiniz yazı boyutunun örneğidir.';

  @override
  String get yaziBoyutuNot =>
      'Seçtiğiniz boyut bütün ekranlarda, Kur\'an ve dualar dahil uygulanır. Telefonun kendi yazı boyutu ayarına da uyar.';

  @override
  String get yuksekKontrast => 'Yüksek kontrast';

  @override
  String get yuksekKontrastAciklama =>
      'Yazı ve zemin arasındaki farkı artırır.';

  @override
  String get ezanVeBildirimler => 'Ezan ve bildirimler';

  @override
  String get ezanVeBildirimlerOzet =>
      'Vakit sesleri, hatırlatma ve test bildirimi';

  @override
  String get konumVeVakitler => 'Konum ve vakitler';

  @override
  String get kuranAyarOzet => 'Okuma görünümü ve meal';

  @override
  String get tema => 'Tema';

  @override
  String get temaAcik => 'Açık';

  @override
  String get temaKoyu => 'Koyu';

  @override
  String get alarmOlarakCal => 'Ezanı alarm olarak çal';

  @override
  String get alarmOlarakCalAciklama =>
      'Medya sesi kısık olsa da, ekran kapalıyken de ezan duyulur.';

  @override
  String get onceHatirlat => 'Vakitten 15 dk önce hatırlat';

  @override
  String get onceHatirlatAciklama =>
      'Özellikle sabah ve sahur için ikinci bir uyarı.';

  @override
  String get cumaSessiz => 'Cuma namazında sessiz';

  @override
  String get cumaSessizAciklama =>
      'Cuma günü öğle vaktinde ezan yerine titreşim.';

  @override
  String get vakitBildirimleri => 'Vakit bildirimleri';

  @override
  String get vakitBildirimleriAciklama =>
      'Her vakit için aç/kapa ve ses seçimi';

  @override
  String get sesEzan => 'Ezan';

  @override
  String get sesKisa => 'Kısa uyarı';

  @override
  String get sesTitresim => 'Titreşim';

  @override
  String get ezanSesiYokNot =>
      'Ezan kaydı henüz eklenmedi; \"Ezan\" seçili vakitlerde telefonun varsayılan bildirim sesi çalar.';

  @override
  String get bildirimIzniYok =>
      'Bildirim izni verilmedi; ezan vakitlerinde bildirim gelmez.';

  @override
  String get bildirimIzniVer => 'Bildirimlere izin ver';

  @override
  String get tamZamanliYok =>
      'Tam zamanlı alarm izni kapalı; ezan birkaç dakika gecikebilir.';

  @override
  String get tamZamanliIzinVer => 'Tam zamanlı alarma izin ver';

  @override
  String get testBildirimiAciklama =>
      'Ezan bildiriminin telefonunuzda çaldığını hemen doğrulayın.';

  @override
  String get testBildirimiGonder => 'Test bildirimi gönder';

  @override
  String get testBildirimiGonderildi =>
      'Birkaç saniye içinde bildirim gelecek.';

  @override
  String get pilBaslik => 'Ezanın her durumda çalması için';

  @override
  String get pilMetin =>
      'Telefonunuz pil tasarrufu için uygulamayı durdurabilir. Bu uygulama için pil optimizasyonunu kapatın.';

  @override
  String get ayariAc => 'Ayarı aç';

  @override
  String get markaSamsung => 'Samsung';

  @override
  String get markaSamsungYol =>
      'Ayarlar > Uygulamalar > Abyad > Pil > \"Kısıtlamasız\" seçin.';

  @override
  String get markaXiaomi => 'Xiaomi';

  @override
  String get markaXiaomiYol =>
      'Ayarlar > Uygulamalar > Abyad > Pil tasarrufu > \"Kısıtlama yok\" seçin; ayrıca \"Otomatik başlatma\"yı açın.';

  @override
  String get markaHuawei => 'Huawei / Honor';

  @override
  String get markaHuaweiYol =>
      'Ayarlar > Uygulamalar > Uygulama başlatma > Abyad > \"Elle yönet\" seçip üç seçeneği de açın.';

  @override
  String get vakitHesaplama => 'Vakit hesaplama';

  @override
  String get hesaplamaYontemi => 'Hesaplama yöntemi';

  @override
  String get dakikaDuzeltme => 'Vakitlere dakika ekle/çıkar';

  @override
  String get dakikaDuzeltmeAciklama =>
      'Camideki ezan vaktiyle fark varsa her vakit için dakika ekleyip çıkarabilirsiniz.';

  @override
  String dakikaArtir(String vakit) {
    return '$vakit: bir dakika ekle';
  }

  @override
  String dakikaAzalt(String vakit) {
    return '$vakit: bir dakika çıkar';
  }

  @override
  String dakikaDeger(int dakika) {
    return '$dakika dakika';
  }

  @override
  String get hicriDuzeltme => 'Hicrî tarih düzeltmesi';

  @override
  String get hicriDuzeltmeAciklama =>
      'Hicrî gün, bulunduğunuz yerdeki takvimden bir gün farklıysa düzeltin.';

  @override
  String get gunEksiBir => '−1 gün';

  @override
  String get gunFarkiYok => 'Düzeltme yok';

  @override
  String get gunArtiBir => '+1 gün';

  @override
  String get mahremiyetBaslik => 'Mahremiyetiniz emanettir';

  @override
  String get mahremiyetMetin =>
      'Bu uygulama hiçbir veri toplamaz, reklam göstermez ve hesap istemez. Konumunuz sadece vakitleri hesaplamak için bu telefonda kullanılır, hiçbir yere gönderilmez.';

  @override
  String get kaynaklarVeLisanslar => 'Kaynaklar ve Lisanslar';

  @override
  String surumBilgisi(String surum) {
    return 'Sürüm $surum · Ücretsizdir, ücretsiz kalacaktır.';
  }

  @override
  String get lisansKuranBaslik => 'Kur\'an-ı Kerim metni';

  @override
  String get lisansKuranMetin =>
      'Arapça metin, Tanzil Projesi\'nin Uthmani metnidir (sürüm 1.1, tanzil.net). Creative Commons Attribution 3.0 lisansı gereği metin değiştirilmeden kullanılmıştır. Sure, cüz ve sayfa bilgileri de Tanzil üst verisinden gelir.';

  @override
  String get lisansMealBaslik => 'Türkçe meal';

  @override
  String get lisansMealMetin =>
      'Henüz bir meal eklenmedi. Meal, yalnızca hak sahibinden izin alındıktan sonra eklenecektir.';

  @override
  String get lisansSehirBaslik => 'Şehir koordinatları';

  @override
  String get lisansSehirMetin =>
      'İl, ilçe ve yurt dışı şehir koordinatları GeoNames (geonames.org) verisinden alınmıştır. Creative Commons Attribution 4.0.';

  @override
  String get lisansYaziBaslik => 'Yazı tipleri';

  @override
  String get lisansYaziMetin =>
      'Manrope, Fraunces ve Amiri; SIL Open Font License 1.1 ile lisanslıdır.';

  @override
  String get lisansEzanBaslik => 'Ezan sesi';

  @override
  String get lisansEzanMetin =>
      'Henüz ezan kaydı eklenmedi; telefonun varsayılan bildirim sesi kullanılıyor. Kayıt, yalnızca izinli ya da lisanslı bir kaynaktan eklenecektir.';

  @override
  String get lisansIcerikBaslik => 'Dua ve bilgi metinleri';

  @override
  String get lisansIcerikMetin =>
      'Dualar, okunuşlar, Esmâ-ül Hüsnâ anlamları ve rehber metinleri yayın öncesinde bir hoca tarafından incelenecektir. Vakit hesaplama parametreleri açık kaynaklı Adhan kütüphanesindeki Türkiye yöntemine dayanır.';

  @override
  String get lisansHadisBaslik => 'Kırk Hadis';

  @override
  String get lisansHadisMetin =>
      'Hadislerin Arapça metni İmam Nevevî\'nin Kırk Hadis\'inden (el-Erbaûn) alınmıştır; eser kamu malıdır. Türkçe tercümeler Abyad için hazırlanmıştır ve yayın öncesinde bir hoca tarafından incelenecektir.';

  @override
  String get lisansCizimBaslik => 'Çizimler ve görseller';

  @override
  String get lisansCizimMetin =>
      'Namaz ve abdest rehberindeki çizimler Abyad için hazırlanmıştır; başka bir kaynaktan alınmamıştır. Zikirmatik arka planındaki manzara görselleri yapay zekâ ile üretilmiştir; fotoğraf değildir, mekânları temsilen gösterir.';

  @override
  String get lisansPaketler => 'Kullanılan yazılım paketleri';

  @override
  String get kanalEzanAlarm => 'Ezan (alarm sesiyle)';

  @override
  String get kanalEzan => 'Ezan';

  @override
  String get kanalHatirlatma => 'Hatırlatmalar';

  @override
  String get kanalTitresim => 'Sessiz (titreşim)';

  @override
  String get kanalAciklama => 'Namaz vakti bildirimleri';

  @override
  String bildirimVakitBaslik(String vakit) {
    return '$vakit vakti';
  }

  @override
  String bildirimVakitGovde(String sehir, String saat) {
    return '$sehir · $saat';
  }

  @override
  String bildirimOnceBaslik(String vakit, int dakika) {
    return '$vakit vaktine $dakika dakika kaldı';
  }

  @override
  String get bildirimGunGovde =>
      'Bugün mübarek bir gün. Hayırlara vesile olsun.';

  @override
  String get bildirimTestBaslik => 'Test bildirimi';

  @override
  String get bildirimTestGovde =>
      'Bu bildirimi duyduysanız ezan bildirimleri çalışıyor.';

  @override
  String ilkAdim(int adim, int toplam) {
    return 'Adım $adim / $toplam';
  }

  @override
  String get ilkVaatBaslik => 'Reklam yok, veri yok, hesap yok.';

  @override
  String get ilkVaatMetin =>
      'Abyad tamamen ücretsizdir ve öyle kalacak. Hiçbir verinizi toplamaz, internete bağlanmaz, sizden hesap istemez. Vakitler, Kur\'an ve dualar telefonunuzun içindedir.';

  @override
  String get ilkKonumBaslik => 'Vakitler için konumunuz';

  @override
  String get ilkKonumMetin =>
      'Namaz vakitlerini bulunduğunuz yere göre hesaplamak için konumunuzu kullanırız. Konumunuz yalnızca vakitleri hesaplamak içindir, telefonunuzda kalır ve hiçbir yere gönderilmez. İsterseniz konum izni vermeden şehrinizi listeden seçebilirsiniz.';

  @override
  String get ilkKonumAlinamadi =>
      'Konum alınamadı. Şehrinizi listeden seçebilirsiniz.';

  @override
  String get sehrimiSecerim => 'Şehrimi listeden seçeyim';

  @override
  String get simdilikAtla => 'Şimdilik atla (İstanbul ile devam et)';

  @override
  String get ilkBildirimBaslik => 'Ezan vaktinde haber verelim';

  @override
  String get ilkBildirimMetin =>
      'Vakit girdiğinde ezan bildirimi gönderebilmemiz için bildirim iznine ihtiyacımız var. Hangi vakitlerde bildirim alacağınızı sonra Ayarlar\'dan değiştirebilirsiniz.';

  @override
  String get ilkBildirimMetinAndroid =>
      'Vakit girdiğinde ezan bildirimi gönderebilmemiz için bildirim iznine ihtiyacımız var. Ezanın tam vaktinde çalması için telefonunuz \"Alarmlar ve hatırlatıcılar\" iznini de sorabilir. Bazı telefonlar pil tasarrufu için uygulamayı durdurur; bunu Ayarlar\'daki yönergelerle kapatabilirsiniz.';

  @override
  String get kazaTakibi => 'Kaza Takibi';

  @override
  String get gizle => 'Gizle';

  @override
  String get goster => 'Göster';

  @override
  String get sayilariGizle => 'Sayıları gizle';

  @override
  String get sayilariGoster => 'Sayıları göster';

  @override
  String get kalanKaza => 'Kalan kaza namazı';

  @override
  String get tahminiBitis => 'Tahmini bitiş';

  @override
  String get kazaYok => 'Borç yok';

  @override
  String get kazaOzetGizli => 'Kaza sayıları gizli';

  @override
  String kazaOzetOkuma(int adet, String sure) {
    return 'Kalan kaza namazı $adet. Tahmini bitiş: $sure';
  }

  @override
  String get gundeKacVakit => 'Günde kaç vakit kaza kılarım?';

  @override
  String gundeVakit(int adet) {
    return 'Günde $adet vakit';
  }

  @override
  String bugunKazaKildiniz(int adet) {
    return 'Bugün $adet kaza kıldınız. Allah kabul etsin.';
  }

  @override
  String get kazaSabah => 'Sabah';

  @override
  String get kazaVitir => 'Vitir';

  @override
  String get kazaOruc => 'Ramazan kazası';

  @override
  String kazaKaldi(int adet) {
    return '$adet kaldı';
  }

  @override
  String orucKaldi(int adet) {
    return '$adet gün kaldı';
  }

  @override
  String kazaEkle(String namaz) {
    return '$namaz kazası ekle';
  }

  @override
  String kazaKildimOkuma(String namaz) {
    return 'Bir $namaz kazası kıldım';
  }

  @override
  String get kildim => 'Kıldım';

  @override
  String get tuttum => 'Tuttum';

  @override
  String get orucEkle => 'Kaza orucu ekle';

  @override
  String get orucTuttumOkuma => 'Bir kaza orucu tuttum';

  @override
  String get kazaNasilHesaplarim => 'Kaza borcumu nasıl hesaplarım?';

  @override
  String get kazaHesapAlt => 'Adım adım hesaplama ve kısa fıkıh bilgisi';

  @override
  String get kazaMahremiyet => 'Bu bilgiler sadece bu telefonda saklanır.';

  @override
  String sureYilAy(int yil, int ay) {
    return 'yaklaşık $yil yıl $ay ay';
  }

  @override
  String sureYil(int yil) {
    return 'yaklaşık $yil yıl';
  }

  @override
  String sureAyGun(int ay, int gun) {
    return 'yaklaşık $ay ay $gun gün';
  }

  @override
  String sureAy(int ay) {
    return 'yaklaşık $ay ay';
  }

  @override
  String sureGun(int gun) {
    return '$gun gün';
  }

  @override
  String get kazaHesaplama => 'Kaza Borcu Hesaplama';

  @override
  String get kazaHesaplamaGiris =>
      'Kaç yıl namaz kılmadığınızı ve oruç tutmadığınızı girin; yaklaşık kaza sayınızı hesaplayalım. Sonuç bir tahmindir, sayaçları sonradan elle düzeltebilirsiniz.';

  @override
  String get sihirbazNamazYil => 'Namaz kılmadığım yıl';

  @override
  String get sihirbazNamazYilAciklama =>
      'Buluğ çağından sonra namaz kılmadığınız süre.';

  @override
  String get sihirbazNamazAy => 'Ek ay';

  @override
  String get sihirbazOzurGun => 'Aylık özür günü (kadınlar)';

  @override
  String get sihirbazOzurGunAciklama =>
      'Âdet günlerinde kılınmayan namazların kazası yoktur; bu günler hesaptan düşülür.';

  @override
  String get sihirbazOrucYil => 'Oruç tutmadığım Ramazan sayısı';

  @override
  String get sihirbazOrucYilAciklama => 'Her Ramazan 30 gün sayılır.';

  @override
  String get sihirbazSonuc => 'Tahmini kaza borcu';

  @override
  String sihirbazSonucNamaz(int adet) {
    return 'Her vakit ve vitir için $adet namaz';
  }

  @override
  String sihirbazSonucOruc(int adet) {
    return '$adet gün oruç';
  }

  @override
  String get sihirbazUygula => 'Sayaçlara uygula';

  @override
  String get sihirbazOnayBaslik => 'Sayaçlar değiştirilsin mi?';

  @override
  String get sihirbazOnayMetin =>
      'Mevcut kaza sayılarınız bu hesaplamanın sonucuyla değiştirilecek.';

  @override
  String get kisaFikihBilgisi => 'Kısa fıkıh bilgisi';

  @override
  String get fikihNot =>
      'Bu bilgiler Hanefi mezhebine göre özettir. Özel durumunuz için bir din görevlisine danışın.';

  @override
  String adimNo(int adim, int toplam) {
    return 'Adım $adim / $toplam';
  }

  @override
  String cizimAlani(String adim) {
    return 'Çizim alanı · $adim';
  }

  @override
  String get sonrakiAdim => 'Sonraki adım';

  @override
  String get hareketiTekrarla => 'Hareketi tekrar göster';

  @override
  String get bastanBasla => 'Baştan başla';

  @override
  String get rehberNamazSec => 'Öğrenmek istediğiniz namazı ve bölümünü seçin.';

  @override
  String get rehberIcerikBekleniyor => 'Bu bölümün içeriği hazırlanıyor.';

  @override
  String rekatSayisi(int rekat) {
    return '$rekat rekat';
  }

  @override
  String rehberBolumBasligi(String vakit, String bolum) {
    return '$vakit – $bolum';
  }

  @override
  String rekatAdim(int rekat, String adim) {
    return '$rekat. rekat · $adim';
  }

  @override
  String tekrarSayisi(int adet) {
    return '$adet kez';
  }

  @override
  String ornekSure(String sure) {
    return 'Örnek sure: $sure';
  }

  @override
  String get kadinlarIcin => 'Kadınlar için';

  @override
  String get okunusuDinle => 'Okunuşu dinle';

  @override
  String get ezberAc => 'Ezber modunu aç';

  @override
  String get ezberKapat => 'Ezber modunu kapat';

  @override
  String get ezberAcik =>
      'Ezber modu açık: Arapça metin ve okunuş gizli, görmek için dokunun.';

  @override
  String get ezberGoster => 'Göstermek için dokunun';

  @override
  String get abdestRehberi => 'Abdest Rehberi';

  @override
  String get abdestAltBaslik => 'Abdestin adım adım alınışı';

  @override
  String abdestRehberiAciklama(int adet) {
    return 'Abdestin alınışı $adet adımda, çizimlerle anlatılır.';
  }

  @override
  String get abdestBasla => 'Abdest adımlarına başla';

  @override
  String get abdestiBozanlar => 'Abdesti bozan durumlar';

  @override
  String get hadisBaslik => 'Kırk Hadis';

  @override
  String get hadisAltBaslik => 'Hz. Peygamber\'in (s.a.v.) sözlerinden';

  @override
  String get hadisAciklama => 'İmam Nevevî\'nin derlemesi';

  @override
  String get hadisBekleniyorBaslik => 'İçerik hazırlanıyor';

  @override
  String get hadisBekleniyorMetin =>
      'Hadisleri kaynağı ve tercümesi belli olmadan eklemiyoruz. Derleme seçilip bir hoca tarafından incelendikten sonra kırk hadis burada yer alacak.';

  @override
  String hadisNo(int no) {
    return '$no. hadis';
  }

  @override
  String hadisRavi(String ravi) {
    return 'Rivayet eden: $ravi';
  }

  @override
  String hadisTercume(String kaynak) {
    return 'Tercüme: $kaynak';
  }

  @override
  String get hadisHikayeEtiket => 'Temsilî hikâye';

  @override
  String get hadisHikayeNot =>
      'Bu hikâye, hadisin daha iyi anlaşılması için yazılmış kurgusal bir anlatıdır; yaşanmış bir olay ya da rivayet değildir.';

  @override
  String get hatimBaslik => 'Toplu Hatim';

  @override
  String get hatimAciklama => 'Hatmi cüz cüz, sayfa sayfa takip edin';

  @override
  String get hatimYeni => 'Yeni hatim';

  @override
  String get hatimBaslat => 'Hatim başlat';

  @override
  String get hatimBosBaslik => 'Henüz hatim yok';

  @override
  String get hatimBosMetin =>
      'Bir hatim başlatın; cüzleri ya da sayfaları pay pay alın, okudukça işaretleyin.';

  @override
  String get hatimYerelNotBaslik => 'Linkle paylaşım henüz açık değil';

  @override
  String get hatimYerelNot =>
      'Hatmi aileniz ve arkadaşlarınızla linkle paylaşma özelliği hazırlanıyor. Şimdilik hatmi bu telefonda başlatıp payları kendiniz takip edebilirsiniz. Bilgileriniz telefonunuzda kalır, hiçbir yere gönderilmez.';

  @override
  String get hatimDevamEden => 'Devam eden hatim';

  @override
  String get hatimTamamlandi => 'Hatim tamamlandı';

  @override
  String hatimIlerlemeCuz(int okunan, int toplam) {
    return '$okunan / $toplam cüz okundu';
  }

  @override
  String hatimIlerlemePay(int okunan, int toplam) {
    return '$okunan / $toplam pay okundu';
  }

  @override
  String hatimHedef(String tarih) {
    return 'Hedef: $tarih';
  }

  @override
  String get hatimAdi => 'Hatmin adı';

  @override
  String get hatimAdiIpucu => 'Örnek: Ramazan Aile Hatmi';

  @override
  String get hatimNotu => 'Niyet notu (isteğe bağlı)';

  @override
  String get hatimNotuIpucu => 'Örnek: Annemizin ruhu için';

  @override
  String get hatimBolme => 'Bölme şekli';

  @override
  String get hatimCuzCuz => 'Cüz cüz';

  @override
  String get hatimSayfaSayfa => 'Sayfa sayfa';

  @override
  String hatimBolmeCuzAciklama(int pay) {
    return '$pay pay; her pay bir cüz.';
  }

  @override
  String hatimBolmeSayfaAciklama(int pay, int sayfa) {
    return '$pay pay; her pay $sayfa sayfa.';
  }

  @override
  String get hatimHedefTarih => 'Hedef tarih';

  @override
  String get hatimHedefYok => 'Belirlenmedi';

  @override
  String get hatimHedefKaldir => 'Hedef tarihi kaldır';

  @override
  String get hataBos => 'Bu alan boş bırakılamaz.';

  @override
  String hataUzun(int sinir) {
    return 'En fazla $sinir karakter yazabilirsiniz.';
  }

  @override
  String get hataLink => 'Bu alana link yazılamaz.';

  @override
  String get hatimCuzSec => 'Bir cüz seç';

  @override
  String get hatimCuzSecAciklama => 'Boş bir cüze dokunarak sorumluluğu al.';

  @override
  String get hatimSayfaSec => 'Bir sayfa aralığı seç';

  @override
  String get hatimSayfaSecAciklama =>
      'Boş bir sayfa aralığına dokunarak sorumluluğu al.';

  @override
  String get durumOkundu => 'Okundu';

  @override
  String get durumAlindi => 'Alındı';

  @override
  String get durumSenin => 'Senin';

  @override
  String get durumBos => 'Boş';

  @override
  String hatimCuzAdi(int no) {
    return '$no. cüz';
  }

  @override
  String hatimSayfaAdi(int bas, int bit) {
    return 'Sayfa $bas–$bit';
  }

  @override
  String get seninPayin => 'Senin payın';

  @override
  String get okumayaBasla => 'Okumaya başla';

  @override
  String get okudum => 'Okudum';

  @override
  String get payiBirak => 'Bırak';

  @override
  String get geriAl => 'Geri al';

  @override
  String get hatimAlinmis => 'Bu pay az önce alındı.';

  @override
  String get hatimSil => 'Hatmi sil';

  @override
  String get hatimSilOnay =>
      'Bu hatim ve işaretlediğiniz paylar bu telefondan silinecek.';

  @override
  String get hatimTamamMetin => 'Bütün paylar okundu. Allah kabul etsin.';

  @override
  String get hatimAltNot =>
      'Hesap gerekmez. Hatim bilgileri yalnızca bu telefonda durur.';

  @override
  String get esmaBaslik => 'Esmâ-ül Hüsnâ';

  @override
  String get esmaAltBaslik => 'Allah\'ın en güzel 99 ismi';

  @override
  String get esmaAraIpucu => 'İsim veya anlam ara';

  @override
  String get gununIsmi => 'Günün ismi';

  @override
  String isimNo(int no) {
    return '$no. isim';
  }

  @override
  String get zikirmatikteZikret => 'Zikirmatik\'te zikret';
}
