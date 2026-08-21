#!/usr/bin/bash
# Sets the desktop wallpaper via feh and mirrors it into AccountsService's
# BackgroundFile property, so lightdm-gtk-greeter's user-background=true
# picks up the same image at the login screen. feh only paints the X root
# window directly -- it never touches AccountsService on its own.

set -e

img="$(realpath "$1")"

feh --bg-fill "$img"

user_path=$(gdbus call --system --dest org.freedesktop.Accounts \
    --object-path /org/freedesktop/Accounts \
    --method org.freedesktop.Accounts.FindUserByName "$USER" \
    | grep -oP "(?<=objectpath ')[^']+")

gdbus call --system --dest org.freedesktop.Accounts \
    --object-path "$user_path" \
    --method org.freedesktop.DBus.Properties.Set \
    org.freedesktop.DisplayManager.AccountsService BackgroundFile \
    "<'$img'>" >/dev/null
