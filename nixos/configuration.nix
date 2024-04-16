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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 4;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostId = "20ae29ac";
  networking.hostName = "nwtnni-g16";
  networking.networkmanager.enable = true;

  # https://nixos.wiki/wiki/Dual_Booting_NixOS_and_Windows#System_time
  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/Chicago";

  hardware.opengl.enable = true;
  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.greetd = {
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
  services.printing.enable = true;
  services.udev.extraHwdb = "evdev:name:Asus Keyboard:*\n KEYBOARD_KEY_70039=leftctrl";
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    audio.enable = true;
    pulse.enable = true;
  };

  environment = {
    persistence."/nix/persist" = {
      directories = [
        "/etc/NetworkManager/system-connections"
        "/var/cache/tuigreet"
        "/var/log"
        "/var/lib"
      ];

      files = [
        "/etc/greetd/environments"
        "/etc/machine-id"
      ];
    };
  };

  fonts.packages = with pkgs; [
    iosevka
    liberation_ttf
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  users.defaultUserShell = pkgs.bash;
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

  programs = {
    direnv.enable = true;

    git.enable = true;

    ssh.startAgent = true;

    sway.enable = true;

    tmux = {
      enable = true;
      shortcut = "a";
      keyMode = "vi";
      customPaneNavigationAndResize = true;
      historyLimit = 10000;
    };

    vim.defaultEditor = true;
  };
}
