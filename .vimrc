" Use the system clipboard
set clipboard+=unnamed

" Switch syntax highlighting on
syntax on

" Don't worry about trying to support old school Vi features
set nocompatible

" No backup files
set nobackup

" No write backup
set nowritebackup

" No swap file
set noswapfile

" Command history
set history=100

" Always show cursor
set ruler

" Show incomplete commands
set showcmd

" Incremental searching (search as you type)
set incsearch

" Highlight search matches
set hlsearch

" Ignore case in search
set smartcase

" Make sure any searches /searchPhrase doesn't need the \c escape character
set ignorecase

" A buffer is marked as ‘hidden’ if it has unsaved changes, and it is not currently loaded in a window
" If you try and quit Vim while there are hidden buffers, you will raise an error:
" E162: No write since last change for buffer “a.txt”
set hidden

" Turn word wrap off
set nowrap

" Allow backspace to delete end of line, indent and start of line characters
set backspace=indent,eol,start

" Convert tabs to spaces
set expandtab

" Set tab size in spaces (this is for manual indenting)
set tabstop=2

" The number of spaces inserted for a tab (used for auto indenting)
set shiftwidth=2

" Turn on line numbers
set number

" Highlight tailing whitespace
set list listchars=tab:\ \ ,trail:·

" Get rid of the delay when pressing O (for example)
" http://stackoverflow.com/questions/2158516/vim-delay-before-o-opens-a-new-line
set timeout timeoutlen=1000 ttimeoutlen=100

" Always show status bar
set laststatus=2

" Set the status line to something useful
set statusline=%f\ %m\ %=L:%l/%L\ %c\ (%p%%)

" UTF encoding
set encoding=utf-8

" Autoload files that have changed outside of vim
set autoread

" Better splits (new windows appear below and to the right)
set splitbelow
set splitright

" Highlight the current line
set cursorline

" Ensure Vim doesn't beep at you every time you make a mistype
set visualbell

" Visual autocomplete for command menu (e.g. :e ~/path/to/file)
set wildmenu

" Redraw only when we need to (i.e. don't redraw when executing a macro)
set lazyredraw

" Highlight a matching [{()}] when cursor is placed on start/end character
set showmatch

" Set built-in file system explorer to use layout similar to the NERDTree plugin
" P opens file in previously focused window
" o opens file in new horizontal split window
" v opens file in new vertical split window
" t opens file in new tab split window
let g:netrw_liststyle=3

" Set-up required by Vundle
" Launch vim and run :PluginInstall
" To install from command line: vim +PluginInstall +qall
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

Plugin 'ekalinin/Dockerfile.vim'
Plugin 'ervandew/supertab'
Plugin 'fatih/vim-go'
  let g:go_fmt_command = "goimports"
Plugin 'godlygeek/tabular'
  map <Leader>e :Tabularize /=<cr>
  map <Leader>c :Tabularize /:<cr>
  map <Leader>es :Tabularize /=\zs<cr>
  map <Leader>cs :Tabularize /:\zs<cr>
Plugin 'guns/vim-clojure-highlight'
Plugin 'guns/vim-clojure-static'
Plugin 'guns/vim-sexp'
Plugin 'kana/vim-textobj-user' " Dependant for vim-textobj-rubyblock
Plugin 'kien/ctrlp.vim'
  map <leader>t <C-p>
  map <leader>y :CtrlPBuffer<cr>
  let g:ctrlp_show_hidden=1
  let g:ctrlp_working_path_mode=0
  let g:ctrlp_max_height=30
  let g:ctrlp_arg_map = 1 " Override <C-o> to provide options for how to open files
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*.,*/.DS_Store " Files matched are ignored when expanding wildcards
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""' " Use Ag for searching instead of VimScript (might not work with ctrlp_show_hidden and ctrlp_custom_ignore)
  let g:ctrlp_custom_ignore = '\v[\/]((node_modules)|\.(git|svn|grunt|sass-cache))$' " Directories to ignore when fuzzy finding
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'mileszs/ack.vim'
  let g:ackprg = 'ag --nogroup --nocolor --column'
Plugin 'nelstrom/vim-textobj-rubyblock' " Relies on vim-textobj-user
  runtime macros/matchit.vim
Plugin 'othree/html5.vim'
Plugin 'plasticboy/vim-markdown'
Plugin 'scrooloose/syntastic'
Plugin 'sheerun/vim-polyglot'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-leiningen'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-sexp-mappings-for-regular-people'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/Gist.vim'
  let g:github_user = $GITHUB_USER
  let g:gist_detect_filetype = 1
  let g:gist_open_browser_after_post = 1
Plugin 'vim-scripts/camelcasemotion'
  map <silent> w <Plug>CamelCaseMotion_w
  map <silent> b <Plug>CamelCaseMotion_b
  map <silent> e <Plug>CamelCaseMotion_e
  sunmap w
  sunmap b
  sunmap e

" Closing settings required by Vundle
call vundle#end()
filetype plugin indent on

" NeoVim shortcut for quick terminal exit
:silent! tnoremap § <C-\><C-n>

fun! StripTrailingWhitespace()
  " Don't strip on these filetypes
  if &ft =~ 'markdown'
    return
  endif
  %s/\s\+$//e
endfun
autocmd BufWritePre * call StripTrailingWhitespace()

autocmd Filetype gitcommit setlocal spell textwidth=72
autocmd Filetype markdown setlocal wrap linebreak nolist textwidth=0 wrapmargin=0 " http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
autocmd FileType sh,cucumber,ruby,yaml,zsh,vim setlocal shiftwidth=2 tabstop=2 expandtab

" Specify syntax highlighting for specific files
autocmd Bufread,BufNewFile *.spv set filetype=php
autocmd Bufread,BufNewFile *.md set filetype=markdown " Vim interprets .md as 'modula2' otherwise, see :set filetype?

" Rainbow parenthesis always on!
autocmd VimEnter * if exists(':RainbowParenthesesToggle') | exe ":RainbowParenthesesToggleAll" | endif

" Change colourscheme when diffing
fun! SetDiffColours()
  highlight DiffAdd    cterm=bold ctermfg=white ctermbg=DarkGreen
  highlight DiffDelete cterm=bold ctermfg=white ctermbg=DarkGrey
  highlight DiffChange cterm=bold ctermfg=white ctermbg=DarkBlue
  highlight DiffText   cterm=bold ctermfg=white ctermbg=DarkRed
endfun
autocmd FilterWritePre * call SetDiffColours()
