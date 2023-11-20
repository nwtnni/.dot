{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "nwtnni";
  home.homeDirectory = "/home/nwtnni";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    alacritty
    fd
    firefox-wayland
    fzf
    htop
    neovim
    ripgrep
    rustup
    shotman
    tmux
    wl-clipboard
  ];

  programs.git = {
    enable = true;
    userName = "Newton Ni";
    userEmail = "nwtnni@gmail.com";
  };

  wayland.windowManager.sway = {
    enable = true;

    config = rec {
      modifier = "Mod1";
      terminal = "alacritty";
    };

    extraConfig = ''
      bindsym Print exec shotman -c output
      bindsym Print+Shift exec shotman -c region
      bindsym Print+Shift+Control exec shotman -c window
    '';
  };
}
