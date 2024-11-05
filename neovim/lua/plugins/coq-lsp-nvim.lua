vim.g.loaded_coqtail = 1
vim.cmd "let g:coqtail#supported = 0"

return {
  "tomtomjhj/coq-lsp.nvim",
  ft = "coq",
  opts = {
    lsp = {
      autostart = true,
    }
  }
}
