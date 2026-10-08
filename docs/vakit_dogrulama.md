# Vakit hesabının Diyanet'le karşılaştırılması

**Tarih:** 8 Ekim 2026. **Kaynak:** namazvakitleri.diyanet.gov.tr şehir
sayfalarındaki aylık ve yıllık tablolar (8 Ekim 2026 – 31 Aralık 2027,
şehir başına 396 gün). **Araç:** `dart run tool/diyanet_karsilastir.dart DIYANET.json`.
Tolerans ±2 dakika (CLAUDE.md §6.2).

## Sonuç

- **Türkiye: tam uyum.** Sekiz şehirde (İstanbul, Ankara, İzmir, Erzurum, Van,
  Trabzon, Edirne, Antalya) altı vaktin hepsi 396 günün **tamamında** ±2
  dakika içinde. Fark hiçbir gün 2 dakikayı aşmıyor.
- **Avrupa, yaz dışı: uyum.** Güneş, öğle, ikindi ve akşam bütün yıl tutuyor.
  Yatsı, aşağıdaki düzeltmeden sonra yaz dışındaki günlerde tutuyor.
- **Avrupa, yaz: imsak ve yatsı tutmuyor.** Diyanet bu günlerde açıyla
  hesaplamıyor; kuralını çıkaramadık (aşağıda).

## Bu karşılaştırmayla yapılan düzeltme

Diyanet, uygulamadaki on Avrupa ülkesinin hepsinde (Almanya, Avusturya,
Belçika, Birleşik Krallık, Danimarka, Fransa, Hollanda, İsveç, İsviçre,
Norveç; her birinden en az bir şehre bakıldı) **yatsıyı 17° değil 16°** ile
yayımlıyor; imsak 18° ve temkinler Türkiye'dekiyle aynı. Motor artık ülkesi
bilinen ve Türkiye dışındaki konumlarda Diyanet yönteminde yatsıyı 16° ile
hesaplıyor (`HesapYontemi.diyanet.yatsiAcisiYurtDisi`, `Konum.yurtDisi`).

Bu bir enlem kuralı değildir: Roma (41,9°) 16°, Sofya (42,7°) ve Edirne
(41,7°) 17° ile yayımlanıyor. Uygulamadaki listede olmayan ülkeler için
hangi açının kullanıldığı bilinmiyor; ülkesi bilinmeyen konum (listedeki
hiçbir şehre yakın olmayan otomatik konum) Türkiye gibi 17° ile hesaplanır.

## Kalan farklar

Düzeltmeden sonra ±2 dakikanın dışında kalan gün sayısı (396 gün içinde) ve
farkın aralığı (motor − Diyanet, dakika):

| Şehir (enlem) | İmsak | Yatsı | Diğer |
|---|---|---|---|
| Lyon (45,7°) | 70 gün, −33 … +1 | 62 gün, −2 … +20 | yok |
| Paris (48,9°) | 111 gün, −135 … +28 | 102 gün, −2 … +80 | yok |
| Amsterdam (52,4°) | 126 gün, −119 … +34 | 125 gün, −23 … +122 | yok |
| Berlin (52,5°) | 131 gün, −120 … +30 | 129 gün, −19 … +144 | yok |
| Stockholm (59,3°) | 162 gün, −127 … +40 | 180 gün, −28 … +132 | akşam 14 gün, en çok −3 |
| Oslo (59,9°) | 169 gün, −130 … +34 | 182 gün, −22 … +136 | güneş 20 gün, en çok −7 |

Eksi değer motorun vakti Diyanet'ten **erken**, artı değer **geç** verdiğini
gösterir.

### Neden?

Diyanet yaklaşık nisan–ağustos arasında, 44,8° ve üstündeki şehirlerde imsak
ve yatsıyı 18°/16° açılarıyla değil, **kısaltılmış bir süreyle** yayımlıyor.
Kısaltma, fecir süresi gecenin yaklaşık yüzde 23'ünü aşınca başlıyor; yaz
ortasında imsak güneşten gecenin kabaca beşte biri kadar önce, yatsı akşamdan
biraz daha kısa bir süre sonra oluyor (ör. Berlin 21 Haziran: imsak güneş
doğmadan 88, yatsı güneş battıktan 79 dakika sonra; gece 430 dakika).

Kuralın kendisini çıkaramadık: aynı enlemdeki şehirlerde oranlar farklı
(Berlin 0,205, Amsterdam 0,215; Oslo 0,211, Stockholm 0,225), yani basit bir
enlem ya da gece oranı formülü değil. Denediğimiz yaklaşımlar ±2 dakikayı
tutturmadı. **Tahmini bir formülü "Diyanet uyumlu" diye koymadık.**

Motorun bu günlerde yaptığı:

- Şafak/fecir astronomik olarak **oluşuyorsa** açıyla hesaplar. Sonuç:
  imsak Diyanet'ten erken, yatsı geç (ihtiyatlı taraf), ama fark bir saati
  aşabilir.
- **Oluşmuyorsa** "gecenin yedide biri" kuralını uygular (CLAUDE.md §6.2).
  Sonuç: imsak Diyanet'ten **30–40 dakika geç**, yatsı 20–30 dakika erken
  olabilir. Oruç için ihtiyatlı taraf **değildir**.

İki durumda da Vakitler ekranı bir açıklama kartı gösterir ve kullanıcıyı
cami takvimine yönlendirir.

### Karar bekleyen

1. **Yüksek enlem kuralı.** "Gecenin yedide biri" Diyanet'in uyguladığı
   değil. Seçenekler: (a) olduğu gibi bırakmak, (b) Diyanet'in yayımladığı
   vakitlere daha yakın, sabit bir oran kullanmak (ör. imsak için gecenin
   beşte biri), (c) Diyanet'ten kuralın tanımını istemek. Bu bir fıkıh ve
   şartname kararıdır; `docs/hoca/danisilacak_konular.md` 7. konuya eklendi.
2. **Stockholm akşam ve Oslo güneş.** 59° ve üstünde birkaç gün 3–7
   dakikalık fark var; nedeni bilinmiyor (rakım ya da ufuk düzeltmesi olabilir).
3. **Listede olmayan ülkeler** için yatsı açısı.

## Test dosyası

`test/fixtures/diyanet_referans.json`:

- `kayitlar` (112 kayıt): sekiz Türkiye şehri × dokuz gün (iki gündönümü,
  iki ekinoks dahil) ve Berlin, Amsterdam, Paris, Lyon × on gün (yaz saati
  geçişlerinin önceki ve sonraki günleri dahil). Altı vakit ±2 dakika.
- `yaz_farklari` (12 kayıt): aynı dört Avrupa şehrinin yaz günleri. Yalnızca
  güneş, öğle, ikindi ve akşam karşılaştırılır.

Stockholm, akşam vaktindeki 3 dakikalık fark nedeniyle sıkı listeye alınmadı.

## Yeniden doğrulama

Diyanet tablosu JSON'a dökülür
(`{"Şehir": {"vakitler": {"YYYY-AA-GG": ["imsak", …, "yatsi"]}}}`) ve araç
çalıştırılır. İndirilen tablonun tamamı depoya konmaz; yalnızca yukarıdaki
seçilmiş günler test dosyasındadır.
