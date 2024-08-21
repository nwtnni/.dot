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
    ./wayland.nix
    ./wezterm.nix
  ];

  programs.home-manager.enable = true;

  xdg.enable = true;

  home = {
    username = "nwtnni";
    homeDirectory = "/home/nwtnni";
    stateVersion = "23.05";

    packages = with pkgs; [
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
      pavucontrol
      zotero
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

  services.ssh-agent = {
    enable = true;
  };
}
