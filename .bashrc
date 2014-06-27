#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Finding full name of the current user to use in the gitconfig file
# taken from http://www.thegeekscope.com/script-to-get-linux-user-info/
FULLUSERNAME=`cat /etc/passwd | grep -Ew ^$USER | cut -d":" -f5 | cut -d"," -f1`

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups  # no duplicate entries

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# append to the history file, don't overwrite it
shopt -s histappend
# saving multiline commands
shopt -s cmdhist
## reedit a history substitution line if it failed
shopt -s histreedit
## edit a recalled history line before executing
shopt -s histverify

# formating history better
if [ -f "./.histrc" ]; then
    . ./.histrc
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

COLOR_DEFS=~/.dotfiles/.colordefrc
COLOR_PROMPT=~/.dotfiles/.bash_colorprompt

[[ -f ${COLOR_DEFS} ]] && . ${COLOR_DEFS}

if [ -f ${COLOR_PROMPT} ]; then
	. ${COLOR_PROMPT}
else
	PS11='${debian_chroot:+($debian_chroot)}\u@\h:\W '
	PS12=' \$ '
	PS1=${PS11}${PS12}"\[\e]0;[\u@\h] \w\a\]"
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -alF'
#alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# export LS_COLORS="*$LS_COLORS:*.*rc=01;33:" # testing only

#----------------------------------------------------------
# Copied from https://github.com/magicmonty/bash-git-prompt
# Requires:       gitstatus.py        in the same directory
# Optional addition:     .git-prompt-colors.sh
#------------------ Numan ---------------------------------
# If a userspecific gitconfig is available, then use it, saving the old one.
#[[ -f ~/.gitconfig.$USER ]] && { ( [[ -f ~/.gitconfig ]] && mv ~/.gitconfig ~/.gitconfig.save.$(date); ); cp -f -i ~/.gitconfig.$USER ~/.gitconfig; }

# A bash prompt that displays information about the current git repository. 
# In particular the branch name, difference with remote branch, 
# number of files staged, changed, etc.
# Prompt Structure :
#
# By default, the general appearance of the prompt is::
#
# (<branch> <branch tracking>|<local status>)
# The symbols are as follows:
#GIT_PROMPT_START
# Local Status Symbols
# ---------------------
# ✔: repository clean
# ●n: there are n staged files
# ✖n: there are n unmerged files
# ✚n: there are n changed but unstaged files
# …n: there are n untracked files
#
# Branch Tracking Symbols
# -----------------------
# ↑n: ahead of remote by n commits
# ↓n: behind remote by n commits
# ↓m↑n: branches diverged, other by m commits, yours by n commits
#
# Branch Symbol:
# When the branch name starts with a colon :, it means it's actually a hash, not a branch 
# (although it should be pretty clear, unless you name your branches like hashes :-)
#
if [ -f ~/gitprompt.sh ]; then
    # gitprompt configuration
    GIT_PROMPT_START=$PS11
    GIT_PROMPT_END=$PS12

    # Set config variables first
    GIT_PROMPT_ONLY_IN_REPO=1

    # as last entry source the gitprompt script
    . ~/gitprompt.sh
else
    echo "==========giptprompt not found======="
fi

if [ -f ~/.git-completion.bash ]; then
	. ~/.git-completion.bash
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# # Following stops expanding ~ in tab-completion which is 
# # expanded by default in /etc/bash_completion
# __expand_tilde_by_ref() {
#   eval cur=$cur;
# }
# # Disable Tilde Expansion
# _expand() {
#     eval cur=$cur;
# }

# uncomment below if using CentOS and also for bash_aliases 
export EDITOR=vim

# making custom ls colors!
if [ -f "~/.lscolorsrc" ]; then 
	. ~/.lscolorsrc
fi

# Adding path safely ---
# [[ :$PATH: != *:/my/dir:* ]] && PATH+=:/my/dir 
# ------------------------
# ---OR---
# Add :
# ((SHLVL>1)) || 

((SHLVL>1)) || export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

### Added by the Heroku Toolbelt
((SHLVL>1)) || export PATH="/usr/local/heroku/bin:$PATH"
