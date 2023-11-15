# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ pkgs, impermanence, ... }:

{
  imports = [
    ./hardware-configuration.nix
    "${impermanence}/nixos.nix"
  ];

  system.stateVersion = "23.05";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 4;

  networking.hostId = "20ae29ac";
  networking.hostName = "nwtnni-g16";
  networking.networkmanager.enable = true;

  # https://nixos.wiki/wiki/Dual_Booting_NixOS_and_Windows#System_time
  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/Chicago";

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.printing.enable = true;

  environment = {
    persistence."/nix/persist" = {
      directories = [
        "/etc/NetworkManager/system-connections"
        "/var/log"
        "/var/lib"
      ];

      files = [
        "/etc/machine-id"
      ];
    };

    systemPackages = with pkgs; [
      git
      vim
    ];
  };

  users.mutableUsers = false;
  users.extraUsers = {
    root = {
      initialHashedPassword = "$6$wwAkpT1c0DOGE34/$ssPWCcxWnpjMCikLllHlKCO0HmU03jqg/jR5BKBFzyi3NdP29zXGWTJ6Jo3zarA.4QMZ9OUeqqW8myQxHXPmJ0";
    };

    nwtnni = {
      isNormalUser = true;
      description = "Newton Ni";
      extraGroups = [ "wheel" "networkmanager" ];
      initialHashedPassword = "$6$wwAkpT1c0DOGE34/$ssPWCcxWnpjMCikLllHlKCO0HmU03jqg/jR5BKBFzyi3NdP29zXGWTJ6Jo3zarA.4QMZ9OUeqqW8myQxHXPmJ0";
    };
  };
}
