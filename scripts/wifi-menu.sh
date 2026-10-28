#!/bin/bash

wifi=$(nmcli -t -f SSID,SIGNAL,SECURITY device wifi list --rescan auto|
    awk -F: 'NF >= 2 && $1 != "" {print $1 "  (" $2 "%)"}' |
    sort -t'(' -k2 -nr |
    awk '!seen[$1]++')

[ -z "$wifi" ] && exit 0

selected=$(printf '%s\n' "$wifi" | wofi --dmenu --prompt "Wi-Fi")

[ -z "$selected" ] && exit 0

ssid=$(printf '%s' "$selected" | sed 's/  ([0-9]*%)$//')

if ! nmcli connection show "$ssid" >/dev/null 2>&1; then
    password=$(wofi --dmenu --password --prompt "Password")
    [ -z "$password" ] && exit 0

    nmcli device wifi connect "$ssid" password "$password"
else
    nmcli connection up "$ssid"
fi
