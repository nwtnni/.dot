return {
  "ellisonleao/gruvbox.nvim",
  main = "gruvbox",
  lazy = false,
  priority = 1000,
  opts = {
    contrast = "soft",
  },
  config = function(plugin, opts)
    require(plugin.main).setup(opts)
    vim.cmd("colorscheme gruvbox")
  end,
}
