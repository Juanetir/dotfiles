#!/bin/bash

current=$(hyprctl activeworkspace -j | jq '.id')
max=$(hyprctl workspaces -j | jq '[.[].id] | max')

IsEmpty=$(hyprctl activeworkspace -j | jq '.windows')

if [ "$current" -ge "$max" ]; then
    if [ "$IsEmpty" -ge 2 ]; then
        hyprctl dispatch movetoworkspace +1
    fi  
else    
    hyprctl dispatch movetoworkspace e+1
fi
