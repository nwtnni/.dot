vim.pack.add({{
  name = "gruvbox",
  src = "https://github.com/ellisonleao/gruvbox.nvim",
  version = "154eb5ff5b96d0641307113fa385eaf0d36d9796",
}})

local gruvbox = require("gruvbox")
gruvbox.setup({
  overrides = {
    SignColumn = {
      bg = gruvbox.palette["dark0"]
    }
  }
})
vim.cmd.colorscheme("gruvbox")
