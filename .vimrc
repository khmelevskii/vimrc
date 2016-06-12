call plug#begin('~/.vim/plugged')

" initialize default settings
let s:settings = {}
let s:settings.default_indent = 2
let s:settings.max_column = 80
let s:settings.enable_cursorcolumn = 0
let s:settings.colorscheme = 'solarized'

let s:settings.plugin_groups = []
call add(s:settings.plugin_groups, 'core')
call add(s:settings.plugin_groups, 'web')
call add(s:settings.plugin_groups, 'tern')
call add(s:settings.plugin_groups, 'javascript')
call add(s:settings.plugin_groups, 'clojure')
call add(s:settings.plugin_groups, 'db')
call add(s:settings.plugin_groups, 'scm')
call add(s:settings.plugin_groups, 'autocomplete')
call add(s:settings.plugin_groups, 'editing')
call add(s:settings.plugin_groups, 'navigation')
call add(s:settings.plugin_groups, 'unite')
call add(s:settings.plugin_groups, 'misc')


" functions {{{
  " Close tab and set focus on previous tab
  function! CloseTab() "{{{
    if winnr("$") == 1
          \ && tabpagenr("$") > 1
          \ && tabpagenr() > 1
          \ && tabpagenr() < tabpagenr("$")
      tabclose | tabprev
    else
      q
    endif
  endfunction
  "}}}
  "
  function! Preserve(command) "{{{
    " preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    execute a:command
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
  endfunction "}}}

  function! StripTrailingWhitespace() "{{{
    call Preserve("%s/\\s\\+$//e")
  endfunction "}}}

  function! EnsureExists(path) "{{{
    if !isdirectory(expand(a:path))
      call mkdir(expand(a:path))
    endif
  endfunction "}}}
"}}}


" base configuration {{{
  set timeoutlen=500          "mapping timeout
  set ttimeoutlen=50          "keycode timeout

  set mouse=a                 "enable mouse
  set mousehide               "hide when characters are typed
  set history=1000            "number of command lines to remember

  set ttyfast                 "assume fast terminal connection
  set viewoptions=folds,options,cursor,unix,slash     "unix/windows compatibility
  set encoding=utf-8          "set encoding for text
  set clipboard=unnamed       "sync with OS clipboard
  set hidden                  "allow buffer switching without saving
  set autoread                "auto reload if file saved externally
  set fileformats+=mac        "add mac to auto-detection of file format line endings
  set nrformats-=octal        "always assume decimal numbers
  set showcmd
  set tags=tags;/
  set showfulltag
  set modeline
  set modelines=5

  " whitespace
  set backspace=indent,eol,start                      "allow backspacing everything in insert mode
  set autoindent                                      "automatically indent to match adjacent lines
  set expandtab                                       "spaces instead of tabs
  set smarttab                                        "use shiftwidth to enter tabs
  let &tabstop=s:settings.default_indent              "number of spaces per tab for display
  let &softtabstop=s:settings.default_indent          "number of spaces per tab in insert mode
  let &shiftwidth=s:settings.default_indent           "number of spaces when indenting
  set list                                            "highlight whitespace
  set listchars=tab:│\ ,trail:•,extends:❯,precedes:❮
  set shiftround
  set nowrap
  set linebreak
  let &showbreak='↪ '

  set scrolloff=3               "always show content after scroll
  set scrolljump=3              "minimum number of lines to scroll
  set display+=lastline
  set wildmenu                  "show list for autocomplete
  set wildmode=list:full
  set wildignorecase
  set wildignore+=*.o,tags,Session.vim
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store,*/node_modules,*/temp

  set iskeyword+=$,_,-   " added word chars

  set splitbelow
  set splitright

  " disable sounds
  set visualbell             " don't beep
  set noerrorbells           " don't beep
  set noeb vb t_vb=          " disable audio and visual bells
  au GUIEnter * set vb t_vb=

  " searching
  set hlsearch                                        "highlight searches
  set incsearch                                       "incremental searching
  set ignorecase                                      "ignore case for searching
  set smartcase                                       "do case-sensitive if there's a capital letter
  set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
  set grepformat=%f:%l:%c:%m

  " giu settings {{{
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
  " }}}

  " vim file/folder management {{{
    " persistent undo
    if exists('+undofile')
      set undofile
      set undodir=~/.vim/.cache/undo
    endif

    " backups
    set backup
    set backupdir=~/.vim/.cache/backup

    " swap files
    set directory=~/.vim/.cache/swap
    set noswapfile

    call EnsureExists('~/.vim/.cache')
    call EnsureExists(&undodir)
    call EnsureExists(&backupdir)
    call EnsureExists(&directory)
  "}}}

  let mapleader = ","
  let g:mapleader = ","

  if has("unix")
    let s:uname = system("uname")
    let g:python_host_prog='/usr/bin/python'
    if s:uname == "Darwin\n"
      let g:python_host_prog='/usr/local/bin/python' " found via `which python`
    endif
  endif
