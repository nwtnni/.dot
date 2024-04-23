{ ... }:
{
  programs.ripgrep = {
    enable = true;

    arguments = [
      "--smart-case"
      "--follow"
      "--no-require-git"
      "--hyperlink-format=default"
    ];
  };
}
