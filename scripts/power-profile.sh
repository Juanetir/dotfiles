#!/bin/bash

profiles=(
    "󰓅 | Performance"
    "󰾅 | Balanced"
    "󰾆 | Low Power"
)

choice=$(printf '%s\n' "${profiles[@]}" | wofi \
    --dmenu \
    --prompt "Power Profile" \
    --width 400 \
    --height 250)

case "$choice" in
    *"Performance")
        profile="performance"
        ;;
    *"Balanced")
        profile="balanced"
        ;;
    *"Low Power")
        profile="low-power"
        ;;
    *)
        exit 0
        ;;
esac

echo "$profile" | sudo tee /sys/firmware/acpi/platform_profile > /dev/null

notify-send \
    "Power Profile" \
    "Profile changed to $profile"
