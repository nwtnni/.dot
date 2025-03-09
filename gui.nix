{ pkgs, ... }:
{
  imports = [
    ./wayland.nix
    ./wezterm.nix
    ./zathura.nix
  ];

  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      calibre
      firefox-wayland
      gthumb
      inkscape
      iosevka
      liberation_ttf
      nerd-fonts.iosevka-term
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      obsidian
      pavucontrol
      shotman
      wl-clipboard
      zotero
    ];
  };
}
