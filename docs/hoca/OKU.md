# Hoca görüşmesi için dosyalar

| Dosya | Ne işe yarar |
|-------|--------------|
| `inceleme_belgesi.html` | Kapak, danışılacak konular ve incelenecek bütün kayıtlar (Arapça, Türkçe, kaynak, karar/not sütunu). Tarayıcıda açıp **A4 yatay** yazdırın. |
| `ek_temsili_hikayeler.html` | Kırk Hadis için yazılmış kurgusal hikâyeler. Uygulamada kapalıdır; karar hocaya bırakıldı. İsterse ayrıca verilir. |
| `fikhi_sorular.md` | Danışılacak konuların kaynağı. Soruları burada düzenleyin; belge buradan üretilir. |

İki HTML dosyası elle düzenlenmez. Veri ya da sorular değişince yeniden üretin:

```
dart run tool/hoca_belgesi.dart
```

Yazı tipleri `fonts/` klasöründen yüklenir; dosyaları depo içindeki yerinden
açın (başka klasöre kopyalarsanız Arapça metin sistem yazı tipiyle basılır).

## Görüşmeden önce

- Belgeyi basın. Bölümler ayrı sayfada başlar; hoca öğrencileriyle
  paylaştırmak isterse bölüm bölüm ayırabilirsiniz.
- Uygulamayı kendi telefonunuzda, Ayarlar > Yazı boyutu "Çok büyük" iken
  gösterin: vakitler, Kur'an, bir dua, bir hadis. Beş dakika yeter.
- `fikhi_sorular.md` içindeki 10. konuyu (isim ve iş bölümü) siz açın;
  hocanın sormasını beklemeyin.

## Hocanın sorabileceği dört soru

Cevaplar projenin bugünkü durumuna göre yazıldı; kendi cümlelerinizle söyleyin.

**Yanlış bilgi yayılırsa sorumluluk kimde?** Sorumluluk geliştiricidedir.
Her dinî metin veride `incelendi: false` ile başlar; hoca onaylamadan hiçbiri
"incelendi" yapılmaz. Şu an incelenmiş tek bir kayıt yoktur
(`dart run tool/inceleme_raporu.dart`). Hocanın onaylamadığı metin yayına
girmez; hata bulunursa güncellemeyle düzeltilir.

**Bu iş ticari mi?** Hayır. Reklam, abonelik, ücretli özellik ve veri toplama
yoktur; uygulama internete bile bağlanmaz.

**Kaynaklar sağlam mı?** Ayet metni yalnızca Tanzil dosyasından gelir ve
değiştirilmez. Bunun dışındaki metinlerin durumu belgede açıkça yazılıdır:
çoğunun kaynak satırı "taslak"tır ve kaynağı hocanın göstermesi beklenir;
hadislerin Arapçası harekesizdir ve basılı nüshayla karşılaştırılmamıştır.
Bunu gizlemeyin, baştan söyleyin.

**İsmim nerede kullanılacak?** İzin vermediği sürece hiçbir yerde. İsterse
"Hakkında" bölümünde, kendi belirlediği unvan ve yazımla.

## Görüşmeden sonra

Hocanın uygun bulduğu her kayıt için ilgili `assets/data/*.json` dosyasında
`incelendi: true`, `inceleyen` (izin verdiyse adı) ve varsa `not` alanını
doldurun; düzeltmeleri metne işleyin. Kerahat süreleri
`assets/data/ek_vakitler.json` içindeki `sureler` alanından, temsilî
hikâyelerin gösterimi `assets/data/hadisler.json` içindeki
`hikayeler_gosterilsin` alanından değişir.
