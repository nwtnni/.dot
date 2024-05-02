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
    { "tt", "<CMD>Telescope<CR>",                               desc = "Telescope",             unique = true },
    { "tf", "<CMD>Telescope find_files find_command=" .. fd,    desc = "Telescope find files",  unique = true },
    { "tg", "<CMD>Telescope live_grep<CR>",                     desc = "Telescope live grep",   unique = true },
    { "to", "<CMD>Telescope oldfiles<CR>",                      desc = "Telescope oldfiles",    unique = true },
    { "tb", "<CMD>Telescope buffers<CR>",                       desc = "Telescope buffers",     unique = true },
    { "th", "<CMD>Telescope help_tags<CR>",                     desc = "Telescope help tags",   unique = true },
    { "tm", "<CMD>Telescope marks<CR>",                         desc = "Telescope marks",       unique = true },
    { "td", "<CMD>Telescope diagnostics<CR>",                   desc = "Telescope diagnostics", unique = true },
    { "ts", "<CMD>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Telescope symbols",     unique = true },
    { "gd", "<CMD>Telescope lsp_definitions<CR>",               desc = "Go to definition",      unique = true },
    { "gr", "<CMD>Telescope lsp_references<CR>",                desc = "Go to reference",       unique = true },
    { "gy", "<CMD>Telescope lsp_type_definitions<CR>",          desc = "Go to type definition", unique = true },
    { "gm", "<CMD>Telescope lsp_implementations<CR>",           desc = "Go to implementation",  unique = true },
    { "ge", "<CMD>Telescope lsp_incoming_calls<CR>",            desc = "Go to incoming call",   unique = true },
    { "gl", "<CMD>Telescope lsp_outgoing_calls<CR>",            desc = "Go to outgoing call",   unique = true },
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
