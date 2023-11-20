{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "nwtnni";
  home.homeDirectory = "/home/nwtnni";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    fd
    fzf
    htop
    neovim
    ripgrep
    tmux
  ];

  programs.git = {
    enable = true;
    userName = "Newton Ni";
    userEmail = "nwtnni@gmail.com";
  };
}
