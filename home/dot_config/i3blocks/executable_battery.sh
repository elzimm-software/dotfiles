#!/bin/bash
# Battery status for i3blocks, colored per the Horizon Dark palette.
BAT=/sys/class/power_supply/BAT0

capacity=$(cat "$BAT/capacity" 2>/dev/null)
status=$(cat "$BAT/status" 2>/dev/null)

if [ -z "$capacity" ]; then
    echo "No battery"
    exit 0
fi

if [ "$status" = "Charging" ]; then
    icon="󰂄"
    color="#29d398"
elif [ "$capacity" -le 15 ]; then
    icon="󰁺"
    color="#e95678"
elif [ "$capacity" -le 40 ]; then
    icon="󰁽"
    color="#fab795"
else
    icon="󰁹"
    color="#29d398"
fi

echo "<span color=\"$color\">$icon ${capacity}%</span>"
