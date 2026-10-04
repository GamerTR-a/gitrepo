# CLAUDE.md — Abyad

Bu dosya Abyad projesinin kalıcı talimatlarıdır. Her oturumda önce bunu oku.
Buradaki **Değişmez İlkeler** hiçbir görev için esnetilemez; bir görev bunlarla
çelişiyorsa uygulamadan önce bana sor.

---

## 1. Proje

**Abyad**, Müslümanlar için reklamsız, veri toplamayan, hesap istemeyen ve
tamamen ücretsiz bir Flutter mobil uygulamasıdır (Android + iOS). Adı,
Bakara 187'de imsak vaktini tarif eden "el-haytu'l-abyad" (fecrin beyaz ipliği)
ifadesinden gelir.

Hedef kitle: Türkiye'deki ve gurbetteki Türkçe konuşan Müslümanlar; yaşlılar,
görme zorluğu çekenler ve dini öğrenmeye yeni başlayanlar dahil.

Rakip analizi özeti: e-Diyanet resmî ve ücretsizdir ama sık arayüz değişikliği
ve internet bağımlılığı şikâyet alır. Muslim Pro gibi uygulamalar reklam,
abonelik ve konum verisi satışı nedeniyle güven kaybetmiştir. Abyad'ın farkı:
**sadelik, istikrar, internetsiz çalışma, mahremiyet ve ezanın her telefonda
gerçekten çalması.**

---

## 2. Değişmez İlkeler

1. **Sıfır veri.** Hiçbir analitik, çökme raporlama, reklam, izleme veya
   üçüncü taraf SDK eklenmez (Firebase Analytics, Crashlytics, Sentry,
   AdMob, Facebook SDK vb. YASAK). Kullanıcı verisi cihazdan çıkmaz.
