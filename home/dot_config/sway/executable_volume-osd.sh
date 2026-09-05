#!/usr/bin/bash
# Volume control on the default sink with a dunst OSD.
# Usage: volume-osd.sh <up|down|mute>
step=5

case "$1" in
    up)   pamixer --allow-boost -i "$step" ;;
    down) pamixer --allow-boost -d "$step" ;;
    mute) pamixer -t ;;
esac

vol=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

if [ "$muted" = "true" ]; then
    icon="󰝟"
    body="Muted"
else
    if [ "$vol" -ge 66 ]; then
        icon="󰕾"
    elif [ "$vol" -ge 33 ]; then
        icon="󰖀"
    else
        icon="󰕿"
    fi
    body="${vol}%"
fi

dunstify -a "volume" -u normal -t 1500 -h int:value:"$vol" -h string:x-dunst-stack-tag:volume "$icon Volume" "$body"
