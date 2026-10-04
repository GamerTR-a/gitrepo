# Abyad — Claude Code Faz Promptları

Kullanım: `CLAUDE.md` dosyasını proje köküne koyun. Aşağıdaki promptları
**sırayla**, her fazı bitirip test ettikten sonra Claude Code'a yapıştırın.
Bir fazı tek seferde yaptırmak yerine bu şekilde bölmek, hataları erken
yakalamanızı ve kontrolün sizde kalmasını sağlar.

Her fazdan sonra kendiniz şunu yapın: uygulamayı gerçek telefonda açın,
`flutter test` sonucuna bakın, beğenmediğiniz yeri Claude Code'a söyleyin.

---

## Faz 0 — Proje kurulumu

```
CLAUDE.md dosyasını baştan sona oku ve özetini 10 madde ile bana yaz.

Sonra projeyi kur:
1. Proje kökünde abyad_flutter_baslangic.zip var. İçindekileri incele;
   lib/theme ve lib/widgets dosyalarını CLAUDE.md §4'teki yapıya göre
   lib/core/theme ve lib/core/widgets altına taşı, assets/ ve fonts/
   klasörlerini kökte tut, importları düzelt.
2. Riverpod, drift, shared_preferences ve gen-l10n (app_tr.arb) altyapısını kur.
   Ana sayfa ve alt menüdeki sabit Türkçe metinleri .arb dosyasına taşı.
3. Ana AndroidManifest.xml'de INTERNET izni OLMADIĞINDAN emin ol.
4. analysis_options.yaml'ı flutter_lints + birkaç sıkı kuralla ayarla.
5. Uygulama başlangıç paketindeki Ana Sayfa ile açılsın, flutter analyze
   sıfır uyarı versin, flutter test geçsin.

Önce planını yaz, onayımı bekle.
```

---

## Faz 1 — Vakit hesaplama motoru

```
CLAUDE.md §6.2'ye göre internetsiz vakit hesaplama motorunu yaz.

- features/vakitler/domain altında saf Dart. Flutter'a bağımlı olmasın.
- Paket olarak adhan (veya adhan_dart) değerlendir: pub.dev'de bakım durumunu,
  Türkiye/Diyanet yöntemini nasıl desteklediğini ve API'sini doğrula,
  bulgularını bana özetle. Gerekirse Diyanet yönteminin parametrelerini
  (açılar, temkin dakikaları) kendin uygula ve kaynağını yorumda belirt.
- Mevcut GunlukVakitler modelini koru ve genişlet; Ana Sayfa'daki örnek veriyi
  motordan gelen veriyle değiştir.
- Yüksek enlem kuralı, saat dilimi ve yaz saati geçişleri.
- test/fixtures/diyanet_referans.json için şema oluştur (şehir, tarih, 6 vakit);
  ben dolduracağım. Dolu kayıtlar için ±2 dk toleranslı testler yaz,
  boşsa skip et.
- Sıradaki vakit / geri sayım için yatsıdan sonra ve gece yarısında doğru
  çalıştığını gösteren testler.
```

---

## Faz 2 — Konum ve şehir seçimi

```
Konum özelliğini yaz:
- geolocator + permission_handler ile konum; izin reddedilirse uygulama
  çalışmaya devam etsin.
- assets/data/sehirler.json: Türkiye'nin 81 ili ve ilçeleri ile gurbetteki
  Türklerin yoğun olduğu Avrupa şehirleri (ad, ülke, enlem, boylam, saat
  dilimi). Koordinatları güvenilir bir açık kaynaktan (ör. GeoNames, CC BY)
  al, kaynağı ve lisansı Kaynaklar ve Lisanslar listesine ekle.
  Hepsini tek seferde ekleyemiyorsan önce 81 il merkezi ile başla ve bana söyle.
- İnternetsiz arama yapılabilen şehir seçme ekranı (erişilebilir, büyük yazıda düzgün).
- Konum değişince vakitleri ve bildirimleri yeniden hesaplayan servis.
- Konum yalnızca cihazda saklanır.
```

---

## Faz 3 — Ezan bildirimi (en kritik faz)

```
CLAUDE.md §6.3'ü eksiksiz uygula. Bu, uygulamanın en önemli özelliği;
acele etme, önce detaylı bir plan ve risk listesi çıkar.

- Bildirim planlama mantığını saf Dart'ta yaz (girdi: vakitler + ayarlar,
  çıktı: planlanacak bildirim listesi) ve kapsamlı test et.
- Android: alarm ses kanalı, exactAllowWhileIdle, SCHEDULE_EXACT_ALARM ve
  POST_NOTIFICATIONS izin akışları, BOOT_COMPLETED / saat dilimi / saat
  değişiminde yeniden kurma. Google Play'in tam zamanlı alarm politikasını
  özetle ve hangi izni neden seçtiğini açıkla.
- iOS: 64 bildirim sınırı için kayan pencere; ezan sesinin 30 sn'yi aşmayan
  iOS sürümü için yer (assets/audio/ezan/ios/), dosya yoksa varsayılan ses.
- Ayarlar'a "Test bildirimi gönder" ve pil optimizasyonu kartı.
- docs/cihaz_testi.md'yi bu fazın senaryolarıyla doldur.
- Sonunda, gerçek cihazda benim test etmem gereken adımları sıralı liste
  olarak ver.
```

---

## Faz 4 — Vakitler ekranı ve Kıble

