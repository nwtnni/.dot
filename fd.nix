{ ... }:
{
  programs.fd = {
    enable = true;
    hidden = true;
    extraOptions = [
      "--follow"
      "--no-require-git"
    ];
  };
}
