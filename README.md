# Abyad

Reklamsız, veri toplamayan, hesap istemeyen ve ücretsiz Müslüman rehberi
(Flutter, Android + iOS). Kurallar ve şartname: [CLAUDE.md](CLAUDE.md).
Faz planı: [CLAUDE_CODE_PROMPTLARI.md](CLAUDE_CODE_PROMPTLARI.md).

## Durum

| Özellik | Durum |
|---------|-------|
| Vakit hesaplama motoru (internetsiz) | Yazıldı; Türkiye'de sekiz şehirde bir yıl boyunca Diyanet vakitleriyle ±2 dk içinde. Avrupa'da yaz aylarında imsak ve yatsı Diyanet'ten farklı: [docs/vakit_dogrulama.md](docs/vakit_dogrulama.md) |
| Konum ve şehir seçimi (81 il, 940 ilçe, 303 Avrupa şehri) | Yazıldı |
| Ezan bildirimi | Yazıldı, emülatörde denendi; gerçek cihaz testi ve ezan kaydı bekliyor |
| Ana Sayfa, Vakitler, aylık imsakiye, Kıble | Yazıldı |
| Kur'an: sayfa sayfa (Mushaf düzeni) ve ayet ayet okuma, yer imi, kalınan yer | Yazıldı |
| Kur'an > Metin ve İşaretler (metnin kaynağı, rivayeti, yazımı; durak ve secde işaretleri) | Yazıldı; bilgiler taslak (`assets/data/kuran_metni.json`), hoca incelemesi bekliyor |
| Meal altyapısı (dosya biçimi, seçim, gösterim) | Yazıldı; meal metni lisans bekliyor ([nasıl eklenir](assets/data/quran/README.md)) |
| Tefsir | Ertelendi |
| Dualar, Zikirmatik | Yazıldı; içerik hoca incelemesi bekliyor |
| Önemli Günler ve hicrî tarih | Yazıldı; tarihler ve ay başlangıçları Diyanet'in 2026–2027 dinî günler listesinden. 2028 listesi yayımlanınca eklenmeli |
| Ayarlar (kısa ana sayfa + alt sayfalar), büyük yazı, yüksek kontrast, ekran okuyucu etiketleri | Yazıldı |
| Koyu tema (Ayarlar > Tema; varsayılan açık) | Yazıldı |
| Zikirmatik arka planında değişen manzara görselleri (varsayılan kapalı) | Yazıldı; 16 görsel yapay zekâ ile üretildi, `tool/manzara_uret.py` ile küçültülüp gömülür (2,3 MB) |
| Ana ekran widget'ları (Android) | Yazıldı; gerçek cihazda denenmedi |
| Kaza takibi ve hesaplama sihirbazı | Yazıldı |
| Namaz ve abdest rehberi (5 vakit, bölüm bölüm; ezber modu) | Yazıldı; çizimler geçici şematik, ses yok, Kunut ve Cuma yer tutucu ([liste](docs/rehber_varliklari.md)) |
| Esmâ-ül Hüsnâ | Yazıldı |
| Toplu hatim | Cihaz içi kısmı yazıldı (hatim, pay alma, okudum); linkle paylaşım sunucu kararını bekliyor: [docs/surum3_kararlar.md](docs/surum3_kararlar.md) |
| Kırk Hadis (Nevevî, 42 hadis: Arapça, tercüme) | Yazıldı; tercümeler taslak, hoca incelemesi bekliyor. Temsilî hikâyeler veride duruyor ama kapalı (`hikayeler_gosterilsin`) |
| Kerahat, işrak/duhâ ve teheccüd vakitleri; yüksek enlem açıklaması | Yazıldı; süreler taslak (`assets/data/ek_vakitler.json`), hoca incelemesi bekliyor |
| Sesli tilavet | Karar bekliyor: [docs/surum3_kararlar.md](docs/surum3_kararlar.md) |
| iOS | Derlenmedi, denenmedi; widget'lar yazılmadı |

## Çalıştırma

```
flutter pub get
flutter run
```

Uygulama kimliği: `com.abyad`

## Geliştirme komutları

```
dart format .
flutter analyze
flutter test
dart run tool/inceleme_raporu.dart
```

- **Çeviri metinleri** `tool/arb_uret.py` içindeki tablodan üretilir:
  `python tool/arb_uret.py && flutter gen-l10n`
  (çıktılar: `lib/l10n/app_tr.arb`, `lib/core/l10n/`).
- **Veritabanı (drift)** tablolarını değiştirince:
  `dart run build_runner build --force-jit`
  (`--force-jit` şart: proje yolu Türkçe karakter içerdiği için varsayılan
  derleme modu dosya yazamıyor).
