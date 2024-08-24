{ config, ... }:
{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    shellWrapperName = "y";
  };

  xdg.configFile.yazi = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dot/yazi";
    target = "yazi";
  };
}
