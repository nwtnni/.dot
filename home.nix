{ ... }:
{
  imports = [
    ./tui.nix
    ./gui.nix
  ];

  home = {
    username = "nwtnni";
    homeDirectory = "/home/nwtnni";
    stateVersion = "25.05";
  };
}