"}}}


" ui configuration {{{
  set showmatch              "automatically highlight matching braces/brackets/etc.
  set matchtime=2            "tens of a second to show matching parentheses
  set nonumber
  set ruler         " Показываем положение курсора все время
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
  " set nocursorline  " not highlights the cursor line
  set lazyredraw
  set laststatus=2
  set noshowmode
  set foldenable             "enable folds by default
  set fdm=marker      "fold via syntax of files
  set fdl=0      "open all folds by default
  let g:xml_syntax_folding=1 "enable xml folding
  set title

  " set cursorline
  let &colorcolumn=s:settings.max_column
  if s:settings.enable_cursorcolumn
    set cursorcolumn
    autocmd WinLeave * setlocal nocursorcolumn
    autocmd WinEnter * setlocal cursorcolumn
  endif

  " if $TERM_PROGRAM == 'iTerm.app'
    " different cursors for insert vs normal mode
    if exists('$TMUX')
      let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
      let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    else
      let &t_SI = "\<Esc>]50;CursorShape=1\x7"
      let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    endif
  " endif
"}}}


" plugin/mapping configuration {{{
  if count(s:settings.plugin_groups, 'core') "{{{
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-dispatch'
    Plug 'wakatime/vim-wakatime'
    Plug 'embear/vim-localvimrc' "{{{
      let g:localvimrc_ask = 0
      let g:localvimrc_sandbox = 0
    "}}}
    Plug 'majutsushi/tagbar' | Plug 'vim-php/tagbar-phpctags.vim' " {{{
      nmap <F8> :TagbarToggle<CR>
      let g:tagbar_phpctags_bin='~/.vim/bundle/phpctags'
      let g:tagbar_phpctags_memory_limit = '256M'
    " }}}
    Plug 'vim-airline/vim-airline' "{{{
      let g:airline_powerline_fonts = 1
      let g:airline#extensions#tabline#enabled = 1
      let g:airline#extensions#tabline#left_sep=' '
      let g:airline#extensions#tabline#left_alt_sep='¦'
    "}}}
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-surround'
    Plug 'Shougo/vimproc.vim', {'do': 'make'}
    " Plug 'christoomey/vim-tmux-navigator'
  endif "}}}

  if count(s:settings.plugin_groups, 'editing') "{{{
    Plug 'junegunn/vim-easy-align' " {{{
      vmap <Space> <Plug>(EasyAlign)
      nmap ga <Plug>(EasyAlign)
    " }}}
    Plug '907th/vim-auto-save' "{{{
      let g:auto_save_no_updatetime = 1
      let g:auto_save_in_insert_mode = 0
      let g:auto_save = 1
      let g:auto_save_events = ["InsertLeave"]
    "}}}
    Plug 'terryma/vim-multiple-cursors' "{{{
      let g:multi_cursor_next_key='<c-m>'
      let g:multi_cursor_prev_key='<c-l>'
      function! Multiple_cursors_before()
        AutoSaveToggle
      endfunction

      function! Multiple_cursors_after()
        AutoSaveToggle
        w
      endfunction
    "}}}
    Plug 'terryma/vim-expand-region'
    Plug 'tomtom/tcomment_vim'
    " Plug 'matze/vim-move'
    " let g:move_key_modifier = 'C'
    Plug 'nathanaelkane/vim-indent-guides' " {{{
      let g:indent_guides_auto_colors = 0
      let g:indent_guides_start_level = 2
      let g:indent_guides_guide_size = 1
      autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=0
      autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=0
    " }}}
    Plug 'YankRing.vim'
    Plug 'AndrewRadev/switch.vim', {'on': 'Switch'} "{{{
      nnoremap - :Switch<cr>
      let g:variable_style_switch_definitions =
            \[
            \ ['up', 'down'],
            \ ['height', 'width'],
            \ ['after', 'before'],
            \ ['new', 'old'],
            \ ['top', 'right', 'bottom', 'left']
            \]
      autocmd FileType coffee let b:switch_custom_definitions =
            \[
            \ ['==', '!=']
            \]
      autocmd FileType sass let b:switch_custom_definitions =
            \[
            \ ['margin', 'padding'],
            \ ['absolute', 'relative', 'fixed'],
            \ ['inline', 'inline-block', 'block'],
            \ ['normal', 'bold', 'italic'],
            \ ['center', 'left', 'right'],
            \ ['height', 'width'],
            \ ['after', 'before'],
            \ ['top', 'right', 'bottom', 'left']
            \]
    "}}}
    Plug 'easymotion/vim-easymotion' "{{{  TODO зависимость от вызова комманды
      let g:EasyMotion_keys = 'asdfghjklqwertyuiopzxcvbnm'
      autocmd ColorScheme * highlight EasyMotionTarget ctermfg=32 guifg=#0087df
      autocmd ColorScheme * highlight EasyMotionShade ctermfg=237 guifg=#3a3a3a
    "}}}
  endif
  " }}}

  if count(s:settings.plugin_groups, 'navigation') "{{{
    " Plug 'ap/vim-buftabline'
    Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']} "{{{
      let NERDTreeShowHidden=0
      let NERDTreeQuitOnOpen=1
      let NERDTreeShowLineNumbers=0
      let NERDTreeChDirMode=0
      let NERDTreeShowBookmarks=1
      let NERDTreeIgnore=['\.git','\.hg', '\.sass-cache']
      nnoremap <F2> :NERDTreeToggle<CR>
      nnoremap <F3> :NERDTreeFind<CR>
    "}}}
    Plug 'mileszs/ack.vim', {'on': ['Ack']} "{{{
      let g:ackprg = "ack"
    "}}}
    Plug 'dyng/ctrlsf.vim' "{{{
    " }}}
    Plug 'mbbill/undotree', {'on': ['UndotreeToggle']} "{{{
      let g:undotree_SplitLocation='botright'
      let g:undotree_SetFocusWhenToggle=1
      nnoremap <silent> <F5> :UndotreeToggle<CR>
    "}}}
    Plug 'kien/ctrlp.vim' | Plug 'tacahiroy/ctrlp-funky' "{{{
      let g:ctrlp_clear_cache_on_exit=1
      let g:ctrlp_max_height=40
      let g:ctrlp_show_hidden=0
      let g:ctrlp_follow_symlinks=1
      let g:ctrlp_working_path_mode=0
      let g:ctrlp_max_files=20000
      let g:ctrlp_cache_dir='~/.vim/.cache/ctrlp'
      let g:ctrlp_reuse_window='startify'
      let g:ctrlp_extensions=['funky']
      let g:ctrlp_custom_ignore = {
        \ 'dir':  '\v[\/](node_modules|temp|build|bin|img|static-servers|css|test)$',
        \ }
      if executable('ag')
        let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
      endif

      let g:ctrlp_map = '<c-z>'
      nmap \ [ctrlp]
      nnoremap [ctrlp] <nop>

      nnoremap <c-g> :CtrlPBufTag<cr>
      nnoremap [ctrlp]T :CtrlPTag<cr>
      nnoremap [ctrlp]l :CtrlPLine<cr>
      nnoremap <c-f> :CtrlPFunky<cr>
      nnoremap <c-b> :CtrlPBuffer<cr>
    "}}}
  endif "}}}

  if count(s:settings.plugin_groups, 'autocomplete') "{{{
    Plug 'SirVer/ultisnips'
    Plug 'Valloric/YouCompleteMe', {'do': './install.sh'} "{{{
      let g:ycm_complete_in_comments_and_strings=1
      " let g:ycm_auto_trigger=0 "?
      let g:ycm_seed_identifiers_with_syntax=1
      let g:ycm_key_list_select_completion=['<C-n>', '<Down>', '<tab>']
      let g:ycm_key_list_previous_completion=['<C-p>', '<Up>', '<s-tab>']
      let g:ycm_filetype_blacklist={'unite': 1}

      let g:UltiSnipsListSnippets="<c-x>"
      let g:UltiSnipsExpandTrigger="<c-a>"
      let g:UltiSnipsJumpForwardTrigger="<c-a>"
      let g:UltiSnipsJumpBackwardTrigger="<c-l>"
      let g:UltiSnipsSnippetDirectories=["UltiSnips", "bundle/uwin-snippets", $HOME . '/uwinart/projects/webdev/tools/uwin-snippets']
    "}}}
    Plug 'honza/vim-snippets'
  endif "}}}

  if count(s:settings.plugin_groups, 'web') "{{{
    Plug 'cakebaker/scss-syntax.vim', {'for': ['scss', 'sass']}
    Plug 'hail2u/vim-css3-syntax', {'for': ['css', 'scss', 'sass']}
    Plug 'ap/vim-css-color', {'for': ['css', 'scss', 'sass', 'less', 'styl']}
    Plug 'othree/html5.vim', {'for':['html', 'smarty']}
    " Plug 'elzr/vim-json', {'for':['json']}
    Plug 'facebook/vim-flow', {'for':['javascript']}
    let g:flow#enable=0
    let g:flow#autoclose=1
    nnoremap <leader>kk :FlowMake<cr>
    Plug 'wavded/vim-stylus', {'for': 'stylus'}
    Plug 'digitaltoad/vim-jade', {'for': ['jade', 'pug', 'smarty']}
    Plug 'xml.vim', {'do': 'make', 'for': ['xml']}
    Plug 'mattn/emmet-vim', {'for': ['html', 'smarty', 'xml', 'xsl', 'javascript', 'javascript.jsx', 'xslt', 'xsd', 'css', 'sass', 'scss', 'less']} "{{{
      function! s:zen_html_tab()
        let line = getline('.')
        if match(line, '<.*>') < 0
          return "\<c-y>,"
        endif
        return "\<c-y>n"
      endfunction
      autocmd FileType xml,xsl,xslt,xsd,css,sass,scss,less,mustache imap <buffer><c-e> <c-y>,
      autocmd FileType html,smarty,javascript imap <buffer><expr><c-e> <sid>zen_html_tab()
    "}}}
  endif "}}}

  if count(s:settings.plugin_groups, 'tern') "{{{
    Plug 'marijnh/tern_for_vim', {'for': ['javascript'], 'do': 'npm install'}
  endif "}}}

  if count(s:settings.plugin_groups, 'javascript') "{{{
    " Plug 'pangloss/vim-javascript', {'for': ['javascript', 'javascript.jsx']}
    " Plug 'jelera/vim-javascript-syntax', {'for': ['javascript', 'javascript.jsx']}
    Plug 'maksimr/vim-jsbeautify', {'for': ['javascript']} "{{{
      nnoremap <leader>fjs :call JsBeautify()<cr>
    "}}}
    " Plug 'kchmck/vim-coffee-script', {'for': ['coffee']}
    Plug 'mmalecki/vim-node.js', {'for': ['javascript']}
    Plug 'othree/yajs.vim', {'for': ['javascript', 'javascript.jsx']}
    Plug 'othree/es.next.syntax.vim', {'for': ['javascript', 'javascript.jsx']}
    Plug 'othree/javascript-libraries-syntax.vim', {'for': ['javascript', 'javascript.jsx']}
    autocmd FileType javascript,javascript.jsx :hi Special ctermfg=9
    Plug 'isRuslan/vim-es6'
    Plug 'mxw/vim-jsx', {'for': ['javascript', 'javascript.jsx']} " {{{
      let g:jsx_ext_required = 0
    " }}}
  endif "}}}

  " if count(s:settings.plugin_groups, 'clojure') "{{{
  "   Plug 'guns/vim-clojure-static', {'for': ['clojure', 'clojurescript']}
  "   Plug 'kien/rainbow_parentheses.vim', {'for': ['clojure', 'clojurescript']}
  "   Plug 'guns/vim-clojure-highlight', {'for': ['clojure', 'clojurescript']}
  "   Plug 'tpope/vim-fireplace', {'for': ['clojure', 'clojurescript']}
  "   Plug 'bhurlow/vim-parinfer', {'for': ['clojure', 'clojurescript']}
  " endif "}}}

  if count(s:settings.plugin_groups, 'db') "{{{
    Plug 'khmelevskii/pgsql.vim', {'for': ['sql', 'php']} "{{{
      let g:sql_type_default = 'pgsql'
    "}}}
    Plug 'dbext.vim', {'for': ['sql', 'php']}
    Plug 'SQLComplete.vim', {'for': ['sql', 'php']} "{{{
      let g:omni_sql_include_owner = 0
    "}}}
  endif "}}}

  if count(s:settings.plugin_groups, 'scm') "{{{
    Plug 'tpope/vim-fugitive', {'on': ['Gstatus', 'Gdiff', 'Gcommit', 'Gblame', 'Glog', 'Git', 'Gwrite', 'Gremove']} "{{{
      nnoremap <silent> <leader>gs :Gstatus<CR>
      nnoremap <silent> <leader>gd :Gdiff<CR>
      nnoremap <silent> <leader>gc :Gcommit<CR>
      nnoremap <silent> <leader>gb :Gblame<CR>
      nnoremap <silent> <leader>gl :Glog<CR>
      nnoremap <silent> <leader>gp :Git push<CR>
      nnoremap <silent> <leader>gw :Gwrite<CR>
      nnoremap <silent> <leader>gr :Gremove<CR>
      autocmd FileType gitcommit nmap <buffer> U :Git checkout -- <C-r><C-g><CR>
      autocmd BufReadPost fugitive://* set bufhidden=delete
    "}}}
    Plug 'gregsexton/gitv', {'on': 'Gitv'} | Plug 'tpope/vim-fugitive' "{{{
      nnoremap <silent> <leader>gv :Gitv<CR>
      nnoremap <silent> <leader>gV :Gitv!<CR>
    "}}}
    Plug 'mhinz/vim-signify', {'on': 'SignifyToggle'} "{{{
      let g:signify_disable_by_default = 1
      nnoremap <silent> <leader>st :SignifyToggle<CR>
    "}}}
    Plug 'chrisbra/vim-diff-enhanced', {'on': ['Gdiff']}
  endif "}}}

  if count(s:settings.plugin_groups, 'unite') "{{{
    Plug 'Shougo/unite.vim' "{{{
      let g:unite_data_directory='~/.vim/.cache/unite'
      " let g:unite_enable_start_insert=0
      " let g:unite_source_history_yank_enable=1
      let g:unite_source_rec_max_cache_files=5000
      let g:unite_source_file_mru_filename_format = ""
      let g:unite_source_file_mru_time_format = ""
      let g:unite_source_buffer_time_format = ""
      let g:unite_source_grep_default_opts = "-HnEi"
        \ . " --exclude='*.svn*'"
        \ . " --exclude='*.log*'"
        \ . " --exclude='.sass-cache/**'"
        \ . " --exclude='*tmp*'"
        \ . " --exclude-dir='.svn'"
        \ . " --exclude-dir='.git'"
      let g:unite_prompt='» '

      if executable('ag')
        let g:unite_source_grep_command='ag'
        let g:unite_source_grep_default_opts='--nocolor --nogroup -S -C4'
        let g:unite_source_grep_recursive_opt=''
      elseif executable('ack')
        let g:unite_source_grep_command='ack'
        let g:unite_source_grep_default_opts='--no-heading --no-color -a -C4'
        let g:unite_source_grep_recursive_opt=''
      endif

      function! s:unite_settings()
        nmap <buffer> Q <plug>(unite_exit)
        nmap <buffer> <esc> <plug>(unite_exit)
        imap <buffer> <esc> <plug>(unite_exit)
      endfunction
      autocmd FileType unite call s:unite_settings()

      nmap <space> [unite]
      nnoremap [unite] <nop>

      nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -buffer-name=mixed file_rec/async buffer file_mru bookmark<cr><c-u>
      nnoremap <silent> [unite]f :<C-u>Unite -toggle -buffer-name=files file_rec/async<cr><c-u>
      nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<cr>
      nnoremap <silent> [unite]l :<C-u>Unite -buffer-name=line line<cr>
      nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=buffers buffer -no-start-insert<cr>
      nnoremap <silent> [unite]/ :<C-u>Unite -no-quit -buffer-name=search grep:.<cr>
      nnoremap <silent> [unite]m :<C-u>Unite -buffer-name=mappings mapping<cr>
      nnoremap <silent> [unite]s :<C-u>Unite -quick-match buffer<cr>
    "}}}
    Plug 'tsukkee/unite-tag' " {{{
      nnoremap <silent> [unite]t :<C-u>Unite -buffer-name=tag tag tag/file<cr>
    "}}}
    Plug 'Shougo/unite-outline' " {{{
      nnoremap <silent> [unite]o :<C-u>Unite -buffer-name=outline outline<cr>
    "}}}
    Plug 'Shougo/unite-help' " {{{
      nnoremap <silent> [unite]h :<C-u>Unite -buffer-name=help help<cr>
    "}}}
  endif "}}}

  if count(s:settings.plugin_groups, 'misc') "{{{
    " Plug 'kana/vim-vspec'
    Plug 'kennethzfeng/vim-raml'
    Plug 'xolox/vim-misc'
    Plug 'xolox/vim-notes' " {{{
      let g:notes_directories = ['~/Library/Mobile\ Documents/com\~apple\~CloudDocs/Notes']
      let g:notes_suffix = '.md'
      let g:notes_list_bullets = ['']
      let g:notes_conceal_url = 0
    " }}}
    Plug 'nginx.vim', {'for': ['nginx']} " {{{
      au BufNewFile,BufRead *.nginx.conf setf nginx
    " }}}
    Plug 'tpope/vim-scriptease', {'for': ['vim']}
    Plug 'tpope/vim-markdown', {'for': ['markdown']}
    if executable('redcarpet') && executable('instant-markdown-d')
      Plug 'suan/vim-instant-markdown', {'for':['markdown']}
    endif
    Plug 'guns/xterm-color-table.vim', {'on': 'XtermColorTable'}
    " Plug 'scrooloose/syntastic' "{{{
    "   set statusline+=%#warningmsg#
    "   set statusline+=%{SyntasticStatuslineFlag()}
    "   set statusline+=%*
    "
    "   let g:syntastic_check_on_open = 0
    "   let g:syntastic_check_on_wq = 0
    "   let g:syntastic_error_symbol = '✗'
    "   let g:syntastic_style_error_symbol = '✠'
    "   let g:syntastic_warning_symbol = '∆'
    "   let g:syntastic_style_warning_symbol = '≈'
    "   let g:syntastic_javascript_checkers = ['eslint']
    "   let g:syntastic_mode_map = { 'mode': 'active',
    "                            \ 'passive_filetypes': ['javascript'] }
    "   nnoremap <leader>ll :SyntasticCheck<cr>
    " "}}}
    Plug 'Shougo/vimshell.vim', {'on': ['VimShell', 'VimShellInteractive']} "{{{
      let g:vimshell_editor_command='vim'
      let g:vimshell_right_prompt='getcwd()'
      let g:vimshell_temporary_directory='~/.vim/.cache/vimshell'
      let g:vimshell_vimshrc_path='~/.vim/vimshrc'

      nnoremap <leader>c :VimShell -split<cr>
      nnoremap <leader>cc :VimShellPop -split<cr>
      nnoremap <leader>cn :VimShellInteractive node<cr>
      nnoremap <leader>cl :VimShellInteractive lua<cr>
      nnoremap <leader>cr :VimShellInteractive irb<cr>
      nnoremap <leader>cp :VimShellInteractive python<cr>
    "}}}
    Plug 'diepm/vim-rest-console', {'for': ['rest']}
    nnoremap <leader>nbu :Unite neobundle/update -vertical -no-start-insert<cr>
  endif
