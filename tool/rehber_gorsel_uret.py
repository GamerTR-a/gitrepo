# -*- coding: utf-8 -*-
"""Namaz ve abdest rehberinin gerçek görsellerini uygulamaya hazırlar.

    python tool/rehber_gorsel_uret.py KAYNAK_KLASOR

KAYNAK_KLASOR içindeki görseller docs/rehber_gorsel_istemleri.md'deki
adlarla kaydedilmiş olmalıdır (ör. namaz_04_ruku.jpg; uzantı jpg/jpeg/png).
Betik her birini 3:2 oranına ortadan kırpar, 960 piksel genişliğinde WebP
olarak assets/rehber/ altına yazar, aynı adlı geçici SVG çizimi siler ve
veri dosyalarındaki `cizim` alanını yeni dosyaya çevirir. Kaynakta olmayan
adımlar eski çizimiyle kalır; betik eksikleri listeler.
Pillow gerekir (pip install pillow).
"""
import io
import os
import sys

from PIL import Image

HEDEF = os.path.join("assets", "rehber")
VERI = [
    os.path.join("assets", "data", "rehber", "abdest.json"),
    os.path.join("assets", "data", "rehber", "namaz_adimlari.json"),
]
GENISLIK, YUKSEKLIK = 960, 640
KALITE = 82

ADLAR = [
    "abdest_01_niyet", "abdest_02_eller", "abdest_03_agiz", "abdest_04_burun",
    "abdest_05_yuz", "abdest_06_kollar", "abdest_07_bas",
    "abdest_08_kulak_boyun", "abdest_09_ayaklar",
    "namaz_01_niyet", "namaz_02_tekbir", "namaz_03_kiyam", "namaz_04_ruku",
    "namaz_05_kavme", "namaz_06_secde", "namaz_07_celse", "namaz_08_kade",
    "namaz_09_selam",
]


def ortadan_kirp(resim):
    """Görseli 3:2 oranına ortadan kırpar."""
    hedef_oran = GENISLIK / YUKSEKLIK
    if resim.width / resim.height > hedef_oran:
        yeni = round(resim.height * hedef_oran)
        sol = (resim.width - yeni) // 2
        return resim.crop((sol, 0, sol + yeni, resim.height))
    yeni = round(resim.width / hedef_oran)
    ust = (resim.height - yeni) // 2
    return resim.crop((0, ust, resim.width, ust + yeni))


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    kaynak = sys.argv[1]
    bulunan = {}
    for dosya in os.listdir(kaynak):
        ad, uzanti = os.path.splitext(dosya)
        if uzanti.lower() in (".jpg", ".jpeg", ".png") and ad in ADLAR:
            bulunan[ad] = os.path.join(kaynak, dosya)

    for ad, yol in sorted(bulunan.items()):
        resim = ortadan_kirp(Image.open(yol).convert("RGB"))
        resim = resim.resize((GENISLIK, YUKSEKLIK), Image.LANCZOS)
        hedef = os.path.join(HEDEF, ad + ".webp")
        resim.save(hedef, "WEBP", quality=KALITE, method=6)
        eski = os.path.join(HEDEF, ad + ".svg")
        if os.path.exists(eski):
            os.remove(eski)
        print(f"{ad:24} {os.path.getsize(hedef) // 1024:4} KB")

    for yol in VERI:
        metin = io.open(yol, encoding="utf-8", newline="").read()
        for ad in bulunan:
            metin = metin.replace(f'"{ad}.svg"', f'"{ad}.webp"')
        io.open(yol, "w", encoding="utf-8", newline="").write(metin)

    eksik = [ad for ad in ADLAR if ad not in bulunan]
    print(f"{len(bulunan)} görsel işlendi.")
    if eksik:
        print("Kaynakta bulunmayan (eski çizimiyle kalan): " + ", ".join(eksik))


if __name__ == "__main__":
    main()
