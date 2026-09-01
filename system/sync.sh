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
# A few files only belong on one machine profile (see i3_only/sway_only
# below). This reads the `wm` profile chezmoi already asks about (from
# ~/.config/chezmoi/chezmoi.toml) and skips files tagged for the other
# profile, so pull/push can't cross-contaminate the two machines - e.g. a
# blanket `push` on the sway laptop must not install the desktop's
# i3-monitors.sh or dnf.conf. If `wm` can't be determined, every tagged
# file is skipped rather than guessed.
#
# Usage:
#   system/sync.sh diff   # show what differs between repo and live files
#   system/sync.sh pull   # copy live -> repo (snapshot current system state)
#   system/sync.sh push   # copy repo -> live (apply tracked changes, needs sudo)

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

cmd="${1:-diff}"

wm=$(sed -n 's/^[[:space:]]*wm[[:space:]]*=[[:space:]]*"\(.*\)"[[:space:]]*$/\1/p' ~/.config/chezmoi/chezmoi.toml 2>/dev/null || true)
if [[ "$wm" != "i3" && "$wm" != "sway" ]]; then
	echo "warning: couldn't determine this machine's wm profile from ~/.config/chezmoi/chezmoi.toml; skipping all machine-specific files for safety" >&2
	wm=""
fi

i3_only=(
	"./etc/dnf/dnf.conf"
	"./etc/lightdm/lightdm.conf.d/10-monitors-setup.conf"
	"./etc/systemd/logind.conf.d/10-power-button-suspend.conf"
	"./usr/local/bin/i3-monitors.sh"
)
sway_only=(
	"./etc/lightdm/lightdm-gtk-greeter.conf.d/50-hidpi.conf"
	"./usr/share/backgrounds/horizon-dark-greeter-laptop.jpg"
	"./usr/share/fonts/hack-nerd-font/"*.ttf
)

belongs_to_other_profile() {
	local f="$1" p
	if [[ "$wm" != sway ]]; then
		for p in "${sway_only[@]}"; do [[ "$f" == $p ]] && return 0; done
	fi
	if [[ "$wm" != i3 ]]; then
		for p in "${i3_only[@]}"; do [[ "$f" == $p ]] && return 0; done
	fi
	return 1
}

while IFS= read -r -d '' repo; do
	if belongs_to_other_profile "$repo"; then
		[[ "$cmd" == diff ]] && echo "skipping $repo (belongs to the other machine profile)" >&2
		continue
	fi
	live="/${repo#./}"
	case "$cmd" in
	diff)
		diff -u "$live" "$repo" --label "live:$live" --label "repo:$repo" || true
		;;
	pull)
		cp -v "$live" "$repo"
		;;
	push)
		sudo install -D -m "$(stat -c %a "$live" 2>/dev/null || stat -c %a "$repo")" "$repo" "$live"
		;;
	*)
		echo "usage: $0 {diff|pull|push}" >&2
		exit 1
		;;
	esac
done < <(find . -type f ! -name sync.sh -print0)
