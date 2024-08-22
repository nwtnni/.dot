{ config, ... }:
{
  programs.starship.enable = true;

  xdg.configFile.starship = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dot/starship/starship.toml";
    target = "starship.toml";
  };
}
