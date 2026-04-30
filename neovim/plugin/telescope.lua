vim.pack.add({
  {
    name = "plenary",
    src = "https://github.com/nvim-lua/plenary.nvim",
  },
  {
    name = "telescope",
    src = "https://github.com/nvim-telescope/telescope.nvim",
  },
})

local builtin = require("telescope.builtin")

local setn = function(key, action, desc)
  vim.keymap.set("n", key, action, { desc = desc, unique = true })
end

setn("tt", builtin.resume, "Telescope resume")
setn("tf", function() builtin.find_files({ find_command = { "fd", "--type=file", "--hidden", "--follow" } }) end,
  "Telescope find files")
setn("tg", builtin.live_grep, "Telescope live grep")
setn("to", builtin.oldfiles, "Telescope oldfiles")
setn("tb", builtin.buffers, "Telescope buffers")
setn("th", builtin.help_tags, "Telescope help tags")
setn("tm", builtin.marks, "Telescope marks")
setn("td", function() builtin.diagnostics({ sort_by = "severity" }) end, "Telescope diagnostics")
setn("tq", builtin.quickfix, "Telescope quickfix")
setn("t/", builtin.current_buffer_fuzzy_find, "Telescope fuzzy find buffer")
setn("ts", builtin.lsp_dynamic_workspace_symbols, "Telescope symbols")
setn("gd", builtin.lsp_definitions, "Go to definition")
setn("gr", builtin.lsp_references, "Go to reference")
setn("gt", builtin.lsp_type_definitions, "Go to type definition")
setn("gm", builtin.lsp_implementations, "Go to implementation")
vim.keymap.del("n", "ge")
setn("ge", builtin.lsp_incoming_calls, "Go to incoming call")
setn("gl", builtin.lsp_outgoing_calls, "Go to outgoing call")

local telescope = require("telescope")
telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<CR>"] = "select_default",
        ["<C-s>"] = "select_horizontal",
        ["<C-v>"] = "select_vertical",
        ["<TAB>"] = "move_selection_worse",
        ["<S-TAB>"] = "move_selection_better",
        ["<UP>"] = "cycle_history_prev",
        ["<DOWN>"] = "cycle_history_next",
        ["<C-c>"] = "close",
        ["<ESC>"] = "close",
        ["<C-q>"] = function(buffer)
          require("telescope.actions").send_to_qflist(buffer)
          require("telescope.builtin").quickfix()
        end,
      },
    },
    path_display = { "filename_first" },
    results_titile = false,
  }
})
