set nocompatible
filetype off

" Check Vundle is installed
if !empty(glob('~/.vim/bundle/Vundle.vim'))
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    " alternatively, pass a path where Vundle should install plugins
    "call vundle#begin('~/some/path/here')

    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'

    Plugin 'SirVer/ultisnips'
    Plugin 'tomtom/tcomment_vim'
    Plugin 'tpope/vim-surround'
    Plugin 'https://github.com/rust-lang/rust.vim'
    Plugin 'https://github.com/msteinert/vim-ragel'
    Plugin 'https://github.com/michaeljsmith/vim-indent-object'
    Plugin 'https://github.com/haya14busa/incsearch.vim'
    Plugin 'https://github.com/altercation/vim-colors-solarized'
    Plugin 'https://github.com/easymotion/vim-easymotion'
    Plugin 'https://github.com/cespare/vim-toml'
    Plugin 'https://github.com/leafgarland/typescript-vim'

    " All of your Plugins must be added before the following line
    call vundle#end()            " required
endif
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" From: https://wiki.archlinux.org/index.php/vim/.vimrc
" .vimrc
" See: http://vimdoc.sourceforge.net/htmldoc/options.html for details

" For multi-byte character support (CJK support, for example):
"set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,gb18030,latin1

set nowrap          " Don't wrap long lines

set tabstop=4       " Number of spaces that a <Tab> in the file counts for.

set shiftwidth=4    " Number of spaces to use for each step of (auto)indent.

set expandtab       " Use the appropriate number of spaces to insert a <Tab>.
                    " Spaces are used in indents with the '>' and '<' commands
                    " and when 'autoindent' is on. To insert a real tab when
                    " 'expandtab' is on, use CTRL-V <Tab>.

set smarttab        " When on, a <Tab> in front of a line inserts blanks
                    " according to 'shiftwidth'. 'tabstop' is used in other
                    " places. A <BS> will delete a 'shiftwidth' worth of space
                    " at the start of the line.

set showcmd         " Show (partial) command in status line.

set relativenumber  " Show relative line numbers, except on the current line,
set number          " which will show the current line number

set showmatch       " When a bracket is inserted, briefly jump to the matching
                    " one. The jump is only done if the match can be seen on the
                    " screen. The time to show the match can be set with
                    " 'matchtime'.

set hlsearch        " When there is a previous search pattern, highlight all
                    " its matches.

set incsearch       " While typing a search command, show immediately where the
                    " so far typed pattern matches.

set ignorecase      " Ignore case in search patterns.

set smartcase       " Override the 'ignorecase' option if the search pattern
                    " contains upper case characters.

set backspace=2     " Influences the working of <BS>, <Del>, CTRL-W
                    " and CTRL-U in Insert mode. This is a list of items,
                    " separated by commas. Each item allows a way to backspace
                    " over something.

set autoindent      " Copy indent from current line when starting a new line
                    " (typing <CR> in Insert mode or when using the "o" or "O"
                    " command).

set textwidth=79    " Maximum width of text that is being inserted. A longer
                    " line will be broken after white space to get this width.

set formatoptions=c,q,r,t " This is a sequence of letters which describes how
                    " automatic formatting is to be done.
                    "
                    " letter    meaning when present in 'formatoptions'
                    " ------    ---------------------------------------
                    " c         Auto-wrap comments using textwidth, inserting
                    "           the current comment leader automatically.
                    " q         Allow formatting of comments with "gq".
                    " r         Automatically insert the current comment leader
                    "           after hitting <Enter> in Insert mode.
                    " t         Auto-wrap text using textwidth (does not apply
                    "           to comments)

set ruler           " Show the line and column number of the cursor position,
                    " separated by a comma.
set mouse=a         " Enable the use of the mouse.

set laststatus=2
set tags=./tags;
" Use unnamedplus to set the clipboard to the + (shared between vim sessions)
" register
set clipboard=unnamed

"Make history persistent:
set history=500
set viminfo=%,'20,/100,:100,<500,f1,n~/.vim/viminfo

filetype off

" Allow use of <C-Q> and <C-S> by stopping the TTY from capturing them
" silent !stty -ixon > /dev/null 2>/dev/null
" This doesn't work..
" au VimLeave * !stty ixon > /dev/null 2>/dev/null

if has('nvim')
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
    let g:solarized_italic=0
    let g:solarized_termcolors=16
    let g:solarized_style="dark"
    let g:solarized_contrast="high"
    set rtp^=/usr/share/vim/vimfiles/
endif

" Do this after adding the old vimfiles to rtp; else plugins may not work
" correctly
filetype plugin indent on

" Solarized options
" TODO: can these settings be moved to ~/.vim/after/plugins/ ?
" TODO: need to check for solarized, otherwise an annoying message is shown
" when it doesn't exist. (Or is that better?)
syntax on
set t_Co=16
au VimEnter * colorscheme solarized
set background=dark " When set to "dark", Vim will try to use colors that look
                    " good on a dark background. When set to "light", Vim will
                    " try to use colors that look good on a light background.
                    " Any other value is illegal.

