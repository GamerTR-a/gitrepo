# -*- coding: utf-8 -*-
"""Zikirmatik arka planındaki manzara siluetlerini üretir.

    python tool/manzara_uret.py

Çizimler Abyad için hazırlanmış özgün, tek renkli siluetlerdir (fotoğraf ya
da başka bir kaynaktan alınma değildir). Uygulama bunları tema rengine boyar
ve silik gösterir; derinlik `fill-opacity` ile verilir.
"""
import os

KLASOR = os.path.join("assets", "zikir_arkaplan")
G, Y = 400, 240
ZEMIN = 220  # yapıların oturduğu çizgi


def dortgen(x0, y0, x1, y1, op=1.0):
    return f'<rect x="{x0}" y="{y0}" width="{x1 - x0}" height="{y1 - y0}" fill-opacity="{op}"/>'


def kubbe(cx, taban, rx, ry, op=1.0):
    return f'<path d="M{cx - rx} {taban} A{rx} {ry} 0 0 1 {cx + rx} {taban} Z" fill-opacity="{op}"/>'


def sivri_kubbe(cx, taban, rx, ry, op=1.0):
    return (f'<path d="M{cx - rx} {taban} C{cx - rx * 1.12} {taban - ry * 0.75} {cx - rx * 0.45} {taban - ry} {cx} {taban - ry * 1.22} '
            f'C{cx + rx * 0.45} {taban - ry} {cx + rx * 1.12} {taban - ry * 0.75} {cx + rx} {taban} Z" fill-opacity="{op}"/>')


def alem(cx, tepe, boy=14, op=1.0):
    return (dortgen(cx - 1, tepe - boy, cx + 1, tepe, op)
            + f'<circle cx="{cx}" cy="{tepe - boy}" r="3" fill-opacity="{op}"/>')


def minare(x, boy, en=7, serefeler=(0.62,), op=1.0, taban=ZEMIN):
    tepe = taban - boy
    p = [dortgen(x - en / 2, tepe, x + en / 2, taban, op)]
    for s in serefeler:
        y = taban - boy * s
        p.append(dortgen(x - en / 2 - 3, y - 4, x + en / 2 + 3, y, op))
    kulah = max(18, en * 3)
    p.append(f'<path d="M{x - en / 2 - 1} {tepe} L{x} {tepe - kulah} L{x + en / 2 + 1} {tepe} Z" fill-opacity="{op}"/>')
    return "".join(p)


def kemerli_duvar(x0, x1, ust, adet, op=1.0, taban=ZEMIN, oran=0.6):
    """Kemer boşlukları olan duvar (boşluklar arkayı gösterir)."""
    aralik = (x1 - x0) / adet
    r = aralik * oran / 2
    d = [f"M{x0} {ust} H{x1} V{taban} H{x0} Z"]
    for i in range(adet):
        cx = x0 + aralik * (i + 0.5)
        ky = max(ust + r + 4, taban - (taban - ust) * 0.62)
        d.append(f"M{cx - r} {taban} V{ky} A{r} {r} 0 0 1 {cx + r} {ky} V{taban} Z")
    return f'<path fill-rule="evenodd" d="{" ".join(d)}" fill-opacity="{op}"/>'


def kabe(x0, x1, ust, taban=ZEMIN):
    """Küp, kuşak boşluğu ve kapı boşluğu."""
    b = x1 - x0
    kusak = ust + (taban - ust) * 0.22
    kapi_x = x0 + b * 0.58
    return (f'<path fill-rule="evenodd" d="M{x0} {ust} H{x1} V{taban} H{x0} Z '
            f'M{x0} {kusak} H{x1} V{kusak + b * 0.07} H{x0} Z '
            f'M{kapi_x} {taban} V{taban - (taban - ust) * 0.42} H{kapi_x + b * 0.17} V{taban} Z"/>')


