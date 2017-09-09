#!/usr/bin/env bash

# Set-up the bare repo
git clone --bare https://github.com/laurenkt/dotfiles.git $HOME/.dotfiles.git
function git. {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

git. config status.showUntrackedFiles no
git. checkout
