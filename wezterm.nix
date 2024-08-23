{ config, pkgs, ... }:
{
  # Can't use `programs.wezterm.enable` because it
  # unconditionally creates `.config/wezterm/wezterm.lua`,
  # whereas we want to use an out-of-store symlink.
  home.packages = with pkgs; [
    wezterm
    xwayland
  ];

  programs.bash.initExtra = /* bash */ ''
    # https://github.com/nix-community/home-manager/blob/2598861031b78aadb4da7269df7ca9ddfc3e1671/modules/programs/wezterm.nix#L50
    source "${pkgs.wezterm}/etc/profile.d/wezterm.sh"
  '';

  xdg.configFile.wezterm = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dot/wezterm";
    target = "wezterm";
  };
}
