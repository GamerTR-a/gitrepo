# Diyanet İşleri Başkanlığı Meal Kullanım İzin ve Başvuru Dosyası (Abyad Projesi)

> **Doküman Amacı:** Bu dosya, Diyanet İşleri Başkanlığı Dini Yayınlar Genel Müdürlüğü’ne sunulacak başvuru dosyasının eksiksiz kopyasını, teknik şartları ve resmi yazışma yönergelerini içermektedir.

---

## 1. BAŞVURU SAHİBİ VE KURUM BİLGİLERİ

| Alan | Açıklama / Bilgi |
| :--- | :--- |
| **Geliştirici Adı Soyadı** | Abdurrahman Turan Özcan |
| **T.C. Kimlik Numarası** | *[Dilekçede Islak İmzalı Alan Doldurulacaktır]* |
| **Geliştirici Rolü** | Bağımsız Yazılım Geliştirici (Bireysel Kamu Yararı Projesi) |
| **İletişim E-Posta** | abdurrahmanturanozcan9191@gmail.com |
| **İletişim Telefonu** | 0553 883 26 57 |
| **Yazışma Adresi** | *[Tebligat Adresi]* |
| **Resmi KEP Adresi** | *[Varsa Kurumsal / Bireysel KEP Adresi]* |

---

## 2. PROJE TANITIMI VE MİSYONU

