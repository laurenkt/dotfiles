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

" Change brackets and quotes
Plug 'tpope/vim-surround'
" " Make vim-surround repeatable with .
Plug 'tpope/vim-repeat'

call plug#end()

colorscheme molokai

" I like to see whitespace chars
set listchars=eol:¬,tab:→ 
set list " Should find out what this actually does

" Highlight current line
set cursorline

set number " Show line numbers
