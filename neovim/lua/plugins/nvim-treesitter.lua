return {
  "nvim-treesitter/nvim-treesitter",
  main = "nvim-treesitter.configs",
  lazy = false,
  opts = {
    auto_install = false,
    highlight = {
      enable = true,
      disable = function(_, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local uv = vim.uv or vim.loop
        local ok, stats = pcall(uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end
    },
  },
  config = function(plugin, opts)
    require(plugin.main).setup(opts)
    vim.o.foldmethod = "expr"
    vim.o.foldenable = false
    vim.o.foldexpr = "nvim_treesitter#foldexpr()"
  end
}
