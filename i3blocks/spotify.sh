#!/bin/bash
# Get the status of the player
PLAYER='spotify'

status=$(playerctl -p $PLAYER status 2>/dev/null)

if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
    artist=$(playerctl -p $PLAYER metadata artist)
    title=$(playerctl -p $PLAYER metadata title)
    echo "$artist - $title"
else
    echo "Spotify"
fi
