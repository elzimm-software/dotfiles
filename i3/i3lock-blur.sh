#!/usr/bin/bash
# Horizon Dark lock screen. Invoked by xss-lock (see i3/config), which
# expects this to stay in the foreground and waits on it to release the
# sleep lock -- hence --nofork + `wait` below rather than i3lock's own fork.

i3lock \
    --nofork \
    --blur 7 \
    --indicator \
    --clock \
    --time-str="%I:%M%P" \
    --date-str="%a %m-%d" \
    --time-font="Hack Nerd Font Mono" \
    --date-font="Hack Nerd Font Mono" \
    --layout-font="Hack Nerd Font Mono" \
    --verif-font="Hack Nerd Font Mono" \
    --wrong-font="Hack Nerd Font Mono" \
    --time-size=32 \
    --date-size=14 \
    --color=1e181aff \
    --ring-color=5b5858bb \
    --inside-color=1e181abb \
    --ringver-color=26bbd9ff \
    --insidever-color=1e181abb \
    --ringwrong-color=e95678ff \
    --insidewrong-color=1e181abb \
    --line-color=00000000 \
    --separator-color=00000000 \
    --keyhl-color=29d398ff \
    --bshl-color=e95678ff \
    --verif-color=e0e0e0ff \
    --wrong-color=e95678ff \
    --modif-color=fab795ff \
    --layout-color=e0e0e0ff \
    --time-color=e0e0e0ff \
    --date-color=5b5858ff \
    --greeter-color=e0e0e0ff &

LOCK_PID=$!

# Signal logind that the screen is locked so it can proceed with suspend
[[ -n "$XSS_SLEEP_LOCK_FD" ]] && exec {XSS_SLEEP_LOCK_FD}>&-

wait $LOCK_PID
