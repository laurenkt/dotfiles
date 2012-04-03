setopt APPEND_HISTORY
setopt AUTO_CD
setopt AUTO_RESUME
setopt AUTO_PUSHD
setopt CDABLE_VARS
setopt CORRECT
setopt CORRECT_ALL
setopt EXTENDED_HISTORY
setopt EXTENDED_GLOB
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt LONG_LIST_JOBS
setopt MENU_COMPLETE
setopt NOTIFY
setopt PROMPT_SUBST
setopt PUSHD_SILENT
setopt RC_QUOTES
setopt REC_EXACT
setopt SHARE_HISTORY

unsetopt AUTO_PARAM_SLASH
unsetopt BEEP
unsetopt BG_NICE
unsetopt CLOBBER

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

setopt ALL_EXPORT

EDITOR="vim"
PATH=":/usr/local/bin:/usr/local/sbin/:~/bin:~/.gem/ruby/1.8/bin:$PATH"
TZ="Europe/London"
HISTFILE=$HOME/.zhistory
HISTSIZE=1000
SAVEHIST=1000
HOSTNAME="`hostname`"
PAGER='less'
NODE_PATH='/usr/local/lib/node_modules'

# Colours
autoload colors zsh/terminfo && colors

for color in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PX_$color='$fg[${(L)color}]'
done

PX_NO_COLOR="$terminfo[sgr0]"

LC_ALL='en_GB.UTF-8'
LANG='en_GB.UTF-8'
LC_CTYPE=C
DISPLAY=:0

unsetopt ALL_EXPORT

# Some parts of this are specific to OS X, or specific to Linux
if [[ `uname` == "Darwin" ]]; then
	# Only do this part on OS X
	
	# Highlight the location in the prompt a particular colour depending on platform
	host_colour=$PX_YELLOW
	
	# the 'cdf' command will cd to the current open Finder directory, needs OpenTerminal installed
	alias cdf='eval `osascript /Applications/Utilities/OpenTerminal.app/Contents/Resources/Scripts/OpenTerminal.scpt`'

	# set macvim as the editor
	export EDITOR='mvim -f -c "au VimLeave * !open -a Terminal"'

	# set ls for colorized; label dirs, exes, etc.; one entry per line
	alias ls='pwd;ls -F1G '

	# This loads RVM into a shell session.
	[[ -s "~/.rvm/scripts/rvm" ]] && source "~/.rvm/scripts/rvm"  
else
	# Only do this part elsewhere (Linux, assumed)
	
	# Show running processes on a different tty, that aren't sh or the current shell
	ps -Nft - -t `tty` -C `basename $SHELL` -C sh 2> /dev/null | grep "^$(whoami)"
	
	# Highlight the location in the prompt a particular colour depending on platform
	host_colour=$PX_CYAN

	# set ls for colorized; label dirs, exes, etc.; one entry per line
	alias ls='pwd;ls -F1 --color=auto '
fi 

user_colour=$PX_MAGENTA
dir_colour=$PX_GREEN
no_colour=$PX_NO_COLOR
vimode_colour='[1;30m'

function pwd_with_home() {
	pwd | sed `printf 's?%q?~?' $HOME` | sed 's/\\/\\\\/g'
}

# Called before prompt is printed
# Put our actual prompt here because multi-line prompts seem to malfunction with reset-prompt widget
function precmd() {
	print -rn -- $terminfo[el]	# needed to clear vi-mode from previous prompt
	echo
	echo "$user_colour$(whoami)$no_colour at $host_colour$(hostname)$no_colour in $dir_colour$(pwd_with_home)$no_colour"
}

function preexec () {
	print -rn -- $terminfo[el]	# needed to clear vi-mode while command executes
}

# Goes down, then up (to insert a bottom-line if at bottom of terminal), saves position, then goes down
line_under_prompt=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
function zle-line-init zle-keymap-select {
	VIMODE="%{$line_under_prompt$vimode_colour${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}$terminfo[rc]$no_colour%}"
	zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Because part of the prompt is written in precmd, not all in PS1, we need to make the clear key redraw this part too
function clear-screen-with-prompt {
	clear
	precmd
	zle reset-prompt
}

zle -N clear-screen-with-prompt

expand-or-complete-with-dots() {
	echo -n "\e[1;30m...\e[0m" # put the "waiting" dots
	zle expand-or-complete   # do the completion
	zle redisplay            # remove the dots
}

zle -N expand-or-complete-with-dots

export PS1='$VIMODE%# '

alias man='LC_ALL=C LANG=C man'
alias ll='ls -alh'
alias l.='ls -d .[^.]*'

autoload -U compinit && compinit

bindkey '	' expand-or-complete-with-dots
bindkey '^L' clear-screen-with-prompt
bindkey '^R' history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space

# Removes line, giving prompt for next command, then puts line back afterwards
bindkey -M vicmd "q" push-line
bindkey -M vicmd "gg" beginning-of-history
bindkey -M vicmd "G" end-of-history
bindkey -M vicmd "k" history-search-backward
bindkey -M vicmd "j" history-search-forward
bindkey -M vicmd "?" history-incremental-search-backward
bindkey -M vicmd "/" history-incremental-search-forward

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

[[ -s "~/.zsh/highlighting.zsh" ]] && source ~/.zsh/highlighting.zsh
