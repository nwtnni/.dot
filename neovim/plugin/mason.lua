vim.pack.add({ {
  name = "mason",
  src = "https://github.com/mason-org/mason.nvim",
  version = "v2.2.1",
} })

require("mason").setup({})
