#!/bin/bash

while true; do
    battery=$(cat /sys/class/power_supply/BAT1/capacity)
    status=$(cat /sys/class/power_supply/BAT1/status)

    if [ "$battery" -le 20 ] && [ "$status" = "Discharging" ]; then
        notify-send -u critical "Low battery" "${battery}%"
        sleep 350
    else
        sleep 60
    fi
done
