#!/usr/bin/bash
# Sets the desktop wallpaper via swaymsg and mirrors it into AccountsService's
# BackgroundFile property, so lightdm-gtk-greeter's user-background=true
# picks up the same image at the login screen. swaybg only paints the
# compositor's output directly -- it never touches AccountsService on its own.

set -e

img="$(realpath "$1")"

swaymsg output "*" bg "$img" fill

user_path=$(gdbus call --system --dest org.freedesktop.Accounts \
    --object-path /org/freedesktop/Accounts \
    --method org.freedesktop.Accounts.FindUserByName "$USER" \
    | grep -oP "(?<=objectpath ')[^']+")

gdbus call --system --dest org.freedesktop.Accounts \
    --object-path "$user_path" \
    --method org.freedesktop.DBus.Properties.Set \
    org.freedesktop.DisplayManager.AccountsService BackgroundFile \
    "<'$img'>" >/dev/null
