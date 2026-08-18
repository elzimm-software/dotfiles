#!/usr/bin/bash

i3lock \
    --nofork \
    --blur 7 \
    --indicator \
    --keyhl-color="88cc00ff" \
    --ring-color="333333ff" \
    --inside-color="00000000" \
    --clock \
    --timestr="%I:%M%P" \
    --datestr="%a %m-%d" &

LOCK_PID=$!

# Signal logind that the screen is locked so it can proceed with suspend
[[ -n "$XSS_SLEEP_LOCK_FD" ]] && exec {XSS_SLEEP_LOCK_FD}>&-

wait $LOCK_PID
