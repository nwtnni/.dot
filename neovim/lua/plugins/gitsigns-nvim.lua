local main = "gitsigns"

return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  opts = {

    -- https://github.com/lewis6991/gitsigns.nvim?tab=readme-ov-file#keymaps
    on_attach = function(bufnr)
      local gitsigns = require(main)

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
          gitsigns.preview_hunk()
        end
      end)

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
          gitsigns.preview_hunk()
        end
      end)

      map('n', '<SPACE>gs', gitsigns.stage_hunk)
      map('n', '<SPACE>gS', gitsigns.stage_buffer)
      map('n', '<SPACE>gc', gitsigns.reset_hunk)
      map('n', '<SPACE>gC', gitsigns.reset_buffer)
      map('n', '<SPACE>gd', function()
        gitsigns.toggle_deleted()
        gitsigns.toggle_linehl()
      end)
      map('n', '<SPACE>gD', gitsigns.diffthis)

      map({ 'o', 'x' }, 'ic', ':<C-U>Gitsigns select_hunk<CR>')
    end,
  },
}
