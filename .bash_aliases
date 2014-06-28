#!/bin/sh
# .bash_aliases

#-------------------
# Personnal Aliases
#-------------------

# Modify basic commands interactive, and verbose
alias cp="cp -iv"             		# Modified CP to be interactive, verbose
alias rm="rm -i --one-file-system"  # Modified RM to be interactive
alias mv="mv -iv"             		# Modified MV to be interactive, verbose
alias grep="grep -i --color"  		# Modified GREP to ignore case
alias ln='ln -sfn'					# Modified ln to create or modify the link

# -> Prevents accidentally clobbering files.
alias md='mkdir -vpm0755'
alias rd='rm -IRv'

# Create and change into a new directory
alias mdcd='_(){ md "$1"; cd "$1"; }; _'  	# From http://stackoverflow.com/a/941390/2378780
alias wtf='_(){ SHOW_PROMPT_HELP; }; _' 	# Shows prompt info

# Move a file to .dotfiles folder and symbolically Link to it from ~
alias ml.dir='_(){ mv ~/$1 ~/.dotfiles/$1; ln -sfn ~/.dotfiles/$1 ~/$1; }; _'

alias h='history'
alias j='jobs -l'
alias which='type -a'

# To navigate to the different directories
alias ..='cd ..'
alias ...='cd ../..'

# Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias dircolors='echo -e ${dircolors//:/\\n}'
alias lscolors='echo -e ${LS_COLORS//:/\\n}'

# Filesystem diskspace usage
alias du='du -kh'    # Makes a more readable output.
alias df='df -kTh'
alias dus='df -h'

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -hG --color'											# Makes sure to show inode of the file and/or media

# --------------------------------
# |          nmn - start         |
# ---------------------------------

alias lx='ls -lXB;echo "==Sorted by eXtension=="'                     #  Sort by extension.
alias lk='ls -lSr;echo "==Sorted by size - biggest last=="'           #  Sort by size, biggest last.
alias lt='ls -ltr;echo "==Sorted by date - recent last=="'            #  Sort by date, most recent last.
alias lc='ls -ltcr;echo "==Sorted by change time - recent last=="'    #  Sort by/show change time,most recent last.
alias lu='ls -ltur;echo "==Sorted by access time - recent last=="'    #  Sort by/show access time,most recent last.

# alias lsl='_(){ la $@| \grep ^l; && echo "\nNo more linked files!"; }; _'                      # List linked files & folders only
alias lsl='_(){ (la $@| \grep ^l; )||( echo "No linked files found!";)  }; _'

# alias lsh="ls -dlv --group-directories-first .[^.]*"		# experimental : list hidden files and folders
alias lsh='_(){ ls -dlv --group-directories-first .[^.]* ; }; _'
alias lsh='_(){ dirvalue=".[^.]*" ; [[ -e $@ && dirvalue=$@  ]]; ( ls -dlv --group-directories-first ${dirvalue} ) || ( echo "There are NO hidden files in here(${dirvalue})!"); }; _'
alias lhd='_(){ lsh $@| grep ^d; }; _'						# experimental : list hidden folders only
alias lhf='_(){ lsh $@| grep -v ^d | grep -v ~$; }; _'		# experimental : list only hidden files, & not folders

alias lsf='_(){ ( ll $@| grep -v ^[dl]; )||( echo "No files in this folder!"; ) }; _'								# experimental : list non-hidden files only, & no folders
alias lsd='_(){ ll $@| \grep ^d; }; _'									# experimental : list non-hidden folders only, & no files
alias lsb='_(){ lsh $@| grep ~$; }; _'									# experimental : list backup files only

# Modified commands
alias sudo='sudo '
#alias apt-get="apt-fast"
alias uu='sudo apt-get --quiet update && sudo apt-get --yes --quiet upgrade'
alias ud='sudo apt-get --quiet update && sudo apt-get --yes --quiet dist-upgrade'

# Alias chmod commands
alias mx='chmod a+x'
alias 000='chmod 000'
alias 600='chmod 600'
alias 644='chmod 644'
alias 755='chmod 755'

