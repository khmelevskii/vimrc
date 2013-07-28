" ============================================================================
" Enviroment
" ============================================================================
set nocompatible " be iMproved
set background=dark

filetype off " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

filetype plugin indent on " required!


" ============================================================================
" Bundles
" ============================================================================
if filereadable(expand("~/.vim/.vimrc.bundles"))
	source ~/.vim/.vimrc.bundles
endif


" ============================================================================
" General
" ============================================================================
" Include colorscheme Solarized
colorscheme solarized 
let g:solarized_contrast = "high"
let g:solarized_visibility = "high"

" Enabled syntax highlighting
syntax on

let mapleader = ","
set mouse=a           " automatically enable mouse usage
set mousehide         " hide the mouse cursor while typing

set scrolljump=3      " lines to scroll when cursor leaves screen
set scrolloff=3       " scroll 3 lines before bottom/top

set autoread          " set to auto read when a file is changed from the outside
set autowrite     
set showcmd           " display incomplete commands
set hidden            " allow buffer to be put in the background without saving

set clipboard=unnamed " one mac and windows, use * register for copy-paste

" no use auto folding
autocmd VimEnter,BufNewFile,BufRead * set foldmethod=manual

set wildmenu " show autocomplete menus
set wildmode=list:longest,list:full " completion menu behaves more like cli
set whichwrap=b,s,h,l,<,>,[,]        " Backspace and cursor keys wrap too
set wildignore+=*.o,tags,Session.vim

set iskeyword+=$,_,-   " added word chars

set nonumber      " not show line number, cursor position
set ruler         " Показываем положение курсора все время
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
set nocursorline  " not highlights the cursor line
set nowrap
set linebreak     " this will not break whole words while wrap is enabled
set showbreak=…
set backspace=start,indent,eol " set backspace to act like normal
set linespace=0                " No extra spaces between rows
set encoding=utf-8

" search settings
set hlsearch               " highlight search things
set incsearch              " go to search results as typing
set ignorecase             " ignore case when searching
set smartcase              " but case-sensitive if expression contains a capital letter.
set gdefault               " assume global when searching or substituting
au SessionLoadPost  * set suffixesadd=.styl,.css,.js,.php,.tpl,.html,.coffee,.haml,.sql
nmap gF :tab split <Bar> normal! gf<cr>

hi SignColumn ctermbg=0

set ttyfast                " improves redrawing for newer computers
set fileformats=unix,mac,dos

" indent settings
set autoindent
set smartindent

" tab settings
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set smarttab

" do not create backup files!
set nobackup
set nowritebackup
set noswapfile

" vim 7.3 features
if v:version >= 703
  set undodir=$HOME/.vim/.undo
  set undofile
  set undolevels=1000
  set undoreload=1000
  set colorcolumn=80    " show a right margin column
endif

set history=200 " create a larger history

set pastetoggle=<F7>
set listchars=tab:‣\ ,trail:-,extends:#,nbsp:%,eol:¬

" show editing mode
set showmode

" only show 10 tabs
set tabpagemax=10               

" set the title within xterm as well
set title

" set status line
set laststatus=2

