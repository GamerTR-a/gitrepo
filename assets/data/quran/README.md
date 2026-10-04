# Kur'an verisi

| Dosya | Kaynak | Not |
|-------|--------|-----|
| `quran-uthmani.txt` | Tanzil Project, Uthmani metin, sürüm 1.1 | **Değiştirilmez.** Dosyanın sonundaki lisans bloğu korunur. |
| `quran-data.xml` | Tanzil üst verisi (sure, cüz, hizip, sayfa, secde) | Aynen kopya; uygulama okumaz, kaynak olarak durur. |
| `quran_meta.json` | `quran-data.xml`'den `tool/veri_uret.py` ile türetildi | Ayet metni içermez. Türkçe sure adları betikte yazılıdır. |

## Lisans

Tanzil Quran Text — Creative Commons Attribution 3.0. Şartlar:

- Metin birebir kopyalanabilir ve dağıtılabilir, **değiştirilemez**.
- Kaynak (Tanzil Project) açıkça belirtilir ve tanzil.net'e bağlantı verilir
  (uygulamada: Ayarlar > Kaynaklar ve Lisanslar ve okuma ekranının altı).
- Telif bildirimi metnin kopyalarında korunur.

## Nasıl indirildi

```
https://tanzil.net/pub/download/index.php?quranType=uthmani&outType=txt-2&agree=true&marks=true&sajdah=true&tatweel=true
https://tanzil.net/res/text/metadata/quran-data.xml
```

Biçim: "Text (with aya numbers)" — her satır `sure|ayet|metin`. Fâtiha ve
Tevbe dışındaki surelerin ilk ayeti dosyada besmele ile birlikte gelir;
uygulama dosyayı değiştirmez, besmeleyi yalnızca **gösterirken** ayrı bir
başlık olarak sunar (`KuranVerisi.ayetMetni`). `test/domain/icerik_test.dart`
gösterimin dosyadaki metni eksiksiz yeniden kurduğunu doğrular.

Güncellemeler: <http://tanzil.net/updates/>

## Meal

Şu an gömülü meal **yoktur** (`mealler.json` içinde `"mealler": []`).
Ekranlar "Meal kaynağı eklenecek" yer tutucusunu gösterir. İzinsiz hiçbir
meal eklenmez, internetten indirilmez.

### Meal nasıl eklenir

1. Hak sahibinden yazılı izin alın (ya da eserin kamu malı olduğunu bir
   hukukçuya teyit ettirin). Belgeyi `docs/lisanslar/` altına koyun.
2. Meal metnini `assets/data/quran/meal/<id>.txt` olarak kaydedin:
   UTF-8, her satır `sure|ayet|metin` (Tanzil ile aynı biçim). Boş satırlar
   ve `#` ile başlayan satırlar atlanır. 6236 ayetin tamamı bulunmalıdır.
3. `mealler.json` içindeki `mealler` listesine kaydı ekleyin (`ornek`
   alanındaki şablona göre): `id`, `ad`, `sahip`, `lisans`, `izinBelgesi`, `dosya`.
4. `flutter test` çalıştırın: `test/ekranlar/kuran_sayfa_test.dart` her
   meal için eksik ayet olmadığını, lisans metninin ve izin belgesinin
   bulunduğunu denetler.

Kod değişikliği gerekmez: meal okuma ekranlarında, sayfa görünümünde ayete
dokununca, dualarda, Günün Ayeti'nde ve Kaynaklar ve Lisanslar'da kendiliğinden
görünür. Birden fazla meal eklenirse Ayarlar > Kur'an > Meal'den seçilir.
