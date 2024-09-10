{ pkgs, ... }:

{
  imports = [
    ./bat.nix
    ./bash.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./git.nix
    ./neovim.nix
    ./readline.nix
    ./ripgrep.nix
    ./starship.nix
    ./vivid.nix
    ./wayland.nix
    ./wezterm.nix
    ./yazi.nix
    ./zathura.nix
    ./zoxide.nix
  ];

  programs.home-manager.enable = true;

  xdg.enable = true;

  home = {
    username = "nwtnni";
    homeDirectory = "/home/nwtnni";
    stateVersion = "23.05";

    packages = with pkgs; [
      calibre
      file
      firefox-wayland
      gthumb
      hexyl
      htop
      hyperfine
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

    shellAliases = {
      cat = "bat";
      l = "eza";
      p = "cd ..";
      vi = "nvim";
      vim = "nvim";

      cc = "cargo check";
      cb = "cargo build";
      cbr = "cargo build --release";
      ct = "cargo test";
      cr = "cargo run";
      crr = "cargo run --release";
    };
  };

  fonts.fontconfig.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.ssh-agent = {
    enable = true;
  };
}
