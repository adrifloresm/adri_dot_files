#!/usr/bin/env bash
# install.sh — deploy these dotfiles into $HOME.
#
# Default mode = symlink (changes in this repo appear immediately in $HOME
# after a `git pull`). Pass --copy to copy instead.
#
# Any pre-existing file or directory in $HOME is renamed to
# <name>.bak-YYYYMMDD-HHMMSS before the new one is installed, so nothing
# is lost. Run the script as many times as you like; each run backs up
# whatever is currently there.
#
# Usage:
#   ./install.sh              # symlinks (default)
#   ./install.sh --copy       # physical copies
#   ./install.sh --dry-run    # show what would happen, change nothing

set -euo pipefail

###############################################################################
# Options
###############################################################################
MODE="symlink"
DRY_RUN=0
for arg in "$@"; do
    case "$arg" in
        --copy)    MODE="copy" ;;
        --symlink) MODE="symlink" ;;
        --dry-run) DRY_RUN=1 ;;
        -h|--help)
            sed -n '2,16p' "$0"
            exit 0
            ;;
        *)
            echo "unknown arg: $arg" >&2
            exit 2
            ;;
    esac
done

# Resolve this repo's absolute path (symlinks need absolute targets).
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

###############################################################################
# Helpers
###############################################################################
say() { printf '[install] %s\n' "$*"; }
run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '  DRY: %s\n' "$*"
    else
        eval "$@"
    fi
}

# Back up $1 (if it exists, and isn't already a symlink into this repo).
backup() {
    local target="$1"
    if [ -L "$target" ]; then
        local cur
        cur="$(readlink "$target")"
        case "$cur" in
            "$REPO"/*) run "rm -f '$target'"; return ;;  # our own old symlink
        esac
    fi
    if [ -e "$target" ] || [ -L "$target" ]; then
        run "mv '$target' '${target}.bak-${STAMP}'"
        say "backed up $(basename "$target") -> $(basename "${target}.bak-${STAMP}")"
    fi
}

# Install $REPO/$1 -> $HOME/$1 using the chosen MODE.
install_file() {
    local rel="$1"
    local src="$REPO/$rel"
    local dst="$HOME/$rel"
    if [ ! -e "$src" ]; then
        say "skip (missing in repo): $rel"
        return
    fi
    backup "$dst"
    case "$MODE" in
        symlink) run "ln -s '$src' '$dst'" ;;
        copy)
            if [ -d "$src" ]; then
                run "cp -r '$src' '$dst'"
            else
                run "cp '$src' '$dst'"
            fi
            ;;
    esac
    say "installed ($MODE): ~/$rel"
}

###############################################################################
# Top-level dotfiles
###############################################################################
FILES=(
    .bashrc
    .bash_logout
    .profile
    .prompt
    .gitconfig
    .tmux.conf
    .toprc
    .devsearchrc
)
for f in "${FILES[@]}"; do
    install_file "$f"
done

###############################################################################
# .emacs.d — handled specially so we don't clobber Emacs-managed dirs like
# eln-cache/, elpa/, recentf, etc. We only install init.el and lisp/.
###############################################################################
run "mkdir -p '$HOME/.emacs.d'"
install_file ".emacs.d/init.el"
install_file ".emacs.d/lisp"

###############################################################################
# Post-install reminders
###############################################################################
cat <<EOF

[install] Done.

Next steps:
  1. Set your git identity (the repo's .gitconfig has blank user fields):
       git config --global user.name  "Your Name"
       git config --global user.email "you@example.com"

  2. Reload your shell:
       source ~/.bashrc
     (or open a new terminal)

  3. If you're inside a tmux session, reload its config with:
       prefix R          (i.e. Ctrl-b then Shift-R)

  4. Optional installs referenced by the config (all blocks are guarded
     so their absence is harmless):
       - NVM   (~/.nvm)                 Node version manager
       - RVM   (~/.rvm)                 Ruby version manager
       - linuxbrew                      Homebrew on Linux
       - meld + ~/.meld.py              for the git 'meldon' alias

Backups from this run (if any) are named *.bak-${STAMP}.
EOF