" Style the vertical window split bar
set fillchars+=vert:│
highlight VertSplit ctermbg=NONE ctermfg=NONE

function! s:closeiflast()
    " Close vim if there is only one listed (open) buffer; else close the
    " current buffer
    " From http://stackoverflow.com/questions/17931507/vimscript-number-of-listed-buffers
    let b_num = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    if (b_num == 1)
        :q
    else
        :bd
    endif
endfunction

map <space> <leader>
noremap L $
noremap H 0
noremap M ^
nnoremap Y y$
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap £ £zz
nnoremap <C-S-J> kJ
" TODO: do I still use this?
" nnoremap <silent> <C-L> :TlistToggle<CR>
nnoremap <leader>i =
xnoremap <leader>i =
nnoremap <leader>xx :x<cr>
nnoremap <leader>qq :q<cr>
nnoremap <leader>qa :qa<cr>
nnoremap <leader>bd :call <SID>closeiflast()<CR>
nnoremap <leader>bw :w<cr>
nnoremap <leader>bx :w<cr> :call <SID>closeiflast()<CR>
nnoremap <leader>rs :%s/\<<C-R><C-W>\>/
nnoremap <leader>ss /\<\><left><left>
xnoremap <leader>rs :s/\<\><left><left>
nnoremap <leader>h :noh<CR>
nnoremap <leader>col :.!column -t -o " "<CR>
xnoremap <leader>col :!column -t -o " "<CR>
xnoremap <leader>sort :!sort<CR>
xnoremap <leader>nsort :!sort -n<CR>
xnoremap <leader>w :s/\<<C-R><C-W>\>/
cnoremap fd <C-C>
inoremap fd <C-C>
vnoremap fd <C-C>
inoremap <Esc> <Nop>
nnoremap Q @
" Convert decimal to hex
" nnoremap <leader>dth mz:read !echo "0x$(echo 'obase=16;ibase=10;<C-R><C-W>' \| bc)"<CR>"zd$`zciw<C-R>z<C-C>jdd
" Convert hex to demical
" nnoremap <leader>htd mz:read !calc <C-R><C-W> \| tr -d "[:space:]"<CR>"zd$`zciw<C-R>z<C-C>jdd

" nnoremap <C-Q> :q<CR>
" nnoremap <C-W> :call <SID>closeiflast()<CR>

" C specific (perhaps project specific in places)
nnoremap <leader>blk O#if 0<ESC>jo#endif<ESC>k0
nnoremap <leader>ublk ?#if 0<CR>dd/#endif<CR>dd
nnoremap <leader>com :set lz<CR>^i/*<ESC>:call search('.\/\*\\|$')<CR>a*/<ESC>j^:noh<CR>:set nolz<CR>
nnoremap <leader>ucom :set lz<CR>k$:call search('\/\*')<CR>2x:call search('\*\/')<CR>2xj^:noh<CR>:set nolz<CR>
" nnoremap <leader>fdec <ESC>:set lz<CR>?^{<CR>?[^ \(\)]\+\s*(.*$<CR>ye/{<CR>oDEBUG("<ESC>pA start");<CR><ESC>kk%O<CR>DEBUG("<ESC>pA end");<ESC>3<C-O>:noh<CR>:set nolz<CR>
nnoremap <leader>fdec :set lz<CR>?^{<CR>oTRACE();<ESC>k0%?^\(\(.*return.*\)\@!.\)*$<CR>oTRACEEND();<ESC>:noh<CR>:set nolz<CR>
nnoremap <leader>cdec <ESC>:set ls<CR>$?case .*:\s*\(\/\*.*\*\/\)*\s*$<CR>wyeoDEBUG("<ESC>pA");<ESC><C-O>:noh<CR>:set nolz<CR>
nnoremap <leader>td OTD<C-J>
" Can't handle repeated presses of <leader>,
" nnoremap <leader>, <<
" nnoremap <leader>. >>

" TODO: move to ~/.vim/after/plugins/ ?
" UltiSnips options
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

" TODO: move to ~/.vim/after/plugins/ ?
" YCM options
let g:ycm_use_ultisnips_completer = 1
let g:ycm_collect_identifiers_from_tags_files=1
" let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_confirm_extra_conf = 1
let g:ycm_add_preview_to_completeopt = 1
" The following line whitelists ycm config files
let g:ycm_extra_conf_globlist = [
            \ '~/.ycm_extra_conf.py']

au BufNewFile,BufRead *.boo setf boo
autocmd BufRead,BufNewFile *.erl,*.es.*.hrl,*.yaws,*.xrl set expandtab
au BufNewFile,BufRead *.erl,*.es,*.hrl,*.yaws,*.xrl setf erlang

" When opening a new file remember the cursor position of the last editing
if has("autocmd")
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost * if line("'\"") | exe "'\"" | endif
endif