{ pkgs, impermanence, ... }:

{
  imports = [
    "${impermanence}/nixos.nix"
  ];

  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "thunderbolt" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm_intel" ];

  fileSystems."/" =
    {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=4G" "mode=755" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/SYSTEM";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-label/NIXOS-STORE";
      fsType = "ext4";
      neededForBoot = true;
      options = [ "noatime" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-label/NIXOS-HOME";
      fsType = "ext4";
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

  networking.hostId = "20ae29ac";
  networking.hostName = "nwtnni-g16";

  nixpkgs.hostPlatform = "x86_64-linux";

  powerManagement.cpuFreqGovernor = "powersave";

  programs.sway = {
    extraOptions = [ "--unsupported-gpu" ];

    # TODO: add specialization for disabling GPU entirely
    # extraSessionCommands = /* bash */ ''
    #   gpu_integrated=$(ls -l /dev/dri/by-path/pci-0000:00:02.0-card | grep -o 'card[[:digit:]]$')
    #   export WLR_DRM_DEVICES="/dev/dri/''${gpu_integrated}"
    # '';
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;

    nvidia = {
      modesetting.enable = true;
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        offload.enable = true;
        offload.enableOffloadCmd = true;
      };
    };
  };
}
