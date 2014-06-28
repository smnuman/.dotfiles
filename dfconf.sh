#!/bin/bash
############################
# .make.sh  from http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/.dotfiles						# dotfiles directory
olddir=~/dotfiles_old				# old dotfiles backup directory

gitpromptdir=${dir}/_GitPrompt_ 	# GitPrompt directory

files=(\
	bin \
	.bashrc \
	.bash_aliases \
	# .bash_colorprompt \			# Not required, called with full-path to .dotfiles/
	# .colordefrc \					# Not required, called with full-path to .dotfiles/
	.colorrc \
	.curlrc \
	.gammurc \
	# .gitconfig \
	# .gitconfig.railsusr \
	# .gitconfig.smnuman \
	.git-completion.bash \
	.histrc \
	.inputrc \
	.psqlrc \
	.netrc \
	.msmtprc \
	.pgadmin3 \
	.profile \
	.selected_editor \
	.ssh.config \
	vim \
	.vimrc \
	.wgetrc \
	)

gitpromptFiles=(\
	gitprompt.sh \
	gitstatus.py \
	gitstatus.sh \
	git-prompt-colors.sh \
	git-prompt-help.sh \
	)

#echo "Files are: ${files[*]}"

########## variables:done

# create dotfiles_old in homedir
if [[ ! -e "${olddir}" ]]; then
	echo "Creating '$olddir' for backup of any existing dotfiles in ~"
	mkdir -p $olddir
	echo "...done"
fi

# change to the dotfiles directory
echo "Changing to the '$dir' directory"
# cd $dir
echo "...done"

move_this(){
	if [[ ! -h ~/.$1 ]]; then {
	    echo "Moving '$1' from ~/ to $olddir/"
	    mv ~/$1 $olddir/${1}.bak 
	} else	
		echo "Skipping file: '.$1' --> link already exists!"
	fi
}

link_this(){
	if [[ ! -h ~/.$1 ]]; then
	    echo "Symlinking '$dir/$1' --> '~/$1'"
	    ln -snf $dir/$1 ~/$1
	fi
}

link_in_folder_this(){
	if [[ ! -h ~/.$1 ]]; then
	    echo "Symlinking '$gitpromptdir/$1' --> '~/$1'"
	    ln -snf $gitpromptdir/$1 ~/$1
	fi
}

#
# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
#
for file in "${files[@]}"; do
	# if the file exists then move it to a safe location
    [[ -e ~/.$file ]] && move_this $file 
    # create a symbolic link (in $HOME dir) to the file
	link_this $file
done

#
# Move files in "dotfiles/GitPrompt/" folder to "~"
#
for file in "${gitpromptFiles[@]}"; do
	link_in_folder_this $file
done