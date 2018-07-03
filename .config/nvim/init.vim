" Contents
"
" Plugins (#p)
" - Colorschemes   (#p.0) Statusline     (#p.1)
" - Tags           (#p.2)
" - Autocompletion (#p.3)
" - Utilities      (#p.4)
" - Linting        (#p.5)
" - Language       (#p.6)
" Settings (#s)
" Keybinds (#k)

"----------------------------------------"
"                                        "
"               Plugins (#p)             "
"                                        "
"----------------------------------------"

call plug#begin('~/.config/nvim/bundle')

  " Colorschemes (#p.0)

  Plug 'morhetz/gruvbox' "{
    let g:gruvbox_italic=1
    let g:gruvbox_sign_column="dark0_soft"
    let g:gruvbox_number_column="dark0_soft"
    let g:gruvbox_contrast_dark='soft'
  "}
  Plug 'chrisbra/Colorizer'

  " Status Line (#p.1)

  Plug 'airblade/vim-gitgutter' "{
    let g:gitgutter_map_keys=0
  "}

  " Tags (#p.2)

  Plug 'ludovicchabant/vim-gutentags' "{
    let g:gutentags_cache_dir='~/.config/nvim/tags'
  "}
  Plug 'majutsushi/tagbar'

  " Autocompletion (#p.3)

  Plug 'zchee/deoplete-clang'
  Plug 'eagletmt/neco-ghc' "{
    let g:necoghc_enable_detailed_browse=1
    let g:necoghc_use_stack=1
  "}
  Plug 'Shougo/neoinclude.vim'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "{
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#ignore_sources = {}
    let g:deoplete#ignore_sources._ = ['buffer', 'around']
    let g:deoplete#sources#clang#libclang_path ='/usr/lib/llvm-5.0/lib/libclang.so'
    let g:deoplete#sources#clang#clang_header ='/usr/lib/llvm-5.0/lib/clang'
    let g:deoplete#omni#input_patterns={}
    let g:deoplete#omni#input_patterns.ocaml='[^ ,;\t\[()\]]{2,}'
	"}

  " Utilities (#p.4)

  Plug 'airblade/vim-rooter'
  Plug 'tmux-plugins/vim-tmux-focus-events'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'sjl/tslime.vim' "{
    let g:tslime_normal_mapping = '\t'
    let g:tslime_visual_mapping = '\t'
    let g:tslime_vars_mapping = '\T'
    let g:tslime_ensure_trailing_newlines = 2
  "}
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim' "{
    " Use ripgrep instead of Ag
    command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)
  "}
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'justinmk/vim-sneak'
  Plug 'let-def/vimbufsync'

  " Linting (#p.5)

  Plug 'w0rp/ale' "{
    let g:ale_linters = {'rust': ['cargo'], 'haskell': ['stack-ghc', 'ghc-mod']}
    let g:ale_lint_on_text_changed = "never"
    let g:ale_lint_delay = 200
    let g:ale_pattern_options = {
\   '.*\.mly$': {'ale_enabled': 0},
\   '.*\.mll$': {'ale_enabled': 0},
\}
  "}

  " Language-specific (#p.6)

  Plug 'isRuslan/vim-es6'
  Plug 'donRaphaco/neotex', { 'for': 'tex'  }
  Plug 'rust-lang/rust.vim'
  Plug 'qnighy/lalrpop.vim'
  Plug 'cespare/vim-toml'
  Plug 'wlangstroth/vim-racket'
  Plug 'epdtry/neovim-coq'
  Plug 'neovimhaskell/haskell-vim' "{
    let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
    let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
    let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
    let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
    let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
    let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
    let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
  "}
  Plug 'jpalardy/vim-slime' "{
    let g:slime_target = "tmux"
  "}

  augroup Scheme
    autocmd FileType scheme let g:slime_default_config = {"socket_name": split($TMUX, ",")[0], "target_pane": ":.2"}
    autocmd FileType scheme set commentstring=;\ %s
    autocmd FileType scheme let b:is_chicken=1
  augroup end

  augroup Javascript
    autocmd Filetype javascript setlocal tabstop=4
    autocmd Filetype javascript setlocal softtabstop=4
    autocmd Filetype javascript setlocal shiftwidth=4
  augroup end

  augroup Xi
    autocmd FileType xi set commentstring=//\ %s
  augroup end

  augroup OCaml
    autocmd FileType ocaml set commentstring=(*\ %s\ *)
  augroup end

  augroup P4
    autocmd FileType p4 set commentstring=//\ %s
    autocmd Filetype p4 setlocal tabstop=4
    autocmd Filetype p4 setlocal softtabstop=4
    autocmd Filetype p4 setlocal shiftwidth=4
  augroup end

  augroup LALRPOP
    autocmd Filetype lalrpop setlocal tabstop=4
    autocmd Filetype lalrpop setlocal softtabstop=4
    autocmd Filetype lalrpop setlocal shiftwidth=4
    autocmd FileType lalrpop set commentstring=//\ %s
  augroup end

  " ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
  let s:opam_share_dir = system("opam config var share")
  let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')
  let s:opam_configuration = {}

  function! OpamConfOcpIndent()
    execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
  endfunction
  let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

  function! OpamConfOcpIndex()
    execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
  endfunction
  let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

  function! OpamConfMerlin()
    let l:dir = s:opam_share_dir . "/merlin/vim"
    execute "set rtp+=" . l:dir
  endfunction
  let s:opam_configuration['merlin'] = function('OpamConfMerlin')

  let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
  let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
  let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
  for tool in s:opam_packages
    " Respect package order (merlin should be after ocp-index)
    if count(s:opam_available_tools, tool) > 0
      call s:opam_configuration[tool]()
    endif
  endfor
  " ## end of OPAM user-setup addition for vim / base ## keep this line
