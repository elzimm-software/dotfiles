#!/usr/bin/bash
# swaybg.service and swayidle.service (dot_config/systemd/user/) are only
# started under niri if they're in niri.service's Wants=, and that link has
# to be created once with `systemctl --user add-wants` -- installing the
# unit files alone doesn't do it. That step got missed when niri's config
# was first added, so wallpaper never drew and idle lock/dim never fired,
# with no error anywhere to notice by. add-wants is idempotent (just
# re-creates the same symlink), so this is safe to re-run on every apply.
#
# No-ops entirely if niri isn't installed yet (e.g. first bootstrap, before
# run_onchange_after_10-install-packages has run) or there's no user
# systemd/session to talk to.

set -euo pipefail

if ! command -v systemctl >/dev/null 2>&1; then
    exit 0
fi
if ! systemctl --user list-unit-files niri.service >/dev/null 2>&1; then
    exit 0
fi

systemctl --user add-wants niri.service swaybg.service swayidle.service
