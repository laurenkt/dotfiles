#!/usr/bin/env bash

# Set-up the bare repo
if [ -d "$HOME/.dotfiles.git" ]; then
	echo "Directory already exists, using existing..."
else
	echo "Downloading from GitHub..."
	git clone --bare https://github.com/laurenkt/dotfiles.git $HOME/.dotfiles.git
fi

function git. {
   /usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME $@
}

# Checkout files
git. checkout

if [ $? = 0 ]; then
	echo "Checked out config";
else
	echo "Backing up pre-existing dot files...";
	# Complicated one. Find all the lines in git checkout that failed, 
	# xargs them into sh so that we can use a compound statement which:
	# - uses mkdir to create the dir structure to mv to
	# - mv the files into that dir
	git. checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
		xargs -I{} sh -c 'mkdir --parents `dirname ./config/backup/{}`; mv {} ./config/backup/{};'
	# Now trying again should avoid errors
	git. checkout || (echo "⚠️  Could not resolve git conflicts," \
		"please resolve them manually and try again" && \
		exit)
fi

# This must go after so config exists
git. config status.showUntrackedFiles no

# If zsh exists
if command -v zsh >/dev/null 2>&1; then
	echo "zsh found."
else
	# Install zsh
	echo "No zsh found. Installing..."

	if command -v brew >/dev/null 2>&1; then
		echo "Homebrew found. Installing zsh..."
		brew install zsh
	else
		echo "Trying apt..."
		sudo apt-get install zsh
	fi
fi

if [[ "$SHELL" != *zsh ]]; then
	echo "👌 You're all set!"
	source "$HOME/.zshrc"
else
	echo 'zsh is installed but you should still change your default shell to zsh'
	if command -v chsh >/dev/null 2>&1; then
		echo '> chsh -s $(command -v zsh)'
	fi
	zsh
	exit
fi
