vim.opt.packpath = {}
vim.opt.rtp = {
  vim.fn.stdpath("config"),
  vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
  vim.fn.stdpath("data") .. "/lazy/tree-sitter-parsers",
  vim.env.VIMRUNTIME .. "/../../../lib/nvim",
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

-- Inlay hints
local function toggle_inlay()
  if vim.lsp.inlay_hint then
    -- Note: as of 0.10 is_enabled filter parameter is optional
    ---@diagnostic disable-next-line: missing-parameter
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end
end

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
local function toggle_highlight()
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
vim.o.splitright = true;
vim.o.splitbelow = true;
vim.o.equalalways = false;
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
setn("]q", function() if not pcall(vim.cmd.cbelow) then pcall(vim.cmd.cnext) end end)
setn("[q", function() if not pcall(vim.cmd.cabove) then pcall(vim.cmd.cprevious) end end)
setn("crn", vim.lsp.buf.rename)

-- Override default ]d and [d mappings
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "[d", vim.diagnostic.goto_next)

-- https://github.com/neovim/neovim/blob/9e2f378b6d255cd4b02a39b1a1dc5aea2df1a84c/runtime/lua/vim/lsp/util.lua#L1197C1-L1203C4
local function find_window_by_var(name, value)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ok, _value = pcall(vim.api.nvim_win_get_var, win, name)
    if ok and _value == value then
      return win
    end
  end
end

setn("K", function()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local float = "textDocument/hover"
  local split = "hover/split"
  local response = "hover/response"
  local context = {
    bufnr = buf,
    method = float,
  }

  vim.lsp.buf_request_all(0, float, vim.lsp.util.make_position_params(), function(responses)
    assert(#responses == 1, "TODO: support more than one server")
    if not responses[1].result or not responses[1].result.contents then
      return
    end

    local hover_float = find_window_by_var(float, buf)
    local hover_split = find_window_by_var(split, buf)

    if vim.api.nvim_get_current_buf() ~= buf then
      pcall(vim.api.nvim_win_close, hover_float, false)
      pcall(vim.api.nvim_win_close, hover_split, false)
      return
    end

    local result = responses[1].result
    if not hover_float and not hover_split then
      vim.lsp.handlers.hover(nil, result, context, {})
      return
    end

    if hover_split and vim.api.nvim_win_get_var(hover_split, response) == result.contents then
      vim.api.nvim_win_close(hover_split, false)
      return
    end

    if hover_float then
      vim.api.nvim_win_close(hover_float, false)
    end

    if hover_split then
      vim.api.nvim_set_current_win(hover_split)
    else
      vim.api.nvim_command("split")
    end

    hover_split = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_var(hover_split, split, buf)
    vim.api.nvim_win_set_var(hover_split, response, result.contents)

    buf = vim.api.nvim_create_buf(false, true)
    local contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, contents)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_set_current_win(win)
  end)
end)

setn("<SPACE>s", toggle_status)
setn("<SPACE>h", toggle_highlight)
setn("<SPACE>i", toggle_inlay)

seti("jf", "<ESC>")
set("t", "jf", "<C-\\><C-n>")

-- Navigation
vim.o.cursorlineopt = "screenline"
vim.o.cursorline = false
local navigate = false
setn("<C-u>", "")
setn("<C-d>", "")
setn("<C-o>", "")
setn("j", "gj")
setn("k", "gk")

local function update_cursorline(value)
  vim.api.nvim_set_option_value("cursorline", value, { scope = "local", win = 0 })
end

local function toggle_navigate()
  if navigate then
    for _, key in pairs({ "gg", "G", "u", "d", "h", "j", "k", "l", "i", "o", "q" }) do
      vim.keymap.del("n", key)
    end

    setn("j", "gj")
    setn("k", "gk")
  else
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
    setn("q", "<CMD>quit<CR>")
  end
  navigate = not navigate
  update_cursorline(navigate)
end

setn("w", toggle_navigate)

local navigate_group = vim.api.nvim_create_augroup("navigate", { clear = true })

vim.api.nvim_create_autocmd("WinEnter", {
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
  -- Disable when editing
  pattern = { "*:[ivVsSR]*", "*:<CTRL-V>*" },
  callback = function() if navigate then toggle_navigate() end end,
})

local win_save
local function toggle_terminal()
  local win = vim.api.nvim_get_current_win()
  local term_win = vim.g._term_win
  local term_buf = vim.g._term_buf

  if term_buf and not vim.api.nvim_buf_is_loaded(term_buf) then
    pcall(vim.api.nvim_buf_delete, term_buf)
    term_buf = nil
  end

  if term_win and not vim.api.nvim_win_is_valid(term_win) then
    term_win = nil
  end

  if term_win and term_buf then
    if win == term_win then
      if not pcall(vim.api.nvim_set_current_win, win_save) then
        vim.cmd.wincmd("k")
      end
    else
      win_save = win
      vim.api.nvim_set_current_win(term_win)
    end
    return
  end

  win_save = win
  vim.cmd([[botright split]])
  vim.g._term_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_height(vim.g._term_win, 10)

  if term_buf then
    vim.api.nvim_win_set_buf(vim.g._term_win, term_buf)
    vim.cmd.startinsert()
  else
    vim.cmd.terminal()
    vim.g._term_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_keymap(vim.g._term_buf, "n", "q", "<CMD>quit<CR>", { silent = true })
  end
end

local augroup_term = vim.api.nvim_create_augroup("personal-term", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "TermOpen" }, {
  group = augroup_term,
  pattern = "term://*",
  command = "startinsert",
})
vim.api.nvim_create_autocmd("TermClose", {
  group = augroup_term,
  callback = function(event)
    if event.buf ~= vim.g._term_buf then
      return
    end

    vim.api.nvim_buf_delete(event.buf, { force = true })
  end
})

setn("<TAB>", toggle_terminal)
