" ---------------------------------------------------------------------------
" Portable vim config: sane defaults everywhere, a few IDE conveniences when
" plugins are present. Safe to drop into any container/VM with vim 8+.
" No plugin -> falls back cleanly. Plugin install requires git + network.
" ---------------------------------------------------------------------------

set nocompatible
set history=500

filetype plugin on
filetype indent on
syntax enable

set autoread
au FocusGained,BufEnter * silent! checktime

let mapleader=","

" Edit a file you opened without sudo, then needed it.
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" --- core behavior ----------------------------------------------------------
set scrolloff=8
set wildmenu
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/node_modules/*
set wildignorecase
set ruler
set cmdheight=1
set hidden
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set ignorecase
set smartcase
set hlsearch
set incsearch
set lazyredraw
set showmatch
set mat=2
set noerrorbells
set novisualbell
set t_vb=
set timeoutlen=500
set updatetime=300
set signcolumn=yes

set encoding=utf8
set ffs=unix,dos,mac

set nobackup
set nowritebackup
set noswapfile

set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set autoindent
set linebreak
set wrap

set number
set relativenumber

" Persistent undo, if the container gives us a writable home.
if !empty($HOME) && filewritable($HOME)
  let &undodir = expand('~/.vim/undodir')
  if !isdirectory(&undodir)
    call mkdir(&undodir, 'p', 0700)
  endif
  set undofile
endif

" True color only when the terminal actually advertises it, so this doesn't
" turn into a wall of wrong colors over a dumb SSH/tmux session.
if (has('termguicolors')) && ($COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit')
  set termguicolors
endif

try
  colorscheme habamax
catch
  colorscheme desert
endtry

" netrw as a lightweight built-in file tree, no plugin needed.
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 25
map <leader>e :Lexplore<CR>

map <silent> <leader><cr> :noh<cr>
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Quick window/split navigation.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ---------------------------------------------------------------------------
" Minimal plugin bootstrap (native vim8 packages, no plugin manager binary).
" First launch with network access clones a small set of pure-vimscript
" plugins -- no compiled deps beyond git itself -- then it's offline-safe.
" Re-run any time with :PluginInstall.
" ---------------------------------------------------------------------------
let s:pack_dir = expand('~/.vim/pack/portable/start')

let s:plugins = {
  \ 'vim-fugitive':   'https://github.com/tpope/vim-fugitive',
  \ 'vim-gitgutter':  'https://github.com/airblade/vim-gitgutter',
  \ 'vim-surround':   'https://github.com/tpope/vim-surround',
  \ 'vim-commentary': 'https://github.com/tpope/vim-commentary',
  \ 'ctrlp.vim':      'https://github.com/ctrlpvim/ctrlp.vim',
  \ 'lightline.vim':  'https://github.com/itchyny/lightline.vim',
  \ }

function! s:InstallPlugins()
  if !executable('git')
    echom 'PluginInstall: git not found, skipping.'
    return
  endif
  call mkdir(s:pack_dir, 'p')
  for [name, url] in items(s:plugins)
    let l:dest = s:pack_dir . '/' . name
    if !isdirectory(l:dest)
      echom 'Installing ' . name . '...'
      call system('git clone --depth 1 --quiet ' . shellescape(url) . ' ' . shellescape(l:dest))
    endif
  endfor
  silent! helptags ALL
  echom 'Plugin install done. Restart vim.'
endfunction
command! PluginInstall call s:InstallPlugins()

" Auto-bootstrap once, quietly, if nothing is installed yet and we're online.
if !isdirectory(s:pack_dir) && executable('git')
  call s:InstallPlugins()
endif

" --- plugin settings (all no-ops if the plugin isn't installed) ------------

" ctrlp.vim: fuzzy file/buffer finder, pure vimscript.
let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
if executable('rg')
  let g:ctrlp_user_command = 'rg --files --hidden --glob "!.git" %s'
  let g:ctrlp_use_caching = 0
endif
nnoremap <leader>b :CtrlPBuffer<CR>

" vim-gitgutter: git diff signs in the gutter.
nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)
nnoremap <leader>hp :GitGutterPreviewHunk<CR>
nnoremap <leader>hu :GitGutterUndoHunk<CR>

" vim-fugitive: git porcelain in vim.
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :Gdiffsplit<CR>

" lightline.vim: statusline. Fall back to a manual one if it's not present.
if isdirectory(s:pack_dir . '/lightline.vim')
  set noshowmode
  let g:lightline = { 'colorscheme': 'default' }
else
  set laststatus=2
  set statusline=%f\ %m%r%h%w\ [%{&ff}]\ [%Y]%=[%l,%v][%p%%]
endif
