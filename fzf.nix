{ config, lib, ... }:
{
  programs.fzf = lib.mkMerge [
    {
      enable = true;

      # https://github.com/junegunn/fzf/wiki/Color-schemes#gruvbox-dark
      colors = {
        fg = "#ebdbb2";
        bg = "#282828";
        hl = "#fabd2f";
        "fg+" = "#ebdbb2";
        "bg+" = "#3c3836";
        "hl+" = "#fabd2f";
        info = "#83a598";
        prompt = "#bdae93";
        spinner = "#fabd2f";
        pointer = "#83a598";
        marker = "#fe8019";
        header = "#665c54";
      };
    }
    (lib.mkIf config.programs.fd.enable {
      defaultCommand = "fd --type f";
      changeDirWidgetCommand = "fd --type d";
      fileWidgetCommand = "fd --type f";
    })
  ];

  programs.bash = lib.mkIf config.programs.bash.enable {
    initExtra = ''
      fzf_file() {
        local bat="$(
          command -v bat >/dev/null \
          && echo "bat --force-colorization" \
          || echo "cat" \
        )"
        local hex="$(
          command -v hexyl >/dev/null \
          && echo "hexyl --color=always" \
          || echo "hexdump --color=always -C" \
        )"
        local bin="$(
          command -v file > /dev/null \
          && echo "[[ \$(file --mime {}) =~ binary ]]" \
          || echo "false"
        )"

        local select="$(
          fzf \
          --query="$1" \
          --exit-0 \
          --header 'Use <TAB> to paste or <ENTER> to edit.' \
          --preview "$bin && $hex {} || $bat {} 2>/dev/null" \
          --bind 'enter:become(''${EDITOR:-nvim} {} > "$(command tty)")' \
          --bind 'tab:accept' \
        )"

        if [[ -z "$select" ]]; then
          return
        fi

        export READLINE_LINE="''${READLINE_LINE:0:$READLINE_POINT}$name''${READLINE_LINE:$READLINE_POINT}"
        export READLINE_POINT=$(( READLINE_POINT + ''${#name} ))
      }

      bind '"\C-o": "\ec"'
      bind -x '"\C-e": fzf_file'
    '';
  };
}
