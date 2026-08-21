#!/bin/bash

TOUCHPAD="syna2ba6:00-06cb:cfd8-touchpad"
STATE=$(<~/.cache/touchpad.state)

if [ "$STATE" = "1" ]; then
    hyprctl keyword "device[$TOUCHPAD]:enabled" false
    echo 0 > ~/.cache/touchpad.state
else
    hyprctl keyword "device[$TOUCHPAD]:enabled" true
    echo 1 > ~/.cache/touchpad.state
fi