call plug#end()

"----------------------------------------"
"                                        "
"              Settings (#s)             "
"                                        "
"----------------------------------------"

" Terminal true color
execute "set t_8f=\e[38;2;%lu;%lu;%lum"
execute "set t_8b=\e[48;2;%lu;%lu;%lum"
colorscheme gruvbox

" Transparent background
" hi EndOfBuffer ctermbg=none ctermfg=none guibg=none guifg=none
" hi Normal guibg=none ctermbg=none

filetype plugin indent on
filetype plugin on
syntax on
set autoindent
set autoread
set smartindent
set scrolloff=5
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set nonumber
set norelativenumber
set mouse=
set splitright
set backspace=indent,eol,start
set hidden
set noshowmode
set noruler
set laststatus=0
set noshowcmd
set display=lastline
set ttyfast
set lazyredraw
set incsearch
set inccommand=nosplit
set hlsearch
set sessionoptions-=options
set background=dark
set termguicolors
set completeopt-=preview
set updatetime=250

augroup FourSpaces
  autocmd Filetype java,groovy,c,cpp,make setlocal tabstop=4
  autocmd Filetype java,groovy,c,cpp,make setlocal softtabstop=4
  autocmd Filetype java,groovy,c,cpp,make setlocal shiftwidth=4
  autocmd Filetype makefile setlocal noexpandtab
augroup end

let g:python_host_prog="/home/nwtnni/.pyenv/versions/neovim2/bin/python"
let g:python3_host_prog="/home/nwtnni/.pyenv/versions/neovim3/bin/python3"

" Tags options
set cpoptions+=d
set tags=./.tags

" Backup options
set backupdir=~/.config/nvim/temp
set directory=~/.config/nvim/temp
set undodir=~/.config/nvim/temp
set undofile

" Fold options
set foldenable
set foldlevel=99
set foldnestmax=5
set viewoptions=cursor,folds,slash,unix

"----------------------------------------"
"                                        "
"              Keybinds (#s)             "
"                                        "
"----------------------------------------"

let mapleader = "\<SPACE>"

" Better escaping
inoremap jk <esc>
nnoremap j gj
nnoremap k gk

" Source .vimrc
nnoremap \e :vsplit ~/.config/nvim/init.vim<CR>
nnoremap \r :source ~/.config/nvim/init.vim<CR>

" Clear search
nnoremap <SPACE>h :nohlsearch<CR>

" Swap 0 and ^
noremap 0 ^
noremap ^ 0
nnoremap <S-L> $
vnoremap <S-L> $
nnoremap <S-H> ^
vnoremap <S-H> ^

" Split line
nnoremap <S-K> 080lBi<CR><ESC>

" Insert space before
nnoremap <SPACE><SPACE> i<SPACE><ESC>

" Write
nnoremap \w :w<CR>
nnoremap \q :wq<CR>

" Yank to system buffer
vnoremap \y "+y
vnoremap \d "+d
nnoremap \p "+p
nnoremap \<S-p> "+P

nnoremap <SPACE>- :TagbarToggle<CR>
nnoremap <SPACE>t :Files<CR>

let s:hidden_all = 1
function! ToggleHiddenAll()
    if s:hidden_all == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
        set nonumber
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
        set number
    endif
endfunction
nnoremap <SPACE>0 :call ToggleHiddenAll()<CR>

fun! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun
nnoremap <F2> :call TrimWhitespace()<CR>

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
endfunction
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Open fzf in horizontal split
nnoremap <silent> \s :call fzf#run({
\  'down': '40%',
\  'sink': 'botright split' })<CR>

" Open fzf in horizontal split
nnoremap <silent> \v :call fzf#run({
\  'right': winwidth('.') / 2,
\  'sink':  'vertical botright split' })<CR>
