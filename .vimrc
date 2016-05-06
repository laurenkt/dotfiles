" No Compatibility. That just sucks
" especially annoying on redhat/windows/osx
set nocompatible
set backspace=indent,eol,start

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'


Bundle 'bbchung/clighter'
let g:clighter_libclang_file = '/Library/Developer/CommandLineTools/usr/lib/libclang.dylib' "`xcode-select -p`/usr/lib/libclang.dylib

set lines=35
set columns=120

" Show whitespace
set listchars=eol:¬,tab:→ 
set list

" User Interface
" --------------
" activate wildmenu, permanent ruler and disable Toolbar, and add line
" highlightng as well as numbers.
" And disable the sucking pydoc preview window for the omni completion
" also highlight current line and disable the blinking cursor.
set cursorline
set wildmenu
set ruler
set completeopt-=preview
set gcr=a:blinkon0

" Enable Syntax Colors
" --------------------
"  in GUI mode we go with fruity and Monaco 12
"  in CLI mode desert looks better (fruity is GUI only)
syntax on
if has("gui_running")
  colorscheme fruity
  set guifont=Inconsolata-g:h12
else
  set nolist
  set nocursorline
endif

" Do syntax highlight syncing from start
autocmd BufEnter * :syntax sync fromstart

" Move Backup Files to ~/.vim/sessions
" ------------------------------------
set backupdir=~/.vim/sessions
set dir=~/.vim/sessions

" Don't outdent hashes
inoremap # #

" Statusbar and Linenumbers
" -------------------------
"  Make the command line two lines heigh and change the statusline display to
"  something that looks useful.
set cmdheight=2
set laststatus=2
set statusline=[%l,%c\ %P%M]\ %f\ %r%h%w
set number

" Tab Settings
" ------------
set autoindent
set smarttab
set tabstop=4
set shiftwidth=4
set noexpandtab

" utf-8 default encoding
" ----------------------
set enc=utf-8

" Better Search
" -------------
set hlsearch
set incsearch

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
