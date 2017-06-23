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
	Plug 'pangloss/vim-javascript'   " Better JS
	Plug 'mxw/vim-jsx'               " JSX extensions for React
	" Plug 'othree/yajs.vim'         " JS with flow
	Plug 'othree/html5.vim'          " HTML 5
	Plug 'hail2u/vim-css3-syntax'    " CSS3
	Plug 'cakebaker/scss-syntax.vim' " SCSS
	" Flow
	Plug 'flowtype/vim-flow'
	" Change brackets and quotes
	Plug 'tpope/vim-surround'
	" Make vim-surround repeatable with .
	Plug 'tpope/vim-repeat'
	" Show git diff stuff in the gutter
	Plug 'mhinz/vim-signify'
	" Dash integration
	Plug 'rizzatti/dash.vim'
	" Syntax checking integrations
	Plug 'neomake/neomake'
	" Aligning text on seperators
	" Use :Tab /regex to align to the regex
	Plug 'godlygeek/tabular'
	" Auto-completion for quotes parens etc
	Plug 'Raimondi/delimitMate'
	" Code completion
	Plug 'Valloric/YouCompleteMe'
call plug#end()

" Mouse please
set mouse=a

" Neomake on write
autocmd! BufWritePost * Neomake

" Set active scheme
colorscheme monokai

" Make Vim use bash (for compatibility with some plugins)
set shell=/bin/bash

" Tabs preferences..
" This would enable Ctrl+[/] to switch tabs but since I have switched to using
" Neovim.app there's no need for this
" map <c-[> gT
" map <c-]> gt

" I like to see whitespace chars
set listchars=trail:◊,eol:¬,tab:→ 
set list " Visible whitespace

" Highlight current line
set cursorline

" Show line numbers
set number

" Tab/spaces
set shiftwidth=4
set tabstop=4

" Make JSX work on .js files, flow types, jsdoc
let g:jsx_ext_required = 0
let g:javascript_plugin_flow = 1
let g:javascript_plugin_jsdoc = 1

" netrw settings (file viewer)
let g:netrw_winsize = -28  " Don't take up half the screen
let g:netrw_liststyle = 3  " Tree view
let g:netrw_browse_split=3 " Open in tabs
let g:netrw_banner=0       " Remove the banner at the top
map <c-e> :Lexplore<cr>    " Invoke with Ctrl-E

" Hide things in netrw and ctrl-P
" OS junk, intermediate caches, source maps..
set wildignore+=*/.git/,.DS_Store,*.map,*/.sass-cache/*,*/node_modules/*,*/.nyc_output/*,*/.Trash/*
let g:netrw_list_hide='\.git/$,\.DS_Store$,.*\.map$,\.sass-cache/$,node_modules/$'

" Ctrl-P settings
" Open in new tab by default (changes pressing enter into pressing ctrl-t in
" ctrp window)
let g:ctrlp_prompt_mappings = {
			\ 'AcceptSelection("e")': ['<c-t>'],
			\ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
			\ }
" Disable caching (it was annoying when a file was added)
" Need to give a lower max so it's not annoying
let g:ctrlp_use_caching = 0
let g:ctrlp_max_files = 500
" Allow dotfiles (otherwise .babelrc etc are hidden)
let g:ctrlp_show_hidden = 1

" Airline
"let g:airline_powerline_fonts=0
"let g:airline_left_sep=''
"let g:airline_right_sep=''
" We don't need the default status indicator because we are using airline
set noshowmode

" Dash
" <silent> Stops the command being shown in the command bar, <leader> means \
" Map \d to look-up in Dash
nmap <silent> <leader>d <Plug>DashSearch

" eslint please
let g:neomake_javascript_enabled_makers=['eslint_d']
let g:neomake_json_enabled_makers=['jsonlint']
