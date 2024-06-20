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

  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  networking.hostId = "20ae29ac";
  networking.hostName = "nwtnni-g16";

  nixpkgs.hostPlatform = "x86_64-linux";

  services.udev.extraRules =
    let
      tune-cpu = pkgs.writeShellScript "tune-cpu.sh" /* bash */ ''
        cpu="/sys/devices/system/cpu"
        intel_pstate="$cpu/intel_pstate"
        nmi_watchdog="/proc/sys/kernel/nmi_watchdog"

        # This script assumes that intel_pstate is in active mode.
        # https://wiki.archlinux.org/title/CPU_frequency_scaling
        #
        # Note: for newer Intel CPUs, it seems that energy performance
        # preference (EPP) takes precedence over energy performance bias (EPB):
        # https://bbs.archlinux.org/viewtopic.php?id=282383
        if [[ "''${POWER_SUPPLY_ONLINE:-0}" -eq 1 ]]; then
          echo 1 > "$intel_pstate/hwp_dynamic_boost"
          echo 0 > "$intel_pstate/no_turbo"
          echo performance | tee $cpu/cpu*/cpufreq/scaling_governor
          echo default | tee $cpu/cpu*/cpufreq/energy_performance_preference
          echo 1 > "$nmi_watchdog"
        else
          echo 0 > "$intel_pstate/hwp_dynamic_boost"
          echo 1 > "$intel_pstate/no_turbo"
          echo powersave | tee $cpu/cpu*/cpufreq/scaling_governor
          echo power | tee $cpu/cpu*/cpufreq/energy_performance_preference
          echo 0 > "$nmi_watchdog"
        fi
      '';
    in
      /* udev */ ''
      # https://bbs.archlinux.org/viewtopic.php?pid=1155492#p1155492
      # Get power supply name from `udevadm monitor --property --udev`.
      SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_NAME}=="ADP0", RUN+="${tune-cpu}"

      # https://wiki.archlinux.org/title/Power_management
      SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="auto"
    '';

  specialisation = {
    # https://github.com/NixOS/nixos-hardware/blob/8251761f93d6f5b91cee45ac09edb6e382641009/common/gpu/nvidia/disable.nix
    gpu-disable.configuration = {
      boot = {
        blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
        extraModprobeConfig = ''
          blacklist nouveau
          options nouveau modeset=0
        '';
      };

      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
    };

    gpu-nvidia.configuration = {
      boot.kernelParams = [
        # https://wiki.archlinux.org/title/backlight
        "acpi_backlight=native"

        # Enable nvidia framebuffer to support booting without integrated GPU
        "nvidia-drm.fbdev=1"
      ];

      programs.sway = {
        extraOptions = [ "--unsupported-gpu" ];

        extraSessionCommands = /* bash */ ''
          # https://wiki.archlinux.org/title/sway#No_visible_cursor
          export WLR_NO_HARDWARE_CURSORS=1;

          # Miscellaneous environment variables for trying to get Vulkan
          # working with sway + wlroots + nvidia + external monitor.
          # Could not find a working configuration.
          #
          # export WLR_RENDERER="vulkan";
          # export DRI_PRIME="pci-0000_01_00_0";
          # export __VK_LAYER_NV_optimus="NVIDIA_only";
          # export __GLX_VENDOR_LIBRARY_NAME="nvidia";
          # export VK_DRIVER_FILES="/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
        '';
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware = {
        nvidia = {
          modesetting.enable = true;
          prime = {
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
          };
        };
      };
    };
  };
}
