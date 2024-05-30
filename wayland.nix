{ ... }:

{
  wayland.windowManager.sway = {
    enable = true;

    # Use NixOS sway package
    package = null;

    config = {
      modifier = "Mod1";
      terminal = "alacritty";
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
    settings = [
      {
        profile.name = "g16";
        profile.outputs = [
          {
            criteria = "eDP-1";
          }
        ];
      }
      {
        profile.name = "g16-gdc";
        profile.outputs = [
          {
            criteria = "eDP-1";
            position = "0,960";
          }
          {
            criteria = "Dell Inc. DELL U2412M YMYH134F24TS";
            transform = "90";
            position = "1920,0";
          }
        ];
      }
    ];
  };
}
