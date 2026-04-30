vim.pack.add({ {
  name = "oil",
  src = "https://github.com/stevearc/oil.nvim",
  version = "0fcc83805ad11cf714a949c98c605ed717e0b83e",
} })

local oil = require("oil")
oil.setup({
  use_default_keymaps = false,
  keymaps = {
    -- https://github.com/stevearc/oil.nvim/issues/68#issuecomment-1868567511
    ["<CR>"] = {
      function()
        oil.select(nil, function(err)
          if err then
            return
          end

          local cwd = oil.get_current_dir()
          if cwd then
            vim.cmd.lcd(cwd)
          end
        end)
      end,
      mode = "n",
    },
    ["<SPACE>."] = { "actions.toggle_hidden", mode = "n" },
    ["<SPACE>o"] = { "actions.change_sort", mode = "n" },
    ["<SPACE>p"] = { "actions.preview", mode = "n" },
  },
})

vim.keymap.set(
  "n",
  "gp",
  function()
    oil.open(nil, { preview = {} })
    vim.cmd.lcd(oil.get_current_dir())
  end,
  {
    desc = "Open oil",
    unique = true,
  }
)
