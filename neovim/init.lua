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

-- Set up LSP-based autocommands
--
-- nvim-lspconfig uses the FileType event to start language servers,
-- which subsequently fire the LspAttach event when they attach to
-- a buffer. We can define this autocommand after plugin initialization aboveleft
-- Neovim doesn't enable filetype detection until after user configuration is run,
-- so we won't miss the first LspAttach event.
local augroup_attach = vim.api.nvim_create_augroup("personal-lsp-attach", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup_attach,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buffer = args.buf

    local function autocmd(event, callback)
      vim.api.nvim_create_autocmd(event, {
        group = augroup_attach,
        buffer = buffer,
        callback = callback,
      })
    end

    -- Format on BufWritePre
    if client.supports_method("textDocument/formatting") then
      autocmd("BufWritePre", function()
        vim.lsp.buf.format()
        pcall(vim.diagnostic.show)
      end)
    end

    -- Highlight references on CursorHold
    if client.supports_method("textDocument/documentHighlight") then
      local highlight = { underline = true }
      vim.api.nvim_set_hl(0, "LspReferenceText", highlight)
      vim.api.nvim_set_hl(0, "LspReferenceRead", highlight)
      highlight.bold = true;
      vim.api.nvim_set_hl(0, "LspReferenceWrite", highlight)

      autocmd("CursorHold", vim.lsp.buf.document_highlight)
      autocmd("CursorHoldI", vim.lsp.buf.document_highlight)
      autocmd("CursorMoved", vim.lsp.buf.clear_references)
    end
  end
})

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
  group = vim.api.nvim_create_augroup("lsp-indent", { clear = true }),
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
local function toggle_status()
  vim.o.laststatus = 2 - vim.o.laststatus
  vim.o.number = not vim.o.number
  vim.o.ruler = not vim.o.ruler
end

vim.o.laststatus = 0
vim.o.ruler = false
vim.o.completeopt = "menu,menuone,preview"
vim.o.scrolloff = 5
vim.o.showcmd = true
vim.o.showmode = true
-- https://github.com/neovim/neovim/issues/13098
vim.o.signcolumn = "yes:1"

-- Diagnostics
vim.diagnostic.config({
  signs = false,
  severity_sort = true,
  virtual_text = true,
})

-- Search
local function toggle_search()
  vim.o.hlsearch = not vim.o.hlsearch
end

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

-- Folding
vim.o.foldtext = ""
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldenable = false
vim.o.foldlevelstart = 99
vim.o.foldminlines = 16

-- Keybindings
local function set(mode, source, target)
  vim.keymap.set(mode, source, target, { silent = true, unique = true })
end
local setn = function(source, target) set("n", source, target) end
local seti = function(source, target) set("i", source, target) end

setn("<CR>", "<CMD>update<CR>")
setn("j", "gj")
setn("k", "gk")
setn("[d", vim.diagnostic.goto_prev)
setn("]d", vim.diagnostic.goto_next)
setn("K", vim.lsp.buf.hover)
setn("crn", vim.lsp.buf.rename)

setn("<SPACE>s", toggle_status)
setn("<SPACE>h", toggle_search)

seti("jf", "<ESC>")

-- Navigation
vim.o.cursorlineopt = "screenline"
vim.o.cursorline = false
local navigate = false
setn("<C-u>", "")
setn("<C-d>", "")
setn("<C-o>", "")

local function update_cursorline(value)
  vim.api.nvim_set_option_value("cursorline", value, { scope = "local", win = 0 })
end

local function toggle_navigate()
  if navigate then
    for _, key in pairs({ "gg", "G", "u", "d", "h", "j", "k", "l", "i", "o" }) do
      vim.keymap.del("n", key)
    end

    setn("j", "gj")
    setn("k", "gk")
  else
    local snippy = require("snippy")

    -- Avoid colliding with snippets
    if snippy.can_jump(1) then
      snippy.next()
      return
    end

    pcall(vim.keymap.del, "n", "j")
    pcall(vim.keymap.del, "n", "k")

    setn("gg", "ggzz")
    setn("G", "Gzz")
    setn("u", "<C-u>zz")
    setn("d", "<C-d>zz")
    setn("h", "<C-w>h")
    setn("j", "<C-w>j")
    setn("k", "<C-w>k")
    setn("l", "<C-w>l")
    setn("i", "<C-I>")
    setn("o", "<C-O>")
    setn("w", "<CMD>update<CR>")
    setn("q", "<CMD>quit<CR>")
  end
  navigate = not navigate
  update_cursorline(navigate)
end

setn("<TAB>", toggle_navigate)

local navigate_group = vim.api.nvim_create_augroup("navigate", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  group = navigate_group,
  callback = function() update_cursorline(navigate) end,
})

for _, event in ipairs({ "WinLeave", "WinClosed" }) do
  vim.api.nvim_create_autocmd(event, {
    group = navigate_group,
    callback = function() update_cursorline(false) end,
  })
end

vim.api.nvim_create_autocmd("ModeChanged", {
  group = navigate_group,
  pattern = "n:*",
  callback = function() if navigate then toggle_navigate() end end,
})
