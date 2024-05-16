return {
  -- HACK: repository is actually named 'Comment.nvim', but is
  -- packaged in nixpkgs as 'comment.nvim'. We need to use the
  -- latter so that (a) we find the package in nixpkgs and (b)
  -- lazy.nvim finds the correct directory, which uses the
  -- nixpkgs name.
  "numToStr/comment.nvim",
  main = "Comment",
  keys = {
    { mode = "n", "gc", "<Plug>(comment_toggle_linewise_current)", "Toggle comment on current line" },
    { mode = "x", "gc", "<Plug>(comment_toggle_linewise_visual)",  "Toggle comment on current selection" },
  },
  opts = {
    mappings = false,
  },
}
