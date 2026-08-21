#!/bin/bash

signal=$(iw dev wlp192s0 link | awk '/signal/ {print $2}')

if [ -z "$signal" ]; then
    echo '{"text":"󰤭","class":"wifi-off","tooltip":"No WiFi"}'
    exit
fi

if [ "$signal" -gt -50 ]; then
    class="wifi-full"
elif [ "$signal" -gt -70 ]; then
    class="wifi-medium"
else
    class="wifi-low"
fi

echo "{\"text\":\" \",\"class\":\"$class\",\"tooltip\":\"WiFi $signal dBm\"}"
