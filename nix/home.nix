{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "nwtnni";
  home.homeDirectory = "/home/nwtnni";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    alacritty
    fd
    firefox-wayland
    fzf
    htop
    neovim
    ripgrep
    rustup
    shotman
    tmux
    wl-clipboard
  ];

  programs.git = {
    enable = true;
    userName = "Newton Ni";
    userEmail = "nwtnni@gmail.com";
  };

  programs.tmux = {
    enable = true;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    shortcut = "a";
    plugins = with pkgs.tmuxPlugins; [
      { plugin = gruvbox; }
      {
        plugin = tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-key f
          set -g @thumbs-reverse enabled
          set -g @thumbs-command 'echo -n {} | wl-copy'
          set -g @thumbs-upcase-command 'echo -n {} | wl-paste'
        '';
      }
      { plugin = vim-tmux-navigator; }
      { plugin = yank; }
    ];
    extraConfig = ''
      set -g status 'off'

      bind C-a send-keys 'C-a'
      bind C-x send-keys 'C-x'
      bind C-l send-keys 'C-l'
      bind - split-window -v -c '#{pane_current_path}'
      bind | split-window -h -c '#{pane_current_path}'
      bind -T copy-mode-vi 'v' send -X begin-selection

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
    '';
  };

  wayland.windowManager.sway = {
    enable = true;

    config = rec {
      modifier = "Mod1";
      terminal = "alacritty";
    };

    extraConfig = ''
      bindsym Print exec shotman -c output
      bindsym Print+Shift exec shotman -c region
      bindsym Print+Shift+Control exec shotman -c window
    '';
  };
}
