#!/bin/bash

current=$(hyprctl activeworkspace -j | jq '.id')
max=$(hyprctl workspaces -j | jq '[.[].id] | max')

IsEmpty=$(hyprctl activeworkspace -j | jq '.windows')

if [ "$current" -ge "$max" ]; then
    if [ "$IsEmpty" -ne 0 ]; then
        hyprctl dispatch workspace +1
    fi  
else    
    hyprctl dispatch workspace e+1
fi
