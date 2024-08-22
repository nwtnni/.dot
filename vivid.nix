{ pkgs, ... }:
{
  home.packages = [ pkgs.vivid ];

  programs.bash.initExtra = /* bash */ ''
    export LS_COLORS="$(vivid generate gruvbox-dark)";
  '';
}