* **Uygulama Adı:** Abyad (Namaz Vakti ve Kur'an-ı Kerim Rehberi)
* **İsim Menşei:** Bakara Suresi 187. ayetindeki *"fecrin beyaz ipliği"* (`el-haytu'l-abyad`) ifadesinden ilham alınmıştır.
* **Hedef Kitle:** Türkiye'de ve yurt dışında yaşayan Türkçe konuşan Müslümanlar, yaşlılar, görme zorluğu çeken vatandaşlarımız ve dini içeriklere reklamsız erişmek isteyen tüm kullanıcılar.
* **Hedef Platformlar:** 
  - Android (Google Play Store - Paket Adı: `com.abyad`)
  - iOS (Apple App Store)

### Temel Modüller:
1. **Kur'an-ı Kerim:** Tanzil Uthmani Arapça metni + Diyanet İşleri Başkanlığı Türkçe Meali.
2. **Namaz Vakitleri:** Diyanet hesaplama parametrelerine %100 uyumlu internetsiz vakit motoru.
3. **Ezan ve Bildirimler:** Alarm düzeyinde sesli ezan ve vakit hatırlatmaları.
4. **Kıble Pusulası:** Kâbe açısı yüksek hassasiyetli hesaplama motoru.
5. **Dualar, Zikirmatik ve Kaza Takibi:** Internetsiz ve reklamsız ibadet takip araçları.

---

## 3. TALEP EDİLEN ESER VE MÜLKİYET SAHİBİ

* **Talep Edilen Eser:** Diyanet İşleri Başkanlığı Kur'an-ı Kerim Meali (Vatandaşlarımızın güvenle okuyabileceği resmi onaylı Türkçe meal metni).
* **Eser Sahibi / Hak Sahibi:** T.C. Cumhurbaşkanlığı Diyanet İşleri Başkanlığı.

---

## 4. GELİR MODELİ VE ETİK TAAHHÜTLER (KAR AMACI GÜTMEME)

Diyanet İşleri Başkanlığı'nın ticari ve reklam içeren dijital yayınlara uyguladığı kısıtlamalar çerçevesinde, uygulamamız aşağıdaki ilkelere **koşulsuz ve kesin olarak** tabidir:

1. **%100 Ücretsiz:** Uygulama indirme, kullanma veya hiçbir özelliği için ücret talep edilmez.
2. **Reklamsız:** Uygulama içerisinde AdMob, Google Ads, sponsorlu içerik veya banner dahil hiçbir reklam bulunmaz.
3. **Sayısal Mahremiyet (Sıfır Veri):** Kullanıcı kaydı/hesabı istenmez. Konum verisi dahil hiçbir kişisel veri sunuculara aktarılmaz.
4. **Çevrimdışı (Offline) Çalışma:** Tüm veriler uygulama kurulurken gömülü gelir, internet erişimi ve veri tüketimi gerektirmez.
5. **Bağış ve Satın Alma Yoktur:** Uygulama içi satın alma, abonelik veya bağış toplama modülleri tamamen yasaktır.

---

## 5. TEKNİK ARAYÜZ VE TİPOGRAFİ TASARIMI

### 5.1. Arayüz Görünümü ve Tasarım Taslakları
Meal metni uygulamada aşağıdaki standartlarla gösterilecektir:
* **Arapça Font:** Amiri Font (OFL Lisanslı, yüksek okunabilirlikte nesih hat).
* **Türkçe Meal Fontu:** Manrope / Inter (Net ve yüksek okunabilirlikli modern tipografi).
* **Gösterim Düzeni:** Ayet ayet hizalı Arapça metin ve altında Diyanet Türkçe Meali.
* **Erişilebilirlik:** Metin boyutları 2.0x ölçeğe kadar taşmadan büyüyebilir; yüksek kontrast seçeneği mevcuttur.
* **Görsel Taslak Referansı:** `docs/tasarim/04_kuran_oku.png` dosyası ve aşağıda örneklendirilen yerleşim düzeni.

```
+-------------------------------------------------------------+
|  Bakara Suresi - 187. Ayet (Sayfa 28 / Cüz 2)       [Bookmark] |
+-------------------------------------------------------------+
|  أُحِلَّ لَكُمْ لَيْلَةَ الصِّيَامِ الرَّفَثُ إِلَىٰ نِسَائِكُمْ ...                     |
|  وَكُلُوا وَاشْرَبُوا حَتَّىٰ يَتَبَيَّنَ لَكُمُ الْخَيْطُ الْأَبْيَضُ مِنَ الْخَيْطِ الْأَسْوَدِ  |
|  مِنَ الْفَجْرِ ۖ ثُمَّ أَتِمُّوا الصِّيَAMَ إِلَى اللَّيْلِ ...                         |
+-------------------------------------------------------------+
|  DİYANET İŞLERİ BAŞKANLIĞI MEALİ:                           |
|  "Oruç gecesinde kadınlarınıza yaklaşmak size helal kılındı.|
|  ... Fecrin beyaz ipliği siyah ipliğinden sizce ayırt edilinceye |
|  kadar yeyin için; sonra da geceye kadar orucu tamamlayın." |
+-------------------------------------------------------------+
|  [Kaynak: Diyanet İşleri Başkanlığı Meali - İzinli Kullanım] |
+-------------------------------------------------------------+
```

### 5.2. Metin Güvenliği ve Tahrifatı Önleme Tedbirleri
* **Salt Okunur (Read-Only) Veritabanı:** Meal metinleri SQLite/Drift veritabanı içerisinde şifrelenmiş veya değiştirilemez tablolar halinde saklanır.
* **Hash Doğrulama (SHA-256):** Uygulama her açılışında veritabanının bütünlüğünü kontrol eder. Dışarıdan müdahale veya ayet metni değiştirilme girişimlerinde veritabanı kendini kilitler.
* **Doğru İndeksleme ve Arama:** Arama algoritmaları ayet sırasını ve bağlamını bozmayacak şekilde sadece orijinal indekslere bağlı arama yapar.

---

## 6. RESMİ BAŞVURU VE İLETİŞİM KANALLARI

Hazırlanan dilekçe ve bu başvuru dosyası aşağıdaki yetkili makamlara iletilir:

### A. Fiziksel Posta / Doğrudan Teslim Adresi:
* **Kurum:** T.C. Cumhurbaşkanlığı Diyanet İşleri Başkanlığı - Dini Yayınlar Genel Müdürlüğü
* **Evrak Kayıt Adresi:** Üniversiteler Mah. Dumlupınar Bulvarı No:147/A 06800 Çankaya / ANKARA
* **İlgili Daireler:** Basılı Yayınlar Daire Başkanlığı & Radyo ve Televizyon Daire Başkanlığı (Dijital Yayınlar)

### B. Resmi KEP (Kayıtlı Elektronik Posta) Yolu:
* Şahıs KEP adresi veya tüzel kişilik KEP adresi üzerinden Diyanet İşleri Başkanlığı resmi KEP adresine e-imzalı başvuru yapılabilir.

---

## 7. İNCELEME, PROTOKOL VE MAĞAZA (STORE) YAYIN SÜRECİ

1. **Din İşleri Yüksek Kurulu İncelemesi:** Başvuru dosyamız ve arayüz tasarımlarımız yetkili kurulca metin bütünlüğü ve ticari kullanım açısından incelenir.
2. **Kullanım Protokolü İmzalama:** Başvuru olumlu sonuçlandığında Diyanet Döner Sermaye İşletmesi / Dini Yayınlar Genel Müdürlüğü ile bedelsiz Kullanım Protokolü imzalanır.
3. **Resmi Veri Seti Teslimi:** Diyanet tarafından onaylı dijital meal veri seti / JSON dosyası veya erişim yetkisi teslim alınır.
4. **Google Play & App Store Mağaza İzin Beyanı:**  
   Google Play Console ve Apple App Store Connect mağaza inceleme notlarına (App Review Information) şu beyan eklenir:
   > *"Uygulamada yer alan Türkçe Kur'an-ı Kerim meali, T.C. Diyanet İşleri Başkanlığı Dini Yayınlar Genel Müdürlüğü'nden alınan [PROTOKOL_NUMARASI] sayılı resmi izin belgesi uyarınca kullanılmaktadır."*

---
*İşbu dosya Abyad projesinin telif ve resmi izin süreçlerinin takibi amacıyla hazırlanmıştır.*
