#!/usr/bin/bash
# Dims the backlight after inactivity, unless audio is actively playing.
# Fullscreen suppression is handled natively by sway's inhibit_idle rule
# (see ~/.config/sway/config).

if pactl list short sink-inputs | grep -q RUNNING; then
    exit 0
fi

brightnessctl -s set 10%
