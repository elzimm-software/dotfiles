#!/usr/bin/bash
# Sets the desktop wallpaper via swaymsg and mirrors the primary image into
# AccountsService's BackgroundFile property, so lightdm-gtk-greeter's
# user-background=true picks up the same image at the login screen. swaybg
# only paints the compositor's output directly -- it never touches
# AccountsService on its own.
#
# Usage:
#   set-wallpaper.sh <image>                     # same image on every output
#   set-wallpaper.sh <OUTPUT>=<image> [...]       # per-output image; the
#                                                  # first OUTPUT given is
#                                                  # primary for the greeter
#                                                  # sync

set -e

primary_img=""
if [[ "$1" == *=* ]]; then
    for pair in "$@"; do
        output="${pair%%=*}"
        img="$(realpath "${pair#*=}")"
        [ -z "$primary_img" ] && primary_img="$img"
        swaymsg output "$output" bg "$img" fill
    done
else
    primary_img="$(realpath "$1")"
    swaymsg output "*" bg "$primary_img" fill
fi

user_path=$(gdbus call --system --dest org.freedesktop.Accounts \
    --object-path /org/freedesktop/Accounts \
    --method org.freedesktop.Accounts.FindUserByName "$USER" \
    | grep -oP "(?<=objectpath ')[^']+")

gdbus call --system --dest org.freedesktop.Accounts \
    --object-path "$user_path" \
    --method org.freedesktop.DBus.Properties.Set \
    org.freedesktop.DisplayManager.AccountsService BackgroundFile \
    "<'$primary_img'>" >/dev/null
