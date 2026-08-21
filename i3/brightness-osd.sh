#!/usr/bin/bash
# Screen brightness control with a dunst OSD.
# Usage: brightness-osd.sh <up|down>
step=5%

case "$1" in
    up)   brightnessctl set "+${step}" >/dev/null ;;
    down) brightnessctl set "${step}-" >/dev/null ;;
esac

pct=$(brightnessctl -m | awk -F, '{gsub("%","",$4); print $4}')

if [ "$pct" -ge 66 ]; then
    icon="󰃠"
elif [ "$pct" -ge 33 ]; then
    icon="󰃝"
else
    icon="󰃞"
fi

dunstify -a "brightness" -u normal -t 1500 -h int:value:"$pct" -h string:x-dunst-stack-tag:brightness "$icon Brightness" "${pct}%"
