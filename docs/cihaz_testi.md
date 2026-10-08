# Gerçek cihaz test listesi

Ezan bildirimi Abyad'ın en kritik özelliğidir ve yalnızca gerçek telefonda
doğrulanabilir. Her sürümden önce aşağıdaki senaryolar şu cihazlarda denenir:
**Samsung, Xiaomi, Huawei/Honor, Pixel, eski bir Android (8–9), iPhone.**

Sonuçları tabloya `✓` / `✗` ve kısa notla işleyin.

## Hazırlık

1. Uygulamayı kurun, ilk açılışta konumu ve bildirim iznini verin.
2. Ayarlar > "Test bildirimi gönder": birkaç saniye içinde bildirim ve ses gelmeli.
3. Ayarlar'da "Tam zamanlı alarm izni kapalı" uyarısı görünüyorsa izni verin.
4. Ayarlar > "Ezanın her durumda çalması için" kartındaki yönergeyi uygulayın.
5. Hızlı deneme için: Ayarlar > Vakitlere dakika ekle/çıkar ile bir vakti
   birkaç dakika sonrasına çekin (ya da telefonun saatini vakte yaklaştırın).

## Senaryolar

| # | Senaryo | Beklenen | Samsung | Xiaomi | Huawei | Pixel | Android 8–9 | iPhone |
|---|---------|----------|---------|--------|--------|-------|-------------|--------|
| 1 | Ekran açık, uygulama önde | Bildirim + ses, vakitte (±1 dk) | | | | | | |
| 2 | Ekran kapalı, telefon masada 30+ dk | Ses çalar, ekran uyanır | | | | | | |
| 3 | Medya sesi sıfır, alarm sesi açık | Ezan yine duyulur | | | | | | |
| 4 | Telefon sessizde / titreşimde | Cihaz davranışını not edin | | | | | | |
| 5 | Rahatsız Etmeyin açık | Not edin (alarm istisnası açıksa çalar) | | | | | | |
| 6 | Uygulama son uygulamalardan kaydırılıp kapatıldı | Bildirim yine gelir | | | | | | |
| 7 | Telefon yeniden başlatıldı, uygulama açılmadı | Sıradaki vakitte bildirim gelir | | | | | | |
| 8 | Pil tasarrufu modu açık | Bildirim gelir (gecikme varsa dakikasını yazın) | | | | | | |
| 9 | Gece boyunca şarjsız, sabah imsakı | İmsak ve 15 dk önce hatırlatma gelir | | | | | | |
| 10 | Uçak modu, bütün gün | Vakitler, Kur'an, dualar, bildirimler çalışır | | | | | | |
| 11 | Saat dilimi değişimi (ör. İstanbul → Berlin) | Elle seçili şehirde bildirimler aynı anda gelir; "Konumumu kullan" sonrası yeni yere göre kurulur | | | | | | |
| 12 | Telefon saati elle değiştirildi | Uygulama açılınca vakit ve geri sayım doğru | | | | | | |
| 13 | Uygulama 7 gün hiç açılmadı | 7. günden sonra bildirim gelmeyebilir (bkz. Bilinen sınırlar) | | | | | | |
| 14 | "Cuma namazında sessiz" açık, Cuma öğlesi | Ses yok, titreşim var | | | | | | |
| 15 | Bir vakit "Titreşim", biri "Kısa uyarı" | Seçilen ses türü uygulanır | | | | | | |
| 16 | Önemli gün hatırlatması açık | O gün 10:00'da bildirim | | | | | | |

## Widget

| # | Senaryo | Beklenen |
|---|---------|----------|
| W1 | "Sıradaki Vakit" ve "Günün Vakitleri" widget'larını ekleyin | Doğru şehir ve vakitler |
| W2 | Bir vakit girdikten sonra (uygulama kapalı) | Widget sıradaki vakte geçer, geri sayım yenilenir |
| W3 | Gece yarısından sonra | Yeni günün vakitleri görünür |
| W4 | Yeniden başlatma sonrası | Widget boş kalmaz |
| W5 | Uygulamada şehir değiştirin | Widget yeni şehre geçer |

## Erişilebilirlik

