return {
  "ellisonleao/gruvbox.nvim",
  main = "gruvbox",
  lazy = false,
  priority = 1000,
  config = function(plugin, opts)
    local gruvbox = require(plugin.main)
    local bg = gruvbox.palette["dark0"]
    gruvbox.setup({
      overrides = {
        SignColumn = {
          bg = bg
        },
      },
    })
    vim.cmd("colorscheme gruvbox")
  end,
}
