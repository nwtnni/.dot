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
    ./yazi.nix
    ./zoxide.nix
  ];

  programs.home-manager.enable = true;

  xdg.enable = true;

  home = {
    packages = with pkgs; [
      file
      hexyl
      htop
      hyperfine
      tmate
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.ssh-agent = {
    enable = true;
  };
}
