#!/bin/bash

WALLPAPER=$(cat "$HOME/.cache/current-wallpaper")
BATTERY=$(cat /sys/class/power_supply/BAT1/capacity)

sed \
    -e "s|^    path = .*|    path = $WALLPAPER|" \
    -e "s|__BATTERY__|$BATTERY|g" \
    "$HOME/dotfiles/hypr/hyprlock.conf" \
    > /tmp/hyprlock.conf

exec hyprlock -c /tmp/hyprlock.conf
