#!/bin/bash

DEVICE="a85992f465f24025ba8f1a23220874a9"
SERVICE="org.kde.kdeconnect"
PATH="/modules/kdeconnect/devices/$DEVICE/mprisremote"
INTERFACE="org.kde.kdeconnect.device.mprisremote"

case "$1" in
    get)
       /usr/bin/busctl --user get-property \
            "$SERVICE" \
            "$PATH" \
            "$INTERFACE" \
            volume | /usr/bin/awk '{print $2}'
        ;;

    set)
         /usr/bin/busctl  --user set-property \
            "$SERVICE" \
            "$PATH" \
            "$INTERFACE" \
            volume i "$2"
        ;;
esac
