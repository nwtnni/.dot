return {
  "NvChad/nvim-colorizer-lua",
  main = "colorizer",
  ft = {
    "bash",
    "css",
    "html",
    "javascript",
    "json",
    "nix",
    "toml",
  },
  opts = {
    filetypes = { "*" },
    user_default_options = {
      mode = "virtualtext",
    }
  }
}
