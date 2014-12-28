" initialize default settings
let s:settings = {}
let s:settings.default_indent = 2
let s:settings.max_column = 80
let s:settings.enable_cursorcolumn = 0
let s:settings.colorscheme = 'solarized'

let s:settings.plugin_groups = []
call add(s:settings.plugin_groups, 'core')
call add(s:settings.plugin_groups, 'web')
call add(s:settings.plugin_groups, 'javascript')
call add(s:settings.plugin_groups, 'db')
call add(s:settings.plugin_groups, 'scm')
call add(s:settings.plugin_groups, 'autocomplete')
call add(s:settings.plugin_groups, 'editing')
call add(s:settings.plugin_groups, 'navigation')
call add(s:settings.plugin_groups, 'unite')
call add(s:settings.plugin_groups, 'textobj')
call add(s:settings.plugin_groups, 'misc')

" setup & neobundle {{{
  set nocompatible
  set all& "reset everything to their defaults
  set rtp+=~/.vim/bundle/neobundle.vim
  call neobundle#begin(expand('~/.vim/bundle/'))
  NeoBundleFetch 'Shougo/neobundle.vim'
  call neobundle#end()
"}}}

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
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store

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
"}}}

" ui configuration {{{
  set showmatch              "automatically highlight matching braces/brackets/etc.
  set matchtime=2            "tens of a second to show matching parentheses
  set nonumber
  set ruler         " Показываем положение курсора все время
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
  set nocursorline  " not highlights the cursor line
  set lazyredraw
  set laststatus=2
  set noshowmode
  set foldenable             "enable folds by default
  set fdm=marker      "fold via syntax of files
  set fdl=0      "open all folds by default
  let g:xml_syntax_folding=1 "enable xml folding
  set title

  " set cursorline
  " autocmd WinLeave * setlocal nocursorline
  " autocmd WinEnter * setlocal cursorline
  let &colorcolumn=s:settings.max_column
  if s:settings.enable_cursorcolumn
    set cursorcolumn
    autocmd WinLeave * setlocal nocursorcolumn
    autocmd WinEnter * setlocal cursorcolumn
  endif

  if has('conceal')
    set conceallevel=1
    set listchars+=conceal:Δ
  endif

  if $TERM_PROGRAM == 'iTerm.app'
    " different cursors for insert vs normal mode
    if exists('$TMUX')
      let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
      let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    else
      let &t_SI = "\<Esc>]50;CursorShape=1\x7"
      let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    endif
  endif
"}}}

