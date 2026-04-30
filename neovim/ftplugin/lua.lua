vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
        keywordSnippet = "Replace",
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
      diagnostics = {
        libraryFiles = "Disable",
      },
      hint = {
        enable = true,
      },
    },
  },
})

vim.lsp.enable("lua_ls")

vim.pack.add({ {
  name = "lazydev",
  src = "https://github.com/folke/lazydev.nvim",
  version = "ff2cbcba459b637ec3fd165a2be59b7bbaeedf0d"
} })

require("lazydev").setup()
