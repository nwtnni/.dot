vim.pack.add({ {
  name = "blink.cmp",
  src = "https://github.com/saghen/blink.cmp",
  version = "v1",
} })

require("blink.cmp").setup({
  completion = {
    documentation = {
      auto_show = true,
    },
    menu = {
      draw = {
        columns = {
          { "kind_icon" },
          { "label",      "label_description", gap = 1 },
          { "source_name" }
        },
        treesitter = { "lsp", "lazydev" },
      }
    }
  },
  keymap = {
    preset = "none",
    ["<TAB>"] = { "select_next", "fallback" },
    ["<S-TAB>"] = { "select_prev", "fallback" },
    ["<CR>"] = { "select_and_accept", "fallback" },
  },
  signature = {
    enabled = true,
  },
  sources = {
    per_filetype = {
      lua = { inherit_defaults = true, "lazydev" },
    },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    }
  }
})
