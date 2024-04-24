inline:
{
  lazy = false;
  priority = 1000;
  config = inline ''
    function()
      vim.cmd([[colorscheme gruvbox]])
    end
  '';
}