| # | Senaryo | Beklenen |
|---|---------|----------|
| E1 | Telefon yazı boyutu en büyük + uygulamada "Çok büyük" | Hiçbir ekranda taşma, kesilen metin yok |
| E2 | TalkBack / VoiceOver ile Ana Sayfa'yı baştan sona gezin | Her öğe anlamlı okunur, düğmelerin adı var |
| E3 | TalkBack ile Zikirmatik | Her dokunuşta yeni sayı duyurulur |
| E4 | Yüksek kontrast açık | Bütün metinler rahat okunur |
| E5 | Kıble: pusulayı çevirin | Kıbleye gelince titreşim; yön metni güncellenir |

## Rehber, Toplu Hatim ve Hadis

| # | Senaryo | Beklenen |
|---|---------|----------|
| R1 | Rehber > Öğle > Farz; adımları sona kadar yana kaydırın | 30 adım; çizimler görünür; "2. rekat · Rükû" göstergesi doğru ilerler |
| R2 | Göz düğmesiyle ezber modunu açın | Arapça ve okunuş gizlenir; "Göstermek için dokunun" ile açılır |
| R3 | TalkBack ile bir adımı dinleyin | Çizim tarifi, başlık, açıklama ve okunuş okunur; Arapça harfler okunmaz |
| R4 | Rehber > Abdest | 9 adım ve "Abdesti bozan durumlar" listesi |
| H1 | Toplu Hatim > Hatim başlat; bir cüze dokunun, "Okudum" deyin | Cüz "Senin", sonra "Okundu" olur; ilerleme çubuğu artar |
| H2 | Uygulamayı kapatıp açın | Hatim ve paylar yerinde |
| H3 | "Okumaya başla" | Kur'an o cüzün ilk sayfasından açılır |
| H4 | Uçak modunda H1–H3 | Aynı şekilde çalışır (internet gerekmez) |
| K1 | Kırk Hadis > bir hadis | 42 hadis listelenir; detayda Arapça metin düzgün (sağdan sola, harfler bitişik), tercüme, kaynak ve "Temsilî hikâye" kartı görünür |

## Tema ve Zikirmatik arka planı

| # | Senaryo | Beklenen |
|---|---------|----------|
| T1 | Ayarlar > Tema > Koyu | Bulunduğunuz ekran değişmeden bütün uygulama koyu renklere geçer; durum çubuğu ikonları açık renk olur |
| T2 | Koyu temada bütün sekmeleri ve alt sayfaları gezin | Okunmayan yazı, kaybolan ikon ya da açık kalmış zemin yok |
| T3 | Uygulamayı kapatıp açın | Seçilen tema korunur |
| T4 | Koyu tema + yüksek kontrast + "Çok büyük" yazı | Metinler rahat okunur, taşma yok |
| Z1 | Zikirmatik (ilk hâli) | Arka plan boş ve sade; eskisiyle aynı |
| Z2 | Zikirmatik > "Arka planda manzara" açık, aralık 15 sn | Sayacın arkasında manzara görseli görünür, 15 saniyede bir yumuşakça değişir; sayaçtaki sayı rahat okunur, sayma ve titreşim etkilenmez; eski/az bellekli telefonda takılma olmaz |
| Z3 | Z2 açıkken ekranı kapatıp açın, başka ekrana gidip dönün | Çizim göstermeye devam eder; pil tüketiminde belirgin artış yok |

## Bilinen sınırlar (doğrulanacak)

- **7 günlük pencere:** Android'de bildirimler 7 gün önceden kurulur ve
  uygulama her açıldığında yenilenir. Uygulama 7 günden uzun süre hiç
  açılmazsa bildirimler durur. iOS'ta sınır 64 bildirimdir (yaklaşık 5 gün).
- **Tam zamanlı alarm izni verilmezse** Android bildirimi birkaç dakika
  geciktirebilir.
- **Ezan sesi henüz yok:** lisanslı kayıt eklenene kadar telefonun varsayılan
  bildirim sesi çalar (`ezanSesiVar` bayrağı, `bildirim_servisi.dart`).
- **Marka yönergeleri** (Ayarlar'daki Samsung/Xiaomi/Huawei yolları) genel
  bilgiye göre yazıldı; menü adları cihazda doğrulanmalı.
- **Pusula:** gerçek kuzey / manyetik kuzey farkı (Türkiye'de ~5–6°)
  cihazlarda ölçülerek doğrulanmalı.
- iOS'ta hiçbir şey gerçek cihazda denenmedi.
