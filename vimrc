execute pathogen#infect()

syntax enable
set background=dark
set nowrap
set tabstop=2
set autoindent
set expandtab
set softtabstop=2
set copyindent
set number
set shiftwidth=2
set showmatch
set shiftround
set smartcase
set smarttab
set hlsearch
set incsearch
set history=1000
set undolevels=1000
set wildignore=*.swp,*.bak,*.pyc
set visualbell

map <C-t> :NERDTreeToggle<CR>
nnoremap <silent> <F9> :TagbarToggle<CR>

filetype plugin indent on

if has('autocmd')
  autocmd filetype python set expandtab
endif

