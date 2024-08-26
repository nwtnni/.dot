{ ... }:
{
  programs.zathura = {
    enable = true;

    # https://github.com/morhetz/gruvbox
    options = let
      bg0 = "#282828";
      bg1 = "#3c3836";
      fg = "#ebdbb2";
      yellow = "#d79921";
      yellow-bright = "#fabd2f";
    in {
      completion-bg = bg1;
      completion-fg = fg;
      completion-group-bg = bg1;
      completion-group-fg = fg;
      completion-highlight-bg = yellow;
      completion-highlight-fg = fg;
      default-bg = bg0;
      default-fg = fg;
      font = "Iosevka 10";
      guioptions = "";
      inputbar-bg = bg1;
      inputbar-fg = fg;
      notification-bg = bg1;
      notification-fg = fg;
      notification-warning-bg = yellow;
      notification-warning-fg = fg;
      statusbar-bg = bg1;
      statusbar-fg = fg;

      database = "sqlite";
      first-page-column = "1:1";
      highlight-active-color = yellow-bright;
      highlight-color = yellow;
      index-active-bg = yellow-bright;
      index-active-fg = fg;
      index-bg = bg1;
      index-fg = fg;
      recolor = true;
      recolor-darkcolor = fg;
      recolor-lightcolor = bg0;
      render-loading-bg = bg0;
      render-loading-fg = fg;
      statusbar-home-tilde = true;
      statusbar-page-percent = true;
      window-title-home-tilde = true;
    };
  };
}