## copying background image to safety
alias cpbg='sudo cp ~/.config/ubuntu-tweak/lovewallpaper.jpg /usr/share/backgrounds/lwp-$(date +'\%y\%m\%d-\%H\%M\%S').jpg'
alias alertbgcp='notify-send -u normal -i "$([ $? = 0 ] && echo ubuntu-tweak || echo terminal || echo error )" "Wallpaper saved" "LoveWallPaper.jpg copied successfully!"'
alias sbp='cpbg;alertbgcp'

# Find list of current ppa sources
alias lsppa='cat /etc/apt/sources.list /etc/apt/sources.list.d/*.list | grep ppa $*'

# Cleaning $HOME folder
alias gout='sudo \rm -I ~/.goutputstream-* -v'

# Lock, LogOut, Shutdown, ReStarting shortcut
alias lo='LogOut'
alias sd='sudo shutdown -P +3 "*** Powerring OFF the system in 3 mins ***"'
alias sr='sudo shutdown -rq +1 "*** ReStarting the system in 1 min ***"'
alias srn='sudo shutdown -rq now "*** ReStarting the system Immediately! ***"'
alias sc='sudo shutdown -c "Shutdown CANCELLED for now!"'
alias sx="exit && sudo -k"
alias x="exit"

# Common Git shortcuts functions
# --------- L E G E N D ---------
# shortCMD 			CMD-meaning
# ~~~~~~~~ 		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#	gini 	->		git init
#	g.		-> 		git add .
#	gadd 	->		git add <file(s)>
# 	gcomm 	-> 		git commit -m "<messege>"
# 	gradd 	-> 		git remote add origin http://github.com/<username>/<reponame>.git
# 	gpush 	-> 		git push -u origin master
# 	glob 	-> 		git config --global -l 		# Listing Global configuration
# 	gloc 	-> 		git config --local -l 		# Listing Local configuration
# ______________________________
alias gini='_(){ echo "RUNNING CMD: git init"; git init; }; _'
alias g.='_(){ echo "RUNNING CMD: \"git add -A\""; git add -A ; }; _'
alias gadd='_(){ echo -e "RUNNING CMD: git add \"$@\""; git add $@; }; _'
alias gcomm='_(){ echo -e "RUNNING CMD: git commit -m \"$1\""; git commit -m \""$1\""; }; _'
alias gradd='_(){ echo -e "RUNNING CMD: git remote add origin http://github.com/railsusr/$1.git"; git remote add origin http://github.com/railsusr/$1.git; }; _'
alias gpush='_(){ echo "git push -u origin master"; git push -u origin master; }; _'
alias glob='git config --global -l'
alias gloc='git config --local -l'

# -------------------------------
# |          nmn - ends         |
# -------------------------------

# The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll='ls -lv --group-directories-first "$@"'
alias lm='_(){ ll "$@"|more; }; _'    #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files as well.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...

#-------------------------------------------------------------
# Spelling typos - highly personnal and keyboard-dependent :-)
#-------------------------------------------------------------

alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
alias kk='ll'

#-------------------------------------------------------------
# Miscelleneous working aliases
#-------------------------------------------------------------
# Easy to use aliases for frequently used commands

alias cls='clear'									# Clear the screen only
alias Vim="vim `ls -t | head -1`"					# Open last modified file in vim
alias psg="ps aux |grep bash"						# Grep for a bash process
alias hcl='history -c; clear'						# To clear all the history and screen

# --------------------------------------------------------------------
# 		Below are collected from github.com/avdgaag/dotfiles
# --------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# 									Utilities - avdgaag
# ---------------------------------------------------------------------------------------

alias vi='vim'
#alias lsh='ls -lhGFr --color'
alias lsa='ls -laFr'
alias nicedate='date "+%Y-%m-%d"'
alias nicedatetime='date "+%Y-%m-%d %H:%M"'
alias iaw='open -a iA\ Writer'
alias marked='open -a Marked'
alias bbundle='bundle check || bundle install | grep -v "Using "'
#alias -g bb='`git rev-parse --abbrev-ref HEAD`'

