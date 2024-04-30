return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    "cmp-nvim-lsp",
  },
  config = function(plugin)
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    lspconfig["nixd"].setup({
      capabilities = capabilities,
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
    })
  end,
};
