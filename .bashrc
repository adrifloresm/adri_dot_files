# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

###############################################################################
# If not running interactively, don't do anything
if [[ $- != *i* ]]; then
    #echo "you should be running interactively!!!"
    return
fi


###############################################################################
# Terminal window
###############################################################################

# stupid problem with LXDE
export NO_AT_BRIDGE=1

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

################################################################################
# Prompt
################################################################################
if [ -f ~/.prompt ] || [ -h ~/.prompt ]; then
    source ~/.prompt
fi

################################################################################
# Misc
################################################################################

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# umask
umask u=rwx,g=rx,o=

# Home bin
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# Local bin
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# NVM
NVM_DIR=~/.nvm
if [ -e $NVM_DIR ]; then
    source $NVM_DIR/nvm.sh
    source $NVM_DIR/bash_completion
fi

# RVM
RVM_DIR=~/.rvm
if [ -e $RVM_DIR ]; then
    source $RVM_DIR/scripts/rvm
    source $RVM_DIR/scripts/completion
fi

###############################################################################
# Aliases
###############################################################################
#alias ll='ls -l -F -h'
#alias la='ls -l -F -h -a'
#alias lr='ls -l -F -h -a -R'
alias ll='ls -alF'
alias la='ls -A'
alias lr='ls -l -F -h -a -R'

alias chrome='google-chrome'

# this clears the screen and the terminal buffer
alias cls='echo -en "\ec"'

# parallel make
if [ -e /proc/cpuinfo ]; then
    alias make="make -j `cat /proc/cpuinfo | grep processor | wc -l`"
elif [ -e /proc/sys/hw/ncpu ]; then
    alias make="make -j `sysctl hw.ncpu | awk '{print $2}'`"
fi

# devsearch
alias dev='source devsearch'

# emacs
export EDITOR=emacs
alias nemacs='DISPLAY= emacs'
alias e='emacs'

# tmux
alias t='tmux'
alias ta='tmux attach-session -t'
alias tn='tmux new-session -s'
alias tl='tmux list-sessions'
