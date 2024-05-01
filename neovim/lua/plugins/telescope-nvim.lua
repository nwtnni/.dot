local fd = "fd,--type=file,--hidden,--follow<CR>"
return {
  "telescope-nvim/telescope.nvim",
  main = "telescope",
  dependencies = {
    "plenary.nvim",
    "telescope-fzf-native.nvim",
  },
  cmd = "Telescope",
  keys = {
    { "<SPACE>t", "<CMD>Telescope<CR>",                               desc = "Telescope",              unique = true },
    { "<SPACE>e", "<CMD>Telescope find_files find_command=" .. fd,    desc = "Telescope find files",   unique = true },
    { "<SPACE>g", "<CMD>Telescope live_grep<CR>",                     desc = "Telescope live grep",    unique = true },
    { "<SPACE>o", "<CMD>Telescope oldfiles<CR>",                      desc = "Telescope oldfiles",     unique = true },
    { "<SPACE>b", "<CMD>Telescope buffers<CR>",                       desc = "Telescope buffers",      unique = true },
    { "<SPACE>h", "<CMD>Telescope help_tags<CR>",                     desc = "Telescope help tags",    unique = true },
    { "<SPACE>m", "<CMD>Telescope marks<CR>",                         desc = "Telescope marks",        unique = true },
    { "gd",       "<CMD>Telescope lsp_definitions<CR>",               desc = "Go to definition",       unique = true },
    { "gD",       "<CMD>Telescope lsp_diagnostics<CR>",               desc = "Go to diagnostic",       unique = true },
    { "gr",       "<CMD>Telescope lsp_references<CR>",                desc = "Go to reference",        unique = true },
    { "gy",       "<CMD>Telescope lsp_type_definitions<CR>",          desc = "Go to type definition",  unique = true },
    { "gm",       "<CMD>Telescope lsp_implementations<CR>",           desc = "Go to implementation",   unique = true },
    { "gci",      "<CMD>Telescope lsp_incoming_calls<CR>",            desc = "Go to incoming call",    unique = true },
    { "gco",      "<CMD>Telescope lsp_outgoing_calls<CR>",            desc = "Go to outgoing call",    unique = true },
    { "gsd",      "<CMD>Telescope lsp_document_symbols<CR>",          desc = "Go to document symbol",  unique = true },
    { "gsw",      "<CMD>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Go to workspace symbol", unique = true },
  },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-s>"] = "select_horizontal",
        },
      },
    },
  },
  config = function(plugin, opts)
    local telescope = require(plugin.main)
    telescope.setup(opts)
    telescope.load_extension("fzf")
  end,
}
