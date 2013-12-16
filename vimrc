" Break free from old vi compatibility
set nocompatible

" Plugins :)
execute pathogen#infect()

" Window styling
if has('syntax')
  syntax on
endif
set background=dark
set nowrap
set visualbell

" Tab rules and auto-tabbing
set tabstop=2
set autoindent
set expandtab
set softtabstop=2
set smarttab
set shiftwidth=2
set copyindent

" Line numbers
set number
set showmatch
set shiftround

" Highlight things found in search
set hlsearch
set incsearch
set history=1000
set undolevels=1000

" Ignore temp files
set wildignore=*.swp,*.bak,*.pyc

" Ignore case, and some AI
set ignorecase
set smartcase

" Watch for file changes
set autoread

" Custom status line
set modeline
set laststatus=2
set statusline=%F%m%r%h%w\ [\%03.3b]\ [\%02.2B]\ [%04l,%04v][%p%%]\ [%L]
set wildmenu

" I like my files like I like my terminal, in utf-8
set encoding=utf-8
setglobal fileencoding=utf-8
set nobomb
set termencoding=utf-8
set fileencodings=utf-8,iso-8559-15

" Mappings
nmap w <C-W>
nore ; :
nore , ;
nnoremap <silent> <F8> :NERDTreeToggle<CR>
nnoremap <silent> <F9> :TagbarToggle<CR>
nnoremap th :tabfirst<CR>
nnoremap tj :tabnext<CR>
nnoremap tk :tabprevious<CR>
nnoremap tl :tablast<CR>
nnoremap tt :tabnew<Space>
nnoremap te :tabedit<Space>
nnoremap td :tabclose<CR>

" Favorite Color Scheme
if has("gui_running")
  colorscheme inkpot
  " Remove Toolbar
  set guioptions-=T
  "Terminus is AWESOME
  set guifont=Terminus\ 9
else
"  colorscheme lazarus
"  colorscheme delphi
"  colorscheme candyman  " Dark gray, solid bg, pastel neon
"  colorscheme bvemu  " Like candyman, but darker
  colorscheme blazer
endif

if has('autocmd')
  filetype plugin indent on
  " Force tab rules for python sources
  autocmd filetype python set expandtab
endif