```
docs/tasarim/ altındaki Vakitler görseline birebir uyarak Namaz Vakitleri
ekranını kodla (CLAUDE.md §6.5) ve Kıble özelliğini ekle (§6.6).
- Kıble açısı hesabı saf Dart + testli (İstanbul ≈ 151–152°, Berlin, Ankara
  gibi birkaç şehirle doğrula).
- Pusula ekranı, kalibrasyon uyarısı, sensör yoksa açıklama.
- Aylık imsakiye görünümü.
- §7 erişilebilirlik kontrol listesini bu ekranlar için uygula; 1.0 ve 2.0
  yazı ölçeğinde widget testleri yaz.
```

---

## Faz 5 — Kur'an

```
CLAUDE.md §6.7'ye göre Kur'an bölümünü yap.
- Tanzil'in Uthmani metnini ve meta verisini (sure, ayet, sayfa, cüz)
  assets/data/quran/ altına koy; nasıl indirdiğini ve lisans şartlarını
  README'ye yaz. Metni değiştirme.
- drift ile okuma ilerlemesi ve yer imleri.
- Liste ve okuma ekranlarını tasarım görsellerine göre kodla; büyük metinlerde
  akıcı kaydırma için performansa dikkat et (ListView.builder, önbellek).
- MealKaynagi arayüzü + yer tutucu. Hiçbir meal metnini ekleme.
- Ana Sayfa'daki "kaldığın yerden devam" kartını gerçek veriye bağla.
```

---

## Faz 6 — Dualar, Zikirmatik, Önemli Günler

```
CLAUDE.md §6.8, §6.9 ve §6.10'u uygula.
- dualar.json ve onemli_gunler.json şemalarını §8'deki inceleme alanlarıyla
  kur. Senin yazdığın her kayıt incelendi:false olsun.
- tool/inceleme_raporu.dart betiğini yaz.
- Zikirmatik: titreşim, ekranın her yerine dokunma modu, ekran açık kalsın
  seçeneği, ekran okuyucu duyuruları, drift ile günlük toplam.
- Önemli günler için hatırlatma bildirimleri (Faz 3'teki planlama sistemini kullan).
```

---

## Faz 7 — Ayarlar ve erişilebilirlik turu

```
CLAUDE.md §6.11'e göre Ayarlar ekranını tamamla.
Sonra bütün uygulamada §7 erişilebilirlik kontrol listesini baştan sona uygula:
- Her ekran için 1.0 / 1.5 / 2.0 yazı ölçeği widget testleri
- Semantics denetimi (her ekranın ekran okuyucu okuma sırasını bana yaz)
- Kontrast kontrolü
Bulduğun sorunları ve düzeltmelerini rapor et.
```

---

## Faz 8 — Ana ekran widget'ları

```
CLAUDE.md §6.12'ye göre home_widget ile Android ve iOS widget'larını yap.
- Android: Glance veya klasik AppWidget (hangisini neden seçtiğini açıkla).
- iOS: WidgetKit uzantısı + App Group; kilit ekranı aksesuar widget'ı.
- Uygulama açılmasa da doğru vakit: günün vakitlerini önceden yaz, timeline /
  güncelleme zamanlarını vakit geçişlerine göre ayarla.
- Xcode'da benim elle yapmam gereken adımları (App Group, imzalama) sırayla yaz.
```

---

## Faz 9 — 1. sürüm yayın hazırlığı

```
CLAUDE.md §11'e göre yayın hazırlığı yap:
- Kaynaklar ve Lisanslar ekranı (Tanzil, yazı tipleri, şehir verisi, paketler)
- Gizlilik politikası metni (TR + EN), docs/gizlilik.md
- Mağaza açıklaması taslağı (TR), anahtar kelimeler
- Uygulama ikonu ve açılış ekranı için yer tutucular (flutter_launcher_icons,
  flutter_native_splash yapılandırması)
- Release derlemesi için imzalama adımlarını yaz (anahtarları depoya koyma)
- Son kontrol: INTERNET izni yok mu, hiçbir analitik/izleme paketi yok mu,
  incelendi:false kayıt sayısı kaç? Rapor ver.
```

---

## 2. ve 3. sürüm promptları

```
CLAUDE.md §6.13 (Kaza Takibi) özelliğini uygula. Önce kaza borcu hesaplama
sihirbazının fıkhi varsayımlarını (Hanefi, vitir dahil, buluğ yaşı girişi)
bana listele ve onayımı al; sonra kodla.
```

```
CLAUDE.md §6.14 (Namaz ve Abdest Rehberi) özelliğini uygula. Bütün açıklama
metinleri incelendi:false olsun. Çizimler için yer tutucu kullan.
```

```
3. sürüme geçiyoruz. CLAUDE.md §6.15 Toplu Hatim için arka uç seçeneklerini
(maliyet, mahremiyet, bakım yükü) karşılaştır, kişisel veri tutmayan bir
tasarım öner. Kod yazmadan önce onayımı bekle. İnternet izni bu fazda eklenecek;
gizlilik politikasında neyin değiştiğini de yaz.
```

---

## Her zaman işe yarayan kısa promptlar

- "Bu ekranı docs/tasarim/[dosya] görseliyle karşılaştır, farkları listele ve düzelt."
- "Son yaptığın değişiklikleri gözden geçir: CLAUDE.md'deki Değişmez İlkelere aykırı bir şey var mı?"
- "flutter analyze ve flutter test çıktısını göster, hataları düzelt."
- "Bu özelliği gerçek cihazda nasıl test etmem gerektiğini adım adım yaz."
- "Yaptığın varsayımları ve doğrulayamadığın şeyleri listele."
