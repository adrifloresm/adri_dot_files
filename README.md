# Adriana's dotfiles

Personal shell / editor configuration: bash, git, tmux, emacs, plus an
ancillary rc file (devsearch).

## What's here

| File | Purpose |
|---|---|
| `.bashrc` | interactive-shell setup: history, prompt sourcing, aliases, PATH, NVM/RVM/linuxbrew hooks |
| `.bash_logout` | console-clear on login-shell exit |
| `.profile` | login-shell env (PATH additions, Chrome Remote Desktop size, sources `.bashrc` under bash) |
| `.prompt` | git-aware PS1 (branch name colored green/yellow/red = clean/staged/dirty) |
| `.gitconfig` | `core.editor=emacs`, color palette, ~60 aliases, rerere, tight whitespace rules |
| `.tmux.conf` | prefix stays C-b, 1-indexed windows/panes, `prefix R` reloads, mouse on, 100k scrollback |
| `.devsearchrc` | config for the `devsearch` source-tree tool |
| `.emacs.d/init.el` | top-level Emacs init: clipboard, line numbers, paren match, mouse wheel |
| `.emacs.d/lisp/` | split modules (`ui.el`, `keybindings.el`, `backup.el`, `autosave.el`, `functions.el`) + per-language hooks + vendored third-party modes (`markdown-mode`, `graphviz-dot-mode`, `thrift-mode`, `protobuf-mode`, `google-c-style`) |

All files carry heavy teaching-style comments explaining what each
setting does, so the repo doubles as reference material.

## Install

Prerequisites: bash, git. Everything else (emacs, tmux, NVM, RVM,
linuxbrew) is optional — the relevant blocks no-op when the tool isn't
installed.

```bash
git clone <repo-url> ~/adri_dot_files
cd ~/adri_dot_files
./install.sh              # symlink into $HOME (default, recommended)
# or: ./install.sh --copy    physical copies instead of symlinks
# or: ./install.sh --dry-run show what would happen, change nothing
```

Symlink mode is recommended so `git pull` in this repo updates `$HOME`
immediately with no re-install. Anything already in `$HOME` is renamed
to `*.bak-YYYYMMDD-HHMMSS` before the new file is installed — nothing
is lost. Re-running the script is safe.

## Post-install

1. **Set your git identity** — the tracked `.gitconfig` has blank user
   fields on purpose:
   ```bash
   git config --global user.name  "Your Name"
   git config --global user.email "you@example.com"
   ```

2. **Activate in this shell**:
   ```bash
   source ~/.bashrc
   ```
   Or just open a new terminal.

3. **If you're in a tmux session**, reload its config with
   `prefix R` (Ctrl-b then Shift-R).

## Uninstall

```bash
./uninstall.sh             # restore the most recent *.bak-* per file
./uninstall.sh --dry-run   # preview
```

Removes our symlinks/copies from `$HOME` and restores the most recent
timestamped backup that `install.sh` wrote.

## Caveats

- **`C-u` in Emacs is rebound to undo**, replacing the default
  `universal-argument`. If you depend on numeric prefixes, rebind in
  `~/.emacs.d/lisp/keybindings.el`.
- **Emacs backups** go to `~/.emacs_backups/` and **autosaves** to
  `~/.emacs_autosaves/`. Kept out of project dirs; can grow over time —
  prune when needed.
- **`git a`** is aliased to `git add .` (stages everything under cwd).
- **`git psf` / `git psfo`** are force-pushes with no safety net.
- **Meld aliases** (`meldon`/`meldof`) expect `~/.meld.py` — install
  separately or delete the aliases from `.gitconfig`.
- **tmux mouse mode is on**: to let the terminal emulator (not tmux)
  handle select-to-copy, hold **Shift** on Linux or **Option** on
  iTerm2 while selecting.
- **Bash PATH**: `~/bin` and `~/.local/bin` are prepended, so your
  personal scripts shadow system binaries of the same name.
