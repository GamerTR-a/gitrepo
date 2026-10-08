# Namaz ve Abdest Rehberi: çizim ve ses dosyaları

Rehber adımları `assets/data/rehber/` altındaki JSON dosyalarında durur. Her
adımın `cizim` alanı `assets/rehber/`, `ses` alanı `assets/audio/rehber/`
altındaki bir dosya adıdır. Yeni dosya **aynı adla** klasöre konunca uygulama
onu kullanır; kodda ya da veride değişiklik gerekmez.

Denetim: `dart run tool/rehber_dogrula.dart` eksik çizim ve sesleri listeler.

## Çizimler

**Şu anki durum:** 18 dosyanın hepsi yerinde, fakat bunlar geçici şematik
çizimlerdir (çöp adam ve basit şekiller). Gerçek çizimler geldiğinde aynı
adlarla üzerlerine yazılacak.

Gerçekçi görseller (WebP) de desteklenir: üretim tarifi, duruş başına
istemler ve kabul listesi [rehber_gorsel_istemleri.md](rehber_gorsel_istemleri.md)
içindedir; `python tool/rehber_gorsel_uret.py KLASOR` onları uygulamaya ekler.
Aşağıdaki kurallar yalnızca SVG çizim teslim edecek bir çizer içindir.

Namaz adımlarında bir önceki duruştan bu duruşa kısa bir geçiş oynatılır;
ilerideki gerçek animasyon planı [rehber_animasyon_plani.md](rehber_animasyon_plani.md)
içindedir.

### İllüstratör için kurallar

- Biçim: SVG, `viewBox="0 0 240 160"` (yatay, 3:2). Metin, gömülü resim,
  CSS sınıfı ve filtre kullanılmamalı; yalnızca yol ve temel şekiller.
- Dosya adı kuralı: `abdest_NN_ad.svg` ve `namaz_NN_ad.svg` (küçük harf,
  Türkçe karakter yok). Adlar aşağıdaki tabloyla birebir aynı olmalı.
- Renkler: çizgi zümrüt `#0F3D33`, vurgu pirinç `#C9A24B`, açık dolgu
  `#F4EBD6`, zemin çizgisi `#C9D2CC`. Arka plan saydam.
- Üslup: sade çizgi, yüz ayrıntısı yok (göz, kaş, ifade çizilmez). Figür
  erkek ya da kadın olarak ayırt edilmeyecek kadar yalın olmalı; kadınlara
  özgü farklar metin olarak ("Kadınlar için" kutusu) verilir.
- Namaz çizimlerinde figür yandan görünüşte sağa (kıbleye) bakar; ayakta
  önden görünüş de kabul edilir.
- Küçük ekranda 150 piksel yükseklikte gösterilir; ince ayrıntıdan kaçının.

### Abdest

| Dosya | Duruş / konu | Kısa tarif |
|---|---|---|
| `abdest_01_niyet.svg` | Niyet ve Besmele | Abdeste başlangıç: temiz su (damla, ibrik ya da musluk) |
| `abdest_02_eller.svg` | Eller | İki el bileklere kadar yıkanıyor, parmak araları açık |
| `abdest_03_agiz.svg` | Ağız | Sağ avuçla ağza su veriliyor |
| `abdest_04_burun.svg` | Burun | Sağ elle buruna su çekiliyor |
| `abdest_05_yuz.svg` | Yüz | Alından çene altına, kulaktan kulağa yüzün tamamı yıkanıyor |
| `abdest_06_kollar.svg` | Kollar | Parmak uçlarından dirseğe kadar, dirsek dahil yıkanıyor |
| `abdest_07_bas.svg` | Baş meshi | Islak eller başın üstünde, önden arkaya doğru |
| `abdest_08_kulak_boyun.svg` | Kulaklar ve boyun | Parmaklar kulaklarda, el arkası boyunda |
| `abdest_09_ayaklar.svg` | Ayaklar | Ayak, topuk ve bilek dahil yıkanıyor |

