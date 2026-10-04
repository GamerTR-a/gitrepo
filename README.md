# Abyad

Reklamsız, veri toplamayan, hesap istemeyen ve ücretsiz Müslüman rehberi
(Flutter, Android + iOS). Kurallar ve şartname: [CLAUDE.md](CLAUDE.md).
Faz planı: [CLAUDE_CODE_PROMPTLARI.md](CLAUDE_CODE_PROMPTLARI.md).

## Durum

| Özellik | Durum |
|---------|-------|
| Vakit hesaplama motoru (internetsiz) | Yazıldı; Diyanet referanslarıyla doğrulama bekliyor |
| Konum ve şehir seçimi (81 il, 940 ilçe, 303 Avrupa şehri) | Yazıldı |
| Ezan bildirimi | Yazıldı, emülatörde denendi; gerçek cihaz testi ve ezan kaydı bekliyor |
| Ana Sayfa, Vakitler, aylık imsakiye, Kıble | Yazıldı |
| Kur'an: sayfa sayfa (Mushaf düzeni) ve ayet ayet okuma, yer imi, kalınan yer | Yazıldı |
| Meal altyapısı (dosya biçimi, seçim, gösterim) | Yazıldı; meal metni lisans bekliyor ([nasıl eklenir](assets/data/quran/README.md)) |
| Tefsir | Ertelendi |
| Dualar, Zikirmatik, Önemli Günler | Yazıldı; içerik hoca incelemesi bekliyor |
| Ayarlar, büyük yazı, yüksek kontrast, ekran okuyucu etiketleri | Yazıldı |
| Ana ekran widget'ları (Android) | Yazıldı; gerçek cihazda denenmedi |
| Kaza takibi ve hesaplama sihirbazı | Yazıldı |
| Namaz ve abdest rehberi | Yazıldı; çizimler yok |
| Esmâ-ül Hüsnâ | Yazıldı |
| Toplu hatim, sesli tilavet, hadis | Karar bekliyor: [docs/surum3_kararlar.md](docs/surum3_kararlar.md) |
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
- **Ekran görüntüleri** (gerçek yazı tipleriyle, tasarımla karşılaştırmak için):
  `ABYAD_GORUNTU_KLASORU=build/goruntu flutter test test/ekran_goruntusu_test.dart`

## Bilinen sorunlar

- **Release derlemesi bu klasörde çalışmaz.** `flutter build apk --release`,
  yoldaki Türkçe karakter (`Masaüstü`) yüzünden "Unable to read file …
  app.dill" hatası verir; debug derleme ve `flutter run` çalışır. Çözüm:
  projeyi `C:\dev\abyad` gibi bir klasöre taşımak. `android/gradle.properties`
  içindeki `android.overridePathCheck=true` yalnızca debug içindir.
- **Logodaki Mushaf yazısı** gerçek bir ayet değil, bozuk harfler gibi
  görünüyor; ikon boyutunda okunmuyor ama büyük kullanımda düzeltilmeli.
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
- [docs/bildirim.md](docs/bildirim.md) — ezan bildirimi tasarımı, tam zamanlı alarm izni
- [docs/surum3_kararlar.md](docs/surum3_kararlar.md) — toplu hatim, tilavet, hadis
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
