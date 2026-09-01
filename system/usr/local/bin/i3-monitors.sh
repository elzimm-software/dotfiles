#!/bin/sh
# Monitor layout: HDMI-1 (vertical monitor, left) - DP-2 (primary, center) - HDMI-0 (TV, right)
#
# Lives under /usr/local/bin (not ~/.config/i3) so lightdm's display-setup-script
# can exec it: that hook runs in the confined xdm_t SELinux domain, which is
# denied execute on config_home_t (everything under ~/.config). /usr/local/bin
# gets bin_t by default, which xdm_t can exec. i3's own exec_always uses this
# same path so there's one canonical copy.
xrandr \
  --output DP-2 --primary --mode 1920x1080 --rate 240 --pos 1080x0 --rotate normal \
  --output HDMI-1 --mode 1920x1080 --rate 75 --rotate left --pos 0x-840 \
  --output HDMI-0 --mode 1920x1080 --rate 59.94 --rotate normal --pos 3000x0
