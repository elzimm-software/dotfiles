#!/usr/bin/bash
# Sets a distinct wallpaper per monitor, and mirrors the primary monitor's
# image into AccountsService's BackgroundFile property so lightdm-gtk-greeter's
# user-background=true picks up the same image at the login screen.
#
# feh's multi-image --bg-fill relies on Xinerama or RandR to know where each
# monitor is; this system's feh build only has Xinerama support, and
# Xinerama doesn't represent rotated outputs (our vertical HDMI-1 panel)
# correctly, so letting feh pick per-monitor geometry itself produces
# broken/misplaced backgrounds. Instead we composite one image per output
# ourselves -- sized and positioned from the live `xrandr --query` geometry
# -- into a single canvas, then hand feh one pre-composited image it can't
# get wrong.
#
# Usage: set-wallpaper.sh <OUTPUT>=<image> [<OUTPUT>=<image> ...]
# The first OUTPUT given is treated as primary for the greeter sync.

set -euo pipefail

cache_dir="$HOME/.cache"
mkdir -p "$cache_dir"
composite="$cache_dir/i3-wallpaper.png"

xr="$(xrandr --query)"

read -r screen_w screen_h < <(grep -oP '^Screen 0:.*current \K[0-9]+ x [0-9]+' <<<"$xr" | tr -d 'x')

magick -size "${screen_w}x${screen_h}" xc:black "$composite"

primary_img=""
for pair in "$@"; do
    output="${pair%%=*}"
    img="$(realpath "${pair#*=}")"
    [ -z "$primary_img" ] && primary_img="$img"

    geom=$(grep -m1 "^${output} connected" <<<"$xr" | grep -oE '[0-9]+x[0-9]+\+[0-9]+\+[0-9]+')
    w="${geom%%x*}"; rest="${geom#*x}"
    h="${rest%%+*}"; rest="${rest#*+}"
    x="${rest%%+*}"; y="${rest#*+}"

    panel="$(mktemp --suffix=.png)"
    magick "$img" -resize "${w}x${h}^" -gravity center -extent "${w}x${h}" "$panel"
    # -colorspace sRGB: the canvas is created from xc:black, which magick
    # writes (and re-reads) as Grayscale -- without forcing it back to sRGB
    # here, compositing a color panel onto it silently desaturates the panel.
    magick "$composite" -colorspace sRGB "$panel" -geometry "+${x}+${y}" -composite "$composite"
    rm -f "$panel"
done

# --no-xinerama: even with a single pre-composited image, feh otherwise
# still offsets/repeats it per Xinerama monitor rather than treating the
# virtual screen as one canvas -- which is exactly the bug this script
# exists to work around. Treat the whole display as one screen instead.
feh --no-fehbg --no-xinerama --bg-fill "$composite"

user_path=$(gdbus call --system --dest org.freedesktop.Accounts \
    --object-path /org/freedesktop/Accounts \
    --method org.freedesktop.Accounts.FindUserByName "$USER" \
    | grep -oP "(?<=objectpath ')[^']+")

gdbus call --system --dest org.freedesktop.Accounts \
    --object-path "$user_path" \
    --method org.freedesktop.DBus.Properties.Set \
    org.freedesktop.DisplayManager.AccountsService BackgroundFile \
    "<'$primary_img'>" >/dev/null
