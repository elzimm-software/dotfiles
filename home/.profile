# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
. "$HOME/.cargo/env"
PATH="$HOME/.local/share/pycharm-2026.1.2/bin:$PATH"

PATH="$HOME/Applications:$PATH"
PATH="$HOME/go/bin:$PATH"

# HiDPI: Qt doesn't read Xft.dpi, so ask it to auto-scale from the
# monitor's reported DPI (matches Xft.dpi set in ~/.Xresources).
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export XCURSOR_SIZE=40
