return {
  "neovim/nvim-lspconfig",
  lazy = false,
  main = "lspconfig",
  dependencies = {
    "cmp-nvim-lsp",
    "neodev.nvim",
  },
  config = function(plugin)
    local configurations = {
      nixd = {
        on_new_config = function(config, root_dir)
          local flake = root_dir .. "/flake.nix"

          if not vim.loop.fs_stat(flake) then
            return
          end

          local settings = config.settings

          settings.nixpkgs = {
            expr = [[(builtins.getFlake "]] .. flake .. [[").inputs.nixpkgs.legacyPackages {}]]
          }
        end
      },
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
              keywordSnippet = "Replace",
            },
            diagnostics = {
              libraryFiles = "Disable",
            },
          },
        },
      },
    }

    -- Configure Lua language server for Neovim configuration
    require("neodev").setup({
      override = function(root_dir, library)
        if root_dir:match(".*/.dot/neovim/.*") == 1 then
          library.enabled = true
          library.runtime = true
          library.types = true
          library.plugins = true
        end
      end,
    })

    local lspconfig = require(plugin.main)
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    for server, configuration in pairs(configurations) do
      configuration.capabilities = capabilities
      lspconfig[server].setup(configuration)
    end
  end,
}
