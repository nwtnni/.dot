local main = "actions-preview"

return {
  "aznhe21/actions-preview.nvim",
  main = main,
  dependencies = {
    "telescope.nvim",
  },
  keys = {
    { "ga", function() require(main).code_actions() end, mode = { "n", "v" }, desc = "LSP code actions", unique = true }
  },
  config = function(plugin)
    require(plugin.main).setup({
      diff = {
        algorithm = "histogram",
      },
      backend = {
        "telescope",
      },
      highlight_command = {
        require("actions-preview.highlight").delta("delta --side-by-side"),
      }
    })
  end,
}
