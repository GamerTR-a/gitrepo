"""Gömülü veri dosyalarını üretir. Uygulama internete çıkmaz; bu betik yalnızca
geliştirme sırasında, indirilen kaynak dosyalardan assets/ altını doldurur.

Kaynaklar (KAYNAK klasörüne indirilir):
  GeoNames (CC BY 4.0)  https://download.geonames.org/export/dump/
      TR.zip -> TR.txt, cities15000.zip -> cities15000.txt, admin1CodesASCII.txt
  Tanzil (CC BY 3.0, metin DEĞİŞTİRİLEMEZ)  https://tanzil.net/download/
      quran-uthmani.txt  (Uthmani, "text with aya numbers", durak işaretleri açık)
      quran-data.xml     https://tanzil.net/res/text/metadata/quran-data.xml

Kullanım:  python tool/veri_uret.py KAYNAK_KLASORU
"""

import json
import os
import shutil
import sys
import xml.etree.ElementTree as ET

kaynak = sys.argv[1]
os.makedirs("assets/data/quran", exist_ok=True)


def oku(ad):
    with open(os.path.join(kaynak, ad), encoding="utf-8") as f:
        return [satir.rstrip("\n").split("\t") for satir in f]


# --------------------------------------------------------------------------
# Şehirler
# --------------------------------------------------------------------------
iller = {
    s[0].split(".")[1]: s[1] for s in oku("admin1.txt") if s[0].startswith("TR.")
}
assert len(iller) == 81
# GeoNames il adlarını tutarsız yazar ("Adıyaman Province", "Canakkale",
# "Istanbul"); resmî Türkçe adlarla eşleştirilir.
il_adlari = """Adana,Adıyaman,Afyonkarahisar,Ağrı,Amasya,Ankara,Antalya,Artvin,Aydın,
Balıkesir,Bilecik,Bingöl,Bitlis,Bolu,Burdur,Bursa,Çanakkale,Çankırı,Çorum,Denizli,
Diyarbakır,Edirne,Elazığ,Erzincan,Erzurum,Eskişehir,Gaziantep,Giresun,Gümüşhane,Hakkâri,
Hatay,Isparta,Mersin,İstanbul,İzmir,Kars,Kastamonu,Kayseri,Kırklareli,Kırşehir,Kocaeli,
Konya,Kütahya,Malatya,Manisa,Kahramanmaraş,Mardin,Muğla,Muş,Nevşehir,Niğde,Ordu,Rize,
Sakarya,Samsun,Siirt,Sinop,Sivas,Tekirdağ,Tokat,Trabzon,Tunceli,Şanlıurfa,Uşak,Van,
Yozgat,Zonguldak,Aksaray,Bayburt,Karaman,Kırıkkale,Batman,Şırnak,Bartın,Ardahan,Iğdır,
Yalova,Karabük,Kilis,Osmaniye,Düzce""".replace(chr(10), "").split(",")
assert len(il_adlari) == 81


def sade(ad):
    ad = ad.replace(" Province", "")
    for k, v in zip("çğıöşüâîûÇĞİÖŞÜÂÎÛ", "cgiosuaiucgiosuaiu"):
        ad = ad.replace(k, v)
    return ad.lower()


resmi = {sade(ad): ad for ad in il_adlari}
iller = {k: resmi[sade(v)] for k, v in iller.items()}
assert len(set(iller.values())) == 81

sehirler = []
tr = [s for s in oku("TR.txt") if s[6] == "P"]
for s in tr:
    if s[7] in ("PPLA", "PPLC"):
        # İl merkezi: ilin adıyla kaydedilir (ör. Antakya -> Hatay)
        sehirler.append(
            dict(ad=iller[s[10]], ust="", ulke="Türkiye", enlem=float(s[4]),
                 boylam=float(s[5]), dilim=s[17], tur="il")
        )
# İlçeler: GeoNames'in ilçe (ADM2) kayıtları. Yalnızca PPLA2 (ilçe merkezi)
# kullanılırsa Üsküdar, Çankaya gibi büyükşehir ilçeleri eksik kalır.
gorulen = set()
for s in oku("TR.txt"):
    if s[6] == "A" and s[7] == "ADM2":
        ad = s[1].replace(" İlçesi", "").replace(" District", "")
        ad = ad.split(" / ")[0].strip()
        il = iller[s[10]]
        merkez = ad == il or ad.endswith("Merkez") or "Bölgesi" in ad
        if merkez or (ad, il) in gorulen:
            continue
        gorulen.add((ad, il))
        sehirler.append(
            dict(ad=ad, ust=il, ulke="Türkiye", enlem=float(s[4]),
                 boylam=float(s[5]), dilim=s[17], tur="ilce")
        )

