{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "nwtnni";
    homeDirectory = "/home/nwtnni";
    stateVersion = "23.05";
    packages = with pkgs; [
      alacritty
      bat
      delta
      fd
      firefox-wayland
      fzf
      git
      gthumb
      htop
      inkscape
      neovim
      nil
      nixpkgs-fmt
      ripgrep
      shotman
      tmux
      wl-clipboard
      zathura
    ];
  };

  programs.bash.enable = true;

  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    changeDirWidgetCommand = "fd --type d";
    fileWidgetCommand = "fd --type f";
  };

  programs.git = {
    enable = true;
    userName = "Newton Ni";
    userEmail = "nwtnni@gmail.com";
    # https://jvns.ca/blog/2024/02/16/popular-git-config-options/#rebase-autostash-true
    extraConfig = {
      branch.sort = "-commiterdate";
      commit.verbose = true;
      core.editor = "vim";
      diff.algorithm = "histogram";
      diff.colorMoved = "default";
      diff.colorMovedWS = "allow-indentation-change";
      fetch.prune = true;
      fetch.pruneTags = true;
      merge.conflictStyle = "zdiff3";
      pull.rebase = true;
      push.autoSetupRemote = true;
      push.followTags = true;
      rebase.autoSquash = true;
      rebase.autoStash = true;
      rerere.enabled = true;
      tag.sort = "-taggerdate";
    };

    delta = {
      enable = true;
      options = {
        dark = true;
        hyperlinks = true;
        line-numbers = true;
        navigate = true;
        syntax-theme = "gruvbox";

        blame-code-style = "syntax";
        blame-palette = "#161617 #1b1b1d #2a2a2d #3e3e43";

        file-style = "brightwhite";
        file-decoration-style = "ol ul";

        hunk-header-decoration-style = "#3e3e43 box ul";

        line-numbers-minus-style = "brightred";
        line-numbers-plus-style = "brightgreen";
        line-numbers-left-style = "#3e3e43";
        line-numbers-right-style = "#3e3e43";
        line-numbers-zero-style = "#57575f";

        minus-style = "brightred black";
        minus-emph-style = "black red";
        plus-style = "brightgreen black";
        plus-emph-style = "black green";

        map-styles = "\
          bold purple => syntax purple, \
          bold blue => syntax blue, \
          bold cyan => syntax cyan, \
          bold yellow => syntax yellow";

        file-added-label = "added:";
        file-modified-label = "modified:";
        file-removed-label = "removed:";
        file-renamed-label = "renamed:";
        merge-conflict-begin-symbol = "~";
        merge-conflict-end-symbol = "~";
        right-arrow = "-> ";

        merge-conflict-ours-diff-header-style = "blue bold";
        merge-conflict-ours-diff-header-decoration-style = "#3e3e43 box";
        merge-conflict-theirs-diff-header-style = "yellow bold";
        merge-conflict-theirs-diff-header-decoration-style = "#3e3e43 box";

        whitespace-error-style = "black bold";
        zero-style = "syntax";
      };
    };
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

    config = {
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
