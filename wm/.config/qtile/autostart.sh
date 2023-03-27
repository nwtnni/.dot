#!/usr/bin/env bash
# https://github.com/emersion/xdg-desktop-portal-wlr/wiki/%22It-doesn't-work%22-Troubleshooting-Checklist

if command -v dbus-update-activation-environment > /dev/null; then
    dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
fi

systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
systemctl --user start pipewire
systemctl --user start xdg-desktop-portal
