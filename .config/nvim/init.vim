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

  " Status Line (#p.1)

  Plug 'airblade/vim-gitgutter' "{
    let g:gitgutter_map_keys=0
    let g:gitgutter_grep = 'rg'
    let g:gitgutter_max_signs = 5000
  "}

  " Language Server (#p.3)
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/vim-vsnip'

  " Utilities (#p.4)

  Plug 'airblade/vim-rooter' "{
    let g:rooter_patterns = ['Makefile', '.git/']
  "}
  Plug 'tmux-plugins/vim-tmux-focus-events'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim' "{
    " Use ripgrep instead of Ag
    function! RipgrepFzf(query, fullscreen)
      let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
      let initial_command = printf(command_fmt, shellescape(a:query))
      let reload_command = printf(command_fmt, '{q}')
      let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
      call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
    endfunction

    command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

    " Open fzf in horizontal split
    nnoremap <silent> <SPACE>s :call fzf#run(fzf#vim#with_preview({
    \  'down': '50%',
    \  'sink': 'botright split' }))<CR>

    " Open fzf in vertical split
    nnoremap <silent> <SPACE>v :call fzf#run(fzf#vim#with_preview({
    \  'right': '50%',
    \  'sink':  'vertical botright split' }))<CR>

    " Open fzf in current buffer
    nnoremap <silent> <SPACE>e :GFiles<CR>
    nnoremap <silent> <SPACE>g :Rg<CR>
    nnoremap <silent> <SPACE>/ :History/<CR>
    nnoremap <silent> <SPACE>b :Buffers<CR>
  "}
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'justinmk/vim-sneak' "{
    augroup Sneak
        autocmd!
        autocmd ColorScheme * hi! link Sneak Normal
    augroup end
  "}

  " Language-specific (#p.6)

  Plug 'isRuslan/vim-es6'
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'rust-lang/rust.vim'
  Plug 'simrat39/rust-tools.nvim'
  Plug 'qnighy/lalrpop.vim'
  Plug 'pest-parser/pest.vim'
  Plug 'cespare/vim-toml'

call plug#end()

"----------------------------------------"
"                                        "
"              Settings (#s)             "
"                                        "
"----------------------------------------"

filetype plugin indent on
filetype plugin on
syntax on

let g:python_host_prog="/usr/local/bin/python2"
let g:python3_host_prog="/usr/local/bin/python3"

" Terminal true color
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
set background=dark
colorscheme gruvbox

" Transparent background
" hi EndOfBuffer ctermbg=none ctermfg=none guibg=none guifg=none
" hi Normal guibg=none ctermbg=none

" Indentation
set smartindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround

" Status
set hidden
set noshowmode
set noshowcmd
set noruler
set nonumber
set norelativenumber
set display=lastline
set laststatus=0
set completeopt=menuone,noinsert,noselect
set scrolloff=5
set signcolumn=yes:2

" Disable mouse
set mouse=a

" Perforamnce
set ttyfast
set lazyredraw

" Search
set smartcase
set hlsearch
set incsearch
set inccommand=nosplit

" Session related
set autoread
set sessionoptions-=options
set viewoptions=cursor,folds,slash,unix

" Tags
set cpoptions+=d

" Backup
set updatetime=250
set backupdir=~/.config/nvim/temp
set directory=~/.config/nvim/temp
set undodir=~/.config/nvim/temp
set undofile

" Fold options
set foldenable
set foldlevel=99
set foldnestmax=5

" Miscellaneous
set backspace=indent,eol,start
set splitright
set splitbelow
set list
set listchars=trail:·
highlight TrailingWhitespace ctermbg=red guibg=#592929
match TrailingWhitespace /\s\+$/

"----------------------------------------"
"                                        "
"              Keybinds (#s)             "
"                                        "
"----------------------------------------"

let mapleader = "\<SPACE>"

" Better escaping
inoremap jf <esc>
inoremap jk <esc>
nnoremap j gj
nnoremap k gk
nnoremap <CR> :update<CR>

" Source .vimrc
nnoremap \e :split ~/.config/nvim/init.vim<CR>
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
nnoremap <S-K> 80\|Bi<CR><ESC>

" Insert space before
nnoremap <SPACE><SPACE> i<SPACE><ESC>

" Yank to system buffer
vnoremap <SPACE>y "+y
vnoremap <SPACE>d "+d
nnoremap <SPACE>p "+p
nnoremap \<S-p> "+P

" Show metadata
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

" https://sharksforarms.dev/posts/neovim-rust/
nnoremap <silent> ga <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gt <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> <SPACE>rn <cmd>lua vim.lsp.buf.rename()<CR>

autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)

lua <<EOF
require("rust-tools").setup({
  -- rust-tools
  tools = {
    inlay_hints = {
      show_variable_name = true,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },
  server = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
        importGranularity = "item",
        joinLines = {
          joinElseIf = false,
        },
      },
    },
  },
})

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<TAB>'] = cmp.mapping.select_next_item(),
    ['<S-TAB>'] = cmp.mapping.select_prev_item(),
    ['<C-D>'] = cmp.mapping.scroll_docs(4),
    ['<C-U>'] = cmp.mapping.scroll_docs(-4),
    ['<C-SPACE>'] = cmp.mapping.complete(),
    ['<C-E>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
  },
})
EOF