"}}}
"}}}


" mappings {{{
  " formatting shortcuts
  nmap <leader>fef :call Preserve("normal gg=G")<CR>
  nmap <leader>f$ :call StripTrailingWhitespace()<CR>

  " toggle paste
  map <F6> :set invpaste<CR>:set paste?<CR>

  " smash escape
  inoremap jk <esc>
  inoremap kj <esc>

  " Open current directory in Finder
  nmap <leader>p :execute "silent !open " . expand('%:p:h')<cr>:redraw!<cr>

  " insert path of current file into a command
  cmap <c-p> <c-r>=expand("%:p:h") . "/" <cr>

  " save with ,,
  inoremap <leader>, <esc>:w<cr>
  nnoremap <leader>, :w<cr>

  " save readonly files with w!!
  cmap w!! w !sudo tee % >/dev/null

  " exit
  nmap <leader>q :qa<cr>
  imap <leader>q <Esc>:qa<cr>

  " better comand-line editing
  cnoremap <C-a> <Home>
  cnoremap <C-e> <End>

  inoremap <C-u> <C-g>u<C-u>

  if mapcheck('<space>/') == ''
    nnoremap <space>/ :vimgrep //gj **/*<left><left><left><left><left><left><left><left>
  endif

  " sane regex {{{
    nnoremap / /\v
    vnoremap / /\v
    nnoremap ? ?\v
    vnoremap ? ?\v
    nnoremap :s/ :s/\v
  " }}}

  " command-line window {{{
    nnoremap q: q:i
    nnoremap q/ q/i
    nnoremap q? q?i
  " }}}

  " folds {{{
    nnoremap zr zr:echo &foldlevel<cr>
    nnoremap zm zm:echo &foldlevel<cr>
    nnoremap zR zR:echo &foldlevel<cr>
    nnoremap zM zM:echo &foldlevel<cr>
  " }}}

  " screen line scroll
  nnoremap <silent> j gj
  nnoremap <silent> k gk

  " swaps ' ` for easier bookmark return
  nnoremap ' `
  nnoremap ` '

  " swap ; : for easier commands
  nnoremap ; :

  " reselect visual block after indent
  vnoremap < <gv
  vnoremap > >gv

  " visual select current line
  nmap vil ^v$h

  " reselect last paste
  nnoremap <expr> gV '`[' . strpart(getregtype(), 0, 1) . '`]'

  " find current word in quickfix
  nnoremap <leader>fw :execute "vimgrep ".expand("<cword>")." %"<cr>:copen<cr>
  " find last search in quickfix
  nnoremap <leader>ff :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>

  " shortcuts {{{
    nnoremap <leader>v <C-w>v<C-w>l
    " nnoremap <leader>s <C-w>s
    nnoremap <leader>vsa :vert sba<cr>
  "}}}

  " tab shortcuts
  " inoremap <C-h> <c-o>gT
  " inoremap <C-l> <c-o>gt
  " nmap <C-h> gT
  " nmap <C-l> gt
  "
  " " New tab
  " inoremap <C-t> <c-o>:tabnew<cr>
  " nmap <C-t> :tabnew<CR>

  " Close tab and set focus on previous tab
  " inoremap <C-b> <c-o>:call CloseTab()<cr>
  " nmap <C-b> :call CloseTab()<cr>

  " goto the last active tab
  let g:lasttab = 1
  nmap <leader>l :exe "tabn ".g:lasttab<CR>
  au TabLeave * let g:lasttab = tabpagenr()

  " fast window switching
  map <c-w> <C-W>w

  " cycle between buffers
  map <leader>. :b#<cr>

  " g[bB] in command mode switch to the next/prev. buffer
  nmap <c-k> :bnext<cr>
  nmap <c-j> :bprev<cr>

  " gz in command mode closes the current buffer
  " map <c-x> :bdelete<cr>
  map gz :bdelete<cr>

  " Make current window the only one
  noremap <leader>o :only<CR>i

  " make Y consistent with C and D. See :help Y.
  nnoremap Y y$

  " yank entire file (global yank)
  nmap gy ggVGy

  " Delete current line without copy
  nmap <c-e> "_dd

  " delete word under cursor
  imap <leader>d <c-o>diw

  " clone current line
  imap <c-d> <esc>yypi

  " hide annoying quit message
  nnoremap <C-c> <C-c>:echo<cr>

  " window killer
  nnoremap <silent> Q :call CloseWindowOrKillBuffer()<cr>

  " if neobundle#is_sourced('vim-dispatch')
  "   nnoremap <leader>tag :Dispatch ctags -R<cr>
  " endif

  " general
  nnoremap <BS> :set hlsearch! hlsearch?<cr>

  map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
        \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
        \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

  " helpers for profiling {{{
    nnoremap <silent> <leader>DD :exe ":profile start profile.log"<cr>:exe ":profile func *"<cr>:exe ":profile file *"<cr>
    nnoremap <silent> <leader>DP :exe ":profile pause"<cr>
    nnoremap <silent> <leader>DC :exe ":profile continue"<cr>
    nnoremap <silent> <leader>DQ :exe ":profile pause"<cr>:noautocmd qall!<cr>
  "}}}
"}}}


" commands {{{
  command! -bang Q q<bang>
  command! -bang QA qa<bang>
  command! -bang Qa qa<bang>
"}}}


" autocmd {{{
  " go back to previous position of cursor if any
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \  exe 'normal! g`"zvzz' |
    \ endif

  autocmd FileType css,scss setlocal foldmethod=indent
  autocmd FileType css,scss setlocal foldnestmax=2
  " autocmd FileType css,scss nnoremap <silent> <leader>S vi{:sort<CR>
  autocmd FileType python setlocal foldmethod=indent
  autocmd FileType markdown setlocal nofoldenable
  autocmd FileType vim setlocal fdm=marker keywordprg=:help
"}}}


" color schemes {{{
  Plug 'altercation/vim-colors-solarized' "{{{
    set background=dark
    let g:solarized_contrast = "high"
    let g:solarized_visibility = "high"
    let g:solarized_termtrans = 1
    " let g:solarized_degrade = 1
    " let g:solarized_termcolors=256
  "}}}
"}}}


" russion keyboard {{{
  " set keymap=russian-jcuken
  " set iminsert=0
  " set imsearch=0

  " function MyKeyMapHighlight()
  "   if &iminsert == 0
  "     hi airline_x ctermfg=DarkBlue guifg=DarkBlue
  "   else
  "     hi airline_x ctermfg=DarkRed guifg=DarkRed
  "   endif
  " endfunction
  "
  " call MyKeyMapHighlight()
  "
  " hi airline_tabmod ctermbg=5 guibg=DarkBlue
  " hi airline_c ctermbg=2 guibg=DarkBlue
  " hi airline_x ctermbg=2 guibg=DarkBlue
  " hi airline_x_inactive ctermbg=2 guibg=DarkBlue
  " au WinEnter * :call MyKeyMapHighlight()
"}}}


" finish loading {{{
  " Add plugins to &runtimepath
  call plug#end()

  exec 'colorscheme ' . s:settings.colorscheme

  hi SignColumn ctermbg=0
  hi MatchParen ctermfg=2 ctermbg=none
  hi SpecialKey ctermfg=5 ctermbg=none cterm=none
"}}}
