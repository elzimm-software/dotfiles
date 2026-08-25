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

" ---------------------------------------------------------------------------
" horizon-term: generated from ~/.config/alacritty/alacritty.toml so vim
" matches the terminal. Written out once to ~/.vim/colors/ -- no network,
" no plugin, just a file this vimrc carries the content for. cterm= values
" are 256-color approximations for terminals without truecolor.
" ---------------------------------------------------------------------------
let s:colors_file = expand('~/.vim/colors/horizon-term.vim')

function! s:InstallColorscheme()
  call mkdir(fnamemodify(s:colors_file, ':h'), 'p')
  let l:lines = [
    \ '" Generated from ~/.config/alacritty/alacritty.toml (Horizon Dark). Do not edit by hand.',
    \ 'hi clear',
    \ 'if exists("syntax_on") | syntax reset | endif',
    \ 'let g:colors_name = "horizon-term"',
    \ 'set background=dark',
    \ '',
    \ 'hi Normal        guifg=#e0e0e0 guibg=#1c1e26 ctermfg=254 ctermbg=234',
    \ 'hi Comment       guifg=#5b5858 ctermfg=240 gui=italic cterm=italic',
    \ 'hi Constant      guifg=#fab795 ctermfg=216',
    \ 'hi String        guifg=#fab795 ctermfg=216',
    \ 'hi Character     guifg=#fab795 ctermfg=216',
    \ 'hi Number        guifg=#ee64ac ctermfg=205',
    \ 'hi Boolean       guifg=#ee64ac ctermfg=205',
    \ 'hi Float         guifg=#ee64ac ctermfg=205',
    \ 'hi Identifier    guifg=#26bbd9 ctermfg=38',
    \ 'hi Function      guifg=#29d398 ctermfg=42 gui=bold cterm=bold',
    \ 'hi Statement     guifg=#e95678 ctermfg=204 gui=bold cterm=bold',
    \ 'hi Conditional   guifg=#e95678 ctermfg=204',
    \ 'hi Repeat        guifg=#e95678 ctermfg=204',
    \ 'hi Label         guifg=#e95678 ctermfg=204',
    \ 'hi Operator      guifg=#e95678 ctermfg=204',
    \ 'hi Keyword       guifg=#e95678 ctermfg=204',
    \ 'hi Exception     guifg=#e95678 ctermfg=204',
    \ 'hi PreProc       guifg=#ee64ac ctermfg=205',
    \ 'hi Include       guifg=#ee64ac ctermfg=205',
    \ 'hi Define        guifg=#ee64ac ctermfg=205',
    \ 'hi Macro         guifg=#ee64ac ctermfg=205',
    \ 'hi PreCondit     guifg=#ee64ac ctermfg=205',
    \ 'hi Type          guifg=#3fc4de ctermfg=45 gui=bold cterm=bold',
    \ 'hi StorageClass  guifg=#3fc4de ctermfg=45',
    \ 'hi Structure     guifg=#3fc4de ctermfg=45',
    \ 'hi Typedef       guifg=#3fc4de ctermfg=45',
    \ 'hi Special       guifg=#59e1e3 ctermfg=87',
    \ 'hi SpecialChar   guifg=#59e1e3 ctermfg=87',
    \ 'hi Tag           guifg=#59e1e3 ctermfg=87',
    \ 'hi Delimiter     guifg=#59e1e3 ctermfg=87',
    \ 'hi SpecialComment guifg=#59e1e3 ctermfg=87',
    \ 'hi Debug         guifg=#59e1e3 ctermfg=87',
    \ 'hi Underlined    guifg=#26bbd9 ctermfg=38 gui=underline cterm=underline',
    \ 'hi Error         guifg=#e0e0e0 guibg=#e95678 ctermfg=254 ctermbg=204',
    \ 'hi Todo          guifg=#1c1e26 guibg=#fab795 ctermfg=234 ctermbg=216 gui=bold cterm=bold',
    \ '',
    \ 'hi LineNr        guifg=#5b5858 guibg=#1c1e26 ctermfg=240 ctermbg=234',
    \ 'hi CursorLineNr  guifg=#fab795 guibg=#232530 ctermfg=216 ctermbg=235 gui=bold cterm=bold',
    \ 'hi CursorLine    guibg=#232530 ctermbg=235 cterm=NONE',
    \ 'hi ColorColumn   guibg=#232530 ctermbg=235',
    \ 'hi Cursor        guifg=#1c1e26 guibg=#e0e0e0 ctermfg=234 ctermbg=254',
    \ 'hi Visual        guibg=#2e313f ctermbg=236',
    \ 'hi Search        guifg=#1c1e26 guibg=#fab795 ctermfg=234 ctermbg=216',
    \ 'hi IncSearch     guifg=#1c1e26 guibg=#e95678 ctermfg=234 ctermbg=204',
    \ 'hi MatchParen    guibg=#2e313f ctermbg=236 gui=bold cterm=bold',
    \ '',
    \ 'hi Pmenu         guifg=#e0e0e0 guibg=#232530 ctermfg=254 ctermbg=235',
    \ 'hi PmenuSel      guifg=#1c1e26 guibg=#26bbd9 ctermfg=234 ctermbg=38',
    \ 'hi StatusLine    guifg=#e0e0e0 guibg=#232530 ctermfg=254 ctermbg=235',
    \ 'hi StatusLineNC  guifg=#5b5858 guibg=#1c1e26 ctermfg=240 ctermbg=234',
    \ 'hi VertSplit     guifg=#232530 guibg=#1c1e26 ctermfg=235 ctermbg=234',
    \ 'hi TabLine       guifg=#5b5858 guibg=#232530 ctermfg=240 ctermbg=235',
    \ 'hi TabLineFill   guibg=#1c1e26 ctermbg=234',
    \ 'hi TabLineSel    guifg=#e0e0e0 guibg=#1c1e26 ctermfg=254 ctermbg=234 gui=bold cterm=bold',
    \ 'hi SignColumn    guibg=#1c1e26 ctermbg=234',
    \ 'hi Folded        guifg=#5b5858 guibg=#232530 ctermfg=240 ctermbg=235',
    \ 'hi FoldColumn    guifg=#5b5858 guibg=#1c1e26 ctermfg=240 ctermbg=234',
    \ 'hi NonText       guifg=#5b5858 ctermfg=240',
    \ 'hi EndOfBuffer   guifg=#1c1e26 ctermfg=234',
    \ 'hi Directory     guifg=#26bbd9 ctermfg=38',
    \ 'hi WildMenu      guifg=#1c1e26 guibg=#fab795 ctermfg=234 ctermbg=216',
    \ '',
    \ 'hi DiffAdd       guifg=#29d398 guibg=#1c2e26 ctermfg=42 ctermbg=22',
    \ 'hi DiffChange    guifg=#fab795 guibg=#1c2a2e ctermfg=216 ctermbg=58',
    \ 'hi DiffDelete    guifg=#e95678 guibg=#2e1c22 ctermfg=204 ctermbg=52',
    \ 'hi DiffText      guifg=#ee64ac guibg=#2e1c22 ctermfg=205 ctermbg=53 gui=bold cterm=bold',
    \ '',
    \ 'hi GitGutterAdd          guifg=#29d398 ctermfg=42',
    \ 'hi GitGutterChange       guifg=#fab795 ctermfg=216',
    \ 'hi GitGutterDelete       guifg=#e95678 ctermfg=204',
    \ 'hi GitGutterChangeDelete guifg=#ee64ac ctermfg=205',
    \ ]
  call writefile(l:lines, s:colors_file)
