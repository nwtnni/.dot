# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import copy

from libqtile import bar, layout, widget
from libqtile.backend.wayland import InputConfig
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

import traverse

alt = "mod1"
ctrl = "control"
mod = "mod4"

terminal = guess_terminal()

# A list of available commands that can be bound to keys can be found
# at https://docs.qtile.org/en/latest/manual/config/lazy.html
keys = [
    # Switch between windows
    Key([alt], "h", lazy.function(traverse.left), desc="Move focus to left"),
    Key([alt], "l", lazy.function(traverse.right), desc="Move focus to right"),
    Key([alt], "j", lazy.function(traverse.down), desc="Move focus down"),
    Key([alt], "k", lazy.function(traverse.up), desc="Move focus up"),

    # Move windows between left/right columns or move up/down in current stack.
    Key([alt, ctrl], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([alt, ctrl], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([alt, ctrl], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([alt, ctrl], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([alt, "shift"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([alt, "shift"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([alt, "shift"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([alt, "shift"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([alt, "shift"], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    Key([mod], "tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "tab", lazy.prev_layout(), desc="Toggle between layouts"),

    Key([alt], "tab", lazy.layout.next(), desc="Move window focus to next window"),
    Key([alt, "shift"], "tab", lazy.layout.previous(), desc="Move window focus to previous window"),

    Key([alt], "d", lazy.window.kill(), desc="Kill focused window"),
    Key([alt], "r", lazy.reload_config(), desc="Reload the config"),
    Key([alt], "return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([alt], "escape", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([alt], "space", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]

groups = [Group(i) for i in "1234567890"]

# https://www.reddit.com/r/qtile/comments/ydr1pe/how_to_achieve_i3like_group_behavior_in_qtile/
@lazy.function
def focus_group(qtile, name):
    group = qtile.groups_map[name]
    if group.screen:
        qtile.focus_screen(group.screen.index)
    else:
        group.cmd_toscreen()

for i in groups:
    keys.extend(
        [
            Key(
                [alt],
                i.name,
                focus_group(i.name),
                desc="Focus group {}".format(i.name),
            ),
            Key(
                [alt, ctrl],
                i.name,
                lazy.window.togroup(i.name),
                desc="Move focused window to group {}".format(i.name),
            ),
        ]
    )

layouts = [
    layout.Bsp(
        border_on_single=True,
        border_width=2,
        # https://github.com/morhetz/gruvbox/blob/bf2885a95efdad7bd5e4794dd0213917770d79b7/colors/gruvbox.vim#L90
        border_normal="#282828",
        # https://github.com/morhetz/gruvbox/blob/bf2885a95efdad7bd5e4794dd0213917770d79b7/colors/gruvbox.vim#L127
        border_focus="#79740e",
        ratio=1.0,
        wrap_clients=True,
    ),
    layout.Max(),
]

widget_defaults = dict(
    font="Roboto Mono",
    fontsize=12,
    padding=4,
)

extension_defaults = widget_defaults.copy()

widgets = [
    widget.GroupBox(
        hide_unused=True,
        highlight_method="line",
    ),
    widget.Prompt(),
    widget.Spacer(),
    widget.Spacer(length=10),
    widget.Volume(fmt="Volume: {}"),
    widget.Spacer(length=10),
    widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
]

screens = [
    Screen(top=bar.Bar(widgets, 24)),
    Screen(top=bar.Bar(copy.copy(widgets), 24)),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = {
    "type:keyboard": InputConfig(kb_options="ctrl:nocaps")
}

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
