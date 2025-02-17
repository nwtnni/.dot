local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

local function apply(table)
  for key, value in pairs(table) do
    config[key] = value
  end
end

config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- Appearance
apply({
  color_scheme = "GruvboxDark",
  font = wezterm.font("Iosevka"),
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
    -- FIXME: workaround for starting copy mode without search pattern
    {
      key = "[",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.ActivateCopyMode, pane)
        window:perform_action(act.Multiple {
          act.CopyMode("ClearSelectionMode"),
          act.CopyMode("ClearPattern"),
        }, pane)
        return false
      end)
    },
    { key = 'f', mods = 'LEADER',      action = act.QuickSelect },
    { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },

    { key = "t", mods = "CTRL",        action = act.SpawnTab("CurrentPaneDomain") },
    { key = "t", mods = "LEADER",      action = act.ShowLauncherArgs { flags = "FUZZY|DOMAINS" } },
    { key = "l", mods = "LEADER",      action = act.ClearScrollback("ScrollbackAndViewport") },
    { key = "s", mods = "LEADER",      action = act.PaneSelect { mode = "SwapWithActiveKeepFocus" } },
    { key = " ", mods = "LEADER",      action = act.ShowLauncherArgs { flags = "FUZZY|COMMANDS" } },
    {
      key = "d",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane)
        local action = nil
        if pane:get_domain_name() == "local" then
          action = act.CloseCurrentTab { confirm = true }
        else
          action = act.DetachDomain("CurrentPaneDomain")
        end
        window:perform_action(action, pane)
        return false
      end)
    },

    { key = "h", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "CTRL", action = act.ActivatePaneDirection("Right") },
    { key = "j", mods = "CTRL", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "CTRL", action = act.ActivatePaneDirection("Up") },

    { key = "f", mods = "CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
  },
  key_tables = {
    -- FIXME: does not work properly
    copy_goto_mode = {
      { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") }
    },
    copy_mode = {
      { key = "n",      mods = "NONE",  action = act.CopyMode("PriorMatch") },
      { key = "n",      mods = "SHIFT", action = act.CopyMode("NextMatch") },
      { key = "/",      mods = "NONE",  action = act.Search("CurrentSelectionOrEmptyString") },
      { key = "Escape", mods = "NONE",  action = act.CopyMode("Close") },
      { key = "q",      mods = "NONE",  action = act.CopyMode("Close") },
      { key = "h",      mods = "NONE",  action = act.CopyMode("MoveLeft") },
      { key = "l",      mods = "NONE",  action = act.CopyMode("MoveRight") },
      { key = "k",      mods = "NONE",  action = act.CopyMode("MoveUp") },
      { key = "j",      mods = "NONE",  action = act.CopyMode("MoveDown") },
      { key = "u",      mods = "NONE",  action = act.CopyMode({ MoveByPage = -0.5 }) },
      { key = "d",      mods = "NONE",  action = act.CopyMode({ MoveByPage = 0.5 }) },
      { key = "v",      mods = "NONE",  action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "v",      mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      { key = "v",      mods = "CTRL",  action = act.CopyMode({ SetSelectionMode = "Block" }) },
      { key = "q",      mods = "NONE",  action = act.CopyMode("Close") },
      -- FIXME: does not work properly
      { key = "g",      mods = "NONE",  action = act.ActivateKeyTable { name = "copy_goto_mode", one_shot = true } },
      { key = "g",      mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
      {
        key = 'y',
        mods = "NONE",
        action = act.Multiple {
          act.CopyTo("ClipboardAndPrimarySelection"),
          act.ScrollToBottom,
          act.CopyMode("Close"),
        },
      },
    },
    search_mode = {
      { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
      { key = "Enter",  mods = "NONE", action = act.CopyMode("AcceptPattern"), },
    },
  },
})

return config
