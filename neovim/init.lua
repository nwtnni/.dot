vim.opt.packpath = {}
vim.opt.rtp = {
  vim.fn.stdpath("config"),
  vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
  vim.fn.stdpath("data") .. "/lazy/tree-sitter-parsers",
  vim.env.VIMRUNTIME,
}

Personal = {}

-- Hijack nvim-lspconfig's global on_setup hook:
--
-- https://github.com/neovim/nvim-lspconfig/blob/aa5f4f4ee10b2688fb37fa46215672441d5cd5d9/lua/lspconfig/configs.lua#L94-L96
---@param configuration table Server configuration
function Personal.hook_lspconfig_setup(configuration)
  local name = configuration.name
  local pattern = {}
  for _, filetype in ipairs(configuration) do
    table.insert(pattern, "*." .. filetype)
  end

  local function autocmd(event, group, callback)
    vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback })
  end

  autocmd(
    "LspAttach",
    vim.api.nvim_create_augroup("lsp-" .. name .. "-attach", { clear = true }),
    function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      -- Format on BufWritePre
      if client.supports_method("textDocment/formatting") then
        local augroup = vim.api.nvim_create_augroup("lsp-" .. name .. "-format", { clear = true })
        autocmd(
          "BufWritePre",
          augroup,
          function() vim.lsp.buf.format() end
        )
      end

      -- Highlight references on CursorHold
      if client.supports_method("textDocument/documentHighlight") then
        local highlight = { underline = true }
        vim.api.nvim_set_hl(0, "LspReferenceText", highlight)
        vim.api.nvim_set_hl(0, "LspReferenceRead", highlight)
        highlight.bold = true;
        vim.api.nvim_set_hl(0, "LspReferenceWrite", highlight)

        local augroup = vim.api.nvim_create_augroup("lsp-" .. name .. "-highlight", { clear = true })

        autocmd("CursorHold", augroup, vim.lsp.buf.document_highlight)
        autocmd("CursorHoldI", augroup, vim.lsp.buf.document_highlight)
        autocmd("CursorMoved", augroup, vim.lsp.buf.clear_references)
      end
    end
  )

  if not Personal._capabilities then
    local cmp = require("cmp_nvim_lsp")
    Personal._capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      cmp.default_capabilities()
    )
  end

  configuration.capabilities = Personal._capabilities
end

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
  if vim.o.number then
    vim.o.laststatus = 0
    vim.o.number = false
    vim.o.ruler = false
  else
    vim.o.laststatus = 2
    vim.o.number = true
    vim.o.ruler = true
  end
end

vim.o.completeopt = "menu,menuone,preview"
vim.o.scrolloff = 5
vim.o.showcmd = true
vim.o.showmode = true
vim.o.signcolumn = "yes:1"

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

-- Keybindings
vim.keymap.set("n", "<SPACE>w", "<CMD>update<CR>", { silent = true, unique = true })
vim.keymap.set("n", "<SPACE>s", toggle_status, { silent = true, unique = true })
vim.keymap.set("n", "<SPACE>n", "<CMD>set nohlsearch<CR>", { silent = true, unique = true })

vim.keymap.set("i", "jf", "<ESC>", { silent = true, unique = true })
vim.keymap.set("i", "fj", "<ESC>", { silent = true, unique = true })

vim.keymap.del("n", "<C-l>")
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true, unique = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true, unique = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true, unique = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true, unique = true })
