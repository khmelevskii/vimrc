" Enviroment ===================================================================
set nocompatible " be iMproved
set background=dark

filetype off " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

filetype plugin indent on " required!

" Bundles ======================================================================
if filereadable(expand("~/.vim/.vimrc.bundles"))
	source ~/.vim/.vimrc.bundles
endif

" General =======================================================================

" Подключаем темную тему Solarized
colorscheme solarized 
let g:solarized_termtrans=1
" let g:solarized_contrast="high"
" let g:solarized_visibility="high"
" let g:solarized_termcolors=256
" let g:solarized_degrade = 1 
" let g:solarized_bold = 1
" let g:solarized_underline = 1

" Подсветка синтаксиса
syntax on
let mapleader = ","
set mouse=a                 " automatically enable mouse usage
set mousehide               " hide the mouse cursor while typing

set scrolljump=5                " lines to scroll when cursor leaves screen
set scrolloff=3   " scroll 3 lines before bottom/top

set autoread      " set to auto read when a file is changed from the outside
set autowrite     
set showcmd       " display incomplete commands
set hidden        " allow buffer to be put in the background without saving

set clipboard=unnamed " one mac and windows, use * register for copy-paste

autocmd VimEnter,BufNewFile,BufRead * set foldmethod=manual
set wildmenu      " show autocomplete menus
set wildmode=list:longest,list:full " completion menu behaves more like cli
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set wildignore+=*.o,tags,Session.vim

set iskeyword+=$,_         " added word chars

" Most prefer to automatically switch to the current file directory when
" a new buffer is opened; to prevent this behavior, add
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

" show line number, cursor position
set number
set ruler         " Показываем положение курсора все время
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
set cursorline    " highlights the cursor line
set nowrap
set linebreak              " this will not break whole words while wrap is enabled
" set showbreak=…
set backspace=start,indent,eol " set backspace to act like normal
set linespace=0                 " No extra spaces between rows
set encoding=utf-8

" search settings
set hlsearch               " highlight search things
set incsearch              " go to search results as typing
set ignorecase             " ignore case when searching
set smartcase              " but case-sensitive if expression contains a capital letter.
set gdefault               " assume global when searching or substituting
set magic                  " set magic on, for regular expressions
set showmatch              " show matching brackets when text indicator is over them
au SessionLoadPost  * set suffixesadd=.styl,.css,.js,.php,.tpl,.html,.coffee,.haml,.sql
nmap gF :tab split <Bar> normal! gf<cr>

hi SignColumn ctermbg=0

"set lazyredraw             " don't redraw screen during macros
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

" goto the last active tab
let g:lasttab = 1
nmap <Leader>l :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" be quiet
set visualbell             " don't beep
set noerrorbells           " don't beep
set noeb vb t_vb=          " disable audio and visual bells
au GUIEnter * set vb t_vb=

" do not create swap files!
set nobackup
set nowritebackup
set noswapfile

" vim 7.3 features
if v:version >= 703
  set undodir=$HOME/.vim/.undo
  set undofile
  set undolevels=1000
  set undoreload=10000
  set colorcolumn=80    " show a right margin column
endif

set history=100 " create a larger history

set pastetoggle=<F7>
set listchars=tab:‣\ ,trail:-,extends:#,nbsp:%,eol:¬

" show editing mode
set showmode
set tabpagemax=15               " only show 15 tabs

" set the title within xterm as well
set title

" set status line
set laststatus=2
let g:Powerline_symbols='fancy'
let g:Powerline_stl_path_style = 'filename'

" C-e - удаление текущей строки
nmap <c-e> "_dd

map <c-w> <C-W>w           " fast window switching
map <leader>. :b#<cr>          " cycle between buffers
" g[bB] in command mode switch to the next/prev. buffer
map gb :bnext<cr>
map gB :bprev<cr>
" gz in command mode closes the current buffer
map gz :bdelete<cr>

" Vertical split then hop to new buffer
:noremap <leader>v :vsp<CR>
:noremap <leader>h :split<CR>

" Make current window the only one
:noremap <leader>o :only<CR>i

