install-antibody () {
	# Download antibody, remove the installation alias,
	# and reload zsh conf
	if read -q "REPLY?Install antibody from github? y/n\n"; then
		echo "Installing..."
		unalias antibody && \
			(curl -sL https://git.io/antibody | bash -s) && \
			echo "Reloading $HOME/.zshrc" && \
			source "$HOME/.zshrc"
	fi
}

# Only do this if antibody is installed
if command -v antibody >/dev/null 2>&1; then
    # Initialize getantibody/antibody
    source <(antibody init)
    # Load plugins
    antibody bundle <"$HOME/.config/antibody/plugins.txt" > "$HOME/.config/zsh/plugins.sh"
    source "$HOME/.config/zsh/plugins.sh"
else
	# Make it easy to install antibody
	alias antibody=install-antibody
fi

setopt AUTO_CD            # `cd` optional for dirs where no command conflicts
setopt AUTO_PUSHD         # `cd` pushes dir onto the stack
setopt CORRECT            # Correct spelling of misspelt commands
setopt HIST_IGNORE_DUPS   # Don't clog history with duplicates
setopt HIST_REDUCE_BLANKS # Don't add blank lines to history
setopt INC_APPEND_HISTORY # Don't wait for shell to exit before adding to history
setopt MENU_COMPLETE      # Insert first match, don't stall when multiple matches exist
setopt NOTIFY             # Report status of bg jobs immediately, don't wait for prompt
setopt PROMPT_SUBST       # Allow param exp, cmd subst in PROMPT

unsetopt BEEP    # Don't beep on error
unsetopt BG_NICE # Don't run bg jobs at lower priority
unsetopt CLOBBER # Don't allow > redirection to truncate existing files

# If neovim is installed use it as a drop-in vim replacement
if which nvim > /dev/null; then alias vim=nvim; fi

# Shortcuts for ls
alias ll='ls -alh'       # All files with extra details
alias l.='ls -d .[^.]*'  # Only hidden files

export EDITOR=vim
export HISTFILE=$HOME/.config/zsh/history
export HISTSIZE=5000
export SAVEHIST=$HISTSIZE

# Use vim as a pager
alias less=vim -
# git. to interact with dotfiles repo
alias git.='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'

# Mac specific config
if [[ `uname` == Darwin ]]; then
	# The 'cdf' command will cd to the current open Finder directory, needs OpenTerminal installed
	cdf() { cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`" }

	# Set ls for colorized; label dirs, exes, etc.; one entry per line
	alias ls='pwd;ls -F1G '
else
# Linux
	# Show running processes on a different tty, that aren't sh or the current shell
	# This is useful when you log into a server and have forgotten you have bg tasks
	ps -Nft - -t `tty` -C `basename $SHELL` -C sh 2> /dev/null | grep "^$USER"

	# Set ls for colorized; label dirs, exes, etc.; one entry per line
	alias ls='pwd;ls -F1 --color=auto '
fi

# Only do this if the module is loaded
if zle -l history-substring-search-up; then
	# Find partial history matches with up and down
	bindkey '^[[A' history-substring-search-up
	bindkey '^[[B' history-substring-search-down
fi

# Enable menu selection on tab completion
zstyle ':completion:*' menu select=1 _complete _approximate

# Colours in tab completion menu
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# Need to enable extended engine for completion menu
autoload -Uz compinit && compinit
