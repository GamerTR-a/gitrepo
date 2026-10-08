# -*- coding: utf-8 -*-
"""Zikirmatik arka planındaki manzara görsellerini uygulamaya hazırlar.

    python tool/manzara_uret.py [KAYNAK_KLASOR]

Kaynak görseller (yapay zekâ ile üretilmiş, 2752x1536 JPEG) depoya konmaz;
bu betik onları en çok 1280 piksel genişliğinde WebP'ye çevirip
assets/zikir_arkaplan/ altına yazar. KAYNAK_KLASOR verilmezse proje kökü
kullanılır. Yeni görsel eklerken aşağıdaki tabloya bir satır ve
lib/features/zikirmatik/ui/zikir_arka_plani.dart içindeki listeye aynı adı
ekleyin. Pillow gerekir (pip install pillow).
"""
import os
import sys

from PIL import Image

HEDEF = os.path.join("assets", "zikir_arkaplan")
GENISLIK = 1280
KALITE = 78

# Kaynak dosya adındaki ayırt edici parça -> uygulamadaki ad
GORSELLER = {
    "tyfmce": "kabe",
    "gde40y": "medine",
    "orut4w": "kudus",
    "oc72t7": "ayasofya",
    "avbxy3": "selimiye",
    "2xbd1i": "istanbul",
    "loj8jm": "bursa",
    "mbj1rf": "divrigi",
    "xmr08t": "diyarbakir",
    "e7nljg": "sam",
    "7wrth5": "kahire",
    "j4wlb9": "kayrevan",
    "j9mqz8": "semerkant",
    "sc0yud": "buhara",
    "wpihxo": "isfahan",
    "5qhri6": "halep",
}

# Kaynak görselin yalnızca bir bölümü kullanılacaksa: (sol, üst, sağ, alt),
# görselin eni ve boyuna oranla. Kudüs'te yalnızca Kubbetü's-Sahra ve
# avlusu, Medine'de avludaki hatalı çizilmiş yapının üstünde kalan bölüm.
KIRPMA = {
    "kudus": (0.383, 0.133, 0.727, 0.707),
    "medine": (0.234, 0.0, 0.766, 0.749),
}


def main():
    kaynak = sys.argv[1] if len(sys.argv) > 1 else "."
    dosyalar = [d for d in os.listdir(kaynak) if d.lower().endswith((".jpg", ".jpeg", ".png"))]
    os.makedirs(HEDEF, exist_ok=True)
    toplam = 0
    for parca, ad in GORSELLER.items():
        eslesen = [d for d in dosyalar if parca in d]
        if len(eslesen) != 1:
            sys.exit(f"{ad}: '{parca}' içeren tek bir kaynak dosya bulunamadı ({len(eslesen)})")
        resim = Image.open(os.path.join(kaynak, eslesen[0])).convert("RGB")
        if ad in KIRPMA:
            sol, ust, sag, alt = KIRPMA[ad]
            resim = resim.crop((round(sol * resim.width), round(ust * resim.height),
                                round(sag * resim.width), round(alt * resim.height)))
        genislik = min(GENISLIK, resim.width)
        yukseklik = round(resim.height * genislik / resim.width)
        resim = resim.resize((genislik, yukseklik), Image.LANCZOS)
        hedef = os.path.join(HEDEF, ad + ".webp")
        # Üst veri (EXIF vb.) yazılmaz
        resim.save(hedef, "WEBP", quality=KALITE, method=6)
        boyut = os.path.getsize(hedef)
        toplam += boyut
        print(f"{ad:12} {genislik}x{yukseklik} {boyut // 1024:4} KB")
    print(f"{len(GORSELLER)} görsel, toplam {toplam / 1024 / 1024:.1f} MB")


if __name__ == "__main__":
    main()