def yaz(ad, *parcalar):
    os.makedirs(KLASOR, exist_ok=True)
    govde = "\n  ".join((dortgen(0, ZEMIN, G, Y, 0.35),) + parcalar)
    with open(os.path.join(KLASOR, ad + ".svg"), "w", encoding="utf-8", newline="\n") as f:
        f.write(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {G} {Y}" fill="#000000">\n  {govde}\n</svg>\n')


yaz("kabe",
    minare(52, 150, op=0.4), minare(108, 165, op=0.4),
    minare(292, 165, op=0.4), minare(348, 150, op=0.4),
    kemerli_duvar(14, 386, 178, 14, op=0.5),
    kabe(145, 255, 96))

yaz("mekke",
    # Saat kulesi ve yanındaki kuleler
    dortgen(196, 142, 222, ZEMIN, 0.45), dortgen(338, 142, 364, ZEMIN, 0.45),
    dortgen(222, 112, 252, ZEMIN, 0.55), dortgen(308, 112, 338, ZEMIN, 0.55),
    dortgen(258, 96, 302, ZEMIN, 0.7),
    f'<path fill-rule="evenodd" fill-opacity="0.7" d="M250 52 H310 V96 H250 Z M280 60 A14 14 0 1 0 280.01 60 Z"/>',
    '<path d="M262 52 L280 8 L298 52 Z" fill-opacity="0.7"/>',
    minare(40, 130, op=0.5), minare(160, 140, op=0.5),
    kemerli_duvar(10, 200, 184, 8, op=0.55),
    kabe(78, 142, 150))

yaz("medine",
    minare(22, 120, op=0.45), minare(378, 120, op=0.45),
    minare(70, 176, serefeler=(0.5, 0.72)), minare(150, 160, serefeler=(0.5, 0.72), op=0.75),
    minare(250, 160, serefeler=(0.5, 0.72), op=0.75), minare(330, 176, serefeler=(0.5, 0.72)),
    kubbe(118, 176, 18, 14, 0.8), kubbe(282, 176, 18, 14, 0.8),
    dortgen(174, 158, 226, 176), sivri_kubbe(200, 158, 28, 34), alem(200, 117),
    kemerli_duvar(8, 392, 176, 16))

yaz("kudus",
    # Sur ve mazgallar
    "".join(dortgen(x, 192, x + 8, 200, 0.5) for x in range(4, 396, 16)),
    dortgen(0, 200, G, ZEMIN, 0.5),
    kubbe(62, 200, 18, 15, 0.6), kubbe(338, 200, 16, 13, 0.6),
    dortgen(96, 132, 108, 200, 0.6), '<path d="M94 132 L102 116 L110 132 Z" fill-opacity="0.6"/>',
    # Kubbetü's-Sahra
    kemerli_duvar(130, 270, 166, 7),
    dortgen(160, 138, 240, 166),
    '<path d="M160 138 C148 100 172 70 200 60 C228 70 252 100 240 138 Z"/>',
    alem(200, 60))

yaz("selimiye",
    minare(140, 186, en=6, serefeler=(0.45, 0.62, 0.79), op=0.6),
    minare(260, 186, en=6, serefeler=(0.45, 0.62, 0.79), op=0.6),
    minare(108, 200, en=6, serefeler=(0.45, 0.62, 0.79)),
    minare(292, 200, en=6, serefeler=(0.45, 0.62, 0.79)),
    kubbe(200, 132, 66, 54), alem(200, 78),
    dortgen(134, 132, 266, 150),
    kubbe(138, 152, 22, 16), kubbe(262, 152, 22, 16),
    dortgen(122, 150, 278, ZEMIN),
    kemerli_duvar(84, 316, 186, 9, op=0.8))

yaz("ayasofya",
    minare(96, 138, en=9, op=0.55), minare(304, 138, en=9, op=0.55),
    minare(58, 156, en=10), minare(342, 156, en=10),
    kubbe(200, 122, 60, 32), alem(200, 90),
    dortgen(142, 122, 258, 136),
    kubbe(142, 152, 44, 28, 0.85), kubbe(258, 152, 44, 28, 0.85),
    dortgen(104, 150, 296, ZEMIN),
    dortgen(84, 138, 112, ZEMIN, 0.8), dortgen(288, 138, 316, ZEMIN, 0.8))

yaz("ulucami",
    minare(48, 176, en=10), minare(352, 176, en=10),
    dortgen(96, 148, 304, 162, 0.55),
    "".join(kubbe(cx, 148, 22, 15, 0.55) for cx in (118, 173, 227, 282)),
    "".join(kubbe(cx, 162, 24, 16) for cx in (90, 145, 200, 255, 310)),
    kemerli_duvar(62, 338, 162, 5, oran=0.42))

print(len(os.listdir(KLASOR)), "manzara")
