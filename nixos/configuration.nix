# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "23.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub.enable = false;
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 4;
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.networkmanager.enable = true;

  # https://nixos.wiki/wiki/Dual_Booting_NixOS_and_Windows#System_time
  time = {
    hardwareClockInLocalTime = true;
    timeZone = "America/Chicago";
  };

  hardware.bluetooth.enable = true;
  hardware.graphics.enable = true;

  programs.sway.enable = true;

  programs.nix-ld.enable = true;

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    greetd = {
      enable = true;
      settings.default_session.command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --asterisks \
          --remember \
          --remember-session \
          --time \
          --cmd sway
      '';
    };

    printing.enable = true;

    udev.extraHwdb = "evdev:name:*[Kk]eyboard*:*\n KEYBOARD_KEY_70039=leftctrl";

    # https://nixos.wiki/wiki/Calibre
    udisks2.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      audio.enable = true;
      pulse.enable = true;
    };
  };

  virtualisation.docker.enable = true;

  users.mutableUsers = false;
  users.extraUsers = {
    root = {
      initialHashedPassword = "$6$wwAkpT1c0DOGE34/$ssPWCcxWnpjMCikLllHlKCO0HmU03jqg/jR5BKBFzyi3NdP29zXGWTJ6Jo3zarA.4QMZ9OUeqqW8myQxHXPmJ0";
    };

    nwtnni = {
      isNormalUser = true;
      description = "Newton Ni";
      extraGroups = [ "dialout" "docker" "wheel" "networkmanager" ];
      initialHashedPassword = "$6$wwAkpT1c0DOGE34/$ssPWCcxWnpjMCikLllHlKCO0HmU03jqg/jR5BKBFzyi3NdP29zXGWTJ6Jo3zarA.4QMZ9OUeqqW8myQxHXPmJ0";
    };
  };
}
