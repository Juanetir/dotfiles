#!/bin/bash

echo "START: $(date +%T.%N)"

WALLPAPER_FILE="$HOME/.cache/current-wallpaper"

echo "before checks: $(date +%T.%N)"

WALLPAPER="$(<"$WALLPAPER_FILE")"

echo "before palette: $(date +%T.%N)"

~/dotfiles/scripts/paletteGenerator.py

echo "before waybar: $(date +%T.%N)"

killall -SIGUSR2 waybar

echo "before swaync: $(date +%T.%N)"

swaync-client -rs

echo "END: $(date +%T.%N)"

qs -p ~/dotfiles/quickshell/wallpaper ipc call wallpaper reloadPalette
qs -p ~/dotfiles/quickshell/screenshots ipc call screenshot reloadPalette
qs -p ~/dotfiles/quickshell/control-center ipc call control-center reloadPalette