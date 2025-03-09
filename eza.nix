{ config, ... }:
{
  programs.eza = {
    enable = true;

    icons = "auto";

    extraOptions = [
      "--classify"
      "--group-directories-first"
      "--header"
      "--mounts"
      "--smart-group"
    ];
  };
}
