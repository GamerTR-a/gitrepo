# 3. sürüm: karar bekleyen özellikler

CLAUDE.md bu üç özellik için karar istiyor. Ana manifest'e INTERNET izni
**eklenmedi**; karar gerektirmeyen kısımlar yazıldı (aşağıda "Yazılanlar").

## 1. Toplu Hatim (§6.15)

Tasarım: `docs/tasarim/12_toplu_hatim.png`. Linkle paylaşılan, hesapsız
hatim; cüz ve sayfa bazında pay alma.

### Yazılanlar (5 Ekim 2026)

Sunucu gerektirmeyen kısım kodlandı; hatim yalnızca cihazda tutulur:

- `lib/features/hatim/domain/hatim.dart`: hatim ve pay modeli, pay kuralları
  (aynı payı yalnızca ilk isteyen alır; okudum, geri al, bırak), tahmin
  edilemeyen 12 karakterlik kod, rastgele katılımcı anahtarı, başlık/not
  için uzunluk sınırı ve link filtresi.
- Ekranlar: hatim listesi, yeni hatim, pay ızgarası (tasarımdaki gibi),
  "Okumaya başla" ile Kur'an'ı o cüz ya da sayfadan açma.
- Bölme şekli hatim başına tektir: cüz cüz (30 pay) ya da sayfa sayfa
  (5'er sayfalık 121 pay). "İkisi birden" henüz yok.

Sunucuyla birlikte gelecekler: link ve paylaşım, başkalarının payları,
katılımcı anahtarının hash'lenmesi, yöneticinin ilerlemeyen payları serbest
bırakması, 180 gün sonra otomatik silme, istek sınırlama ve küfür filtresi,
hatim duası ekranı (metin hoca onayı bekliyor).

### Ortak veri modeli (hangi arka uç seçilirse seçilsin)

- **Hatim:** rastgele kimlik (linkteki), ad, hedef tarih, oluşturma zamanı.
- **Pay:** hatim kimliği, cüz ya da sayfa numarası, durum (alındı / okundu),
  payı alan cihazın rastgele anahtarı.
- **Tutulmayanlar:** isim, e-posta, telefon, konum, IP kaydı, cihaz kimliği.
  Cihaz anahtarı uygulamanın ilk açılışta ürettiği rastgele bir değerdir;
  yalnızca "bu pay benim" diyebilmek için kullanılır, kişiyle eşleşmez.
- Link, hatmin tek anahtarıdır: linki olan herkes katılır.

### Seçenekler

| | A. Kendi küçük sunucumuz | B. Mahremiyet dostu BaaS (ör. Supabase AB bölgesi, PocketBase barındırma) | C. Sunucusuz: paylaşılan dosya/mesajla elle eşitleme |
|---|---|---|---|
| Nasıl | Tek bir küçük VPS'te basit bir REST servisi + SQLite/Postgres | Hazır veritabanı + satır düzeyi kurallar | Hatim durumu bir metin olarak WhatsApp vb. ile paylaşılır, uygulama içe aktarır |
| Maliyet | Aylık küçük bir VPS ücreti + alan adı | Küçük ölçekte ücretsiz katman; büyüyünce aylık ücret | Yok |
| Mahremiyet | En iyi: kayıt tutma tamamen bizim elimizde, IP günlükleri kapatılabilir | Sağlayıcı IP ve erişim günlüğü tutabilir; sözleşme ve bölge seçimi gerekir | En iyi: hiçbir veri bizim elimize geçmez |
| Bakım yükü | En yüksek: güncelleme, yedek, izleme, kötüye kullanım önleme bizde | Orta: şema ve kurallar bizde, altyapı sağlayıcıda | Yok |
| Kullanıcı deneyimi | Canlı, tasarımdaki gibi | Canlı, tasarımdaki gibi | Zayıf: iki kişi aynı cüzü alabilir, eşitleme elle |
| İnternet izni | Gerekir | Gerekir | **Gerekmez** (share_plus yeter) |
| "Üçüncü taraf SDK yok" ilkesi | Uyar (düz HTTP) | SDK yerine düz HTTP kullanılırsa uyar | Uyar |

**Önerim: A (kendi küçük sunucumuz), düz HTTP ile.** "Sıfır veri" vaadini
ancak günlükleri kendimiz kapatabildiğimiz bir sunucu tam karşılar; veri
modeli çok küçük olduğu için bakım yükü sınırlıdır. Sunucu bakımı
üstlenilemeyecekse B yerine önce C'yi (internetsiz) düşünmenizi öneririm;
çünkü B'de mahremiyet sözümüz bir sağlayıcıya bağlanır. **Seçim sizin.**

### İnternet izni eklenirse neler değişir

- Ana manifest'e `INTERNET` eklenir; `test/degismez_ilkeler_test.dart`
  bilinçli olarak güncellenir.
- Gizlilik politikası: "Toplu hatim özelliğini kullanırsanız, aldığınız
  cüz/sayfa bilgisi ve rastgele bir cihaz anahtarı sunucumuza gönderilir;
  isim ya da kişisel bilgi gönderilmez. Özelliği kullanmazsanız uygulama
  internete bağlanmaz." maddesi eklenir.
- Mağaza veri etiketleri yeniden doldurulur (Google Play'de sunucuya giden
  her veri beyan edilir).
- Ağ çağrıları yalnızca Toplu Hatim ekranından yapılır; diğer bütün
  özellikler internetsiz kalır.

### Karar vermeniz gerekenler

1. A / B / C seçeneklerinden hangisi?
2. A ya da B ise sunucu hangi ülkede/bölgede barınacak?
3. Kötüye kullanım (linki ele geçiren birinin bütün payları alması) için
   kural: pay başına cihaz sınırı olsun mu?

## 2. Sesli Tilavet (§6.16)

Tasarımda Kur'an okuma ekranının altında oynatıcı var ("Kâri: [KÂRİ ADI]").

- **Engel:** lisanslı tilavet kaydı yok. Kayıtlar izinsiz eklenemez
  (CLAUDE.md §2.8).
- **Gereken kararlar:** hangi kâri ve hangi kaynak (yazılı izin); kayıtlar
  uygulamaya gömülecek mi (boyut çok büyür) yoksa indirilecek mi (internet
  izni ve barındırma gerekir); ayet zaman damgaları (okunan ayeti vurgulamak
  için) kimden gelecek.
- Karar ve dosyalar gelince `just_audio` ile eklenebilir; okuma ekranı
  ayet kartları buna hazır.

## 3. Hadis bölümü (§6.17)

**Durum (6 Ekim 2026): içerik eklendi, inceleme bekliyor.**

- **Derleme:** İmam Nevevî'nin Kırk Hadis'i (el-Erbaûn); geleneksel adı
  "Kırk Hadis" olan eser 42 hadis içerir, hepsi eklendi.
- **Arapça metin:** Vikikaynak'taki (ar.wikisource.org, الأربعون النووية)
  kamu malı metinden alındı. Harekesizdir. Yalnızca uzatma çizgileri ve
  birkaç yazım hatası düzeltildi; 16. hadisin kaynak notu alınan nüshada
  "Buhârî ve Müslim" yazıyordu, yaygın nüshalara göre "Buhârî" yapıldı.
- **Tercüme, açıklama ve hikâyeler:** Abyad için yazılmış taslaklardır;
  yayımlanmış bir tercümeden alınmamıştır.
- **Hikâyeler temsilîdir:** her hadisin altındaki hikâye günümüzde geçen
  kurgusal bir anlatıdır; sahabe kıssası ya da rivayet değildir. Ekranda
  "Temsilî hikâye" başlığı ve altında bu açıklama gösterilir.
- 8. ve 14. hadislerin (savaş ve ceza hükümleri) altına kısa bağlam notu
  eklendi; bu notlar özellikle dikkatle incelenmelidir.

**Hocadan istenenler:** Arapça metnin güvenilir bir baskıyla karşılaştırılması
(mümkünse harekeli metin), tercümelerin ve râvi adlarının denetimi, bağlam
notlarının ve hikâyelerin uygunluğu. 42 kaydın hepsi `incelendi: false`.

## Durum özeti

| Özellik | Durum |
|---------|-------|
| Esmâ-ül Hüsnâ | Yapıldı (99 isim, hepsi `incelendi: false`) |
| Toplu Hatim | Cihaz içi kısmı yapıldı; paylaşım arka uç kararını bekliyor |
| Sesli Tilavet | Lisanslı kayıt ve dağıtım kararı bekliyor |
| Hadis | 42 hadis eklendi (Arapça, tercüme, temsilî hikâye); hoca incelemesi bekliyor |
