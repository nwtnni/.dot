local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

local function apply(table)
  for key, value in pairs(table) do
    config[key] = value
  end
end

-- https://github.com/wez/wezterm/issues/3214
config.enable_wayland = false

-- Appearance
apply({
  color_scheme = "GruvboxDark",
  font = wezterm.font("IosevkaSlabFixed"),
  use_fancy_tab_bar = false,
})

-- Scrollback
apply({
  scrollback_lines = 10000,
})

-- Keybindings
apply({
  leader = { mods = "CTRL", key = "a" },
  keys = {
    { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal },
    { key = "-", mods = "LEADER",       action = act.SplitVertical },
    { key = "z", mods = "LEADER",       action = act.TogglePaneZoomState },
    { key = "[", mods = "LEADER",       action = act.ActivateCopyMode },

    { key = "h", mods = "LEADER",       action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "LEADER",       action = act.ActivatePaneDirection("Right") },
    { key = "j", mods = "LEADER",       action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER",       action = act.ActivatePaneDirection("Up") },

    { key = "f", mods = "CTRL",         action = act.Search("CurrentSelectionOrEmptyString") },
  },
})

return config
