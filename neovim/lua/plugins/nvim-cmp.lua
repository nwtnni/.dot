return {
  "hrsh7th/nvim-cmp",
  main = "cmp",
  dependencies = {
    "cmp-buffer",
    "cmp-nvim-lsp",
    "cmp-snippy",
  },
  cmd = {
    "CmpStatus",
  },
  event = {
    "InsertEnter",
    "CmdlineEnter",
  },
  config = function(plugin)
    local cmp = require(plugin.main)
    local snippy = require("snippy")

    -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#nvim-snippy
    local on_whitespace = function()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      if col == 0 then return end
      local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
      return line:sub(col, col):match("%s")
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          snippy.expand_snippet(args.body)
        end
      },
      completion = {
        completeopt = "menu,menuone,preview",
      },
      mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          elseif snippy.can_expand_or_advance() then
              snippy.expand_or_advance()
          elseif not on_whitespace() then
              cmp.complete()
          else
              fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          elseif snippy.can_expand_or_advance() then
              snippy.previous()
          elseif not on_whitespace() then
              cmp.complete()
          else
              fallback()
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
          else
            fallback()
          end
        end, { "i", "c" }),
      },
      sources = cmp.config.sources(
        {
          { name = "nvim_lsp" },
          { name = "snippy" },
        },
        {
          { name = "buffer" },
        }
      ),
      view = {
        entries = {
          name = "custom",
          selection_order = "near_cursor",
        },
      },
      experimental = {
        ghost_text = true,
      },
    })
  end
}
