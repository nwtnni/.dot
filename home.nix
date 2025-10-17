{ ... }:

let
  local = true;
  username = if local then "nwtnni" else "cc";
in
{
  imports = [
    ./tui.nix
  ] ++ (if local then [./gui.nix] else []);

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  # Handle home-manager standalone installation after
  # multi-user nix installation
  programs.bash.profileExtra = if local then "" else /* bash */ ''
    if [ -e /home/cc/.nix-profile/etc/profile.d/nix.sh ]; then
      . /home/cc/.nix-profile/etc/profile.d/nix.sh
    fi
  '';
}
