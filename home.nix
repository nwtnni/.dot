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
  ];

  programs.home-manager.enable = true;

  xdg.enable = true;

  home = {
    username = "nwtnni";
    homeDirectory = "/home/nwtnni";
    stateVersion = "23.05";

    packages = with pkgs; [
      file
      firefox-wayland
      gthumb
      hexyl
      htop
      inkscape
      # https://typeof.net/Iosevka/customizer
      (iosevka.override {
        set = "SlabFixed";
        privateBuildPlan = /* toml */ ''
          [buildPlans.IosevkaSlabFixed]
          family = "Iosevka Slab Fixed"
          spacing = "fixed"
          serifs = "slab"
          noCvSs = false
          exportGlyphNames = false

          [buildPlans.IosevkaSlabFixed.ligations]
          inherits = "dlig"

          [buildPlans.IosevkaSlabFixed.widths.Condensed]
          shape = 500
          menu = 3
          css = "condensed"

          [buildPlans.IosevkaSlabFixed.widths.Normal]
          shape = 600
          menu = 5
          css = "normal"
        '';
      })
      shotman
      wl-clipboard
      zathura
      # https://sw.kovidgoyal.net/kitty/faq/#kitty-is-not-able-to-use-my-favorite-font
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      liberation_ttf
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      pavucontrol
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
