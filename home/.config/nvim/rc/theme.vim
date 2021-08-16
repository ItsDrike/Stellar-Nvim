" General colorscheme settings
syntax on                   " Turn syntax highlighting on
colorscheme codedark        " Requires vim-code-dark plugin

set cursorline              " Highlight cursor line
set laststatus=2            " Always show status line
set number relativenumber   " Show relative line numbers
set showmatch               " Show matching brackets
set scrolloff=5             " Keep 5 lines horizonal scrolloff
set sidescrolloff=5         " Keep 5 characters vertical scrolloff

set guioptions-=m           " Remove menubar
set guioptions-=T           " Remove toolbar
set guioptions-=r           " Remove right-hand scrollbar
set guioptions-=L           " Remove left-hand scrollbar

" Use more noticable cursor line color
highlight CursorLine guibg=#2b2b2b

" Don't use true colors in TTY
if empty($DISPLAY)
    set notermguicolors
else
    set termguicolors
endif
