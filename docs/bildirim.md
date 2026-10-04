# Ezan bildirimi: tasarım ve izin kararları

## Nasıl çalışır

1. **Plan (saf Dart, testli):** `lib/features/bildirim/domain/bildirim_plani.dart`
   vakitleri ve ayarları alır, kurulacak bildirimlerin listesini üretir.
2. **Uygulama:** `lib/features/bildirim/data/bildirim_servisi.dart` bekleyen
   bildirimleri silip planı işletim sistemine kurar.
3. **Ne zaman yeniden kurulur:** uygulama açıldığında, öne geldiğinde ve
   konum / yöntem / düzeltme / bildirim ayarı değiştiğinde
   (`ArkaPlanIsleri`, `lib/app/abyad_app.dart`).
4. **Telefon yeniden başlayınca / uygulama güncellenince:**
   `flutter_local_notifications` eklentisinin `ScheduledNotificationBootReceiver`
   alıcısı, kayıtlı bildirimleri uygulama açılmadan yeniden kurar.
5. **Saat dilimi değişimi:** bildirimler mutlak zaman anına kurulduğu için
   telefonun saat dilimi değişse de seçili şehrin vaktinde gelir. Kullanıcı
   başka bir şehre gittiyse "Konumumu kullan" ya da şehir seçimi ile plan
   yeni yere göre kurulur.

## Android ses kanalı

| Kanal | Ne zaman | Ses akışı |
|-------|----------|-----------|
| `ezan_alarm` | "Ezanı alarm olarak çal" açık (varsayılan) | Alarm (`AudioAttributesUsage.alarm`): medya sesi kısıkken de duyulur |
| `ezan` | Aynı ayar kapalı | Bildirim |
| `hatirlatma` | Kısa uyarı, 15 dk önce hatırlatma, önemli günler | Bildirim |
| `titresim` | "Titreşim" seçili vakitler, Cuma öğlesi | Sessiz |

Android'de kanal oluşturulduktan sonra sesi değiştirilemez. Ezan kaydı
eklendiğinde kanal kimlikleri değiştirilmelidir (ör. `ezan_alarm_v2`).

## Tam zamanlı alarm izni: hangisi, neden

Android 12+ tam zamanlı alarm için iki izin sunar:

- **`USE_EXACT_ALARM`** — kullanıcıya sorulmadan verilir. Google Play bu izni
  yalnızca temel işlevi çalar saat, zamanlayıcı ya da takvim olan
  uygulamalara tanır ve mağaza incelemesinde gerekçe ister; uymayan
  uygulamalar reddedilebilir.
- **`SCHEDULE_EXACT_ALARM`** — kullanıcının "Alarmlar ve hatırlatıcılar" özel
  erişiminden açtığı izin. Android 14'ten itibaren yeni kurulumlarda
  varsayılan olarak kapalıdır.

**Seçim: `SCHEDULE_EXACT_ALARM`.** Namaz vakti uygulamasının "çalar saat /
takvim" tanımına girip girmediği Google'ın yorumuna bağlıdır; ret riskini
almamak için kullanıcı onaylı izin seçildi. İzin verilmezse uygulama
`inexactAllowWhileIdle` ile çalışmaya devam eder (ezan birkaç dakika
gecikebilir) ve Ayarlar'da izni açma düğmesi gösterir.

> Bu özet, Ocak 2026'ya kadarki bilgiye dayanır. Yayın öncesi Google Play'in
> güncel "Exact alarm permission" politika sayfası okunmalı; ezan vakti
> uygulamaları için `USE_EXACT_ALARM` açıkça kabul ediliyorsa ona geçmek
> kullanıcı deneyimini iyileştirir (izin ekranı kalkar).

## iOS

- Bekleyen yerel bildirim sınırı 64'tür; plan en yakın 60 bildirimle
  sınırlanır (`_iosAzami`) ve uygulama her açıldığında yenilenir.
- Özel ses uygulama paketinde olmalı ve 30 saniyeyi geçemez. Ezan kaydı
  geldiğinde kısaltılmış `ezan.caf` Xcode'da Runner hedefine eklenmeli.
- iOS tarafı gerçek cihazda denenmedi.

## Ezan sesi eklemek

1. Lisanslı kaydı `android/app/src/main/res/raw/ezan.mp3` (ya da `.ogg`)
   olarak koyun; iOS için ≤30 sn `ezan.caf` hazırlayın.
2. `bildirim_servisi.dart` içinde `ezanSesiVar = true` yapın ve Android
   kanal kimliklerini yenileyin.
3. Kaynaklar ve Lisanslar ekranındaki "Ezan sesi" metnini güncelleyin
   (`tool/arb_uret.py` → `lisansEzanMetin`).

## Bilinen sınırlar

- Android'de 7 günlük pencere kurulur; uygulama bundan uzun süre açılmazsa
  bildirimler durur. Çözüm için arka plan işi (ör. WorkManager) gerekir;
  CLAUDE.md'deki paket listesinde olmadığı için eklenmedi.
- Bildirim metinleri kurulduğu andaki dille (Türkçe) yazılır.
