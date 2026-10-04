# Mağaza metni taslağı (TR)

**Ad:** Abyad: Namaz Vakti ve Kur'an

**Kısa açıklama (80 karakter):**
Reklamsız, internetsiz, hesapsız namaz vakti, ezan, kıble ve Kur'an.

**Uzun açıklama:**

Abyad; reklam göstermeyen, veri toplamayan, hesap istemeyen ve tamamen
ücretsiz bir Müslüman rehberidir. İnternet olmadan çalışır.

• Namaz vakitleri: telefonunuzda hesaplanır, internet gerekmez. 81 il,
  ilçeler ve Avrupa şehirleri.
• Ezan bildirimi: her vakit için ayrı ses seçimi, vakitten önce hatırlatma.
  Medya sesi kısıkken de duyulması için alarm olarak çalar.
• Kıble pusulası.
• Kur'an-ı Kerim: Arapça metin, sure/cüz/sayfa gezinme, yer imleri,
  kaldığınız yerden devam.
• Dualar ve Zikirmatik.
• Önemli günler ve hatırlatmalar.
• Kaza namazı ve oruç takibi (sayılar gizlenebilir).
• Yeni başlayanlar için adım adım namaz ve abdest rehberi.
• Esmâ-ül Hüsnâ.
• Ana ekran widget'ları: ücretsiz.
• Büyük yazı, yüksek kontrast ve ekran okuyucu desteği.

Abyad adı, Bakara suresinin 187. ayetinde imsak vaktini tarif eden
"el-haytu'l-abyad" (fecrin beyaz ipliği) ifadesinden gelir.

**Anahtar kelimeler:** namaz vakitleri, ezan vakti, ezan saati, imsakiye,
kıble pusulası, kuran, zikirmatik, dua, kaza namazı, reklamsız

## Yayın öncesi yapılacaklar

- [ ] Projeyi Türkçe karakter içermeyen bir klasöre taşıyın (release
      derlemesi şu an çalışmıyor; bkz. README).
- [ ] Release imzası: `keytool -genkey -v -keystore abyad.jks -keyalg RSA
      -keysize 2048 -validity 10000 -alias abyad`; `android/key.properties`
      dosyasına yolu ve parolaları yazın; **anahtar ve bu dosya depoya
      konmaz** (`.gitignore`'a ekli olmalı). `android/app/build.gradle.kts`
      içindeki `signingConfigs.getByName("debug")` satırı release imzasıyla
      değiştirilir.
- [ ] `dart run tool/inceleme_raporu.dart` sıfır incelenmemiş kayıt göstermeli.
- [ ] `test/fixtures/diyanet_referans.json` doldurulmuş ve testler geçmiş olmalı.
- [ ] Lisanslı meal ve ezan kaydı eklendi ya da eksikliği mağaza metninde
      açıkça belirtildi (şu an meal yok; açıklamada "meal" vaat edilmiyor).
- [ ] Logodaki Mushaf sayfası yazısı düzeltildi (bkz. README, Bilinen sorunlar).
- [ ] `docs/cihaz_testi.md` tablosu dolduruldu.
- [ ] Gizlilik politikası yayımlandı ve bağlantısı mağazaya girildi.
- [ ] Açılış ekranı (şu an Android varsayılanı: beyaz zemin + ikon).
