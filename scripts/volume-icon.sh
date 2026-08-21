#!/bin/bash

volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')

mute=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o "MUTED")

if [ -n "$mute" ]; then
    class="volume-muted"
    tooltip = "Muted"
elif [ "$volume" -gt 70 ]; then
    class="volume-high"
    tooltip = "$volume%"
elif [ "$volume" -gt 30 ]; then
    class="volume-medium"
    tooltip = "$volume%"

else
    class="volume-low"
    tooltip = "$volume%"
fi

echo "{\"text\":\"⠀\",\"class\":\"$class\",\"tooltip\":\"Volume: $volume%\"}"
