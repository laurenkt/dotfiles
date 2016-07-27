" iPad has no ecape key - so use jj
imap jj <Esc>

" Plug plugins
call plug#begin()
	" Defaults everyone can agree with
	Plug 'tpope/vim-sensible'
	" Colorscheme
	Plug 'Comaleaf/vim-monokai'
	Plug 'justinmk/vim-sneak' " Thing to jump around with s<2chars>
	" Airline (lightweight powerline)
	Plug 'vim-airline/vim-airline'
	" Handlebars support
	Plug 'mustache/vim-mustache-handlebars'
	" Ctrl-P fuzzy file matcher
	Plug 'ctrlpvim/ctrlp.vim'
	" Git
	Plug 'tpope/vim-fugitive'
	" Syntax highlighting
	Plug 'pangloss/vim-javascript' " Better JS
	Plug 'mxw/vim-jsx'             " JSX extensions for React
	" Change brackets and quotes
	Plug 'tpope/vim-surround'
	" Make vim-surround repeatable with .
	Plug 'tpope/vim-repeat'
call plug#end()

" Set active scheme
colorscheme monokai

" Tabs preferences..
" This would enable Ctrl+[/] to switch tabs but since I have switched to using
" Neovim.app there's no need for this
" map <c-[> gT
" map <c-]> gt

" I like to see whitespace chars
set listchars=eol:¬,tab:→ 
set list " Visible whitespace

" Highlight current line
set cursorline

" Show line numbers
set number

" Tab/spaces
set shiftwidth=4
set tabstop=4

" Use system clipboard
set clipboard=unnamed

" netrw settings (file viewer)
let g:netrw_winsize = -28  " Don't take up half the screen
let g:netrw_liststyle = 3  " Tree view
let g:netrw_browse_split=3 " Open in tabs
let g:netrw_banner=0       " Remove the banner at the top
map <c-e> :Lexplore<cr>    " Invoke with Ctrl-E

" Hide things in netrw and ctrl-P
" OS junk, intermediate caches, source maps..
set wildignore+=*/.git/,.DS_Store,*.map,*/.sass-cache/*,*/node_modules/*
let g:netrw_list_hide='\.git/$,\.DS_Store$,.*\.map$,\.sass-cache/$,node_modules/$'

" Ctrl-P settings
" Open in new tab by default (changes pressing enter into pressing ctrl-t in
" ctrp window)
let g:ctrlp_prompt_mappings = {
			\ 'AcceptSelection("e")': ['<c-t>'],
			\ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
			\ }

" Airline
let g:airline_powerline_fonts=1
" We don't need the default status indicator because we are using airline
set noshowmode
