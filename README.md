dotfiles
========

Installs shell config in a straightforward way. Uses a [Git bare repo](http://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/) to avoid polluting everything below `~/` with the Git repository.

Installation
------------

	curl -sL "https://raw.githubusercontent.com/laurenkt/dotfiles/master/.config/installer.sh" \
		| bash -s

Usage
-----

To interact with the bare repository use the `git.` command instead of `git`, e.g:

	git. status
	git. log

The format of all the commands are the same (in fact it is the same command, just set to a specific repository location and working-dir to avoid pollution).

Components
----------

+ zsh
+ zplug
+ nvim
