# -*- coding: utf-8 -*-
"""Logodaki mushafın sağ sayfasında bulunan anlamsız Arapça yazıyı siler.

    python tool/logo_duzelt.py

Logo yapay zekâ ile üretilmişti; sağ sayfadaki satırlar besmeleye benzer
başlayıp anlamsız harflerle sürüyordu (uydurma ayet görüntüsü). Betik ana
görselde (logo-abyad.jpg) o sayfanın iç alanını, ayet sonu halkalarını ve
kalan siyah-gri pikselleri sayfa beyazına çevirir; köşe süslemelerine dokunmaz. Sonra düzeltilmiş bölgeyi Android
ve iOS uygulama ikonlarının aynı yerine küçülterek yapıştırır. Bir kez
çalıştırılması yeterlidir; yeniden çalıştırmak zarar vermez.
Pillow gerekir (pip install pillow).
"""
import glob
import os

from PIL import Image, ImageDraw

ANA = "logo-abyad.jpg"
# Sağ sayfanın yazı bölgesi (2048x2048 ana görselde): sol, üst, sağ, alt
BOLGE = (1070, 858, 1312, 1128)


# Sayfanın süslemesiz iç alanı (tamamen beyaza boyanır) ve ayet sonu
# halkalarının merkezleri; ana görsel koordinatlarıyla
IC_ALAN = [(1118, 885), (1215, 870), (1285, 893), (1285, 990), (1253, 1020),
           (1253, 1093), (1145, 1120), (1080, 1100), (1080, 990), (1118, 980)]
HALKALAR = [(1111, 960), (1164, 965), (1093, 1001), (1091, 1035), (1155, 1033), (1150, 1101)]
HALKA_YARICAPI = 15


def temizle(resim):
    """Sağ sayfadaki yazıyı ve ayet sonu halkalarını siler."""
    cizim = ImageDraw.Draw(resim)
    cizim.polygon(IC_ALAN, fill=(255, 255, 255))
    for x, y in HALKALAR:
        cizim.ellipse((x - HALKA_YARICAPI, y - HALKA_YARICAPI, x + HALKA_YARICAPI, y + HALKA_YARICAPI),
                      fill=(255, 255, 255))
    # Kalan renksiz koyu pikseller (yazı); altın süslemelere dokunulmaz
    px = resim.load()
    for y in range(BOLGE[1], BOLGE[3]):
        for x in range(BOLGE[0], BOLGE[2]):
            r, g, b = px[x, y][:3]
            # Altın süsleme: kırmızı maviden belirgin biçimde fazla
            if r - b < 28 and min(r, g, b) < 236:
                px[x, y] = (255, 255, 255)


def kutu(resim, alfa_var):
    """Logonun görseldeki sınır kutusu (beyaz ya da saydam olmayan alan)."""
    px = resim.load()
    g, y_ = resim.size
    xs, ys = [], []
    for y in range(y_):
        for x in range(g):
            p = px[x, y]
            if alfa_var and p[3] < 40:
                continue
            if min(p[:3]) < 225:
                xs.append(x)
                ys.append(y)
    return min(xs), min(ys), max(xs) + 1, max(ys) + 1


def main():
    ana = Image.open(ANA).convert("RGB")
    temizle(ana)
    ana.save(ANA, quality=95, subsampling=0)
    ak = kutu(ana, False)
    yama_kaynak = ana.crop(BOLGE)

    hedefler = sorted(
        glob.glob("android/app/src/main/res/mipmap-*/ic_launcher*.png")
        + glob.glob("ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png")
    )
    for yol in hedefler:
        resim = Image.open(yol)
        alfa_var = resim.mode == "RGBA"
        resim = resim.convert("RGBA" if alfa_var else "RGB")
        hk = kutu(resim, alfa_var)
        ox = (hk[2] - hk[0]) / (ak[2] - ak[0])
        oy = (hk[3] - hk[1]) / (ak[3] - ak[1])
        if abs(ox - oy) / ox > 0.04:
            print(f"ATLANDI (oran uyuşmuyor {ox:.3f}/{oy:.3f}): {yol}")
            continue
        sol = hk[0] + (BOLGE[0] - ak[0]) * ox
        ust = hk[1] + (BOLGE[1] - ak[1]) * oy
        en = max(1, round((BOLGE[2] - BOLGE[0]) * ox))
        boy = max(1, round((BOLGE[3] - BOLGE[1]) * oy))
        yama = yama_kaynak.resize((en, boy), Image.LANCZOS)
        if alfa_var:
            yama = yama.convert("RGBA")
        resim.paste(yama, (round(sol), round(ust)))
        resim.save(yol)
        print(f"{os.path.basename(os.path.dirname(yol))}/{os.path.basename(yol)}: {resim.size[0]}px, yama {en}x{boy}")


if __name__ == "__main__":
    main()
