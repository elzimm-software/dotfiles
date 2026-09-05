#!/usr/bin/bash
# Volume control with a dunst OSD. Operates on the default sink unless a
# PipeWire sink name is given (desktop's per-bus voicemeeter routing).
# Usage: volume-osd.sh <up|down|mute> [sink] [label]
step=5
sink="$2"
label="${3:-Volume}"

sink_args=()
[ -n "$sink" ] && sink_args=(--sink "$sink")

case "$1" in
    up)   pamixer "${sink_args[@]}" --allow-boost -i "$step" ;;
    down) pamixer "${sink_args[@]}" --allow-boost -d "$step" ;;
    mute) pamixer "${sink_args[@]}" -t ;;
esac

vol=$(pamixer "${sink_args[@]}" --get-volume)
muted=$(pamixer "${sink_args[@]}" --get-mute)

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

# Distinct stack tag per sink so adjusting two buses in quick succession
# shows two separate OSD bubbles instead of one overwriting the other.
dunstify -a "volume" -u normal -t 1500 -h int:value:"$vol" -h string:x-dunst-stack-tag:"volume-${sink:-default}" "$icon $label" "$body"
