return {
  "hrsh7th/nvim-cmp",
  main = "cmp",
  dependencies = {
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

    cmp.setup({
      snippet = {
        expand = function(args)
          snippy.expand_snippet(args.body)
        end
      },
      completion = {
        completeopt = "menu,menuone,preview",
      },
      formatting = {
        format = function(entry, item)
          -- https://www.reddit.com/r/neovim/comments/wuqr6i/source_of_lsp_suggestion_in_nvimcmp/
          if entry.source.name == "nvim_lsp" then
            item.menu = "[" .. entry.source.source.client.name .. "]"
          else
            item.menu = "[" .. entry.source.name .. "]"
          end
          return item
        end,
      },
      mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          elseif snippy.can_expand_or_advance() then
            snippy.expand_or_advance()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          elseif snippy.can_expand() or snippy.can_jump(-1) then
            snippy.previous()
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
      sources = cmp.config.sources({
        {
          name = "nvim_lsp",
          entry_filter = function(entry)
            -- Disable entries of type text
            return entry:get_kind() ~= 1
          end
        },
        { name = "snippy" },
      }),
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
