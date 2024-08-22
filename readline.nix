{ config, ... }:
{
  xdg.configFile.readline = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dot/readline";
    target = "readline";
  };

  home.sessionVariables.INPUTRC = "${config.xdg.configHome}/readline/inputrc";
}
