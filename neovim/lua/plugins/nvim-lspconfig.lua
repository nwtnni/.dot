return {
  "neovim/nvim-lspconfig",
  main = "lspconfig",
  ft = {
    "bib",
    "c",
    "cpp",
    "nix",
    "python",
    "rust",
    "tex",
    "toml",
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
    "fidget.nvim",
  },
  config = function(plugin)
    local lspconfig = require(plugin.main)

    -- Hijack nvim-lspconfig's global on_setup hook:
    --
    -- https://github.com/neovim/nvim-lspconfig/blob/aa5f4f4ee10b2688fb37fa46215672441d5cd5d9/lua/lspconfig/configs.lua#L94-L96
    local _on_setup = lspconfig.util.on_setup
    lspconfig.util.on_setup = function(configuration, user_configuration)
      if _on_setup then
        _on_setup(configuration, user_configuration)
      end

      -- Capability priority
      configuration.capabilities = vim.tbl_deep_extend(
        "keep",
        configuration.capabilities,
        require("cmp_nvim_lsp").default_capabilities(),
        vim.lsp.protocol.make_client_capabilities()
      )
    end

    lspconfig["clangd"].setup({})

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

    lspconfig["pylsp"].setup({
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

    lspconfig["rust_analyzer"].setup({
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            features = "all",
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

    lspconfig["taplo"].setup({})

    lspconfig["texlab"].setup({
      settings = {
        texlab = {
          build = {
            args = { "-pdf", "-shell-escape", "-interaction=nonstopmode", "-synctex=1", "%f" },
            onSave = true,
          },
          chktex = {
            onOpenAndSave = true,
          },
        },
      },
    })
  end,
}
