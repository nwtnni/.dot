return {
  "neovim/nvim-lspconfig",
  main = "lspconfig",
  ft = {
    "nix",
  },
  cmd = {
    "LspInfo",
    "LspLog",
    "LspStart",
    "LspStop",
    "LspRestart",
  },
  dependencies = {
    "cmp-nvim-lsp",
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
    }

    local lspconfig = require(plugin.main)
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    for server, configuration in pairs(configurations) do
      configuration.capabilities = capabilities
      lspconfig[server].setup(configuration)
    end
  end,
}
