# Hoca görüşmesi için dosyalar

Görüşülecek hocanın alanı Kur'an okuma, kıraat ve mushaf yazımıdır; fıkıh ve
hadis değildir. Belgeler buna göre düzenlendi: Kur'an metni ve Arapça yazım
öndedir, fıkıh ve hadis konuları için "kime danışalım" diye sorulur.

| Dosya | Ne işe yarar |
|-------|--------------|
| `inceleme_belgesi.html` | Kapak, danışılacak konular ve incelenecek bütün kayıtlar (Arapça, Türkçe, kaynak, karar/not sütunu). **A grubu** Kur'an ve Arapça metin, **B grubu** fıkıh, hadis ve diğerleri. Tarayıcıda açıp **A4 yatay** yazdırın. |
| `ek_temsili_hikayeler.html` | Kırk Hadis için yazılmış kurgusal hikâyeler. Uygulamada kapalıdır. Bu görüşmeye götürmeniz gerekmez; hadis alanından bir hocaya gidilirse verilir. |
| `danisilacak_konular.md` | Danışılacak konuların kaynağı. Soruları burada düzenleyin; belge buradan üretilir. |

İki HTML dosyası elle düzenlenmez. Veri ya da sorular değişince yeniden üretin:

```
dart run tool/hoca_belgesi.dart
```

Yazı tipleri `fonts/` klasöründen yüklenir; dosyaları depo içindeki yerinden
açın (başka klasöre kopyalarsanız Arapça metin sistem yazı tipiyle basılır).

## Görüşmeden önce

- **Mağaza görselini göstermeyin.** `docs/feature_graphic_1024x500.png`
  içindeki telefon ekranında Fâtiha diye gösterilen satırlar bozuk harflerdir;
  mushaf yazımı uzmanı bunu ilk bakışta görür. (Logodaki benzer yazı silindi;
  telefona yeni sürümü kurduktan sonra ikon temizdir.)
- Yalnızca A grubunu ve danışılacak konuları basmanız yeterli olabilir; B
  grubunu isterse verirsiniz.
- Tanzil metnini nereden, hangi ayarlarla indirdiğinizi bilin
  (`assets/data/quran/README.md`). Arapça okuma düzeyinizi olduğu gibi söyleyin.

## Demo sırası (kendi telefonunuzda, yazı boyutu "Çok büyük")

1. Kur'an > bir sayfa (sayfa görünümü), sonra aynı yerin ayet ayet görünümü.
2. Kur'an başlığındaki bilgi düğmesi > "Metin ve İşaretler" sayfası.
3. Bir namaz suresi: Arapça, okunuş ve "incelenmedi" durumunun nasıl
   tutulduğu.
4. Ayarlar > Kaynaklar ve Lisanslar.
5. Vakitler ve zikirmatik en sonda, kısaca.

## Hocanın sorabileceği dört soru

Cevaplar projenin bugünkü durumuna göre yazıldı; kendi cümlelerinizle söyleyin.

**Metne güvenebilir miyiz?** Ayet metni yalnızca Tanzil dosyasından gelir ve
değiştirilmez; bunu her derlemede testler denetler (sure, ayet ve sayfa
sayıları, lisans bloğu, besmelenin yalnızca gösterimde ayrılması). Basılı bir
mushafla karşılaştırma yapılmadı; bunu saklamayın.

**Yanlış bilgi yayılırsa sorumluluk kimde?** Sorumluluk geliştiricidedir.
Her dinî metin veride `incelendi: false` ile başlar; hoca onaylamadan hiçbiri
"incelendi" yapılmaz. Şu an incelenmiş tek bir kayıt yoktur
(`dart run tool/inceleme_raporu.dart`).

**Bu iş ticari mi?** Hayır. Reklam, abonelik, ücretli özellik ve veri toplama
yoktur; uygulama internete bile bağlanmaz.

**İsmim nerede kullanılacak?** İzin vermediği sürece hiçbir yerde. İsterse
"Hakkında" bölümünde, kendi belirlediği unvan ve yazımla.

## Açmaya değer fikirler (kodlanmadı)

Bunlar hocanın alanına giriyor; yapılacaksa içerik ve izin ondan gelmeli.
Görüşmede fikir olarak açın, söz vermeyin:

- Kelimat projesindeki yakın anlamlı kelime açıklamalarından izinle yararlanmak.
- "Mushafın kısa tarihi" bölümü.
- Türkiye'de alışılmış yazımla ikinci bir metin seçeneği.
- Elif-ba ve tecvid bölümü; harf seslerinin kaydı.

## Görüşmeden sonra

Hocanın uygun bulduğu her kayıt için ilgili `assets/data/*.json` dosyasında
`incelendi: true`, `inceleyen` (izin verdiyse adı) ve varsa `not` alanını
doldurun; düzeltmeleri metne işleyin. Kur'an sayfasındaki bilgiler
`assets/data/kuran_metni.json`, kerahat süreleri `assets/data/ek_vakitler.json`
içindedir.