" swaps ' ` for easier bookmark return
nnoremap ' `
nnoremap ` '

" swap ; : for easier commands
nnoremap ; :

" move cursor to next row rather than line. Good when wrapping is on
nnoremap j gj
nnoremap k gk

"save on focus lost
au FocusLost * :wa

" be quiet
set visualbell             " don't beep
set noerrorbells           " don't beep
set noeb vb t_vb=          " disable audio and visual bells
au GUIEnter * set vb t_vb=

" automatically open and close the popup menu / preview window
" au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menu,longest

" save folds and cursor
au BufWinLeave *.* mkview! 
au BufWinEnter *.* silent loadview 
set viewoptions=folds,cursor


" ===========================================================================
" GUI settings
" ===========================================================================
" set font
set guifont=Menlo\ for\ Powerline:h14
" remove right- and left-hand scrollbars
set guioptions-=r
set guioptions-=L
" remove the toolbar and menubar
set guioptions-=T
" set linesapce
set linespace=2

hi SignColumn guibg=#73642
hi Error guibg=#73642

if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

" ===========================================================================
" Plugin settings
" ===========================================================================
" NerdTree ==================================================================
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0
let b:match_ignorecase = 1
let g:NERDShutUp=1

" CtrlP =====================================================================
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$',
  \ 'file': '\.exe$\|\.so$\|\.dll$',
  \ 'link': '',
  \ }

let g:ctrlp_user_command = {
    \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
    \ 'fallback': 'find %s -type f'
\ }

" Redmine ====================================================================
let g:redmine_browser = 'open -a Google\ Chrome'

" Gist =======================================================================
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_use_password_in_gitconfig = 1

" syntastic ==================================================================
" let g:syntastic_check_on_open=0
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠' 
" let g:syntastic_javascript_checker="jshint"
" let g:syntastic_echo_current_error=0

" sessionman =================================================================
set sessionoptions=curdir,tabpages
let g:sessionman_save_on_exit=1

" CoffeeScript ===============================================================
" au BufWritePost *.coffee silent CoffeeMake! -b | cwindow | redraw!
setl scrollbind
let coffee_lint_options = '-f cflint.json'

" JSON =======================================================================
au! BufRead,BufNewFile *.json set filetype=json 

" Tagbar =====================================================================
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_width=28
let g:tagbar_autoshowtag = 1
let g:tagbar_sort = 0
let g:tagbar_foldlevel = 1

" PIV ========================================================================
let g:DisableAutoPHPFolding = 1
au BufNewFile,BufRead *.php let php_folding=0
au BufNewFile,BufRead *.php let php_htmlInStrings=0
au BufNewFile,BufRead *.php let php_noShortTags=1
au BufNewFile,BufRead *.php let php_strip_whitespace=0

" localvimrc =================================================================
let g:localvimrc_ask = 0
let g:localvimrc_sandbox = 0

" easyMotion =================================================================
let g:EasyMotion_leader_key = '\\'
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'

" YouCompleteMe ==============================================================
let g:ycm_complete_in_comments_and_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1

" UltiSnips ==================================================================
let g:UltiSnipsSnippetDirectories=["UltiSnips", "mysnippets"]
let g:UltiSnipsExpandTrigger="<c-z>"

" Nginx.vim ==================================================================
au! BufRead,BufNewFile *.conf set filetype=nginx 

" Слова откуда будем завершать
set complete=""
" Из текущего буфера
set complete+=.
" Из словаря
set complete+=k
" Из других открытых буферов
set complete+=b
" из тегов 
set complete+=t

" SQL Utilities ==============================================================
let g:sqlutil_keyword_case = '\U'
let g:sqlutil_align_where = 1
let g:sqlutil_align_comma = 1
let g:sqlutil_use_tbl_alias = 'n'

" dbext ======================================================================
let g:dbext_default_use_tbl_alias = 'n'

" SqlComplete ================================================================
" use sql complete in xml, php and js files
au FileType xml :setf sql<cr>:setf xml<cr>:call sqlcomplete#ResetCacheSyntax()<cr>
au FileType php :setf sql<cr>:setf php<cr>:call sqlcomplete#ResetCacheSyntax()<cr>
au FileType javascript :setf sql<cr>:setf javascript<cr>
      \:call sqlcomplete#ResetCacheSyntax()<cr>

let g:omni_sql_use_tbl_alias = 'n'
let g:sql_type_default = 'pgsql'
let g:omni_sql_precache_syntax_groups = [
            \ 'syntax',
            \ 'pgsqlKeyword',
            \ 'pgsqlFunction',
            \ 'pgsqlOption',
            \ 'pgsqlType',
            \ 'pgsqlStatement'
            \ ]

au BufNewFile,BufRead *.sql :setf pgsql<cr>
      \:call sqlcomplete#ResetCacheSyntax()<cr>
" au BufRead,BufNewFile *.sql set filetype=pgsql

" TimeKeeper =================================================================
let g:TimeKeeperAwayTimeSec = 60

" Breeze ===================================================================== 
let g:breeze_hl_color = "DiffChange"
hi MatchParen ctermfg=3
hi MatchParen ctermbg=0

" Stylus =====================================================================
autocmd BufNewFile,BufRead *.styl set filetype=stylus

" ============================================================================
" Functions
" ============================================================================
" FUNCTION: MyFoldText {{{
"  
" This function set custom fold line format (short).
"
function! MyFoldText()
    let nl = v:foldend - v:foldstart + 1
    let comment = substitute(getline(v:foldstart),"^ *","",1)
    let linetext = substitute(getline(v:foldstart+1),"^ *","",1)
    let txt = '+ ' . comment . ' : length ' . nl
    return txt
endfunction
set foldtext=MyFoldText()
"																			                                      }}}

" FUNCTION: CloseTab {{{
"  
" Close tab and set focus on previous tab
" 
function! CloseTab()
  if winnr("$") == 1 
        \ && tabpagenr("$") > 1 
        \ && tabpagenr() > 1 
        \ && tabpagenr() < tabpagenr("$")
    tabclose | tabprev
  else
    q
  endif
endfunction
"																			                                      }}}

" FUNCTION: StripTrailingWhitespaces {{{
"  
" Strip all trailing whitespace
" 
function! StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction
autocmd FileType php,javascript,python,xml,yml,coffee,css,stylus 
      \ autocmd BufWritePre <buffer> call StripTrailingWhitespaces()
"																			                                      }}}


" ============================================================================
" Mapping
" ============================================================================
if filereadable(expand("~/.vim/.vimrc.mapping"))
	source ~/.vim/.vimrc.mapping
endif
