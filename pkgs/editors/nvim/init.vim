set undofile
set noshowmode
set undolevels=1000
set number relativenumber
set expandtab tabstop=2 shiftwidth=2
set cursorline
set termguicolors
set colorcolumn=80 " Ruler
set nofoldenable
set showcmd
set ignorecase smartcase
set textwidth=80
set sessionoptions+=globals
set hidden
set guifont=JetBrains\ Mono:h11
set wildignorecase
set linebreak
set autoindent
set smartindent
set splitright
set scrolloff=5
set lazyredraw
set noswapfile
set nomodeline
set autoread
set completeopt=menuone,noselect
set pumheight=10 " Max number of items in autocompletion popup
set pumwidth=25
set updatetime=400
" Some plugin is removing `-` from the separators, for now lets just get it back.
set iskeyword-=-
" Don't auto line break when inserting text
set formatoptions-=t
set shortmess+=cI
" set listchars=extends:›,precedes:‹,nbsp:·,trail:·,eol:¬
" set list

noremap Y "+y
noremap H ^
noremap L $
nnoremap Q @@
nnoremap <C-p> <C-^>

nnoremap j gj
nnoremap k gk

nnoremap <C-q> <C-w>q
" nnoremap <C-s> <cmd>update<cr>

" -- Quickfix/Location lists --
command Cnext try | cnext | catch | cfirst | catch | endtry
command Cprev try | cprev | catch | clast  | catch | endtry
command Lnext try | lnext | catch | lfirst | catch | endtry
command Lprev try | lprev | catch | llast  | catch | endtry

nnoremap [q <cmd>Cprev<cr>
nnoremap ]q <cmd>Cnext<cr>
nnoremap [Q <cmd>cfirst<cr>
nnoremap ]Q <cmd>clast<cr>

nnoremap [w <cmd>Lprev<cr>
nnoremap ]w <cmd>Lnext<cr>
nnoremap [W <cmd>lfirst<cr>
nnoremap ]W <cmd>llast<cr>

" Tabs
nnoremap <leader>to :tabnew<space>
nnoremap <leader>tq :tabclose<cr>
nnoremap <silent>g< :tabmove tabpagenr() - 2<cr>
nnoremap <silent>g> :tabmove tabpagenr() + 1<cr>

" Buffers
nnoremap <leader>bd <cmd>bd<cr>

nnoremap <silent> <leader>vQ <cmd>quitall!<cr>
nnoremap <silent> <leader>vq <cmd>quitall<cr>
nnoremap <silent> <leader>vr <cmd>source $MYVIMRC<cr>

nnoremap <C-s> :w<cr>

" Allow the . to execute once for each line of a visual selection
vnoremap . :normal .<cr>

augroup my_autocommands
  " Remove trailing whitespaces on write
  " au BufWritePre * %s/\s\+$//e
  " Open help windows vertically splitted
  au FileType help wincmd L
  " Highlight on yank (nvim only)
  au TextYankPost * silent! lua vim.highlight.on_yank{higroup="HighlightedYankRegion", timeout=50}

  " Handle nix files
  au BufEnter *.nix set ft=nix
  autocmd FileType nix,elixir setlocal commentstring=#\ %s

  au BufEnter *.fs,*.fsi set ft=fsharp
  autocmd FileType fsharp setlocal commentstring=//\ %s
augroup end

augroup numbertoggle
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup end
