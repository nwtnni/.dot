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
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )

    for server, configuration in pairs(configurations) do
      configuration.capabilities = capabilities
      lspconfig[server].setup(configuration)
    end

    local pattern = { "*.lua" }
    for _, ft in ipairs(plugin.ft) do
      table.insert(pattern, "*." .. ft)
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("lsp-format", { clear = true }),
      pattern = pattern,
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end,
}
