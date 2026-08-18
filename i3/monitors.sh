#!/bin/sh
# Monitor layout: HDMI-1 (vertical monitor, left) - DP-2 (primary, center) - HDMI-0 (TV, right)
xrandr \
  --output DP-2 --primary --mode 1920x1080 --rate 240 --pos 1080x0 --rotate normal \
  --output HDMI-1 --mode 1920x1080 --rate 75 --rotate left --pos 0x-840 \
  --output HDMI-0 --mode 1920x1080 --rate 59.94 --rotate normal --pos 3000x0
