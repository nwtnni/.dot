{ ... }:
{
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

      # https://superuser.com/questions/555310/bash-save-history-without-exit
      export PROMPT_COMMAND="''${PROMPT_COMMAND:-:}; history -a; history -c; history -r;";
    '';
  };
}
