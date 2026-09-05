#!/usr/bin/bash
# Region screenshot -> satty for annotation -> clipboard. Enter copies and
# closes immediately; Escape just cancels. slurp exiting non-zero (Escape
# pressed during region-select) aborts before grim/satty ever run.
geom=$(slurp) || exit 0

grim -g "$geom" - | satty --filename - --copy-command wl-copy \
    --actions-on-enter save-to-clipboard --early-exit copy
