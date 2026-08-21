#!/usr/bin/bash
# Dims the backlight after a period of inactivity -- does NOT lock the
# screen (see i3lock-blur.sh / xss-lock for that). Skips dimming while
# audio is playing or a window is fullscreen (video, presentations, etc).

exec ~/.cargo/bin/xidlehook \
    --not-when-audio \
    --not-when-fullscreen \
    --detect-sleep \
    --timer 180 \
        'brightnessctl -s set 10%' \
        'brightnessctl -r'
