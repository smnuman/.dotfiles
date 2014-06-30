# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 022

#
# if running bash 			:: duplicated below, see below
#
# if [ -n "$BASH_VERSION" ]; then
#     # include .bashrc if it exists
#     if [ -f "$HOME/.bashrc" ]; then
# 	. "$HOME/.bashrc"
#     fi
# fi

#
# If running 'bash' and has a '.bashrc' file source that now
#
[[ -n "$BASH_VERSION" ]] && [[ -r "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
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
