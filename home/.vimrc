set history=500

filetype plugin on
filetype indent on

set autoread
au FocusGained,BufEnter * silent! checktime

let mapleader=","

command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

set so=7
set wildmenu
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set ruler
set cmdheight=1
set hid
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set ignorecase
set smartcase
set hlsearch
set incsearch
set lazyredraw
set magic
set showmatch
set mat=2
set noerrorbells
set novisualbell
set t_vb=
set tm=500

syntax enable
set regexpengine=0
set encoding=utf8
set ffs=unix,dos,mac

set nobackup
set nowb
set noswapfile
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set lbr
set tw=500
set ai
set si
set wrap

map <silent> <leader><cr> :noh<cr>
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

