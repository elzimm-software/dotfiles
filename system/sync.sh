#!/usr/bin/bash
# Syncs root-owned system files (/etc, /usr/share, ...) between their live
# location and this repo. They can't be symlinked directly: lightdm (and
# other system users) can't traverse /home/eli (mode 710) to follow a
# symlink back into ~/.config, so a normal dotfiles symlink silently
# breaks them.
#
# Every file under this directory mirrors its live absolute path, e.g.
#   system/etc/lightdm/lightdm-gtk-greeter.conf -> /etc/lightdm/lightdm-gtk-greeter.conf
#   system/usr/share/backgrounds/foo.jpg        -> /usr/share/backgrounds/foo.jpg
#
# Usage:
#   system/sync.sh diff   # show what differs between repo and live files
#   system/sync.sh pull   # copy live -> repo (snapshot current system state)
#   system/sync.sh push   # copy repo -> live (apply tracked changes, needs sudo)

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

cmd="${1:-diff}"

while IFS= read -r -d '' repo; do
	live="/${repo#./}"
	case "$cmd" in
	diff)
		diff -u "$live" "$repo" --label "live:$live" --label "repo:$repo" || true
		;;
	pull)
		cp -v "$live" "$repo"
		;;
	push)
		sudo install -D -m "$(stat -c %a "$live" 2>/dev/null || echo 644)" "$repo" "$live"
		;;
	*)
		echo "usage: $0 {diff|pull|push}" >&2
		exit 1
		;;
	esac
done < <(find . -type f ! -name sync.sh -print0)
