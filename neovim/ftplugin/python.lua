vim.lsp.config("pylsp", {
  settings = {
    ["pylsp"] = {
      plugins = {
        ruff = {
          enabled = true,
        }
      }
    }
  }
})

vim.lsp.enable("pylsp")
