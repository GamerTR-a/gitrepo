# -*- coding: utf-8 -*-
"""Zikirmatik arka planındaki manzara görsellerini uygulamaya hazırlar.

    python tool/manzara_uret.py [KAYNAK_KLASOR]

Kaynak görseller (yapay zekâ ile üretilmiş, 2752x1536 JPEG) depoya konmaz;
bu betik onları 1280 piksel genişliğinde WebP'ye çevirip
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
    "bgbgpp": "kurtuba",
    "3dkqln": "tac_mahal",
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
        yukseklik = round(resim.height * GENISLIK / resim.width)
        resim = resim.resize((GENISLIK, yukseklik), Image.LANCZOS)
        hedef = os.path.join(HEDEF, ad + ".webp")
        # Üst veri (EXIF vb.) yazılmaz
        resim.save(hedef, "WEBP", quality=KALITE, method=6)
        boyut = os.path.getsize(hedef)
        toplam += boyut
        print(f"{ad:12} {GENISLIK}x{yukseklik} {boyut // 1024:4} KB")
    print(f"{len(GORSELLER)} görsel, toplam {toplam / 1024 / 1024:.1f} MB")


if __name__ == "__main__":
    main()
