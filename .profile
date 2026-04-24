# ~/.profile: executed by the command interpreter for *login* shells.
# This file is NOT read by bash if ~/.bash_profile or ~/.bash_login exists,
# because bash prefers those and stops after the first one it finds.
# See /usr/share/doc/bash/examples/startup-files (bash-doc package) for examples.
#
# Rule of thumb:
#   ~/.profile  -> environment (PATH, exports) — runs once per login session.
#   ~/.bashrc   -> interactive niceties (aliases, prompt) — runs every shell.

###############################################################################
# umask
###############################################################################
# The system default umask lives in /etc/profile. For per-user ssh-login
# umask, prefer configuring libpam-umask (PAM-level) rather than setting it
# here, because not every login path re-reads ~/.profile.
#umask 022

###############################################################################
# Source ~/.bashrc when running under bash
###############################################################################
# On Debian/Ubuntu, login bash shells don't automatically read ~/.bashrc.
# Chain it here so interactive login shells get the same aliases/prompt as
# non-login shells. Gated on $BASH_VERSION so dash/sh login shells don't
# try to execute bash-specific syntax.
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

###############################################################################
# User PATH additions
###############################################################################
# Prepend personal bin dirs so user scripts shadow system binaries of the
# same name. Guard on directory existence to keep PATH clean on hosts that
# don't have these dirs.
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

###############################################################################
# uv / pipx shim
###############################################################################
# Modern Python tool installers (uv, pipx --global) drop an `env` script
# that sets up their cache dirs and a PATH prefix. Source it if present.
if [ -f "$HOME/.local/bin/env" ]; then
    . "$HOME/.local/bin/env"
fi

###############################################################################
# Chrome Remote Desktop resolution
###############################################################################
# CRD spawns an Xvfb session at whatever size(s) this env var lists. One
# resolution = fixed-size virtual display. Space-separated list = selectable
# sizes in the CRD web client.
export CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES=1366x768