" Open current directory in Finder
nmap <leader>p :execute "silent !open " . expand('%:p:h')<cr>:redraw!<cr>

" Move by tabs
inoremap <C-h> <c-o>gT
inoremap <C-l> <c-o>gt
nmap <C-h> gT
nmap <C-l> gt

" New tab
inoremap <C-t> <c-o>:tabnew<cr>
nmap <C-t> :tabnew<CR>
" Close tab
function! CloseSomething()
  if winnr("$") == 1 && tabpagenr("$") > 1 && tabpagenr() > 1 && tabpagenr() < tabpagenr("$")
    tabclose | tabprev
  else
    q
  endif
endfunction
inoremap <C-b> <c-o>:call CloseSomething()<cr>
nmap <C-b> :call CloseSomething()<cr>

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Bubble single lines
nmap <C-j> ]e
nmap <C-k> [e
" Bubble multiple lines
vmap <C-k> [egv
vmap <C-j> ]egv

" map Y to match C and D behavior
nnoremap Y y$                  
" yank entire file (global yank)
nmap gy ggVGy                  
" visual select current line
nmap vil ^v$h

" pull word under cursor into lhs of a substitute (for quick search and replace)
nmap <leader>sr :%s#\<<C-r>=expand("<cword>")<CR>\>#
" switch search highighting off temporaril
nmap <silent> <leader>/ :nohlsearch<CR>

cmap <c-p> <c-r>=expand("%:p:h") . "/" <cr>  
" insert path of current file into a command

" save with ,,
inoremap <leader>, <esc>:w<cr>
nnoremap <leader>, :w<cr>

" С-q - выход из Vim 
nmap <leader>q :qa<cr>
imap <leader>q <Esc>:qa<cr>

" swaps ' ` for easier bookmark return
nnoremap ' `
nnoremap ` '

" swap ; : for easier commands
nnoremap ; :

" move cursor to next row rather than line. Good when wrapping is on
nnoremap j gj
nnoremap k gk

" go to the parent tag
nnoremap <silent> [p :let @a=@"<cr>O<esc>yat<esc>u<c-o>:let @*=@a<cr>:let @"=@a<cr>
nnoremap <silent> <leader>fd ?^\s*[a-zA-Z0-9_ ]*function <cr>:nohlsearch<cr>/function<cr>w:nohlsearch<cr> 

" C-d - дублирование текущей строки
imap <c-d> <esc>yypi
imap <leader>d <c-o>diw
nmap <leader>d diw

" save readonly files with w!!
cmap w!! w !sudo tee % >/dev/null

" Adjust viewports to the same size
map <Leader>= <C-w>=

" map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

"save on focus lost
:au FocusLost * :wa

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
" set completeopt=menu,preview,longest

" ===========================================================================
" Plugin settings
" ===========================================================================

" NerdTree ==================================================================
map <leader>e :NERDTreeToggle<CR>
map <leader>r :NERDTreeFind<CR>
map <leader>nm :NERDTreeMirror<CR>
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

" fugitive ===================================================================
nnoremap <silent> <leader>ga :Gwrite<cr>
nnoremap <silent> <leader>gs :Gstatus<cr>
nnoremap <silent> <leader>gl :Glog<cr>
nnoremap <silent> <leader>gd :Gdiff<cr>i
nnoremap <silent> <leader>gc :Gcommit<cr>
nnoremap <silent> <leader>gp :Git push<cr>
nnoremap <silent> <leader>gh :Gbrowse<cr>
nnoremap <leader>gb :call AddBranch()<cr>
nnoremap <leader>gbd :call DeleteBranch()<cr>
nnoremap <leader>gbc :call GetListBranches()<cr>
nnoremap <leader>gm :call MergeBranch()<cr>
nnoremap <leader>gt :Git tag v
nnoremap <leader>gtd :call DeleteTag()<cr>
nnoremap <leader>gtl :call GetListTags()<cr>

" TODO Refactor. Create small plugin
" создание новой ветки или переключение на существующую
fun! AddBranch()
  let cond = {'author_id' : g:redmine_author_id}
  let cond['project_id'] = g:redmine_project_id

  let url = RedmineCreateCommand('issue_list', '', cond)
  let ret = webapi#http#get(url)
  if ret.content == ' '
      return 0
  endif

  let num = 0
  let dom = webapi#xml#parse(ret.content)
  let s:data = []
  let s:refs = []
  call add(s:data, 'Создать ветку для открытой задачи проекта:')
  call add(s:refs, '')
  let i = 1
  for elem in dom.findAll("issue")
    let id = elem.find("id").value()
    let subject = elem.find("subject").value()
    if strlen(subject) > 110
      let subject = strpart(subject, 0, 110)
      let subject = strpart( subject, 0, strridx(subject, ' ') ) . '...'
    endif

    let branch_exists = system('git branch | grep refs\#' . id . '$')
    if branch_exists != ''
      let branch_exists = '***'
    endif

    call add(s:data, i . ".  refs#" . id . ' - ' . branch_exists . subject)
    call add(s:refs, id)
    let num += 1
    let i += 1
  endfor

  call inputrestore()
  let s:current_branch = inputlist(s:data)

  if s:current_branch != '' 
    " если ветка не существует создаем нее
    let id = s:refs[s:current_branch]
    let branch_exists = system('git branch | grep refs\#' . id . '$')
    if branch_exists == ''
      execute 'silent !git branch refs\#' . id
    endif

    execute 'silent !git checkout refs\#' . id |redraw!
    call TimeKeeper_StartTracking()
  endif

  return num
endfun

" переключение между git ветками
fun! GetListBranches()
  call inputsave()
  let s:branches = system('git for-each-ref refs/heads/')
  let s:data = []
  let s:refs = []
  let i = 1
  call add(s:data, 'Доступные ветки:')
  call add(s:refs, '')

  for s:line in split(s:branches, '\n')
    let s:branch = substitute(s:line, '^.*/', '', 'g')
    let s:branch_id = substitute(s:branch, '^.*#', '', 'g')
    let s:task_name = RedmineGetTicket(s:branch_id)
    

    if s:task_name == '0' 
      let s:task_name = ''
    else
      let s:task_name = ' - ' . s:task_name
    endif

    call add( s:data, i . '.  ' . s:branch . s:task_name)
    call add(s:refs, s:branch)
    let i = i +1
  endfor

  call inputrestore()
  let s:current_branch = inputlist(s:data)

  if s:current_branch != '' 
    let s:command = s:refs[s:current_branch]
    execute 'silent !git checkout ' . substitute(s:command, '#', '\\#', '') |redraw!
    call TimeKeeper_StartTracking()
  endif
endfun

" удаление git ветки
fun! DeleteBranch()
  call inputsave()
  let s:branches = system('git for-each-ref refs/heads/')
  let s:data = []
  let s:refs = []
  let i = 1
  call add(s:data, 'Доступные ветки:')
  call add(s:refs, '')

  for s:line in split(s:branches, '\n')
    let s:branch = substitute(s:line, '^.*/', '', 'g')
    let s:branch_id = substitute(s:branch, '^.*#', '', 'g')
    let s:task_name = RedmineGetTicket(s:branch_id)
    

    if s:task_name == '0' 
      let s:task_name = ''
    else
      let s:task_name = ' - ' . s:task_name
    endif

    call add( s:data, i . '.  ' . s:branch . s:task_name)
    call add(s:refs, s:branch)
    let i = i +1
  endfor

  let s:current_branch = inputlist(s:data)
  call inputrestore()

  if s:current_branch != '' 
    let s:command = s:refs[s:current_branch]
    execute 'silent !git branch -D ' . substitute(s:command, '#', '\\#', '') |redraw!
  endif
endfun

" слить текущую git ветку с master и удалить ее
fun! MergeBranch()
  let s:branch = system('git rev-parse --abbrev-ref HEAD')
  execute 'silent !git checkout master'
  execute '!git merge ' . substitute(s:branch, '#', '\\#', '')
  execute '!git branch -d ' . substitute(s:branch, '#', '\\#', '')
endfun

" посмотреть список тегов
fun! GetListTags()
  let s:tags = system('git for-each-ref --sort=-*taggerdate refs/tags')
  let s:data = []
  echo 'Теги проекта:'
  for s:line in split(s:tags, '\n')
    call insert( s:data, substitute(s:line, '^.*tags/', '', 'g') )
  endfor

  for s:line in s:data
    echo '  ' . s:line
  endfor
endfun

" удаление tag
fun! DeleteTag()
  call inputsave()
  let s:branches = system('git tag -l')
  let s:data = []
  let i = 1
  call add(s:data, 'Удалить тег:')
  for s:line in split(s:branches, '\n')
    call add( s:data, i . '.  ' . s:line )
    let i = i +1
  endfor

  let s:branch = inputlist(s:data)
  call inputrestore()

  if s:branch != '' 
    let s:command = substitute(s:data[s:branch], '\d\.\s*', '', '')
    execute '!git tag -d ' . s:command
  endif
endfun

" Redmine ====================================================================
let g:redmine_browser = 'open -a Google\ Chrome'
nnoremap <leader>rt :RedmineViewAllTicket<cr>
nnoremap <leader>rmt :RedmineViewMyTicket<cr>
nnoremap <leader>rpt :RedmineViewMyProjectTicket<cr>
nnoremap <leader>rat :RedmineAddTicketWithDiscription<cr>

" Gist ======================================================================
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_use_password_in_gitconfig = 1
nnoremap <silent> <leader>gis :Gist<cr>
vnoremap <silent> <leader>gis :Gist<cr>

" syntastic =================================================================
let g:syntastic_check_on_open=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠' 
let g:syntastic_javascript_checker="jshint"

" Numbers ====================================================================
nnoremap <F3> :NumbersToggle<CR>

" sessionman =================================================================
set sessionoptions=blank,buffers,folds,resize,tabpages,winsize
nmap <leader>sl :SessionList<CR>
nmap <leader>ss :SessionSave<CR>
let g:sessionman_save_on_exit=1

" bufexplorer ================================================================
nmap <leader>bb :BufExplorer<CR>

" Ack =====================================================================
nmap <c-f> :Ack 

" Javascript ==============================================================
let g:javascript_ignore_javaScriptdoc = 1
let g:html_indent_inctags = "html,body,head,tbody"

" CoffeeScript ============================================================
" au BufWritePost *.coffee silent CoffeeMake! -b | cwindow | redraw!
nmap <leader>cfw :CoffeeCompile watch vert<cr>
nmap <leader>cfc :CoffeeMake<cr>
nmap <leader>cfl :CoffeeLint<cr>
setl scrollbind
let coffee_lint_options = '-f cflint.json'

" JSON ====================================================================
au! BufRead,BufNewFile *.json set filetype=json 

" Tagbar ====================================================================
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
nmap <f8> :TagbarToggle<cr>
imap <f8> <esc>:TagbarToggle<cr>
let g:tagbar_width=28
let g:tagbar_autoshowtag = 1
let g:tagbar_sort = 0

" PIV ========================================================================
let g:DisableAutoPHPFolding = 1
au BufNewFile,BufRead *.php let php_folding=0
au BufNewFile,BufRead *.php let php_htmlInStrings=0
au BufNewFile,BufRead *.php let php_noShortTags=1
au BufNewFile,BufRead *.php let php_strip_whitespace=0

" CTags ====================================================================
let g:ctags_statusline=1 
let g:ctags_title=1
let g:generate_tags=1
let g:tagbar_phpctags_bin='/usr/bin/phpctags'
nmap <c-\> :pop<cr>

" localvimrc =================================================================
let g:localvimrc_ask = 0
let g:localvimrc_sandbox = 0

" easyMotion =================================================================
let g:EasyMotion_leader_key = '\\'
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'

" NeoComplecache =============================================================
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup=1
let g:neocomplcache_disable_auto_complete=1
" let g:neocomplcache_enable_camel_case_completion = 1
" let g:neocomplcache_enable_smart_case = 1
" let g:neocomplcache_enable_underbar_completion = 1
" let g:neocomplcache_enable_auto_delimiter = 1
" let g:neocomplcache_max_list = 15
" let g:neocomplcache_force_overwrite_completefunc = 1
" let g:SuperTabDefaultCompletionType = "<c-x><c-u>"
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

" Indent guides ==============================================================
let g:indent_guides_auto_colors = 0
" autocmd VimEnter * :IndentGuidesEnable
autocmd VimEnter * :hi IndentGuidesOdd ctermbg=23
autocmd VimEnter * :hi IndentGuidesEven ctermbg=23
set ts=2 sw=2 et
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
" let g:indent_guides_enable_on_vim_startup = 1

" SQL Utilities ==============================================================
let g:sqlutil_keyword_case = '\U'
let g:sqlutil_align_where = 1
let g:sqlutil_align_comma = 1
let g:sqlutil_use_tbl_alias = 'n'

" dbext ======================================================================
let g:dbext_default_use_tbl_alias = 'n'

" SqlComplete ================================================================
imap <leader>pt <C-\><C-O>:call sqlcomplete#Map('table')<CR><C-X><C-O>
imap <leader>pc <C-\><C-O>:call sqlcomplete#Map('column')<CR><C-X><C-O>
imap <leader>pp <C-\><C-O>:call sqlcomplete#Map('procedure')<CR><C-X><C-O>
imap <leader>pv <C-\><C-O>:call sqlcomplete#Map('view')<CR><C-X><C-O>
imap <leader>pa <C-\><C-O>:call sqlcomplete#Map('syntax')<CR><C-X><C-O>
imap <leader>pd <C-\><C-O>:call sqlcomplete#Map('pgsqlType')<CR><C-X><C-O>
imap <leader>ps <C-\><C-O>:call sqlcomplete#Map('pgsqlStatement')<CR><C-X><C-O>

au FileType xml :setf sql<cr>:setf xml<cr>:call sqlcomplete#ResetCacheSyntax()<cr>
au FileType php :setf sql<cr>:setf php<cr>:call sqlcomplete#ResetCacheSyntax()<cr>
au FileType javascript :setf sql<cr>:setf javascript<cr>:call sqlcomplete#ResetCacheSyntax()<cr>

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

au BufNewFile,BufRead *.sql :setf pgsql<cr>:call sqlcomplete#ResetCacheSyntax()<cr>

" VimShell ===================================================================
nmap <leader>shp :VimShellPop<cr>
nmap <leader>sht :VimShellTab<cr>


" SnipMate ===================================================================
imap <c-a> <c-r>=ShowAvailableSnips()<cr>


" strip all trailing whitespace 
fun! StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

" Remove trailing whitespaces and ^M chars
autocmd FileType php,javascript,python,xml,yml,coffee,css,stylus autocmd BufWritePre <buffer> call StripTrailingWhitespaces()

" JsBeautify =================================================================
autocmd FileType javascript noremap <buffer>  <leader>jb :call JsBeautify()<cr>
autocmd FileType html noremap <buffer>  <leader>jb :call HtmlBeautify()<cr>
autocmd FileType handlebars noremap <buffer>  <leader>jb :call HtmlBeautify()<cr>

" TimeKeeper =================================================================
let g:TimeKeeperAwayTimeSec = 60
let g:TimeKeeperUpdateFileTimeSec = 60
nmap <leader>tks :call TimeKeeper_StartTracking()<cr>
nmap <leader>tkp :call TimeKeeper_StopTracking()<cr>

" jscomplete ================================================================= 
autocmd FileType javascript
  \ :setl omnifunc=nodejscomplete#CompleteJS
let g:jscomplete_use = ['dom', 'moz']

" nodejs complete ============================================================
let g:node_usejscomplete=1

" Switch =====================================================================
nnoremap - :Switch<cr>

" Functions ==================================================================
" Custom fold line format (short)
function! MyFoldText()
    let nl = v:foldend - v:foldstart + 1
    let comment = substitute(getline(v:foldstart),"^ *","",1)
    let linetext = substitute(getline(v:foldstart+1),"^ *","",1)
    let txt = '+ ' . comment . ' : length ' . nl
    return txt
endfunction
set foldtext=MyFoldText()
