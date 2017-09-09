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
	if [ ! -d .config/backup ]; then mkdir .config/backup; fi
	mkdir_mv () {
		mkdir --parents `dirname $2`
		mv $1 $2
	}
	export -f mkdir_mv
	git. checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mkdir_mv {} .config/backup/{}
	git. checkout
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
else
	echo 'zsh is installed but you should still change your default shell to zsh'
	if command -v chsh >/dev/null 2>&1; then
		echo '> chsh -s $(command -v zsh)'
	fi
	zsh; exit;
exit
