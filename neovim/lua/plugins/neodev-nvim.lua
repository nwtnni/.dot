return {
  "folke/neodev.nvim",
  main = "neodev",
  ft = "lua",
  dependencies = {
    "nvim-lspconfig",
  },
  opts = {
    override = function(root_dir, library)
      if root_dir:match(".*/.dot/neovim/.*") == 1 then
        library.enabled = true
        library.runtime = true
        library.types = true
        library.plugins = true
      end
    end,
  },
  config = function(plugin, opts)
    require(plugin.main).setup(opts)
    require("lspconfig")["lua_ls"].setup({
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
  end,
}
