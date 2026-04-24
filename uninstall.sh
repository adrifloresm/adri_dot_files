#!/usr/bin/env bash
# uninstall.sh — remove this repo's dotfiles from $HOME and restore the
# most recent *.bak-YYYYMMDD-HHMMSS that install.sh wrote.
#
# - Removes both symlinks (install.sh default) and copies (install.sh --copy).
# - Only removes a file if it's either (a) a symlink pointing into this
#   repo, or (b) a regular file whose content matches the repo's copy.
#   Anything else is left alone — if you edited a file in place, this
#   script won't clobber your work.
# - Restores the backup with the LATEST timestamp per file. Older backups
#   are left on disk so you can prune them yourself.
#
# Usage:
#   ./uninstall.sh              # actually do it
#   ./uninstall.sh --dry-run    # preview

set -euo pipefail

DRY_RUN=0
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        -h|--help)
            sed -n '2,19p' "$0"
            exit 0
            ;;
        *)
            echo "unknown arg: $arg" >&2
            exit 2
            ;;
    esac
done

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

say() { printf '[uninstall] %s\n' "$*"; }
run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '  DRY: %s\n' "$*"
    else
        eval "$@"
    fi
}

# Find the newest ~/.<name>.bak-* file for a given relative path.
# Echos the path, or nothing if no backups exist.
newest_backup() {
    local rel="$1"
    local newest=""
    local b
    # Use a glob + existence check so an unmatched pattern (no backups)
    # doesn't trip `set -euo pipefail`.
    for b in "$HOME/${rel}".bak-*; do
        [ -e "$b" ] || continue
        if [ -z "$newest" ] || [ "$b" \> "$newest" ]; then
            newest="$b"
        fi
    done
    printf '%s' "$newest"
}

# Should we remove $HOME/$rel? Only if it looks like we installed it.
installed_by_us() {
    local dst="$1"
    local src="$2"
    [ -e "$dst" ] || [ -L "$dst" ] || return 1
    if [ -L "$dst" ]; then
        case "$(readlink "$dst")" in
            "$src") return 0 ;;     # symlink into this repo
            *) return 1 ;;
        esac
    fi
    if [ -d "$dst" ] && [ -d "$src" ]; then
        # Directory: compare recursively. If diff finds nothing, assume ours.
        diff -r -q "$dst" "$src" >/dev/null 2>&1 && return 0 || return 1
    fi
    cmp -s "$dst" "$src" && return 0 || return 1
}

uninstall_one() {
    local rel="$1"
    local src="$REPO/$rel"
    local dst="$HOME/$rel"
    if [ ! -e "$dst" ] && [ ! -L "$dst" ]; then
        say "skip (absent): ~/$rel"
        return
    fi
    if installed_by_us "$dst" "$src"; then
        if [ -d "$dst" ] && [ ! -L "$dst" ]; then
            run "rm -rf '$dst'"
        else
            run "rm -f '$dst'"
        fi
        say "removed ~/$rel"
    else
        say "keep (locally modified, not ours): ~/$rel"
        return
    fi
    local bak
    bak="$(newest_backup "$rel")"
    if [ -n "$bak" ]; then
        run "mv '$bak' '$dst'"
        say "restored ~/$rel from $(basename "$bak")"
    fi
}

FILES=(
    .bashrc
    .bash_logout
    .profile
    .prompt
    .gitconfig
    .tmux.conf
    .devsearchrc
    .emacs.d/init.el
    .emacs.d/lisp
)
for f in "${FILES[@]}"; do
    uninstall_one "$f"
done

cat <<EOF

[uninstall] Done.

Older *.bak-* files (if any) were left in place so you can prune
them manually. To list them:
  ls -1 ~/.*.bak-* 2>/dev/null; ls -1 ~/.emacs.d/*.bak-* 2>/dev/null
EOF
