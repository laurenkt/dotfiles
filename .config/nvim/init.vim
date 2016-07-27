" iPad has no ecape key - so use jj
imap jj <Esc>

call plug#begin()
Plug 'tpope/vim-sensible'

" Colorschemes
Plug 'captbaritone/molokai'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'altercation/vim-colors-solarized'
Plug 'fxn/vim-monochrome'
Plug 'chriskempson/base16-vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'justinmk/vim-sneak' " Thing to jump around with s<2chars>

" Ctrl-P fuzzy file matcher
Plug 'ctrlpvim/ctrlp.vim'

" Syntax highlighting
Plug 'pangloss/vim-javascript' " Better JS
Plug 'mxw/vim-jsx' " JSX extensions for React

" Change brackets and quotes
Plug 'tpope/vim-surround'
" " Make vim-surround repeatable with .
Plug 'tpope/vim-repeat'

call plug#end()

colorscheme molokai

" I like to see whitespace chars
set listchars=eol:¬,tab:→ 
set list " Visible whitespace

" Highlight current line
set cursorline

set number " Show line numbers

" Tab/spaces
set shiftwidth=4
set tabstop=4

" Use system clipboard
set clipboard=unnamed

" netrw settings (file viewer)
let g:netrw_winsize = -28 " Don't take up half the screen
let g:netrw_liststyle = 3 " Tree view
let g:netrw_browse_split=3 " Open in tabs
let g:netrw_banner=0 " Remove the banner at the top
" Hide things in netrw
" OS junk, intermediate caches, source maps..
let g:netrw_list_hide='\.git/$,\.DS_Store$,.*\.map$,\.sass-cache/$,node_modules/$'
" Invoke from hotkey (Ctrl-E)
map <c-e> :Lexplore<cr>
