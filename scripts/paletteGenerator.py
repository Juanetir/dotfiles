#!/usr/bin/env python3



# color.font : Blanco + ligera tonalidad hacia el color dominante
# 
#  color.border : el color del borde de las aplicaciones y sliders 
# que sera el color que domine (no blanco y negro) [si la imagen tiene detalles amarillos seria amarillo]
# 
#  color.buttons : el color de los botones de waybar y swaync
# 
# color.appBackground : mas oscuro, pero que tienda un poco al color dominante 
# (lo usaré para casi todo que tenga un fondo).
# 
# color.radius : el radio del border de las aplicaciones 
# cambiar en funcion de que tan blanco o negra sea la imagen. 
# Por ahora (mas blanco = mas radio y mas negro = menos radio) 
# con alguna interpolacion lineal facil
#
# todo : Make Script to make color file

import colorsys
from pathlib import Path
from PIL import Image
import random
import json


from time import perf_counter

WALLPAPER_PATH = Path.home() / ".cache/current-wallpaper"

def printColor(HSV):
    h, s, v = HSV

    r, g, b = colorsys.hsv_to_rgb(h, s, v)

    r = int(r * 255)
    g = int(g * 255)
    b = int(b * 255)

    print(
        f"\033[48;2;{r};{g};{b}m     \033[0m",
        end=""
    )
def bucket2HSV(bucket):
    h, s, v = bucket

    return (
        h / 36,
        s / 10,
        v / 10
    )   
    


def setRadius (brightness, start = 6, end = 20):
    return start + (brightness / 255) * (end - start)

def getColorBucket(h, s, v):
    h = int(h * 36)
    s = int(s * 10)
    v = int(v * 10)

    return (h, s, v)


def analyzeImage(pixels):
    buckets = {}

    brightness_sum = 0
    total_pixels = 0

    for r, g, b in pixels:
        total_pixels += 1

        brightness_sum += (
            0.2126 * r +
            0.7152 * g +
            0.0722 * b
        )

        h, s, v = colorsys.rgb_to_hsv(
            r / 255,
            g / 255,
            b / 255
        )

        if s < 0.25 or v < 0.35:
            continue

        bucket = getColorBucket(h, s, v)
        buckets[bucket] = buckets.get(bucket, 0) + 1

    brightness = brightness_sum / total_pixels

    return brightness, buckets

def colorBoost(color, min_s=0.5, min_v=0.5):
    h, s, v = color
    s = max(s, min_s)
    v = max(v, min_v)

    return (h, s, v)

def colorMixer(color):
    h, s, v = color

    font = (h, s * 0.17, 0.96)
    border = (h, s, v)
    buttons = (h, s * 0.8, min(v + 0.1, 1.0))
    background = (h, s * 0.10, max(v * 0.13, 0.06))
    notificaitions = (h, s * 0.30, max(v * 0.25, 0.05))

    return {
        "font": font,
        "border": border,
        "buttons": buttons,
        "background": background,
        "notifications": notificaitions
    }

def getRandomColor():
    return (
        random.random(),
        0.5,
        0.7
    )
    
def roundPattern(pattern):
    for name, color in pattern["color"].items():
        pattern["color"][name] = tuple(round(value, 3) for value in color)

    pattern["radius"] = round(pattern["radius"], 1)

    return pattern

def makePatternJSON(palette, radius):
    PALETTE_PATH = Path.home() / ".cache/palette.json"

    palette = {
        name: HSV2Hex(color)
        for name, color in palette.items()
    }

    pattern = {
        "color": palette,
        "radius": round(radius, 2)
    }

    with open(PALETTE_PATH, "w") as file:
        json.dump(pattern, file, indent=4)
    
def HSV2Hex(color):
    h, s, v = color

    r, g, b = colorsys.hsv_to_rgb(h, s, v)

    r = int(r * 255)
    g = int(g * 255)
    b = int(b * 255)

    return f"#{r:02x}{g:02x}{b:02x}"

def makeSwayNCCSS(palette):
    SWAYNC_PATH = Path.home() / ".config/swaync/palette.css"
    WAYBAR_PATH = Path.home() / ".config/waybar/palette.css"
    WOFI_PATH = Path.home() / ".config/wofi/colors"

    css = f"""@define-color Cfont {HSV2Hex(palette["font"])};
@define-color Cborder {HSV2Hex(palette["border"])};
@define-color Cbuttons {HSV2Hex(palette["buttons"])};
@define-color Cbackground {HSV2Hex(palette["background"])};
@define-color Cnotifications {HSV2Hex(palette["notifications"])};
"""

    wofi_css = f"""{HSV2Hex(palette["font"])}
{HSV2Hex(palette["border"])} 
{HSV2Hex(palette["buttons"])} 
{HSV2Hex(palette["background"])} 
{HSV2Hex(palette["notifications"])}
    """

    with open(SWAYNC_PATH, "w") as file:
        file.write(css)  
    with open(WAYBAR_PATH, "w") as file:
        file.write(css)
    with open(WOFI_PATH, "w") as file:
        file.write(wofi_css)
        
def makeHyprlandConf(palette, radius):
    HYPRLAND_PATH = Path.home() / ".cache/palette.conf"

    border = HSV2Hex(palette["border"])
    buttons = HSV2Hex(palette["buttons"])

    r1 = int(border[1:3], 16)
    g1 = int(border[3:5], 16)
    b1 = int(border[5:7], 16)
    
    r2 = int(buttons[1:3], 16)
    g2 = int(buttons[3:5], 16)
    b2 = int(buttons[5:7], 16)

    colorBorder = f"rgba({r1:02x}{g1:02x}{b1:02x}fa)"
    colorButtons = f"rgba({r2:02x}{g2:02x}{b2:02x}7f)"
    
    conf = f"""$borderColor = {colorBorder}
$borderRadius = {round(radius)}
$buttonsColor = {colorButtons}
"""

    with open(HYPRLAND_PATH, "w") as file:
        file.write(conf)

def colorGenerate(image):
    
    t0 = perf_counter()
    image = image.convert("RGB")
    # print("RGB:", perf_counter() - t0)
        
    t1 = perf_counter()
    image = image.resize((500, 500), Image.Resampling.BILINEAR)
    # print("Resize:", perf_counter() - t1)
    
    t2 = perf_counter()

    brightness, dominant_color_bucket = analyzeImage(
        image.get_flattened_data()
    )
    # print("Analyze:", perf_counter() - t2)
    
    radius = setRadius (brightness)
    
    # print(f"Brightness: {brightness}")
    # print(f"Radius: {radius}")
   
    
    
    if dominant_color_bucket:
        bucket, _ = max(
            dominant_color_bucket.items(),
            key=lambda x: x[1]
        )

        color = bucket2HSV(bucket)
        boosted = colorBoost(color)
    else:
        boosted = getRandomColor()
        
    # printColor(bucket2HSV(bucket))
    printColor(boosted)

    palette = colorMixer(boosted)

    # print("\n-- Generated palette: --\n")
    for name, color in palette.items():
        printColor(color)
        # print(f" {name}: {color}")

    t3 = perf_counter()

    makePatternJSON(palette, radius)
    makeSwayNCCSS(palette)
    makeHyprlandConf(palette, radius)
    # print("Write files:", perf_counter() - t3)

    # print("Total:", perf_counter() - t0)

    # print("\n--  END  --")

    
def main():
    image_path = Path(WALLPAPER_PATH.read_text().strip())
    image = Image.open(image_path)

    colorGenerate(image)


if __name__ == "__main__":
    main()