### Namaz

| Dosya | Duruş | Kısa tarif | Kullanıldığı adımlar |
|---|---|---|---|
| `namaz_01_niyet.svg` | Niyet | Kıbleye dönük, ayakta, kollar iki yanda | Niyet |
| `namaz_02_tekbir.svg` | Tekbir | Ayakta, eller kulak hizasında, avuçlar kıbleye dönük | İftitah tekbiri, Kunut tekbiri |
| `namaz_03_kiyam.svg` | Kıyam | Ayakta, sağ el sol elin üstünde göbeğin altında bağlı, bakış secde yerinde | Kıyam, Kıraat, Kunut |
| `namaz_04_ruku.svg` | Rükû | Belden eğilmiş, sırt düz, eller dizlerde | Rükû |
| `namaz_05_kavme.svg` | Kavme | Rükûdan doğrulmuş, dik, kollar iki yanda | Kavme |
| `namaz_06_secde.svg` | Secde | Alın, burun, eller, dizler ve ayak parmakları yerde | Secde, İkinci secde |
| `namaz_07_celse.svg` | Celse | İki secde arasında dizler üzerinde kısa oturuş | Celse |
| `namaz_08_kade.svg` | Oturuş | Dizler üzerinde oturulmuş, eller dizlerin üstünde | İlk oturuş, Son oturuş |
| `namaz_09_selam.svg` | Selam | Oturur hâlde, baş önce sağa sonra sola çevrilir | Selam |

Yeni bir çizim eklenecekse (ör. kadınlar için ayrı duruşlar) önce JSON'daki
`cizim` ve `cizim_tarifi` alanları güncellenir; `cizim_tarifi` ekran
okuyucunun okuduğu tariftir.

## Sesler

**Şu anki durum:** ses dosyası yok. Dosyası olmayan adımda "Okunuşu dinle"
düğmesi gösterilmez.

- Biçim: mp3, tek kanal, mümkünse 64–96 kbps. Dosya adı küçük harf ve alt
  çizgi (`fatiha.mp3`).
- Kayıtlar izinli/lisanslı olmalı (CLAUDE.md §2.8); kaynak ve izin
  "Kaynaklar ve Lisanslar" ekranına yazılır.
- Dosyalar gelince bir ses oynatıcı (`just_audio`, CLAUDE.md §3'teki onaylı
  liste) eklenip `rehberSesCalarProvider`'a bağlanacak. Bu adım henüz
  yapılmadı; yalnızca dosyayı klasöre koymak düğmeyi açmaz.

| Dosya | İçerik | Kullanıldığı adımlar |
|---|---|---|
| `besmele.mp3` | Besmele | Abdest: Niyet ve Besmele |
| `tekbir.mp3` | Allâhu Ekber | İftitah tekbiri, Kunut tekbiri |
| `subhaneke.mp3` | Sübhâneke | Kıyam |
| `fatiha.mp3` | Fâtiha Suresi | Kıraat |
| `ruku_tesbihi.mp3` | Sübhâne Rabbiye'l-azîm | Rükû |
| `kavme.mp3` | Semiallâhü limen hamideh | Kavme |
| `secde_tesbihi.mp3` | Sübhâne Rabbiye'l-a'lâ | Secde, İkinci secde |
| `ettehiyyatu.mp3` | Ettehiyyâtü | İlk oturuş, Son oturuş |
| `selam.mp3` | Esselâmü aleyküm ve rahmetullâh | Selam |

## İçerikte bilerek boş bırakılanlar

- **Kunut duaları:** vitir rehberinde adım var, dua metni yok. Metin
  `dualar.json`'a hoca onayıyla eklenince `namaz_adimlari.json` içindeki
  `kunut` adımının `dualar` alanına kimlikleri yazılır.
- **Cuma namazı:** `namaz_vakitleri.json` içinde yer tutucu; içerik hocadan
  gelmeden eklenmeyecek.
