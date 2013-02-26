setopt APPEND_HISTORY AUTO_CD AUTO_RESUME AUTO_PUSHD CDABLE_VARS CORRECT CORRECT_ALL EXTENDED_HISTORY EXTENDED_GLOB \
       HIST_IGNORE_DUPS HIST_REDUCE_BLANKS  INC_APPEND_HISTORY LONG_LIST_JOBS MENU_COMPLETE NOTIFY PROMPT_SUBST \
       PUSHD_SILENT RC_QUOTES REC_EXACT SHARE_HISTORY
unsetopt AUTO_PARAM_SLASH BEEP BG_NICE CLOBBER

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

setopt ALL_EXPORT

EDITOR="vim"
TZ="Europe/London"
HISTFILE=$HOME/.zhistory
HISTSIZE=1000
SAVEHIST=1000
HOSTNAME="`hostname`"
PAGER='less'
LC_ALL='en_GB.UTF-8'
LANG='en_GB.UTF-8'
LC_CTYPE=C

unsetopt ALL_EXPORT

# Some parts of this are specific to OS X, or specific to Linux
if [[ `uname` == "Darwin" ]]; then
	# Only do this part on OS X
	
	# Highlight the location in the prompt a particular colour depending on platform
	host_colour=yellow
	
	# the 'cdf' command will cd to the current open Finder directory, needs OpenTerminal installed
	cdf() { cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`" }

	# set macvim as the editor
	export EDITOR='/usr/local/bin/mate -w'
	#export EDITOR='mvim -f -c "au VimLeave * !open -a Terminal"'

	# set ls for colorized; label dirs, exes, etc.; one entry per line
	alias ls='pwd;ls -F1G '
else
	# Only do this part elsewhere (Linux, assumed)
	
	# Show running processes on a different tty, that aren't sh or the current shell
	ps -Nft - -t `tty` -C `basename $SHELL` -C sh 2> /dev/null | grep "^$(whoami)"
	
	# Highlight the location in the prompt a particular colour depending on platform
	host_colour=cyan

	# set ls for colorized; label dirs, exes, etc.; one entry per line
	alias ls='pwd;ls -F1 --color=auto '
fi

function pwd_with_home() {
	pwd | sed `printf 's?%q?~?' $HOME` | sed 's/\\/\\\\/g'
}

export PROMPT=$'
%F{magenta}$(whoami)%f at %F{$host_colour}$(hostname)%f in %F{green}$(pwd_with_home)%f
%F{cyan}%#%f '

alias man='LC_ALL=C LANG=C man'
alias ll='ls -alh'
alias l.='ls -d .[^.]*'

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

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
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
#
#NEW completion:
# 1. All /etc/hosts hostnames are in autocomplete
# 2. If you have a comment in /etc/hosts like #%foobar.domain,
#    then foobar.domain will show up in autocomplete!
zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}') 
# formatting and messages
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

# command for process lists, the local web server details and host completion
#zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
zstyle '*' hosts $hosts

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

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