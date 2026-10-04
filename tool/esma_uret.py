"""assets/data/esma.json dosyasını aşağıdaki tablodan üretir.
Bütün kayıtlar incelendi:false olarak yazılır; yayın öncesi bir hoca
Arapça yazımı, okunuşu ve anlamı doğrulamalıdır (CLAUDE.md §8).
Kullanım: python tool/esma_uret.py
"""
import json

TABLO = """
Allah|اللّٰهُ|Bütün güzel isimleri kendinde toplayan, kendisinden başka ilah olmayan
er-Rahmân|الرَّحْمٰنُ|Rahmeti bütün varlıkları kuşatan
er-Rahîm|الرَّحِيمُ|Müminlere sonsuz merhamet eden
el-Melik|الْمَلِكُ|Mülkün gerçek sahibi
el-Kuddûs|الْقُدُّوسُ|Her türlü eksiklikten uzak
es-Selâm|السَّلَامُ|Esenlik veren
el-Mü'min|الْمُؤْمِنُ|Güven veren
el-Müheymin|الْمُهَيْمِنُ|Gözetip koruyan
el-Azîz|الْعَزِيزُ|Yenilmeyen, izzet sahibi
el-Cebbâr|الْجَبَّارُ|Dilediğini mutlaka yapan, eksikleri tamamlayan
el-Mütekebbir|الْمُتَكَبِّرُ|Büyüklükte eşi olmayan
el-Hâlık|الْخَالِقُ|Yaratan
el-Bâri'|الْبَارِئُ|Kusursuz ve uyumlu yaratan
el-Musavvir|الْمُصَوِّرُ|Her şeye şekil ve özellik veren
el-Gaffâr|الْغَفَّارُ|Günahları çokça bağışlayan
el-Kahhâr|الْقَهَّارُ|Her şeye üstün gelen
el-Vehhâb|الْوَهَّابُ|Karşılıksız çokça veren
er-Rezzâk|الرَّزَّاقُ|Bütün canlıların rızkını veren
el-Fettâh|الْفَتَّاحُ|Hayır kapılarını açan, adaletle hükmeden
el-Alîm|الْعَلِيمُ|Her şeyi hakkıyla bilen
el-Kâbız|الْقَابِضُ|Dilediğine rızkı daraltan
el-Bâsıt|الْبَاسِطُ|Dilediğine rızkı genişleten
el-Hâfıd|الْخَافِضُ|Dilediğini alçaltan
er-Râfi'|الرَّافِعُ|Dilediğini yükselten
el-Muiz|الْمُعِزُّ|Dilediğini aziz kılan
el-Müzil|الْمُذِلُّ|Dilediğini zelil kılan
es-Semî'|السَّمِيعُ|Her şeyi işiten
el-Basîr|الْبَصِيرُ|Her şeyi gören
el-Hakem|الْحَكَمُ|Mutlak hüküm sahibi
el-Adl|الْعَدْلُ|Mutlak adalet sahibi
el-Latîf|اللَّطِيفُ|Lütfu bol, en ince işleri bilen
el-Habîr|الْخَبِيرُ|Her şeyden haberdar olan
el-Halîm|الْحَلِيمُ|Cezada acele etmeyen, yumuşak davranan
el-Azîm|الْعَظِيمُ|Pek yüce
el-Gafûr|الْغَفُورُ|Bağışlaması çok olan
eş-Şekûr|الشَّكُورُ|Az iyiliğe çok karşılık veren
el-Aliyy|الْعَلِيُّ|Yüceler yücesi
el-Kebîr|الْكَبِيرُ|Büyüklüğüne sınır olmayan
el-Hafîz|الْحَفِيظُ|Koruyup gözeten
el-Mukît|الْمُقِيتُ|Her canlının gıdasını veren
el-Hasîb|الْحَسِيبُ|Hesaba çeken, kullarına yeten
el-Celîl|الْجَلِيلُ|Celal ve azamet sahibi
el-Kerîm|الْكَرِيمُ|Keremi ve ihsanı bol
er-Rakîb|الرَّقِيبُ|Her an gözetleyen
el-Mücîb|الْمُجِيبُ|Dualara karşılık veren
el-Vâsi'|الْوَاسِعُ|İlmi ve rahmeti her şeyi kuşatan
el-Hakîm|الْحَكِيمُ|Her işi hikmetli olan
el-Vedûd|الْوَدُودُ|Kullarını seven ve sevilen
el-Mecîd|الْمَجِيدُ|Şanı yüce olan
el-Bâis|الْبَاعِثُ|Ölüleri dirilten
eş-Şehîd|الشَّهِيدُ|Her şeye şahit olan
el-Hakk|الْحَقُّ|Varlığı gerçek olan
el-Vekîl|الْوَكِيلُ|Kendisine güvenilip dayanılan
el-Kaviyy|الْقَوِيُّ|Pek güçlü
el-Metîn|الْمَتِينُ|Gücü sarsılmaz olan
el-Veliyy|الْوَلِيُّ|Müminlerin dostu ve yardımcısı
el-Hamîd|الْحَمِيدُ|Övülmeye layık olan
el-Muhsî|الْمُحْصِي|Her şeyi tek tek sayıp bilen
el-Mübdi'|الْمُبْدِئُ|İlk defa yaratan
el-Muîd|الْمُعِيدُ|Ölümden sonra yeniden yaratan
el-Muhyî|الْمُحْيِي|Hayat veren
el-Mümît|الْمُمِيتُ|Ölümü yaratan
el-Hayy|الْحَيُّ|Ezelî ve ebedî hayat sahibi
el-Kayyûm|الْقَيُّومُ|Her şeyi ayakta tutan
el-Vâcid|الْوَاجِدُ|Dilediğini dilediği an bulan
el-Mâcid|الْمَاجِدُ|Şanı ve keremi yüce olan
el-Vâhid|الْوَاحِدُ|Bir ve tek olan
es-Samed|الصَّمَدُ|Hiçbir şeye muhtaç olmayan, her şeyin kendisine muhtaç olduğu
el-Kâdir|الْقَادِرُ|Her şeye gücü yeten
el-Muktedir|الْمُقْتَدِرُ|Kudreti her şeye üstün olan
el-Mukaddim|الْمُقَدِّمُ|Dilediğini öne alan
el-Muahhir|الْمُؤَخِّرُ|Dilediğini geriye bırakan
el-Evvel|الْأَوَّلُ|Varlığının başlangıcı olmayan
el-Âhir|الْآخِرُ|Varlığının sonu olmayan
ez-Zâhir|الظَّاهِرُ|Varlığı apaçık olan
el-Bâtın|الْبَاطِنُ|Zatı akıllarla kavranamayan
el-Vâlî|الْوَالِي|Bütün kâinatı yöneten
el-Müteâlî|الْمُتَعَالِي|Aklın alabileceği her şeyden yüce olan
el-Berr|الْبَرُّ|İyiliği ve ihsanı bol
et-Tevvâb|التَّوَّابُ|Tövbeleri çokça kabul eden
el-Müntakım|الْمُنْتَقِمُ|Suçluları adaletiyle cezalandıran
el-Afüvv|الْعَفُوُّ|Çok affeden
er-Raûf|الرَّؤُوفُ|Çok şefkatli
Mâlikü'l-Mülk|مَالِكُ الْمُلْكِ|Mülkün ebedî sahibi
Zü'l-Celâli ve'l-İkrâm|ذُو الْجَلَالِ وَالْإِكْرَامِ|Azamet ve ikram sahibi
el-Muksit|الْمُقْسِطُ|Bütün işlerini adaletle yapan
el-Câmi'|الْجَامِعُ|Dilediğini dilediği zaman bir araya getiren
el-Ganiyy|الْغَنِيُّ|Hiçbir şeye ihtiyacı olmayan
el-Muğnî|الْمُغْنِي|Dilediğini zengin kılan
el-Mâni'|الْمَانِعُ|Dilemediği şeye engel olan
ed-Dârr|الضَّارُّ|Zarar verici şeyleri de yaratan
en-Nâfi'|النَّافِعُ|Fayda veren şeyleri yaratan
en-Nûr|النُّورُ|Âlemleri nurlandıran
el-Hâdî|الْهَادِي|Hidayete erdiren
el-Bedî'|الْبَدِيعُ|Örneksiz ve eşsiz yaratan
el-Bâkî|الْبَاقِي|Varlığı sürekli olan
el-Vâris|الْوَارِثُ|Her şeyin gerçek sahibi, varlığı devam eden
er-Reşîd|الرَّشِيدُ|Doğru yolu gösteren
es-Sabûr|الصَّبُورُ|Çok sabırlı olan
"""

satirlar = [s.split("|") for s in TABLO.strip().splitlines()]
assert len(satirlar) == 99, len(satirlar)
assert len({s[0] for s in satirlar}) == 99
veri = {
    "aciklama": "Esmâ-ül Hüsnâ (Tirmizî rivayetindeki sıra). Her kayıt yayın öncesi incelenmelidir (CLAUDE.md §8).",
    "kaynak": "Tirmizî, Deavât (liste); anlamlar özet olarak yazılmıştır",
    "isimler": [
        {"no": i + 1, "ad": ad, "arapca": ar, "anlam": anlam,
         "incelendi": False, "inceleyen": None, "not": ""}
        for i, (ad, ar, anlam) in enumerate(satirlar)
    ],
}
with open("assets/data/esma.json", "w", encoding="utf-8", newline="\n") as f:
    json.dump(veri, f, ensure_ascii=False, indent=1)
print("isim:", len(satirlar))
