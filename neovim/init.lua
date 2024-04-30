vim.opt.packpath = {}
vim.opt.rtp = {
  vim.fn.stdpath("config"),
  vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
  vim.fn.stdpath("data") .. "/lazy/tree-sitter-parsers",
  vim.env.VIMRUNTIME,
}

require("lazy").setup(
  "plugins",
  {
    change_detection = {
      enabled = false,
    },
    checker = {
      enabled = false,
    },
    defaults = {
      lazy = true,
    },
    install = {
      missing = false,
    },
    performance = {
      reset_packpath = false,
      rtp = {
        reset = false,
      },
    },
    readme = {
      enabled = false,
    },
  }
)

-- Disable provider warnings
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Indentation
local function set_indent(width)
  vim.o.tabstop = width
  vim.o.softtabstop = width
  vim.o.shiftwidth = width
end

vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.shiftround = true
set_indent(4)

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("indent-two", { clear = true }),
  callback = function()
    set_indent(2)
  end,
  pattern = {
    "lua",
    "nix",
    "vim",
  },
})

-- Status
vim.o.completeopt = "menu,menuone,preview"
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
vim.o.inccommand = "nosplit"

-- Persistence
--
-- > For Unix and Win32, if a directory ends in two path separators "//",
-- > the swap file name will be built from the complete path to the file
-- > with all path separators replaced by percent '%' signs (including
-- > the colon following the drive letter on Win32). This will ensure
-- > file name uniqueness in the preserve directory.
-- >
-- > - :help 'directory'
vim.o.backupdir = vim.env.XDG_STATE_HOME .. "/nvim/backup//"
vim.o.directory = vim.env.XDG_STATE_HOME .. "/nvim/swap//"
vim.o.undodir = vim.env.XDG_STATE_HOME .. "/nvim/undo//"
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
