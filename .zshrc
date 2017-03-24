setopt APPEND_HISTORY AUTO_CD AUTO_RESUME AUTO_PUSHD CDABLE_VARS CORRECT CORRECT_ALL EXTENDED_HISTORY EXTENDED_GLOB \
       HIST_IGNORE_DUPS HIST_REDUCE_BLANKS INC_APPEND_HISTORY LONG_LIST_JOBS MENU_COMPLETE NOTIFY PROMPT_SUBST \
       PUSHD_SILENT RC_QUOTES REC_EXACT SHARE_HISTORY
unsetopt AUTO_PARAM_SLASH BEEP BG_NICE CLOBBER

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

export EDITOR=vim
export HISTFILE=$HOME/.zhistory
export HISTSIZE=500
export SAVEHIST=$HISTSIZE
export PAGER=less

# Shortcuts for ls
alias ll='ls -alh'
alias l.='ls -d .[^.]*'

# Neovim
alias vim=nvim

# Coloured Man Pages
man() {
	env LESS_TERMCAP_mb=$(printf "\e[1;31m") LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
	man "$@"
}

# This configuration file is shared between Linux and OS X machines. Only do this bit on OS X.
if [[ `uname` == Darwin ]]; then
	# Highlight the location in the prompt a particular colour depending on platform
	host_colour=magenta
	
	# The 'cdf' command will cd to the current open Finder directory, needs OpenTerminal installed
	cdf() { cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`" }

	# Set Neovim as the editor
	export EDITOR='nvim'

	# Set ls for colorized; label dirs, exes, etc.; one entry per line
	alias ls='pwd;ls -F1G '
	
	# Homebrew set-up
	export PATH=/usr/local/sbin:$PATH
	
# Only do this part on Linux.
else
	# PATH for course tools
	export PATH=$PATH:/usr/lt696/bin:/usr/local/pkg/xilinx-design-suite-14.3-x86_64-1/14.3/ISE_DS/EDK/gnu/microblaze/lin/bin:/usr/local/pkg/marte-1.4/utils:/usr/local/pkg/gnat-3.14p/bin:/32/usr/bin

	# Show running processes on a different tty, that aren't sh or the current shell
	ps -Nft - -t `tty` -C `basename $SHELL` -C sh 2> /dev/null | grep "^$USER"
	
	# Highlight the location in the prompt a particular colour depending on platform
	host_colour=cyan

	# Set ls for colorized; label dirs, exes, etc.; one entry per line
	alias ls='pwd;ls -F1 --color=auto '
fi

# rbenv set-up
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Function that returns `pwd`, but paths relative to home dir are replaced with ~/path
pwd_with_home() {
	pwd | sed `printf 's?%q?~?' $HOME` | sed 's/\\/\\\\/g'
}

export PROMPT=$'
🔆 %F{white} $USER%f %F{$host_colour}$(hostname)%f %K{green} %F{black}$(pwd_with_home) %k%f
%F{cyan}%#%f '

# Autocomplete stuff
expand-or-complete-with-dots() {
	echo -n "\e[1;30m...\e[0m" # put the "waiting" dots
	zle expand-or-complete   # do the completion
	zle redisplay            # remove the dots
}

zle -N expand-or-complete-with-dots

autoload -U compinit && compinit

bindkey '	' expand-or-complete-with-dots
bindkey '^L' clear-screen-with-prompt
bindkey '^R' history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:processes' command 'ps -axw'
zstyle ':completion:*:processes-names' command 'ps -awxho command'
# Completion Styles
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:scp:*' tag-order \
   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
   files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr

zstyle '*' single-ignored show

