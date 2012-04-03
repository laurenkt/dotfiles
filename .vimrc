" No Compatibility. That just sucks
" especially annoying on redhat/windows/osx
set nocompatible
set backspace=indent,eol,start

set lines=35
set columns=120

" Menus I like :-)
" ----------------
" This must happen before the syntax system is enabled
aunmenu Help.
aunmenu Window.
let no_buffers_menu=1
set mousemodel=popup

" Show whitespace
set listchars=eol:¬,tab:→ 
set list

" Support for yankring
set viminfo+=!

" User Interface
" --------------
" activate wildmenu, permanent ruler and disable Toolbar, and add line
" highlightng as well as numbers.
" And disable the sucking pydoc preview window for the omni completion
" also highlight current line and disable the blinking cursor.
set cursorline
set wildmenu
set ruler
set guioptions-=T
set completeopt-=preview
set gcr=a:blinkon0

" Enable Syntax Colors
" --------------------
"  in GUI mode we go with fruity and Monaco 12
"  in CLI mode desert looks better (fruity is GUI only)
syntax on
if has("gui_running")
  colorscheme fruity
  set guifont=Monaco:h12
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

" Some File Type Stuff
" --------------------
"  Enable filetype plugins and indention
filetype on
filetype plugin on

" File Templates
" --------------
"  ^J jumps to the next marker
function! LoadFileTemplate()
  silent! 0r ~/.vim/templates/%:e.tmpl
  syn match vimTemplateMarker "<+.\++>" containedin=ALL
  hi vimTemplateMarker guifg=#67a42c guibg=#112300 gui=bold
endfunction
function! JumpToNextPlaceholder()
  let old_query = getreg('/')
  echo search("<+.\\++>")
  exec "norm! c/+>/e\<CR>"
  call setreg('/', old_query)
endfunction
autocmd BufNewFile * :call LoadFileTemplate()
nnoremap <C-J> :call JumpToNextPlaceholder()<CR>a
inoremap <C-J> <ESC>:call JumpToNextPlaceholder()<CR>a

" Leader
" ------
" sets leader to ',' and localleader to "\"
let mapleader=","
let maplocalleader="\\"

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

" Tab page settings
" -----------------
function! GuiTabLabel()
  let label = ''
  let buflist = tabpagebuflist(v:lnum)
  if exists('t:title')
    let label .= t:title . ' '
  endif
  let label .= '[' . bufname(buflist[tabpagewinnr(v:lnum) - 1]) . ']'
  for bufnr in buflist
    if getbufvar(bufnr, '&modified')
      let label .= '+'
      break
    endif
  endfor
  return label
endfunction
set guitablabel=%{GuiTabLabel()}

" utf-8 default encoding
" ----------------------
set enc=utf-8

" Javascript
" ----------
let javascript_enable_domhtmlcss=1

" Better Search
" -------------
set hlsearch
set incsearch

" Minibuffer
" ----------
"  one click is enough and fix some funny bugs
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapCTabSwitchBufs = 1