" plugin/mapping configuration {{{
  if count(s:settings.plugin_groups, 'core') "{{{
    NeoBundle 'matchit.zip'
    NeoBundle 'bling/vim-airline' "{{{
      let g:airline_powerline_fonts = 1
      let g:airline#extensions#tabline#enabled = 1
      let g:airline#extensions#tabline#left_sep=' '
      let g:airline#extensions#tabline#left_alt_sep='¦'
    "}}}
    NeoBundle 'tpope/vim-surround'
    NeoBundle 'tpope/vim-repeat'
    NeoBundle 'tpope/vim-dispatch'
    NeoBundle 'embear/vim-localvimrc' "{{{
      let g:localvimrc_ask = 0
      let g:localvimrc_sandbox = 0
    "}}}
    NeoBundle 'tpope/vim-unimpaired' "{{{
      nmap <c-up> [e
      nmap <c-down> ]e
      vmap <c-up> [egv
      vmap <c-down> ]egv
    "}}}
    NeoBundle 'Shougo/vimproc.vim', {
      \ 'build': {
        \ 'mac': 'make -f make_mac.mak',
        \ 'unix': 'make -f make_unix.mak',
        \ 'cygwin': 'make -f make_cygwin.mak',
        \ 'windows': '"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\nmake.exe" make_msvc32.mak',
      \ },
    \ }
  endif "}}}

  if count(s:settings.plugin_groups, 'web') "{{{
    NeoBundle 'khmelevskii/uwinutils.vim' "{{{
      nnoremap gs :FindCssProperty<cr>
    "}}}
    NeoBundleLazy 'cakebaker/scss-syntax.vim', {'autoload':{'filetypes':['scss','sass']}}
    NeoBundleLazy 'hail2u/vim-css3-syntax', {'autoload':{'filetypes':['css','scss','sass']}}
    NeoBundleLazy 'ap/vim-css-color', {'autoload':{'filetypes':['css','scss','sass','less','styl']}}
    NeoBundleLazy 'othree/html5.vim', {'autoload':{'filetypes':['html', 'smarty']}}
    NeoBundle 'wavded/vim-stylus'
    NeoBundleLazy 'digitaltoad/vim-jade', {'autoload':{'filetypes':['jade', 'smarty']}}
    NeoBundleLazy 'juvenn/mustache.vim', {'autoload':{'filetypes':['mustache', 'smarty']}}
    " NeoBundleLazy 'gregsexton/MatchTag', {'autoload':{'filetypes':['html','xml', 'smarty']}}
    NeoBundleLazy 'gcmt/breeze.vim', {'autoload':{'filetypes':['html','xml', 'smarty']}}
    NeoBundleLazy 'xml.vim', {'autoload':{'filetypes':['xml','xsl','xslt','xsd']}}
    NeoBundleLazy 'mattn/emmet-vim', {'autoload':{'filetypes':['html','smarty','xml','xsl','xslt','xsd','css','sass','scss','less','mustache']}} "{{{
      function! s:zen_html_tab()
        let line = getline('.')
        if match(line, '<.*>') < 0
          return "\<c-y>,"
        endif
        return "\<c-y>n"
      endfunction
      autocmd FileType xml,xsl,xslt,xsd,css,sass,scss,less,mustache imap <buffer><c-e> <c-y>,
      autocmd FileType html,smarty imap <buffer><expr><c-e> <sid>zen_html_tab()
    "}}}
  endif "}}}

  if count(s:settings.plugin_groups, 'javascript') "{{{
    NeoBundleLazy 'marijnh/tern_for_vim', {
      \ 'autoload': { 'filetypes': ['javascript'] },
      \ 'build': {
        \ 'mac': 'npm install',
        \ 'unix': 'npm install',
        \ 'cygwin': 'npm install',
        \ 'windows': 'npm install',
      \ },
    \ }
    NeoBundleLazy 'pangloss/vim-javascript', {'autoload':{'filetypes':['javascript']}}
    NeoBundleLazy 'maksimr/vim-jsbeautify', {'autoload':{'filetypes':['javascript']}} "{{{
      nnoremap <leader>fjs :call JsBeautify()<cr>
    "}}}
    NeoBundleLazy 'leafgarland/typescript-vim', {'autoload':{'filetypes':['typescript']}}
    NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload':{'filetypes':['coffee']}}
    NeoBundleLazy 'mmalecki/vim-node.js', {'autoload':{'filetypes':['javascript']}}
    NeoBundleLazy 'leshill/vim-json', {'autoload':{'filetypes':['javascript','json']}}
    NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {'autoload':{'filetypes':['javascript','coffee','ls','typescript']}}
  endif "}}}

  if count(s:settings.plugin_groups, 'db') "{{{
    NeoBundleLazy 'khmelevskii/pgsql.vim', {'autoload':{'filetypes':['sql']}} "{{{
      let g:sql_type_default = 'pgsql'
    "}}}
    NeoBundleLazy 'dbext.vim', {'autoload':{'filetypes':['sql']}}
    NeoBundleLazy 'SQLComplete.vim', {'autoload':{'filetypes':['sql']}} "{{{
      let g:omni_sql_include_owner = 0
    "}}}
  endif "}}}

  if count(s:settings.plugin_groups, 'scm') "{{{
    NeoBundle 'mhinz/vim-signify' "{{{
      let g:signify_disable_by_default = 1
      nnoremap <silent> <leader>st :SignifyToggle<CR>
      " let g:signify_update_on_bufenter=0
    "}}}
    NeoBundle 'tpope/vim-fugitive' "{{{
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
    NeoBundleLazy 'gregsexton/gitv', {'depends':['tpope/vim-fugitive'], 'autoload':{'commands':'Gitv'}} "{{{
      nnoremap <silent> <leader>gv :Gitv<CR>
      nnoremap <silent> <leader>gV :Gitv!<CR>
    "}}}
  endif "}}}

  if count(s:settings.plugin_groups, 'autocomplete') "{{{
    if !has("gui_running")
      NeoBundle 'Valloric/YouCompleteMe', {'vim_version':'7.3.584'} "{{{
        let g:ycm_complete_in_comments_and_strings=1
        let g:ycm_seed_identifiers_with_syntax=1
        let g:ycm_key_list_select_completion=['<C-n>', '<Down>', '<tab>']
        let g:ycm_key_list_previous_completion=['<C-p>', '<Up>', '<s-tab>']
        let g:ycm_filetype_blacklist={'unite': 1}
      "}}}
    endif
    NeoBundle 'SirVer/ultisnips' "{{{
      let g:UltiSnipsListSnippets="<c-x>"
      let g:UltiSnipsExpandTrigger="<c-a>"
      let g:UltiSnipsJumpForwardTrigger="<c-a>"
      let g:UltiSnipsJumpBackwardTrigger="<c-l>"
      let g:UltiSnipsSnippetDirectories=["UltiSnips", "bundle/uwin-snippets"]
    "}}}
    NeoBundle 'honza/vim-snippets'
  endif "}}}

  if count(s:settings.plugin_groups, 'editing') "{{{
    NeoBundle 'editorconfig/editorconfig-vim'
    NeoBundle 'tpope/vim-endwise'
    NeoBundle 'tpope/vim-speeddating'
    NeoBundle 'tomtom/tcomment_vim'
    NeoBundle 'terryma/vim-expand-region'
    NeoBundle '907th/vim-auto-save' "{{{
      let g:auto_save_no_updatetime = 1
      let g:auto_save_in_insert_mode = 0
      let g:auto_save = 1
    "}}}
    NeoBundle 'terryma/vim-multiple-cursors' "{{{
      let g:multi_cursor_next_key='<c-m>'
      let g:multi_cursor_prev_key='<c-l>'
    "}}}
    NeoBundle 'chrisbra/NrrwRgn'
    NeoBundle 'YankRing.vim'
    NeoBundleLazy 'AndrewRadev/switch.vim', {'autoload':{'commands':'Switch'}} "{{{
      nnoremap - :Switch<cr>
      let g:variable_style_switch_definitions =
            \[
            \ ['up', 'down'],
            \ ['height', 'width'],
            \ ['after', 'before'],
            \ ['new', 'old'],
            \ ['top', 'right', 'bottom', 'left']
            \]
      autocmd FileType sql let b:switch_custom_definitions =
            \[
            \ ['insert', 'update', 'delete'],
            \ ['dm_ref', 'dm_ref_nn'],
            \ ['dm_bool', 'dm_bool_true', 'dm_bool_false'],
            \ ['dm_date', 'dm_date_nn', 'dm_date_now', 'dm_date_now_nn'],
            \ ['dm_time', 'dm_time_nn', 'dm_time_now', 'dm_time_now_nn'],
            \ ['dm_datetime', 'dm_datetime_nn', 'dm_datetime_now', 'dm_datetime_now_nn'],
            \ ['dm_text_micro', 'dm_text_micro_nn'],
            \ ['dm_text_mini', 'dm_text_mini_nn'],
            \ ['dm_text_small', 'dm_text_small_nn'],
            \ ['dm_text_medium', 'dm_text_medium_nn'],
            \ ['dm_text_large', 'dm_text_large_nn'],
            \ ['dm_text_xlarge', 'dm_text_xlarge_nn'],
            \ ['dm_text_xxlarge', 'dm_text_xxlarge_nn'],
            \ ['dm_text', 'dm_text_nn'],
            \ ['dm_password', 'dm_password_nn'],
            \ ['dm_color', 'dm_color_nn'],
            \ ['dm_email', 'dm_email_nn'],
            \ ['dm_int', 'dm_int_nn', 'dm_float', 'dm_float_nn'],
            \ ['dm_int_range', 'dm_int_range_nn', 'dm_float_range', 'dm_float_range_nn'],
            \ ['dm_date_range', 'dm_date_range_nn', 'dm_datetime_range', 'dm_datetime_range_nn'],
            \ ['dm_interval_year', 'dm_interval_year_nn', 'dm_interval_month', 'dm_interval_month_nn', 'dm_interval_day', 'dm_interval_day_nn'],
            \ ['dm_interval_hour', 'dm_interval_hour_nn', 'dm_interval_minute', 'dm_interval_minute_nn', 'dm_interval_second', 'dm_interval_second_nn'],
            \ ['dm_tel', 'dm_tel_nn'],
            \ ['dm_url', 'dm_url_nn'],
            \ ['dm_enum', 'dm_enum_nn'],
            \ ['dm_file', 'dm_file_nn', 'dm_image', 'dm_image_nn'],
            \ ['dm_gps', 'dm_gps_nn'],
            \ ['dm_typeahead', 'dm_typeahead_nn'],
            \ ['dm_typeahead_list', 'dm_typeahead_list_nn'],
            \ ['dm_name', 'dm_name_nn'],
            \ ['dm_meta_title', 'dm_meta_title_nn'],
            \ ['dm_meta_description', 'dm_meta_description_nn'],
            \ ['dm_meta_keywords', 'dm_meta_keywords_nn'],
            \ ['dm_description', 'dm_description_nn'],
            \ ['dm_count', 'dm_count_nn'],
            \ ['dm_cost_nn', 'dm_cost'],
            \ ['dm_address', 'dm_address_nn'],
            \ ['sql', 'plpgsql']
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
    NeoBundleLazy 'godlygeek/tabular', {'autoload':{'commands':'Tabularize'}} "{{{
      nmap <Leader>a& :Tabularize /&<CR>
      vmap <Leader>a& :Tabularize /&<CR>
      nmap <Leader>a= :Tabularize /=<CR>
      vmap <Leader>a= :Tabularize /=<CR>
      nmap <Leader>a: :Tabularize /:<CR>
      vmap <Leader>a: :Tabularize /:<CR>
      nmap <Leader>a:: :Tabularize /:\zs<CR>
      vmap <Leader>a:: :Tabularize /:\zs<CR>
      nmap <Leader>a, :Tabularize /,<CR>
      vmap <Leader>a, :Tabularize /,<CR>
      nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
      vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
      nmap <Leader>tb :Tab /^\s*\w*<CR>
      vmap <Leader>tb :Tab /^\s*\w*<CR>
    "}}}
    " NeoBundle 'jiangmiao/auto-pairs'
    NeoBundle 'skwp/vim-easymotion' "{{{
      let g:EasyMotion_keys = 'asdfghjklqwertyuiopzxcvbnm'
      autocmd ColorScheme * highlight EasyMotionTarget ctermfg=32 guifg=#0087df
      autocmd ColorScheme * highlight EasyMotionShade ctermfg=237 guifg=#3a3a3a
    "}}}
  endif "}}}

  if count(s:settings.plugin_groups, 'navigation') "{{{
    NeoBundle 'mileszs/ack.vim' "{{{
      " if executable('ag')
      let g:ackprg = "ack"
      "ag --nogroup --column --smart-case --follow"
      " endif
    "}}}
    NeoBundleLazy 'mbbill/undotree', {'autoload':{'commands':'UndotreeToggle'}} "{{{
      let g:undotree_SplitLocation='botright'
      let g:undotree_SetFocusWhenToggle=1
      nnoremap <silent> <F5> :UndotreeToggle<CR>
    "}}}
    NeoBundleLazy 'EasyGrep', {'autoload':{'commands':'GrepOptions'}} "{{{
      let g:EasyGrepRecursive=1
      let g:EasyGrepAllOptionsInExplorer=1
      let g:EasyGrepCommand=1
      nnoremap <leader>vo :GrepOptions<cr>
    "}}}
    NeoBundle 'kien/ctrlp.vim', { 'depends': 'tacahiroy/ctrlp-funky' } "{{{
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
        \ 'dir':  '\v[\/](node_modules|build|bin|components|css|img|static-servers)$',
        \ }
      if executable('ag')
        let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
      endif

      let g:ctrlp_map = '<c-z>'
      nmap \ [ctrlp]
      nnoremap [ctrlp] <nop>

      nnoremap [ctrlp]t :CtrlPBufTag<cr>
      nnoremap [ctrlp]T :CtrlPTag<cr>
      nnoremap [ctrlp]l :CtrlPLine<cr>
      nnoremap [ctrlp]o :CtrlPFunky<cr>
      nnoremap [ctrlp]b :CtrlPBuffer<cr>
    "}}}
    NeoBundleLazy 'scrooloose/nerdtree', {'autoload':{'commands':['NERDTreeToggle','NERDTreeFind']}} "{{{
      let NERDTreeShowHidden=0
      let NERDTreeQuitOnOpen=1
      let NERDTreeShowLineNumbers=0
      let NERDTreeChDirMode=0
      let NERDTreeShowBookmarks=1
      let NERDTreeIgnore=['\.git','\.hg', '\.sass-cache']
      " let NERDTreeBookmarksFile='~/.vim/.cache/NERDTreeBookmarks'
      nnoremap <F2> :NERDTreeToggle<CR>
      nnoremap <F3> :NERDTreeFind<CR>
    "}}}
  endif "}}}

  if count(s:settings.plugin_groups, 'unite') "{{{
    NeoBundle 'Shougo/unite.vim' "{{{
      let bundle = neobundle#get('unite.vim')
      function! bundle.hooks.on_source(bundle)
        call unite#filters#matcher_default#use(['matcher_fuzzy'])
        call unite#filters#sorter_default#use(['sorter_rank'])
        call unite#set_profile('files', 'smartcase', 1)
        call unite#custom#source('line,outline','matchers','matcher_fuzzy')
      endfunction
      let g:airline_section_b='%{airline#util#wrap(airline#extensions#branch#get_head(),0)}'
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
    NeoBundleLazy 'osyo-manga/unite-airline_themes', {'autoload':{'unite_sources':'airline_themes'}} "{{{
      nnoremap <silent> [unite]a :<C-u>Unite -winheight=10 -auto-preview -buffer-name=airline_themes airline_themes<cr>
    "}}}
    NeoBundleLazy 'ujihisa/unite-colorscheme', {'autoload':{'unite_sources':'colorscheme'}} "{{{
      nnoremap <silent> [unite]c :<C-u>Unite -winheight=10 -auto-preview -buffer-name=colorschemes colorscheme<cr>
    "}}}
    NeoBundleLazy 'tsukkee/unite-tag', {'autoload':{'unite_sources':['tag','tag/file']}} "{{{
      nnoremap <silent> [unite]t :<C-u>Unite -buffer-name=tag tag tag/file<cr>
    "}}}
    NeoBundleLazy 'Shougo/unite-outline', {'autoload':{'unite_sources':'outline'}} "{{{
      nnoremap <silent> [unite]o :<C-u>Unite -buffer-name=outline outline<cr>
    "}}}
    NeoBundleLazy 'Shougo/unite-help', {'autoload':{'unite_sources':'help'}} "{{{
      nnoremap <silent> [unite]h :<C-u>Unite -buffer-name=help help<cr>
    "}}}
    NeoBundleLazy 'Shougo/junkfile.vim', {'autoload':{'commands':'JunkfileOpen','unite_sources':['junkfile','junkfile/new']}} "{{{
      let g:junkfile#directory=expand("~/.vim/.cache/junk")
      nnoremap <silent> [unite]j :<C-u>Unite -buffer-name=junk junkfile junkfile/new<cr>
    "}}}
  endif "}}}

  if count(s:settings.plugin_groups, 'textobj') "{{{
    NeoBundle 'kana/vim-textobj-user'
    NeoBundle 'kana/vim-textobj-indent'
    NeoBundle 'kana/vim-textobj-entire'
    NeoBundle 'lucapette/vim-textobj-underscore'
  endif "}}}

  if count(s:settings.plugin_groups, 'misc') "{{{
    NeoBundle 'kana/vim-vspec'
    NeoBundleLazy 'nginx.vim', {
      \ 'autoload': { 'filetypes': ['nginx'] },
    \ }
    au BufNewFile,BufRead *.nginx.conf setf nginx
    NeoBundleLazy 'Rykka/riv.vim', {
      \ 'autoload': { 'filetypes': ['rst'] },
    \ }
    au BufNewFile,BufRead *.sphinx.conf setf rst
    NeoBundleLazy 'tpope/vim-scriptease', {'autoload':{'filetypes':['vim']}}
    NeoBundleLazy 'tpope/vim-markdown', {'autoload':{'filetypes':['markdown']}}
    if executable('redcarpet') && executable('instant-markdown-d')
      NeoBundleLazy 'suan/vim-instant-markdown', {'autoload':{'filetypes':['markdown']}}
    endif
    NeoBundleLazy 'guns/xterm-color-table.vim', {'autoload':{'commands':'XtermColorTable'}}
    NeoBundle 'chrisbra/vim_faq'
    NeoBundle 'vimwiki'
    NeoBundle 'bufkill.vim'
    " NeoBundle 'mhinz/vim-startify' "{{{
    "   let g:startify_session_dir = '~/.vim/.cache/sessions'
    "   let g:startify_change_to_vcs_root = 1
    "   let g:startify_show_sessions = 0
    "   nnoremap <F1> :Startify<cr>
    " "}}}
    NeoBundle 'scrooloose/syntastic' "{{{
      let g:syntastic_error_symbol = '✗'
      let g:syntastic_style_error_symbol = '✠'
      let g:syntastic_warning_symbol = '∆'
      let g:syntastic_style_warning_symbol = '≈'
    "}}}
    NeoBundleLazy 'mattn/gist-vim', { 'depends': 'mattn/webapi-vim', 'autoload': { 'commands': 'Gist' } } "{{{
      let g:gist_post_private=1
      let g:gist_show_privates=1
    "}}}
    NeoBundleLazy 'Shougo/vimshell.vim', {'autoload':{'commands':[ 'VimShell', 'VimShellInteractive' ]}} "{{{
      let g:vimshell_editor_command='vim'
      let g:vimshell_right_prompt='getcwd()'
      let g:vimshell_temporary_directory='~/.vim/.cache/vimshell'
      let g:vimshell_vimshrc_path='~/.vim/vimshrc'

      nnoremap <leader>c :VimShell -split<cr>
      nnoremap <leader>cc :VimShell -split<cr>
      nnoremap <leader>cn :VimShellInteractive node<cr>
      nnoremap <leader>cl :VimShellInteractive lua<cr>
      nnoremap <leader>cr :VimShellInteractive irb<cr>
      nnoremap <leader>cp :VimShellInteractive python<cr>
    "}}}
    NeoBundleLazy 'zhaocai/GoldenView.Vim', {'autoload':{'mappings':['<Plug>ToggleGoldenViewAutoResize']}} "{{{
      let g:goldenview__enable_default_mapping=0
      nmap <F4> <Plug>ToggleGoldenViewAutoResize
    "}}}

    nnoremap <leader>nbu :Unite neobundle/update -vertical -no-start-insert<cr>
  endif
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

  " " auto center {{{
  "   nnoremap <silent> n nzz
  "   nnoremap <silent> N Nzz
  "   nnoremap <silent> * *zz
  "   nnoremap <silent> # #zz
  "   nnoremap <silent> g* g*zz
  "   nnoremap <silent> g# g#zz
  "   nnoremap <silent> <C-o> <C-o>zz
  "   nnoremap <silent> <C-i> <C-i>zz
  " "}}}

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
  inoremap <C-h> <c-o>gT
  inoremap <C-l> <c-o>gt
  nmap <C-h> gT
  nmap <C-l> gt

  " New tab
  inoremap <C-t> <c-o>:tabnew<cr>
  nmap <C-t> :tabnew<CR>

  " Close tab and set focus on previous tab
  inoremap <C-b> <c-o>:call CloseTab()<cr>
  nmap <C-b> :call CloseTab()<cr>

  " goto the last active tab
  let g:lasttab = 1
  nmap <leader>l :exe "tabn ".g:lasttab<CR>
  au TabLeave * let g:lasttab = tabpagenr()

  " fast window switching
  map <c-w> <C-W>w

  " cycle between buffers
  map <leader>. :b#<cr>

  " g[bB] in command mode switch to the next/prev. buffer
  map gb :bnext<cr>
  map gB :bprev<cr>

  " gz in command mode closes the current buffer
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

  if neobundle#is_sourced('vim-dispatch')
    nnoremap <leader>tag :Dispatch ctags -R<cr>
  endif

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

  autocmd FileType js,scss,css autocmd BufWritePre <buffer> call StripTrailingWhitespace()
  autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
  autocmd FileType css,scss nnoremap <silent> <leader>S vi{:sort<CR>
  autocmd FileType python setlocal foldmethod=indent
  autocmd FileType markdown setlocal nolist
  autocmd FileType vim setlocal fdm=marker keywordprg=:help
"}}}

" color schemes {{{
  NeoBundle 'altercation/vim-colors-solarized' "{{{
    set background=dark
    let g:solarized_contrast = "high"
    let g:solarized_visibility = "high"
  "}}}

  exec 'colorscheme '.s:settings.colorscheme
"}}}

" finish loading {{{
  if exists('g:dotvim_settings.disabled_plugins')
    for plugin in g:dotvim_settings.disabled_plugins
      exec 'NeoBundleDisable '.plugin
    endfor
  endif

  filetype plugin indent on
  syntax enable
  hi SignColumn ctermbg=0
  hi MatchParen ctermfg=2 ctermbg=none
  hi SpecialKey ctermfg=5 ctermbg=none cterm=none
  NeoBundleCheck
"}}}
