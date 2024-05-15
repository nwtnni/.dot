{ pkgs, ... }:

{
  imports = [
    ./bat.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./git.nix
    ./neovim.nix
    ./ripgrep.nix
  ];

  programs.home-manager.enable = true;

  xdg.enable = true;

  home = {
    username = "nwtnni";
    homeDirectory = "/home/nwtnni";
    stateVersion = "23.05";

    packages = with pkgs; [
      alacritty
      file
      firefox-wayland
      gthumb
      hexyl
      htop
      inkscape
      shotman
      wl-clipboard
      zathura
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
      liberation_ttf
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];

    shellAliases = {
      cat = "bat";
      l = "eza";
      p = "cd ..";
      vi = "nvim";
      vim = "nvim";

      cc = "cargo check";
      cb = "cargo build";
      cbr = "cargo build --release";
      ct = "cargo test";
      cr = "cargo run";
      crr = "cargo run --release";
    };
  };

  fonts.fontconfig.enable = true;

  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    historyControl = [ "ignoredups" "ignorespace" "erasedups" ];
    historyIgnore = [ "l" "ls" "p" "pwd" ];
    shellOptions = [
      "autocd"
      "cdspell"
      "checkwinsize"
      "globstar"
      "histappend"
    ];

    initExtra = ''
      __prompt_setc() {
        printf "\x1b[38;2;%s;%s;%sm" "$1" "$2" "$3"
      }

      __prompt_clear() {
        printf "\x1b[0m"
      }

      __prompt_branch() {
        if git rev-parse --git-dir > /dev/null 2>&1; then
          if [[ -z $(git status --porcelain) ]]; then
            # Blue for git branch
            __prompt_setc 131 165 152
          else
            # Orange for dirty
            __prompt_setc 254 128 25
          fi
        else
          # White for no version control
          __prompt_setc 235 219 178
        fi
      }

      __prompt_last() {
        if [[ "$?" -eq 0 ]]; then
          # Green for good
          __prompt_setc 152 151 26
        else
          # Red for bad
          __prompt_setc 251 73 52
        fi
      }

      export PROMPT_COMMAND='[[ ''${__prompt_wd:=$PWD} != $PWD ]] && shopt -sq expand_aliases && ls; __prompt_wd=$PWD'
      export PS1='\[$(__prompt_last)\]>\[$(__prompt_clear)$(__prompt_branch)\]> \[$(__prompt_clear)\]'
      export PS2='>> '

      pas() {
          pacman -Slq | fzf --multi --preview "pacman -Si {1}" | xargs -ro sudo pacman -Syu
      }
      par() {
          pacman -Qq | fzf --multi --preview "pacman -Qi {1}" | xargs -ro sudo pacman -Rns
      }
      yas() {
          yay -Slq | fzf --multi --preview "yay -Si {1}" | xargs -ro yay -Syu
      }
      yar() {
          yay -Qq | fzf --multi --preview "yay -Qi {1}" | xargs -ro yay -Rns
      }

      ss() {
          systemctl list-unit-files \
              | fzf \
                  --nth 1 \
                  --height 50% \
                  --multi \
                  --preview "systemctl status {1}" \
                  --preview-window=wrap \
              | awk "{print \$1}"
      }
      sd() { systemctl disable $(ss); }
      se() { systemctl enable $(ss); }
      ssta() { systemctl --user start $(ss); }
      ssto() { systemctl --user stop $(ss); }
      sr() { systemctl restart $(ss); }

      sus() {
          systemctl --user list-unit-files \
              | fzf \
                  --nth 1 \
                  --height 50% \
                  --multi \
                  --preview "systemctl --user status {1}" \
                  --preview-window=wrap \
              | awk "{print \$1}"
      }
      sud() { systemctl --user disable $(sus); }
      sue() { systemctl --user enable $(sus); }
      susta() { systemctl --user start $(sus); }
      susto() { systemctl --user stop $(sus); }
      sur() { systemctl --user restart $(sus); }

      # /etc/bashrc sources `dircolors -b` by default on NixOS,
      # so we want to overwrite it for all interactive shells.
      # https://nixos.org/manual/nixos/stable/options#opt-programs.bash.enableLsColors
      export LS_COLORS="${builtins.readFile shell/.ls-colors}";
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;
    customPaneNavigationAndResize = true;
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

  services.ssh-agent = {
    enable = true;
  };

  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = "Mod1";
      terminal = "alacritty";
      defaultWorkspace = "workspace number 1";
    };

    extraOptions = [ "--unsupported-gpu" ];

    extraConfig = ''
      bindsym Print exec shotman -c output
      bindsym Print+Shift exec shotman -c region
      bindsym Print+Shift+Control exec shotman -c window

      # HACK: disable dying mouse buttons
      bindsym --input-device=2362:9505:USB_OPTICAL_MOUSE --whole-window BTN_SIDE true
      focus_follows_mouse no
    '';
  };
}
