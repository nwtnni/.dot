vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      -- cargo = {
      --   features = "all",
      -- },
      assist = {
        preferSelf = true,
      },
      check = {
        command = "clippy",
      },
      imports = {
        granularity = {
          group = "item",
        },
        preferNoStd = true,
      },
    },
  }
})

vim.lsp.enable("rust_analyzer")
