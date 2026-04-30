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
      firefox
      gthumb
      # inkscape
      iosevka
      liberation_ttf
      nerd-fonts.iosevka-term
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      # obsidian
      pavucontrol
      shotman
      wl-clipboard
      zotero
    ];
  };
}
