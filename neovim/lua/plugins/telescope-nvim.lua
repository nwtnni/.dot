return {
  "telescope-nvim/telescope.nvim",
  main = "telescope",
  dependencies = {
    "plenary.nvim",
    "telescope-fzf-native.nvim",
  },
  cmd = "Telescope",
  keys = {
    { "<SPACE>tt", "<CMD>Telescope<CR>", desc = "Telescope", unique = true },
    { "<SPACE>tf", "<CMD>Telescope find_files<CR>", desc = "Telescope find files", unique = true },
    { "<SPACE>tg", "<CMD>Telescope live_grep<CR>", desc = "Telescope live grep", unique = true },
    { "<SPACE>tb", "<CMD>Telescope oldfiles<CR>", desc = "Telescope oldfiles", unique = true },
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
