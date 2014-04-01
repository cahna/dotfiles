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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" Tab rules and auto-tabbing
" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2
set si "Smart indent
set autoindent
set softtabstop=2
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

" Ignore case when searching
set ignorecase
set smartcase

" Watch for file changes
set autoread

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Custom status line
set modeline
set laststatus=2
set wildmenu

" I like my files like I like my terminal, in utf-8
set encoding=utf-8
setglobal fileencoding=utf-8
set nobomb
set termencoding=utf-8
set fileencodings=utf-8,iso-8559-15
" Use Unix as the standard file type
set ffs=unix,dos,mac

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

nmap <C-up> [e
nmap <C-down> ]e
vmap <C-up> [egv
vmap <C-down> ]egv

let g:airline#extensions#tabline#enabled = 1
let NERDTreeChDirMode = 0
let NERDTreeShowBookmarks = 1
let NERDChristmasTree = 1
let NERDTreeDirArrows = 0

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Favorite Color Scheme
if has("gui_running")
  colorscheme nucolors
  set guioptions-=T " Remove toolbar
else
  colorscheme blazer
endif

if has('autocmd')
  filetype plugin indent on
  " Force tab rules for python sources
  autocmd filetype python set expandtab
endif

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()
autocmd BufWrite *.moon :call DeleteTrailingWS()

" Remember info about open buffers on close
set viminfo^=%

"set listchars=tab:>\ ,eol:<
"set list
"nmap <silent> <F5> :set list!<CR>

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

let g:airline_powerline_fonts = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction
