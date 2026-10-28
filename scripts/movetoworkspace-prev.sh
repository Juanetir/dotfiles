#!/bin/bash

current=$(hyprctl activeworkspace -j | jq '.id')
prev=$(hyprctl workspaces -j | jq --argjson current "$current" '
    [.[].id | select(. < $current)] | max
')

if [ "$prev" != "null" ]; then
    hyprctl dispatch movetoworkspace "$prev"
fi