ulkeler = {
    "DE": "Almanya", "NL": "Hollanda", "BE": "Belçika", "FR": "Fransa",
    "AT": "Avusturya", "CH": "İsviçre", "GB": "Birleşik Krallık",
    "SE": "İsveç", "DK": "Danimarka", "NO": "Norveç",
}
for s in oku("cities15000.txt"):
    # PPLX (şehir içi semt) kayıtları alınmaz
    if s[8] in ulkeler and s[7] != "PPLX" and (int(s[14]) >= 100000 or s[7] == "PPLC"):
        sehirler.append(
            dict(ad=s[1], ust="", ulke=ulkeler[s[8]], enlem=float(s[4]),
                 boylam=float(s[5]), dilim=s[17], tur="yurtdisi")
        )

sira = {"il": 0, "ilce": 1, "yurtdisi": 2}
sehirler.sort(key=lambda x: (sira[x["tur"]], x["ulke"], x["ust"], x["ad"]))
for s in sehirler:
    s["enlem"] = round(s["enlem"], 4)
    s["boylam"] = round(s["boylam"], 4)
with open("assets/data/sehirler.json", "w", encoding="utf-8", newline="\n") as f:
    json.dump(
        {
            "kaynak": "GeoNames (geonames.org), CC BY 4.0",
            "sehirler": sehirler,
        },
        f, ensure_ascii=False, separators=(",", ":"),
    )
print("şehir:", len(sehirler), {t: sum(1 for s in sehirler if s["tur"] == t) for t in sira})

# --------------------------------------------------------------------------
# Kur'an: metin ve üst veri AYNEN kopyalanır; ayrıca üst veriden uygulamanın
# okuduğu küçük bir JSON türetilir (metin içermez).
# --------------------------------------------------------------------------
shutil.copyfile(os.path.join(kaynak, "quran-uthmani.txt"), "assets/data/quran/quran-uthmani.txt")
shutil.copyfile(os.path.join(kaynak, "quran-data.xml"), "assets/data/quran/quran-data.xml")

sure_adlari = """Fâtiha,Bakara,Âl-i İmrân,Nisâ,Mâide,En'âm,A'râf,Enfâl,Tevbe,Yûnus,Hûd,Yûsuf,
Ra'd,İbrâhîm,Hicr,Nahl,İsrâ,Kehf,Meryem,Tâhâ,Enbiyâ,Hac,Mü'minûn,Nûr,Furkân,Şuarâ,Neml,
Kasas,Ankebût,Rûm,Lokmân,Secde,Ahzâb,Sebe',Fâtır,Yâsîn,Sâffât,Sâd,Zümer,Mü'min,Fussilet,
Şûrâ,Zuhruf,Duhân,Câsiye,Ahkâf,Muhammed,Fetih,Hucurât,Kâf,Zâriyât,Tûr,Necm,Kamer,Rahmân,
Vâkıa,Hadîd,Mücâdele,Haşr,Mümtehine,Saf,Cuma,Münâfikûn,Teğâbün,Talâk,Tahrîm,Mülk,Kalem,
Hâkka,Meâric,Nûh,Cin,Müzzemmil,Müddessir,Kıyâme,İnsân,Mürselât,Nebe',Nâziât,Abese,Tekvîr,
İnfitâr,Mutaffifîn,İnşikâk,Bürûc,Târık,A'lâ,Gâşiye,Fecr,Beled,Şems,Leyl,Duhâ,İnşirâh,Tîn,
Alak,Kadir,Beyyine,Zilzâl,Âdiyât,Kâria,Tekâsür,Asr,Hümeze,Fîl,Kureyş,Mâûn,Kevser,Kâfirûn,
Nasr,Tebbet,İhlâs,Felak,Nâs""".replace("\n", "").split(",")
assert len(sure_adlari) == 114

kok = ET.parse(os.path.join(kaynak, "quran-data.xml")).getroot()


def konumlar(yol):
    return [[int(e.get("sura")), int(e.get("aya"))] for e in kok.findall(yol)]


sureler = [
    dict(no=int(e.get("index")), ad=sure_adlari[int(e.get("index")) - 1],
         arapca=e.get("name"), ayet=int(e.get("ayas")), baslangic=int(e.get("start")),
         mekki=e.get("type") == "Meccan")
    for e in kok.findall("suras/sura")
]
meta = dict(
    kaynak="Tanzil Project (tanzil.net), CC BY 3.0 – quran-data.xml'den türetildi",
    sureler=sureler,
    cuzler=konumlar("juzs/juz"),
    sayfalar=konumlar("pages/page"),
    hizipCeyrekleri=konumlar("hizbs/quarter"),
)
assert len(meta["cuzler"]) == 30 and len(meta["sayfalar"]) == 604
assert sum(s["ayet"] for s in sureler) == 6236
with open("assets/data/quran/quran_meta.json", "w", encoding="utf-8", newline="\n") as f:
    json.dump(meta, f, ensure_ascii=False, separators=(",", ":"))
print("sure:", len(sureler), "sayfa:", len(meta["sayfalar"]), "çeyrek:", len(meta["hizipCeyrekleri"]))
