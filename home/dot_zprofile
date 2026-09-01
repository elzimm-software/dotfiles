
# Created by `pipx`
export PATH="$PATH:$HOME/.local/bin"

# LightDM's Xsession here exec's a login shell directly and never sources
# .xprofile/Xsession.d, so pull it in ourselves for X session env vars.
[ -f "$HOME/.xprofile" ] && source "$HOME/.xprofile"
