return {
  "ggandor/leap.nvim",
  main = "leap",
  keys = {
    { "s",  "<Plug>(leap)",             mode = { "n", "x" }, desc = "Leap",             unique = true },
    { "gs", "<Plug>(leap-from-window)", mode = { "n", "x" }, desc = "Leap from window", unique = true },
  },
  opts = {
    safe_labels = {},
  },
  config = function(plugin, opts)
    require(plugin.main).setup(opts)
    vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
  end
}
