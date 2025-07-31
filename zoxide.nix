{ ... }:
{
  programs.zoxide = {
    enable = true;
  };

  programs.bash.initExtra = ''
    o() {
      if [[ -z $1 ]]; then
        zi
      else
        z $1
      fi
    }
  '';
}
