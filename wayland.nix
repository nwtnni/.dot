{ pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;

    # Use NixOS sway package
    package = null;

    config = {
      modifier = "Mod1";
      terminal = "wezterm";
      defaultWorkspace = "workspace number 1";
    };

    extraConfig = ''
      bindsym Print exec shotman -c output
      bindsym Print+Shift exec shotman -c region
      bindsym Print+Shift+Control exec shotman -c window

      # HACK: disable dying mouse buttons
      bindsym --input-device=2362:9505:USB_OPTICAL_MOUSE --whole-window BTN_SIDE true
      focus_follows_mouse no
    '';
  };

  services.kanshi = {
    enable = true;
    settings = let
      G16_MONITOR = "BOE NE160WUM-NX2 Unknown";
      GDC_MONITOR =  "Dell Inc. DELL U2412M YMYH134F24TS";
    in [
      {
        profile = {
          name = "g16";
          outputs = [
            {
              criteria = G16_MONITOR;
            }
          ];
        };
      }
      {
        profile = {
          name = "g16-gdc";
          outputs = [
            {
              criteria = G16_MONITOR;
              position = "0,960";
            }
            {
              criteria = GDC_MONITOR;
              transform = "90";
              position = "1920,0";
            }
          ];
          # FIXME: sway doesn't seem to recognize vendor name
          # exec = [
          #   "${pkgs.sway}/bin/swaymsg workspace 1, move workspace to \"${G16_MONITOR}\""
          #   "${pkgs.sway}/bin/swaymsg workspace 2, move workspace to \"${GDC_MONITOR}\""
          # ];
        };
      }
    ];
  };
}
