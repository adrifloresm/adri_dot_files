# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples.
#
# ~/.bashrc runs for *interactive, non-login* bash invocations. Login shells
# read ~/.profile (which in turn sources this file under bash). Keep
# interactive-only things here (aliases, prompt, completion); put PATH and
# environment exports needed by non-bash login shells in ~/.profile.

###############################################################################
# Non-interactive guard
###############################################################################
# If this shell isn't interactive (e.g. running a scripted `ssh host cmd`),
# bail out early. Sourcing aliases/prompt in non-interactive shells wastes time
# and can even break scp/rsync, which expect a silent stdout on login.
if [[ $- != *i* ]]; then
    return
fi

###############################################################################
# Terminal / window environment
###############################################################################
# NO_AT_BRIDGE=1 silences the "Couldn't register with accessibility bus" GTK
# warning that LXDE (and some minimal X sessions) produces when AT-SPI isn't
# running. Purely cosmetic — no functional effect.
export NO_AT_BRIDGE=1

###############################################################################
# History tuning
###############################################################################
# ignoreboth = ignoredups (don't log consecutive duplicates) + ignorespace
# (don't log commands starting with a space — useful for typing secrets).
HISTCONTROL=ignoreboth

# Append to the history file on shell exit instead of overwriting it. Without
# this, closing two shells in a row loses the first one's history.
shopt -s histappend

# In-memory history entries (HISTSIZE) and on-disk entries (HISTFILESIZE).
HISTSIZE=1000
HISTFILESIZE=2000

###############################################################################
# Shell options (shopt)
###############################################################################
# Recheck terminal size after every command so resized windows report correct
# $LINES / $COLUMNS to programs like less and vim.
shopt -s checkwinsize

# Uncomment to make `**` match files and any depth of directory (globstar).
#shopt -s globstar

###############################################################################
# lesspipe (syntax-aware `less` for archives, PDFs, etc.)
###############################################################################
# lesspipe lets `less` transparently preview .tar, .gz, .pdf, etc. by piping
# them through a preprocessor. Gated on existence so it doesn't error on
# minimal containers.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

###############################################################################
# Custom prompt
###############################################################################
# ~/.prompt defines a git-aware PS1: branch name colored green/yellow/red
# depending on clean/staged/dirty state. Sourced only if present so this
# .bashrc works on hosts without the custom prompt installed.
if [ -f ~/.prompt ] || [ -h ~/.prompt ]; then
    source ~/.prompt
fi

###############################################################################
# Color support + ls/grep aliases
###############################################################################
# dircolors emits LS_COLORS. `~/.dircolors` overrides the default palette if
# present; otherwise use the built-in defaults. The aliases below then apply
# the palette automatically to `ls` and the grep family.
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# `alert` = desktop notification when a long-running command finishes.
# Usage: `sleep 10; alert` — pops a notify-send balloon with the prior cmd.
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

###############################################################################
# Programmable completion
###############################################################################
# Load bash-completion (Tab-completion for git, ssh, systemctl, etc.).
# Skipped when running in strict POSIX mode because the completion scripts
# use bash-only syntax.
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

###############################################################################
# umask
###############################################################################
# 0077-equivalent: owner has full access, group read/execute, world nothing.
# Tighter than the Ubuntu default (0022) — keeps new files private by default.
umask u=rwx,g=rx,o=

###############################################################################
# PATH additions
###############################################################################
# Prepend ~/bin (personal scripts) and ~/.local/bin (pip/pipx --user installs)
# so they shadow system binaries of the same name. Guarded on directory
# existence to avoid cluttering PATH with non-existent entries.
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

###############################################################################
# Version managers: NVM (Node) and RVM (Ruby)
###############################################################################
# NVM sources nvm.sh lazily; once loaded, `nvm use <version>` switches Node.
# bash_completion adds Tab-completion for nvm subcommands.
NVM_DIR=~/.nvm
if [ -e "$NVM_DIR" ]; then
    source "$NVM_DIR/nvm.sh"
    source "$NVM_DIR/bash_completion"
fi

# RVM is the Ruby equivalent: `rvm use 3.2` switches rubies.
RVM_DIR=~/.rvm
if [ -e "$RVM_DIR" ]; then
    source "$RVM_DIR/scripts/rvm"
    source "$RVM_DIR/scripts/completion"
fi

###############################################################################
# uv / pipx shim (~/.local/bin/env)
###############################################################################
# Modern Python tooling (uv, pipx --global) drops an `env` script that
# exports PATH and any tool-specific env vars. Source it if present.
if [ -f "$HOME/.local/bin/env" ]; then
    . "$HOME/.local/bin/env"
fi

###############################################################################
# Linuxbrew (Homebrew on Linux)
###############################################################################
# `brew shellenv` prints the exports needed to use brew-installed binaries
# (HOMEBREW_PREFIX, MANPATH, INFOPATH, and a PATH prefix). Guarded on the
# binary existing so this .bashrc stays portable across machines without brew.
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
fi

###############################################################################
# Aliases — listings
###############################################################################
alias ll='ls -alF'                # long listing, classify, show hidden
alias la='ls -A'                  # show hidden (minus . and ..)
alias lr='ls -l -F -h -a -R'      # recursive long listing, human sizes

###############################################################################
# Aliases — misc utilities
###############################################################################
alias chrome='google-chrome'

# cls: clear screen *and* the scrollback buffer. `clear` only wipes the
# visible area; \ec is the terminal full-reset escape.
alias cls='echo -en "\ec"'

###############################################################################
# Parallel make (auto-detect CPU count)
###############################################################################
# Override `make` so every invocation uses -j N where N = core count.
# /proc/cpuinfo on Linux, /proc/sys/hw/ncpu on some BSDs.
if [ -e /proc/cpuinfo ]; then
    alias make="make -j $(grep -c ^processor /proc/cpuinfo)"
elif [ -e /proc/sys/hw/ncpu ]; then
    alias make="make -j $(sysctl hw.ncpu | awk '{print $2}')"
fi

###############################################################################
# devsearch (source-tree search tool, configured via ~/.devsearchrc)
###############################################################################
alias dev='source devsearch'

###############################################################################
# Editor & tmux shortcuts
###############################################################################
export EDITOR=emacs               # git/cron/visudo/etc. respect $EDITOR
alias nemacs='DISPLAY= emacs'     # force terminal UI even inside X
alias e='emacs'
alias t='tmux'
alias ta='tmux attach-session -t'
alias tn='tmux new-session -s'
alias tl='tmux list-sessions'
