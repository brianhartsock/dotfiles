"NeoBundle Scripts-----------------------------
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Custom Bundles-------------------------------
NeoBundle 'vim-scripts/vim-soy'
NeoBundle 'markcornick/vim-vagrant'
NeoBundle 'fatih/vim-go'
NeoBundle 'andreimaxim/vim-io'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'vim-scripts/scons.vim'
NeoBundle 'digitaltoad/vim-jade'
NeoBundle 'chase/vim-ansible-yaml'
NeoBundle 'editorconfig/editorconfig-vim'
NeoBundle 'ervandew/supertab'
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'vim-perl/vim-perl'
NeoBundle 'scrooloose/syntastic'

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

" Necasary for lots of cool vim things
set nocompatible

" This shows what you are typing as a command
set showcmd

" set tabstop=2
set ai
set guifont=Courier:h10
set ruler
set showmatch

" Syntax highlighting
syntax enable
syntax on
filetype on
filetype plugin on

" Indentation
set autoindent

" Spaces instead of tabs
set expandtab
set smarttab

" Tab length
set shiftwidth=2
set softtabstop=2

" Folding
set foldmethod=marker "i.e. {{{
" Yay!
"}}}

" Use english for spellchecking if it is supported
if version >= 700
  set spl=en spell
  set nospell
endif

" set the PWD to match the current file
" has issues on the mac...
" set autochdir

" make backspace work like most other apps
set backspace=2 

"TODO - Do i still need this?
"ruby
"autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
"autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
"autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
"autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

"python
autocmd FileType python set shiftwidth=4
autocmd FileType python set softtabstop=4

"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

set pastetoggle=<F2>

"Show tabs and trailing whitespace as characters
set list!
set listchars=tab:>-,trail:~,extends:>,precedes:<

" * Search & Replace

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" highlight searches
set hlsearch

" make search work better
set incsearch

" assume the /g flag on :s substitutions to replace all matches in a line:
set gdefault

" Line numbers
set number

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme jellybeans
set background=dark

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic Syntax Highlighting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

let &colorcolumn=join(range(81,999),",")
