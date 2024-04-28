return {
  "telescope-nvim/telescope.nvim",
  main = "telescope",
  dependencies = {
    "plenary.nvim",
    "telescope-fzf-native.nvim",
  },
  cmd = "Telescope",
  keys = {
    { "<SPACE>tf", "<CMD>Telescope find_files<CR>", desc = "Telescope find files", unique = true },
    { "<SPACE>tg", "<CMD>Telescope live_grep<CR>", desc = "Telescope live grep", unique = true },
    { "<SPACE>tb", "<CMD>Telescope oldfiles<CR>", desc = "Telescope oldfiles", unique = true },
  },
  config = function(plugin, opts)
    local telescope = require(plugin.main)
    telescope.setup(opts)
    telescope.load_extension("fzf")
  end,
}
