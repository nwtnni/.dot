{ config, ... }:
{
  programs.eza = {
    enable = true;

    icons = config.fonts.fontconfig.enable;

    extraOptions = [
      "--classify"
      "--group-directories-first"
      "--header"
      "--mounts"
      "--smart-group"
    ];
  };
}