2. **1. ve 2. sürümde internet yok.** Ana `AndroidManifest.xml` içinde
   `INTERNET` izni bulunmaz. Bütün veri (Kur'an metni, dualar, şehir listesi,
   dinî günler, yazı tipleri) uygulamaya gömülüdür. (Debug/profile
   manifest'lerindeki otomatik INTERNET izni geliştirme içindir, sorun değil.)
3. **Hesap yok, giriş yok.**
4. **Reklam yok, abonelik yok, ücretli özellik yok.** Widget dahil her şey ücretsiz.
5. **Erişilebilirlik baştan.** Her ekran yazı boyutu 2.0x'te taşmadan çalışır,
   ekran okuyucuyla kullanılabilir, dokunma alanları ≥ 48dp.
6. **İstikrar.** Mevcut ekranların düzenini gerekçesiz değiştirme. Yaşlı
   kullanıcılar alıştıkları düzenin bozulmasından en çok şikâyet eder.
7. **Dini içerik uydurulmaz.** Ayet metni yalnızca gömülü Tanzil dosyasından
   gelir. Dua, hadis, açıklama metinleri kaynaksız üretilmez; üretmen gereken
   her dini metni `incelendi: false` olarak işaretle (bkz. §8).
8. **Telifli içerik eklenmez.** Türkçe mealler, tilavet kayıtları ve
   başkalarına ait görseller izinsiz eklenmez, internetten kazınmaz.

---

## 3. Teknoloji

- Flutter (güncel stable), Dart 3, `useMaterial3: true`
- Durum yönetimi: `flutter_riverpod`
- Yerel veri: ayarlar için `shared_preferences`; yapısal veri (okuma ilerlemesi,
  yer imleri, kaza sayıları, zikir geçmişi) için `drift`
- Paket adayları (eklemeden önce pub.dev'de adını, bakım durumunu, son
  sürümünü ve API'sini doğrula; API uydurma, emin değilsen dokümana bak):
  - Vakit hesaplama: `adhan` (veya `adhan_dart`) — Türkiye/Diyanet yöntemi
  - Bildirim: `flutter_local_notifications`, `timezone`, `flutter_timezone`
  - Konum: `geolocator`, izinler: `permission_handler`
  - Pusula/kıble: `flutter_compass` (kıble açısını kendimiz hesaplarız)
  - Widget: `home_widget`
  - SVG: `flutter_svg`
  - Hicrî takvim: `hijri` (Ümmü'l-Kurâ) + kullanıcı ±1 gün düzeltmesi
  - Paylaşım (2. sürüm+): `share_plus` — sistem paylaşım menüsü, ağ gerektirmez
  - Ses (3. sürüm): `just_audio`
- Bu liste dışında paket eklemek gerekiyorsa önce bana gerekçesiyle sor.
- Dil: arayüz Türkçe. `flutter gen-l10n` ile `lib/l10n/app_tr.arb` kullan;
  ileride İngilizce, Almanca ve Arapça (RTL) eklenebilecek şekilde kur.
  Kodda sabit Türkçe metin bırakma.

---

## 4. Mimari ve klasör yapısı

Özellik bazlı (feature-first) yapı. Hesaplama mantığı saf Dart ve test edilebilir.

```
lib/
  main.dart
  app/                    MaterialApp, kabuk (alt menü), yönlendirme
  core/
    theme/                abyad_colors, abyad_text, abyad_tokens, abyad_theme
    widgets/              AbyadKart, AbyadIcon, AbyadAltMenu, SekizKoseYildiz, ...
    l10n/
    storage/              drift veritabanı, shared_preferences sarmalayıcı
  features/
    vakitler/             domain/ (hesaplama, saf Dart) · data/ · ui/
    bildirim/             zamanlama, kanallar, yeniden kurma
    kible/
    kuran/
    dualar/
    zikirmatik/
    onemli_gunler/
    ayarlar/
    widget/
    kaza/                 (2. sürüm)
    rehber/               (2. sürüm: namaz + abdest)
    hatim/ esma/ hadis/ tilavet/   (3. sürüm)
assets/
  icons/ ornament/
  data/
    quran/                Tanzil metni + sayfa/cüz/sure meta verisi
    dualar.json
    sehirler.json         il, ilçe ve yurt dışı şehir koordinatları
    onemli_gunler.json
  audio/ezan/             ezan sesleri (lisanslı/izinli olanlar)
fonts/                    Manrope, Fraunces, Amiri (OFL)
docs/tasarim/             kanvastan dışa aktarılan ekran görselleri
```

---

## 5. Tasarım sistemi

Başlangıç paketindeki `lib/theme/` dosyaları (`core/theme/` altına taşı) tek
doğruluk kaynağıdır. Ekran görselleri `docs/tasarim/` altındadır; bir ekranı
kodlarken önce ilgili görsele bak.

- Renkler yalnızca `AbyadColors` üzerinden. Ana renk zümrüt `#0F3D33`,
  vurgu pirinç `#E2C27A` (sadece koyu zemin üstünde), açık zeminde pirinç
  yazı `#8A6316`, ekran zemini `#F3F4EF`, kart beyaz + `#E1E5DF` kenarlık.
- Yazı: Manrope (metin), Fraunces (başlık ve büyük saatler), Amiri (Arapça).
  Değişken yazı tipleri için stil her zaman `abyadStil(...)` / `AbyadText` ile.
- Köşe: kart 20–22, düğme 14, çip 12, koyu başlığın alt köşeleri 28.
- Süsleme: `SekizKoseYildiz` (rub'ul-hizb). Ölçülü kullan, koyu alanlarda düşük opaklık.
- Arapça metin: `TextDirection.rtl`, `textAlign: right`, satır yüksekliği 1.9–2.0.
- Sabit yükseklik verme; metin büyüyünce kart da büyüsün.
- Karanlık mod 1. sürümde zorunlu değil ama renkleri token üzerinden kullan ki sonradan eklenebilsin.

---

## 6. Özellik şartnamesi

### 1. Sürüm — Temel ve kusursuz

**6.1 İlk açılış (onboarding)** — En fazla 3 ekran: (1) Abyad'ın vaadi:
"Reklam yok, veri yok, hesap yok". (2) Konum: neden istendiğini açıkla
("yalnızca vakitleri hesaplamak için, telefonunuzda kalır"); reddedilirse
gömülü listeden il/ilçe seçimi. (3) Bildirim izni + Android'de tam zamanlı alarm
ve pil optimizasyonu açıklaması. Her adım atlanabilir.

**6.2 Vakit hesaplama motoru** (`features/vakitler/domain`, saf Dart)
- Girdi: enlem, boylam, tarih, saat dilimi, yöntem, vakit başına dakika düzeltmeleri.
- Varsayılan yöntem: Diyanet ile uyumlu Türkiye yöntemi.
- Çıktı: İmsak, Güneş, Öğle, İkindi, Akşam, Yatsı (`GunlukVakitler` modeli
  başlangıç paketinde var; genişlet, kır).
- Yüksek enlemlerde (≈ 48°+) yatsı/imsak oluşmayan günler için varsayılan
  olarak "gecenin yedide biri" kuralını uygula; motor hata vermemeli.
- Doğrulama: Diyanet'in yayımladığı vakitlerle en az 8 şehir (İstanbul, Ankara,
  İzmir, Erzurum, Van, Trabzon, Berlin, Amsterdam) için birim testleri yaz.
  Referans değerleri ben `test/fixtures/diyanet_referans.json` içine koyacağım;
  dosya boşsa testleri `skip` ile işaretle ve bana bildir. Tolerans ±2 dk.
- Saat dilimi ve yaz saati geçişlerini test et.

**6.3 Ezan bildirimi — en kritik özellik**
- Her vakit için ayrı aç/kapa, ses seçimi (ezan / kısa uyarı / titreşim),
  "vakitten X dk önce hatırlat" seçeneği.
- Android:
  - Bildirim kanalı ses kullanımı **alarm** (`AudioAttributesUsage.alarm`);
    medya sesi kısıkken de duyulmalı.
  - `exactAllowWhileIdle` ile tam zamanlı alarm. Android 12+ için
    `SCHEDULE_EXACT_ALARM` iznini kullanıcıya açıklayarak iste
    (Google Play'in tam zamanlı alarm politikasını kontrol et ve bana özetle).
  - Android 13+ `POST_NOTIFICATIONS`.
  - Telefon yeniden başlayınca (`RECEIVE_BOOT_COMPLETED`), saat/saat dilimi
    değişince ve konum değişince bildirimleri yeniden kur.
  - Pil optimizasyonu: kullanıcıyı sistem ayar ekranına yönlendiren açıklama
    kartı (Ayarlar tasarımında var). Marka bazlı (Samsung, Xiaomi, Huawei)
    ek ayarlar için kısa yönergeler göster.
- iOS:
  - Bekleyen yerel bildirim sınırı 64'tür → kayan pencere: önümüzdeki günleri
    sınıra sığacak kadar planla, uygulama her açıldığında ve arka planda
    fırsat buldukça yenile.
  - Özel bildirim sesi uygulama paketinde olmalı ve **30 saniyeyi geçemez**;
    ezan sesleri için iOS'a özel kısaltılmış sürümler hazırla.
- Planlama mantığını (hangi bildirim ne zaman) saf Dart'ta yaz ve test et.
- "Test bildirimi gönder" düğmesi (Ayarlar'da): kullanıcı ezanın çaldığını
  hemen doğrulayabilsin.

**6.4 Ana Sayfa** — Başlangıç paketinde kodlandı. Örnek veri yerine motoru
bağla. Konum, hicrî + miladî tarih, sıradaki vakit ve geri sayım, 6 vakit çipi,
hızlı erişim (Kıble, Kur'an, Zikirmatik, Dualar), kaldığın yerden devam,
günün ayeti (gömülü listeden, tarihe göre deterministik seçim), yaklaşan mübarek gün.
Başlığa Ayarlar'a giden bir ikon düğmesi ekle.

**6.5 Namaz Vakitleri** — Gün gün ileri/geri gezinme, sıradaki vakte geri sayım,
her vakitte bildirim aç/kapa, geçmiş vakitler soluk, şu anki ve sıradaki
vurgulu. Aylık imsakiye görünümü (özellikle Ramazan için). Altında kıble kartı.

**6.6 Kıble** — Kâbe koordinatlarıyla büyük daire açısını hesapla (saf Dart, testli).
Pusula ekranı: sensör yoksa veya kalibrasyon gerekiyorsa açık uyarı ve
"8 çizerek kalibre edin" yönergesi. Kıbleye dönünce hafif titreşim (kapatılabilir).

**6.7 Kur'an**
- Liste: sure / cüz / sayfa / yer imleri sekmeleri, arama (sure adı, sure:ayet).
- Okuma: Arapça + meal / sadece Arapça / sadece meal; yazı boyutu; ayet başına
  yer imi; kaldığı yeri otomatik kaydet; hatim ilerlemesi (604 sayfa).
- Arapça metin: Tanzil Uthmani metni + Tanzil meta verisi (sayfa, cüz, hizip).
  Tanzil lisansı gereği metin değiştirilmez ve kaynak gösterilir
  (Ayarlar > Kaynaklar ve Lisanslar).
- Meal: `MealKaynagi` arayüzü tanımla. Lisanslı meal gelene kadar
  "Meal kaynağı eklenecek" yer tutucusu göster. **Hiçbir meali internetten
  indirip gömme.**

**6.8 Dualar** — Kategoriler: Sabah-Akşam, Namaz Duaları, Yemek, Şifa ve Sıkıntı.
Her dua: Arapça, Türkçe okunuş, anlam, kaynak alanı. Veri `assets/data/dualar.json`.

**6.9 Zikirmatik** — Zikir seçimi (Sübhânallah, Elhamdülillah, Allâhu Ekber,
Lâ ilâhe illallah + özel zikir), hedef (33/99/100/serbest), dairesel ilerleme,
tur sayısı, günlük toplam, dokununca hafif titreşim (kapatılabilir), ekranın
her yerine dokunarak sayma seçeneği, ekran kapanmasın seçeneği, sesli okuyucuda
her sayıyı duyurma.

**6.10 Önemli Günler** — `assets/data/onemli_gunler.json` (Diyanet'in resmî
dinî günler takvimi; dosyayı ben dolduracağım, sen şemayı ve örnek kayıtları
`kaynak_dogrulandi: false` ile oluştur). Sıradaki gün kartı, kalan gün,
her gün için hatırlatma bildirimi.

**6.11 Ayarlar** — Yazı boyutu (Normal / Büyük / Çok büyük, telefon ayarıyla
çarpımsal), yüksek kontrast, ezan ve bildirim ayarları, konum (otomatik / elle),
hesaplama yöntemi, vakit başına ±dakika düzeltme, hicrî tarih ±1 gün,
"Mahremiyetiniz emanettir" kartı, Kaynaklar ve Lisanslar, sürüm bilgisi.

**6.12 Ana ekran widget'ları** (`home_widget`) — Küçük: sıradaki vakit.
Orta: günün 6 vakti. Kilit ekranı (iOS) satırı. Widget'lar uygulama açılmasa da
doğru vakti göstermeli: günlük vakitleri önceden yaz, gece yarısı ve her
vakit geçişinde güncelle. Tasarım: `docs/tasarim/Widget`.

### 2. Sürüm — Fark yaratanlar

**6.13 Kaza Takibi** — Sabah, Öğle, İkindi, Akşam, Yatsı, Vitir ve Ramazan
orucu sayaçları; "Kıldım/Tuttum" ile azalt, "+" ile ekle; günlük tempoya göre
tahmini bitiş; "Gizle" ile sayıları maskele (isteğe bağlı uygulama içi PIN);
kaza borcu hesaplama sihirbazı (buluğ yaşından itibaren yıl girerek tahmini sayı).
Dil daima teşvik edici, asla suçlayıcı değil. Veriler yalnızca cihazda.

**6.14 Namaz ve Abdest Rehberi** — Adım adım ilerleyen rehber; her adımda başlık,
açıklama, varsa Arapça + okunuş + anlam, duruş çizimi alanı. Namaz için önce
sabah namazının farzı (Hanefi), sonra diğer vakitler. Çizimler için
`assets/rehber/` altında yer tutucu kullan; gerçek çizimler sonra gelecek.

### 3. Sürüm — Topluluk (bu fazda internet izni eklenir, öncesinde bana danış)

**6.15 Toplu Hatim** — Linkle paylaşılan, hesapsız hatim; cüz ve sayfa bazında
pay alma. Sunucuda kişisel veri tutulmaz (isim yok, yalnızca rastgele cihaz
anahtarı). Arka uç seçeneğini (ör. küçük bir kendi sunucumuz veya
mahremiyet dostu bir BaaS) artı/eksileriyle bana öner, kendin seçme.

**6.16 Sesli Tilavet** — Lisanslı kayıtlar; indirip internetsiz dinleme;
okunan ayeti vurgulama.

**6.17 Esmâ-ül Hüsnâ ve Hadis** — Gömülü veri; hadis bölümü için kaynak
derleme ve tercüme netleşmeden içerik ekleme.

---

## 7. Erişilebilirlik kontrol listesi (her ekran için)

- [ ] Yazı ölçeği 1.0, 1.5 ve 2.0'da taşma yok (widget testleriyle doğrula)
- [ ] Her ikon düğmesinin `tooltip`'i veya `Semantics(label:)`'ı var
- [ ] Dekoratif öğeler `ExcludeSemantics` içinde
- [ ] Kartlar ekran okuyucuda tek ve anlamlı cümle olarak okunuyor
- [ ] Dokunma alanları ≥ 48x48
- [ ] Renk kontrastı WCAG AA (normal metin 4.5:1)
- [ ] Sadece renkle bilgi verilmiyor (ör. "sıradaki vakit" metin olarak da yazıyor)
- [ ] TalkBack ve VoiceOver ile ekran baştan sona gezilebiliyor

---

## 8. Dini içerik kuralları

- Ayet metinleri: yalnızca `assets/data/quran/` (Tanzil). Elle yazma, kopyalama.
- Dua, okunuş, anlam, rehber açıklaması, Esmâ açıklaması gibi her metin
  JSON'da şu alanlarla tutulur: `kaynak`, `incelendi` (bool), `inceleyen`, `not`.
- Senin yazdığın her metin `incelendi: false` olur. Yayın öncesi bir hoca
  inceleyecek. `incelendi: false` kayıtları sayan bir test/betik yaz
  (`dart run tool/inceleme_raporu.dart`) ki eksikler görülsün.
- Hadis ve kaynak uydurma. Emin olmadığın bir şeyi yazma; yer tutucu bırak.
- Fıkhi tercihlerde Hanefi mezhebi ve Diyanet uygulaması esas alınır;
  farklı görüş gereken yerde bana sor.

---

## 9. Test ve kalite

- Her değişiklikten sonra `dart format .`, `flutter analyze` (sıfır uyarı) ve
  `flutter test` çalıştır.
- Birim testleri zorunlu: vakit hesaplama, kıble açısı, bildirim planlama,
  kaza tahmini, hicrî tarih düzeltmesi, sıradaki vakit/geri sayım (gece yarısı
  ve yatsı sonrası geçişler dahil).
- Widget testleri: her ana ekran için yazı ölçeği 1.0 ve 2.0'da render.
- Gerçek cihaz kontrol listesini `docs/cihaz_testi.md` içinde tut:
  Samsung, Xiaomi, Huawei/Honor, Pixel, eski bir Android (8–9), iPhone.
  Senaryolar: ekran kapalıyken ezan, medya sesi kısıkken ezan, yeniden
  başlatma sonrası ezan, uçak modunda tüm uygulama, saat dilimi değişimi.

---

## 10. Çalışma şekli

1. Her görevde önce kısa bir **plan** yaz (hangi dosyalar, hangi paketler,
   riskler); büyük görevlerde onayımı bekle.
2. Küçük ve anlamlı adımlarla ilerle; her adım sonunda analiz ve testleri çalıştır.
3. Commit mesajları Türkçe ve açıklayıcı (ör. "vakitler: Diyanet yöntemiyle hesaplama motoru").
4. Yapamadığın, doğrulayamadığın veya varsaydığın her şeyi görev sonunda
   **açıkça listele** (ör. "iOS'ta gerçek cihazda test edilmedi").
5. Değişmez İlkelerle çelişen bir şey gerekirse dur ve sor.
6. Tasarım tokenlarını, ekran düzenlerini ve metinleri gerekçesiz değiştirme;
   iyileştirme önerin varsa öner, uygulamadan önce sor.
7. Gizli anahtar, imza dosyası veya keystore'u depoya koyma.

---

## 11. Yayın hazırlığı (1. sürüm sonu)

- Uygulama kimliği: `com.abyad`
- Gizlilik politikası sayfası metni (Türkçe + İngilizce): "Veri toplamıyoruz."
- Mağaza gizlilik etiketleri: Google Play "Veri toplanmaz / paylaşılmaz",
  App Store "Data Not Collected"
- Mağaza adı önerisi: "Abyad: Namaz Vakti ve Kur'an"
- Kaynaklar ve Lisanslar ekranı: Tanzil, yazı tipleri (OFL), ezan sesleri, kullanılan paketler
