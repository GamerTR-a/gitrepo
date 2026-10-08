# Namaz ve abdest rehberi: gerçek görseller için üretim tarifi

Rehberdeki 18 çizim şu an geçici şematik SVG'lerdir. Bu belge, onların yerine
konacak gerçekçi görsellerin nasıl üretileceğini (yapay zekâ aracıyla ya da
bir çizerle) ve uygulamaya nasıl ekleneceğini anlatır.

**Önemli:** Duruş tarifleri Hanefî mezhebine ve erkek figüre göre yazılmış
taslaktır. Görselleri uygulamaya koymadan önce tarifleri ve üretilen her
görseli hocaya gösterin (docs/hoca/). Yanlış bir duruş çizimi, yanlış bir
metinden daha kalıcı öğretir.

## Nasıl eklenir

1. Her görseli aşağıdaki **dosya adıyla** bir klasöre kaydedin
   (ör. `namaz_04_ruku.jpg`; jpg ya da png, yatay, en az 1500 piksel genişlik).
2. `python tool/rehber_gorsel_uret.py KLASOR` çalıştırın. Betik görselleri
   3:2 oranına kırpar, küçültür, `assets/rehber/` altına yazar, eski çizimi
   siler ve veri dosyalarını günceller. Hepsini birden getirmek zorunda
   değilsiniz; gelmeyen adım eski çizimiyle kalır.
3. `flutter test` çalıştırın, sonra Rehber'i telefonda baştan sona gezin.

## Üslup: 18 görselin hepsi aynı kişi, aynı kıyafet, aynı üslup

Yapay zekâ araçlarının en zayıf olduğu yer tutarlılıktır. Önce tek bir
görsel üretin (kıyam en uygunudur), beğendiğinizi **referans görsel** olarak
yükleyip diğerlerini "aynı kişi, aynı kıyafet, aynı üslup" diyerek üretin.

Her istemin başına şu ortak bölümü koyun:

```text
Realistic digital illustration with soft, even lighting, in the style of a
clear instructional guide. One adult man with a short beard, wearing a plain
white long-sleeved shirt and loose dark green trousers, barefoot. His face is
calm and simple, without strong expression. Plain warm off-white background,
no room details, no decoration. Full body in frame with margin on all sides.
Anatomically correct hands with five fingers. No text, no letters, no
captions, no watermark, no logo. Landscape format, 3:2.
```

Namaz görselleri için ek:

```text
Exact side view (profile). The man faces the right edge of the image. He is
on a plain rectangular prayer rug without patterns or images.
```

Abdest görselleri için ek:

```text
He is performing ablution at a simple wall tap with clear running water.
Sleeves rolled up above the elbows. Close enough that the hands and the
washed part are clearly visible.
```

## Namaz (9 görsel)

| Dosya adı | Duruş | İsteme eklenecek sahne |
|---|---|---|
| `namaz_01_niyet` | Niyet | `Standing upright, feet about one hand-width apart, arms resting straight down at his sides, looking at the ground ahead of him.` |
| `namaz_02_tekbir` | Tekbir | `Standing upright, both hands raised beside his head with open palms facing forward, thumbs level with the earlobes, fingers slightly apart and pointing up.` |
| `namaz_03_kiyam` | Kıyam | `Standing upright, right hand placed over the left hand, right hand grasping the left wrist, both hands held below the navel. Gaze lowered to the ground ahead.` |
| `namaz_04_ruku` | Rükû | `Bowing from the waist with the back and head in one flat horizontal line, legs straight, hands gripping the knees with fingers spread, arms straight. Gaze toward his feet.` |
| `namaz_05_kavme` | Kavme | `Standing fully upright again after bowing, arms hanging straight down at his sides, looking at the ground ahead.` |
| `namaz_06_secde` | Secde | `Prostrating: forehead and nose touching the rug, both palms flat on the rug beside the head with fingers together pointing forward, elbows lifted off the ground and away from the body, belly lifted away from the thighs, knees on the rug, toes bent and touching the rug pointing forward.` |
| `namaz_07_celse` | Celse (iki secde arası) | `Sitting upright on his knees: sitting on his left foot which lies flat under him, right foot upright with toes bent forward, hands resting on the thighs near the knees, gaze toward his lap.` |
| `namaz_08_kade` | Oturuş (Ettehiyyâtü) | `Sitting upright on his knees: sitting on his left foot which lies flat under him, right foot upright with toes bent forward, both hands resting flat on the thighs with fingertips at the knees, gaze toward his lap.` |
| `namaz_09_selam` | Selam | `Same sitting position on his knees, hands on the thighs, body facing right, head turned over his right shoulder toward the viewer, looking at his shoulder.` |

