set nocompatible           " Not compatible with vi

set history=1000
set undolevels=1000

""" Editor
set number                 " Enable line numbers
set nowrap                 " Require horizontal scroll for long lines
set visualbell
syntax enable              " Enable syntax highlighting

if has('nvim') || has('termguicolors')
  set t_Co=256
endif

colorscheme minimalist

""" Text formatting
set expandtab              " Use spaces instead of TAB
set tabstop=2              " Size of tabs, measured in spaces
set shiftwidth=2           " Size of single indent, measured in spaces
set expandtab              " Make tab key insert spaces instead of tab
set smarttab               " Auto-indent when adding a new line

if has("autocmd")
  filetype plugin indent on  " Configure auto-indent for detected filetype
  autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
endif

""" File encoding
set nobomb
set encoding=utf-8
setglobal fileencoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8
set ffs=unix,dos

""" Plugins
let NERDTreeChDirMode = 0
let NERDTreeShowBookmarks = 1
let NERDChristmasTree = 1
let NERDTreeDirArrows = 0
let g:airline_theme='minimalist'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

""" Key mapping
nnoremap <silent> <F8> :NERDTreeToggle<CR>
nnoremap th :tabfirst<CR>
nnoremap tj :tabnext<CR>
nnoremap tk :tabprevious<CR>
nnoremap tl :tablast<CR>
nnoremap tt :tabnew<Space>
nnoremap te :tabedit<Space>
nnoremap td :tabclose<CR>

""" Other
set wildignore=*.swp,*.bak,*.pyc  " Ignore temp files

