{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd
    nixpkgs-fmt
    neovim-unwrapped
  ];

  home.sessionVariables.EDITOR = "nvim";

  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dot/neovim";
    target = "nvim";
  };
}