function ffind() {
  find -E . -type f -regex ".*$@.*"
}
# Find top 5 big files
alias findbig="find . -type f -exec ls -s {} \; | sort -n -r | head -5"

# Working with these dotfiles made easier
alias reb='source ~/.bashrc'
alias ea='_(){ echo -e "Editing aliases ... "; editor ~/.bash_aliases; echo "Reloading aliases ... "; reb; echo " ... done!"; }; _' # Edit aliases

#echo -e '\n******Before/after this line in .bash_aliases********\n'

# To Do files
alias td='cat TODO'                  # what to do
alias tdn='head -1 TODO'             # what to do next
alias tdc='sed "/^$/d" TODO | wc -l' # to do count
alias tdd='sed "1d" TODO > TODO'     # mark next to do done
alias tdg='cat TODO | grep'          # what to do grep

# Pretty printing files
function pp() {
  pygmentize -O 'bg=dark,style=vim' -f terminal256 "$1" 
}

# Generating ctags
function cctags() {
  bundle show --paths | xargs ctags -R --languages=-javascript
  ctags -a --extra=+f --exclude=.git --exclude=log --exclude=tmp --languages=-javascript,sql -R *
}

# Other
alias redis-start='redis-server /usr/local/etc/redis.conf'

# ---------------------------------------------------------------------------------------
# 										Git - avdgaag
# ---------------------------------------------------------------------------------------
alias ga='git commit --amend'
alias gap='git add -p'
alias gb='git branch'
alias gbc='git rev-parse --abbrev-ref HEAD'
alias gc='git commit --verbose'
alias gca='git commit --all --verbose'
alias gd='git diff'
alias gdd='git difftool'
alias gds='git diff -w --staged'
alias gdw='git diff --word-diff'
alias gdws='git diff --staged --word-diff'
alias gfo='git fetch origin'
alias gl='git log --pretty=format:"%C(yellow)%h%C(reset)|%C(bold blue)%an%C(reset)|%s" | column -s "|" -t | less -FXRS'
alias glr='git log --pretty="format:* %s" --merges --grep "pull request" | sed -e "s/Merge pull request #[0-9]\{1,\} from kabisaict\///" -e "s/_/ /g"'
alias glog='git log --pretty=format:"%C(yellow)%h%C(reset) %C(green)%ar%C(reset) %C(bold blue)%an%C(reset) %C(red)%d%C(reset) %s" --graph --abbrev-commit --decorate'
alias gm='git merge --no-ff --no-commit'
alias gmc='git ls-files --unmerged | cut -f2 | uniq' # git merge conflicts
alias gmf='git commit -F .git/MERGE_MSG'
alias gmnff='git merge --no-ff'
alias go='git checkout'
alias gp='git push'
alias gpom='git push origin master'
alias gpp='git push -u origin `git rev-parse --abbrev-ref HEAD`'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grd='git rm $(git ls-files -d)'   # git remove deleted
alias grs='git rebase --skip'
alias gs='git status -b -s --ignore-submodules=dirty'
alias gsd='git svn dcommit'
alias gsf='git svn fetch'
alias gsr='git svn rebase'
alias gtimelog='! git --no-pager log --pretty=format:"%C(red)%h%C(reset){%C(green)%cd%C(reset){%C(bold blue)%an%C(reset){%s" --date=iso | column -t -s"{" | less -FXRS'
alias gw='git whatchanged --oneline'
alias gz='git archive -o snapshot.zip HEAD'

# Commit pending changes and quote all args as message
function gg() {
    git commit -v -a -m "$*"
}

# Bundler
alias be='bundle exec'

# Add ./bin to PATH to use bundler binstubs
alias binstubs='export PATH=./bin:$PATH'

# Rake
alias migrate='rake db:migrate db:test:prepare'
alias remigrate='rake db:drop db:create db:migrate db:test:prepare'

# Modified Heroku commands
alias hr='heroku'
alias hrl='hr logs -t'
alias hrr='hr run'
alias hrake='hr run rake'

# Rsync
alias sync='rsync -glpPrtvz --delete --exclude .svn --exclude .DS_Store --exclude .sass-cache'