endfunction

if !filereadable(s:colors_file)
  call s:InstallColorscheme()
endif

try
  colorscheme horizon-term
catch
  try
    colorscheme habamax
  catch
    colorscheme desert
  endtry
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
  let g:lightline = { 'colorscheme': 'wombat' }
else
  set laststatus=2
  set statusline=%f\ %m%r%h%w\ [%{&ff}]\ [%Y]%=[%l,%v][%p%%]
endif

" ---------------------------------------------------------------------------
" ,hh : cheatsheet for this config, since it's meant to get dropped into
" unfamiliar containers where you won't remember the bindings.
" ---------------------------------------------------------------------------
function! s:Installed(name)
  return isdirectory(s:pack_dir . '/' . a:name) ? '' : '  [not installed]'
endfunction

function! s:ShowHelp()
  let l:lines = [
    \ 'Portable vim cheatsheet   (leader = ,)',
    \ '',
    \ 'Core',
    \ '  ,<CR>          clear search highlight',
    \ '  ,e             toggle netrw file tree',
    \ '  Ctrl-h/j/k/l   move between splits',
    \ '  :W             write with sudo (file opened without perms)',
    \ '',
    \ 'Fuzzy find / buffers' . s:Installed('ctrlp.vim'),
    \ '  Ctrl-p         fuzzy find files',
    \ '  ,b             fuzzy find buffers',
    \ '',
    \ 'Git (vim-fugitive)' . s:Installed('vim-fugitive'),
    \ '  ,gs            :Git status',
    \ '  ,gb            :Git blame',
    \ '  ,gd            :Gdiffsplit',
    \ '',
    \ 'Git hunks (vim-gitgutter)' . s:Installed('vim-gitgutter'),
    \ '  ]c / [c        next / prev hunk',
    \ '  ,hp            preview hunk',
    \ '  ,hu            undo hunk',
    \ '',
    \ 'Editing (vim-surround / vim-commentary)' . s:Installed('vim-surround'),
    \ '  cs"''           change surrounding " to '' ',
    \ '  ds"            delete surrounding "',
    \ '  ysiw)          surround word with ()',
    \ '  gcc            comment/uncomment line',
    \ '  gc             comment/uncomment selection (visual)',
    \ '',
    \ 'Plugins',
    \ '  :PluginInstall re-run bootstrap for anything missing',
    \ '',
    \ 'Press q to close.',
    \ ]
  botright new
  resize 18
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  setlocal nonumber norelativenumber signcolumn=no statusline=cheatsheet
  call setline(1, l:lines)
  setlocal nomodifiable
  nnoremap <buffer> <silent> q :bwipeout<CR>
  nnoremap <buffer> <silent> <Esc> :bwipeout<CR>
endfunction
command! Help call s:ShowHelp()
nnoremap <silent> <leader>hh :call <SID>ShowHelp()<CR>
