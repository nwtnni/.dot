{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home = {
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
      wl-clipboard
      zotero
    ];
  };
}
