" colors
syntax enable 

" tabs and spaces
set expandtab   " tabs are spaces
set tabstop=4   " number of visual spaces per TAB
set autoindent  " auto indent on enter

" ui
set relativenumber number   " show relative line number and line number
set showcmd                 " show command in bottom bar
set wildmenu                " visual autocomplete for command menu
set lazyredraw              " redraw only when needed to
set showmatch               " highlight matching () [] {}
set ruler                   " file stats
set laststatus=2

" backup
set nobackup
set nowb
set noswapfile

" split
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" searching
set incsearch " search as we type
set hlsearch  " highlight matches

" folding 
set foldenable 