Celse ve oturuş aynı duruştur; tek görsel üretip iki adla kaydedebilirsiniz.

## Abdest (9 görsel)

| Dosya adı | Adım | İsteme eklenecek sahne |
|---|---|---|
| `abdest_01_niyet` | Niyet ve Besmele | `Standing in front of the tap before starting, sleeves rolled up, hands open under the stream of water.` |
| `abdest_02_eller` | Eller | `Washing both hands up to the wrists under the water, fingers interlaced to wash between them.` |
| `abdest_03_agiz` | Ağız | `Bringing water to his mouth with his cupped right hand to rinse the mouth.` |
| `abdest_04_burun` | Burun | `Bringing water to his nose with his cupped right hand to rinse the nose.` |
| `abdest_05_yuz` | Yüz | `Washing his whole face with both wet hands, from the hairline to below the chin.` |
| `abdest_06_kollar` | Kollar | `Washing his right arm with his left hand, from the fingertips up to and including the elbow, water running along the forearm.` |
| `abdest_07_bas` | Baş meshi | `Wiping the top of his head with his wet right hand, palm flat on the hair, moving from front to back.` |
| `abdest_08_kulak_boyun` | Kulaklar ve boyun | `Wiping his ears with wet hands: index fingers inside the ears, thumbs behind the ears.` |
| `abdest_09_ayaklar` | Ayaklar | `Washing his right foot under a low tap with his left hand, including the heel and ankle, fingers washing between the toes. Trouser leg rolled up above the ankle.` |

## Her görseli kabul etmeden önce bakın

Yapay zekâ bu konuda sık hata yapar. Aşağıdakilerden biri varsa görseli
kullanmayın, yeniden üretin:

- [ ] Her elde beş parmak var; fazla ya da kaynaşmış parmak, fazla kol/bacak yok.
- [ ] Kıyamda **sağ el üstte**, eller göbeğin altında (göğüste değil).
- [ ] Tekbirde avuçlar öne bakıyor, başparmaklar kulak hizasında.
- [ ] Rükûda sırt düz ve yere paralel; baş ne eğik ne kalkık; dizler bükük değil.
- [ ] Secdede alın **ve burun** yerde, dirsekler yerden kalkık, ayak parmakları
      yere basıyor (ayaklar havada değil).
- [ ] Oturuşta sol ayak yatık, sağ ayak dik.
- [ ] Selamda yalnızca baş dönüyor, gövde dönmüyor.
- [ ] Abdestte yıkanan uzuv doğru (sağ kol, sağ ayak) ve sınır görünür
      (dirsek, topuk ve bilek dahil).
- [ ] Görselde yazı, harf, Arapça benzeri anlamsız karalama, logo yok.
- [ ] Seccadede Kâbe ya da canlı resmi yok; arka planda eşya yok.
- [ ] Ayakkabı ve çorap yok; kıyafet 18 görselde aynı.
- [ ] Figür 18 görselde aynı kişi.

## Kadınlar için

Uygulama kadınlara özgü farkları şu an metin olarak ("Kadınlar için" kutusu)
veriyor. Ayrı görsel isterseniz tekbir, kıyam, rükû, secde ve oturuş için
beş ek görsel gerekir; duruşlar farklı olduğundan (eller göğüste, secdede
kollar bitişik, oturuşta ayaklar sağ yanda) bunların tarifini hocayla
netleştirdikten sonra ekleyelim.

## Lisans ve açıklama

Görseller yapay zekâ ile üretilirse "Kaynaklar ve Lisanslar" ekranındaki
metin buna göre güncellenmelidir (zikirmatik görsellerinde yapıldığı gibi).
Başkasına ait fotoğraf ya da çizim izinsiz eklenmez (CLAUDE.md §2.8).
