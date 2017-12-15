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
    let g:gruvbox_contrast_dark='soft'
  "}

  " Status Line (#p.1)

  Plug 'vim-airline/vim-airline-themes'
  Plug 'vim-airline/vim-airline' "{
    let g:airline_powerline_fonts=1
    let g:airline#extensions#tabline#enabled=1
    let g:airline#extensions#tmuxline#enabled=0
  "}
  Plug 'airblade/vim-gitgutter' "{
    let g:gitgutter_map_keys=0
  "}

  " Tags (#p.2)

  Plug 'MarcWeber/hasktags'
  Plug 'rob-b/gutenhasktags'
  Plug 'ludovicchabant/vim-gutentags' "{
    let g:gutentags_cache_dir='~/.config/nvim/tags'
    let g:gutentags_project_info = [ {'type': 'python', 'file': 'setup.py'},
                                  \ {'type': 'ruby', 'file': 'Gemfile'},
                                  \ {'type': 'haskell', 'file': 'Setup.hs'} ]
    let g:gutentags_ctags_executable_haskell = 'gutenhasktags'
  "}
  Plug 'majutsushi/tagbar' "{
    let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
      \ ],
      \ 'sro' : '.',
      \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
      \ },
      \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
      \ },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
      \ }
  "}

  " Autocompletion (#p.3)

  Plug 'Shougo/echodoc.vim'
  Plug 'zchee/deoplete-go', { 'do': 'make'}
  Plug 'zchee/deoplete-jedi'
  Plug 'copy/deoplete-ocaml' "{
    let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
    execute "set rtp+=" . g:opamshare . "/merlin/vim"
  "}
  Plug 'sebastianmarkow/deoplete-rust' "{
    let g:deoplete#sources#rust#racer_binary='/home/nwtnni/.cargo/bin/racer'
    let g:deoplete#sources#rust#rust_source_path='$RUST_SRC_PATH'
    let g:deoplete#sources#rust#disable_keymap=1
    let g:ale_rust_rls_executable='/home/nwtnni/.cargo/bin/rls'
  "}
  Plug 'eagletmt/neco-ghc' "{
    let g:haskellmode_completion_ghc=0
    let g:necoghc_enable_detailed_browse=1
    let g:necoghc_use_stack=1
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
  "}
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "{
    let g:deoplete#enable_at_startup=1
    let g:deoplete#max_list=5
    let g:deoplete#omni_patterns={}
    let g:deoplete#omni_patterns.rust='[(\.)(::)]'
  "}

  " Utilities (#p.4)

  Plug 'airblade/vim-rooter'
  Plug 'tmux-plugins/vim-tmux-focus-events'
  Plug 'christoomey/vim-tmux-navigator'
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
  Plug 'raimondi/delimitmate'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'

  " Linting (#p.5)

  Plug 'alx741/vim-hindent'
  Plug 'w0rp/ale' "{
    let g:ale_linters= {
    \ 'bash'    : ['shellcheck'],
    \ 'c'       : ['gcc'],
    \ 'go'      : ['golint'],
    \ 'haskell' : ['ghc'],
    \ 'java'    : ['javac'],
    \ 'latex'   : ['lacheck'],
    \ 'ocaml'   : ['merlin'],
    \ 'python'  : ['flake8'],
    \ 'rust'    : ['cargo', 'rls', 'rustfmt'],
    \}
    let g:ale_sign_error="◼"
    let g:ale_sign_warning="▲"
    let g:airline#extensions#ale#enabled=1
    highlight ALEErrorSign cterm=None ctermfg=124 ctermbg=237
    highlight ALEWarningSign cterm=None ctermfg=214 ctermbg=237
  "}

  " Language-specific (#p.6)

  Plug 'fatih/vim-go'       , { 'for': 'go'   } "{
    let g:go_highlight_types=1
    let g:go_highlight_fields=1
    let g:go_highlight_functions=1
    let g:go_highlight_methods=1
    let g:go_highlight_extra_types=1
    let g:go_highlight_build_constraints=1
    let g:go_highlight_generate_tags=1
  "}
  Plug 'donRaphaco/neotex'  , { 'for': 'tex'  }
  Plug 'rust-lang/rust.vim' , { 'for': 'rust' } "{
    let g:rustfmt_autosave=1
    let g:rustfmt_fail_silently=1
  "}
  Plug 'cespare/vim-toml'

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
hi Normal guibg=none ctermbg=none

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
set relativenumber
set mouse=
set splitright
set backspace=indent,eol,start
set hidden
set laststatus=2
set display=lastline
set noshowmode
set showcmd
set ttyfast
set lazyredraw
set incsearch
set hlsearch
set sessionoptions-=options
set background=dark
set termguicolors
set completeopt-=preview
set updatetime=250

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

" Rebind increment/decrement to avoid conflict with tmux
nnoremap <M-a> <C-a>
nnoremap <M-x> <C-x>

" Source .vimrc
nnoremap \ev :vsplit ~/.config/nvim/init.vim<CR>
nnoremap \sv :source ~/.config/nvim/init.vim<cr>

" Clear search
nnoremap <SPACE>h :nohlsearch<CR>

" Swap 0 and ^
noremap 0 ^
noremap ^ 0

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

