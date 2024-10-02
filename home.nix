{ pkgs, ... }:

{
  imports = [
    ./tui.nix
  ];

  home = {
    username = "nwtnni";
    homeDirectory = "/home/nwtnni";
    stateVersion = "23.05";

    packages = with pkgs; [
      calibre
      firefox-wayland
      gthumb
      inkscape
      iosevka
      liberation_ttf
      # https://sw.kovidgoyal.net/kitty/faq/#kitty-is-not-able-to-use-my-favorite-font
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      obsidian
      pavucontrol
      shotman
      tmate
      wl-clipboard
      zotero
    ];

  };

  fonts.fontconfig.enable = true;
}