- **Gömülü veriler** (şehirler, Kur'an üst verisi): `python tool/veri_uret.py KAYNAK`
  — ayrıntı betiğin başında. Esmâ: `python tool/esma_uret.py`.
- **İnceleme raporu:** `incelendi: false` kayıtları sayar; yayın öncesi sıfır olmalı.
- **Hoca inceleme belgesi** (yazdırılabilir tablo): `dart run tool/hoca_belgesi.dart`
  — çıktı ve hazırlık notları [docs/hoca/](docs/hoca/OKU.md).
- **Ekran görüntüleri** (gerçek yazı tipleriyle, tasarımla karşılaştırmak için):
  `ABYAD_GORUNTU_KLASORU=build/goruntu flutter test test/ekran_goruntusu_test.dart`

## Bilinen sorunlar

- **Release derlemesi bu klasörde çalışmaz.** `flutter build apk --release`,
  yoldaki Türkçe karakter (`Masaüstü`) yüzünden "Unable to read file …
  app.dill" hatası verir; debug derleme ve `flutter run` çalışır. Çözüm:
  projeyi `C:\dev\abyad` gibi bir klasöre taşımak. `android/gradle.properties`
  içindeki `android.overridePathCheck=true` yalnızca debug içindir.
  Taşımadan derlemek için: PowerShell'de `subst Y: "<proje yolu>"`, `Y:\`
  içinden `flutter build appbundle --release`, sonra `subst Y: /D`.
- **Mağaza görseli (`docs/feature_graphic_1024x500.png`) kullanılmamalı.**
  Yapay zekâ ile üretilmiş; içindeki telefon ekranı gerçek uygulama değil ve
  Fâtiha diye gösterilen Arapça satırlar bozuk. Gerçek ekran görüntüsüyle
  yeniden hazırlanmalı. (Logodaki benzer yazı `tool/logo_duzelt.py` ile silindi.)
- **Kurulu Flutter 3.41.5** ile drift 2.35+, Riverpod 3 ve permission_handler
  14 çözülmüyor/derlenmiyor; sürümler buna göre sabitlendi.

## Klasörler

```
lib/app/            MaterialApp, kabuk (alt menü), arka plan yenileme
lib/core/           tema, ortak widget'lar, içerik yükleyiciler, depolama, tarih
lib/features/       özellik bazlı: domain/ (saf Dart) · data/ · ui/
lib/l10n/           app_tr.arb (tool/arb_uret.py üretir)
assets/data/        şehirler, Kur'an (Tanzil), dualar, esma, rehber, günler
android/…/AbyadWidget.kt   ana ekran widget'ları
docs/               tasarım, cihaz testi, bildirim, gizlilik, mağaza, 3. sürüm
test/domain/        hesaplama, plan, içerik ve depolama testleri
test/ekranlar/      her ekran için taşma (1.0/1.5/2.0) ve etkileşim testleri
tool/               veri ve çeviri üretme betikleri, inceleme raporu
```

`test/degismez_ilkeler_test.dart`, ana Android manifest'ine INTERNET izni
veya projeye analitik/reklam paketi eklenirse testleri kırar.

## Belgeler

- [docs/cihaz_testi.md](docs/cihaz_testi.md) — gerçek cihazda denenecek senaryolar
- [docs/vakit_dogrulama.md](docs/vakit_dogrulama.md) — vakit hesabının Diyanet'le karşılaştırması ve kalan farklar
- [docs/bildirim.md](docs/bildirim.md) — ezan bildirimi tasarımı, tam zamanlı alarm izni
- [docs/surum3_kararlar.md](docs/surum3_kararlar.md) — toplu hatim, tilavet, hadis
- [docs/hoca/OKU.md](docs/hoca/OKU.md) — hoca görüşmesi: inceleme belgesi, danışılacak konular, demo sırası
- [docs/gizlilik.md](docs/gizlilik.md) — gizlilik politikası taslağı (TR + EN)
- [docs/magaza.md](docs/magaza.md) — mağaza metni ve yayın öncesi liste
- [assets/data/quran/README.md](assets/data/quran/README.md) — Tanzil lisansı

## Tasarım

`docs/tasarim/NN_ad.png` ekranın görüntüsü, `NN_ad.dc.html` ölçülerin ve
renklerin okunabildiği kaynak dosyadır. Asıl kanvas:
`Müslüman Rehberi – Uygulama Ekranları.html`.

## Lisans notları

- Yazı tipleri: SIL Open Font License 1.1 (`fonts/OFL-*.txt`).
- Kur'an metni: Tanzil Project, CC BY 3.0, değiştirilmeden.
- Şehir koordinatları: GeoNames, CC BY 4.0.
- Türkçe meal, tilavet ve ezan kayıtları izinsiz eklenmez.
