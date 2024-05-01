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
    local lspconfig = require(plugin.main)

    local _on_setup = lspconfig.util.on_setup
    lspconfig.util.on_setup = function(configuration, user_configuration)
      if _on_setup then
        _on_setup(configuration, user_configuration)
      end
      Personal.hook_lspconfig_setup(configuration)
    end

    lspconfig["nixd"].setup({
        on_new_config = function(config, root_dir)
          local flake = root_dir

          if not vim.loop.fs_stat(flake .. "/flake.nix") then
            return
          end

          -- local settings = {
          --   nixd = {
          --     nixpkgs = {
          --       expr = [[import (builtins.getFlake "]] .. flake .. [[").inputs.nixpkgs {}]]
          --     }
          --   }
          -- }
          --
          -- config.settings = vim.tbl_deep_extend("force", config.settings, settings)
          -- vim.print(config)
        end
      })
  end,
}
