#!/usr/bin/env bash

# Set-up the bare repo
git clone --bare https://github.com/laurenkt/dotfiles.git $HOME/.dotfiles.git
function git. {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

# Checkout files
git. checkout

# This must go after so config exists
git. config status.showUntrackedFiles no

# If zsh exists
if command -v zsh >/dev/null 2>&1; then
	echo "zsh found."
else
	# Install zsh
	echo "No zsh found. Installing..."

	if command -v brew >/dev/null 2>&1; then
		echo "Homebrew found. Using..."
		brew install zsh
	else
		echo "Trying apt..."
		sudo apt-get install zsh
	fi
fi

if command -v chsh >/dev/null 2>&1; then
	chsh -s $(which zsh)
fi

zsh
exit
