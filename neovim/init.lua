vim.o.compatible = false

-- Indentation
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.shiftround = true

-- Status
vim.o.completeopt = "menuone"
vim.o.display = "lastline"
vim.o.laststatus = 2
vim.o.number = true
vim.o.ruler = true
vim.o.scrolloff = 5
vim.o.showcmd = true
vim.o.showmode = true
vim.o.signcolumn = "auto:3"

-- Search
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.inccommand=nosplit

-- Persistence
vim.o.backupdir = vim.env.XDG_STATE_HOME .. "/nvim/backup"
vim.o.directory = vim.env.XDG_STATE_HOME .. "/nvim/swap"
vim.o.undodir = vim.env.XDG_STATE_HOME .. "/nvim/undo"
vim.o.undofile = true;

-- Miscellaneous
vim.o.updatetime = 250
vim.o.mouse = false
vim.o.splitright = true;
vim.o.splitbelow = true;
vim.o.virtualedit = "block";
vim.o.list = true;
vim.o.listchars = "trail:·";
vim.cmd("highlight TrailingWhitespace ctermbg=red guibg=#592929")
vim.cmd("match TrailingWhitespace /\\s\\+$/")
