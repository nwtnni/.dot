return {
  'stevearc/oil.nvim',
  lazy = true,
  keys = {
    {
      "gp",
      function()
        local oil = require("oil")
        oil.open(nil, { preview = {} })
        vim.cmd.lcd(oil.get_current_dir())
      end,
      desc = "Open oil"
    },
  },
  opts = {
    use_default_keymaps = false,
    keymaps = {
      -- https://github.com/stevearc/oil.nvim/issues/68#issuecomment-1868567511
      ["<CR>"] = {
        function()
          local oil = require("oil")
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
    }
  },
}
