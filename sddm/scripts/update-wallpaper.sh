#!/bin/bash

WALLPAPER_FILE="$HOME/.cache/current-wallpaper"
SDDM_WALLPAPER="/var/lib/sddm/wallpaper/current.png"

if [[ ! -f "$WALLPAPER_FILE" ]]; then
    exit 1
fi

WALLPAPER="$(<"$WALLPAPER_FILE")"

if [[ ! -f "$WALLPAPER" ]]; then
    exit 1
fi

sudo mkdir -p "$(dirname "$SDDM_WALLPAPER")"
sudo cp "$WALLPAPER" "$SDDM_WALLPAPER"
sudo chown root:sddm "$SDDM_WALLPAPER"
sudo chmod 640 "$SDDM_WALLPAPER"
