# Namaz ve abdest rehberi: animasyon planı

## Bugünkü durum (1. yol, yapıldı)

Namaz rehberinde duruş bir önceki adımdan farklıysa önce eski duruş görünür,
sonra yumuşakça yeni duruşa geçilir (yaklaşık 2 saniye, bir kez). Sağ üstteki
düğme geçişi tekrar oynatır. Telefonda "animasyonları kaldır" ayarı açıksa
geçiş oynatılmaz. Yeni paket ya da yeni görsel gerekmedi; gerçek görseller
(`docs/rehber_gorsel_istemleri.md`) eklendiğinde aynı geçiş onlarla çalışır.

Eksikleri: iki kare arasında "solarak geçiş" vardır, gerçek hareket yoktur;
abdest adımlarında geçiş yoktur (her adım ayrı bir uzuvdur, "önce/sonra"
karesi gerekir).

## 3. yol: gerçek vektör animasyon (Lottie ya da Rive)

Tek bir karakter bir kez "iskeletlenir", sonra her duruş geçişi o iskeletin
hareketi olarak kaydedilir. Sonuç akıcıdır, dosyalar küçüktür (animasyon
başına onlarca KB), her ekran boyutunda nettir ve renkleri temaya uydurulabilir.

### "Pahalı" olan ne?

- **Para ya da emek.** Bu animasyonları yapay zekâ üretemez, kod da yazamaz;
  bir animatörün (ya da öğrenmeye istekli birinin) çizip hareketlendirmesi
  gerekir: 1 karakter, 9 namaz geçişi, 9 abdest hareketi.
- **Yeni bir paket.** Uygulamada animasyonu oynatacak bir kütüphane gerekir;
  onaylı pakette yoktur, eklemek sizin kararınızdır (CLAUDE.md §3).
- **Tekrar inceleme.** Hareketin kendisi (ör. secdeye giderken önce dizlerin
  yere değmesi) hocanın onayından geçmelidir.

### Araç seçenekleri

| | Lottie | Rive |
|---|---|---|
| Animatörün kullandığı araç | Adobe After Effects (ücretli) ya da Lottie üreten başka çizim araçları | Rive'ın kendi editörü |
| Uygulamadaki paket | `lottie` | `rive` |
| Dosya | `.json` (ya da sıkıştırılmış `.lottie`) | `.riv` |
| Artısı | Bu işi bilen animatör bulmak kolay; hazır dosya biçimi yaygın | Etkileşimli animasyona (durdur, ileri sar) daha uygun |
| Eksisi | After Effects'in her özelliği desteklenmez | Editör tek şirkete bağlı; bilen animatör daha az |

**Ön tercih: Lottie.** Bizim ihtiyacımız etkileşim değil, kısa ve tek seferlik
hareket; animatör bulmak da daha kolay.

Karar vermeden önce doğrulanacaklar (henüz doğrulanmadı):

- Paketin pub.dev'deki bakım durumu, son sürümü ve kurulu Flutter sürümüyle
  derlenip derlenmediği.
- Paketin internet izni istemediği ve hiçbir veri göndermediği (Değişmez
  İlke 1 ve 2). `test/degismez_ilkeler_test.dart` bunu ayrıca denetler.
- Paketin APK boyutuna etkisi.
- Editörlerin güncel ücret ve lisans koşulları (üretilen dosyaların ticari
  olmayan ücretsiz bir uygulamada kullanımı dahil).

### Animatöre verilecek şartlar

- Duruş tarifleri: `docs/rehber_gorsel_istemleri.md` (Hanefî, erkek figür,
  yandan görünüş, sağa bakar). Hoca onayından sonra verilir.
- Oran 3:2, saydam arka plan, yazı yok, yüz ayrıntısı sade.
- Her animasyon 1,5–2,5 saniye, döngüsüz; **son kare adımın duruşudur**
  (animasyon kapalıyken yalnızca son kare gösterilir).
- Gömülü resim (PNG/JPEG) ve betik/ifade kullanılmaz; yalnızca vektör şekil.
- Animasyon başına en çok 150 KB.
- Dosya adları bugünkü çizimlerle aynı (`namaz_04_ruku`, `abdest_06_kollar`…).

### Adımlar

1. Duruş tarifleri ve (varsa) gerçek görseller hocaya onaylatılır.
2. Paket seçimi yukarıdaki doğrulamalarla yapılır; karar sizindir.
3. **Deneme:** tek bir animasyon (rükû) yaptırılır, eski ve yavaş bir
   Android telefonda denenir. Sonuç iyi değilse 1. yolla kalınır.
4. Kalan 17 animasyon yaptırılır; her biri hocaya gösterilir.
5. Kodda `cizim` alanına yeni dosya türü eklenir. Tekrar oynatma düğmesi,
   animasyon kapalıyken durağan gösterim ve ekran okuyucu tarifi bugünkü
   hâliyle kalır; yalnızca gösterim değişir.
6. "Kaynaklar ve Lisanslar" ekranına animasyonların sahibi ve izni yazılır.

### Ne zaman?

Acele gerektirmez. Önce gerçek durağan görseller ve hoca onayı; 1. yolun
kullanıcıya yetip yetmediği görüldükten sonra 3. adımdaki denemeye geçilir.
