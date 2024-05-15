{ config, lib, ... }:

{
  home.shellAliases = {
    g = "git";
    gs = "git status";
    gsh = "git show HEAD";
    gshs = "DELTA_FEATURES=+side-by-side git show HEAD";
    ga = "git add";
    gaa = "git add :/";
    gap = "git add -p";
    gc = "git commit";
    gca = "git commit --amend";
    gcm = "git commit --message";
    gcf = "git commit --fixup";
    gk = "git checkout";
    gkp = "git checkout -p";
    gd = "git diff";
    gds = "DELTA_FEATURES=+side-by-side git diff";
    gdc = "git diff --cached";
    gdcs = "DELTA_FEATURES=+side-by-side git diff --cached";
    gf = "git fetch";
    gl = "git log";
    glp = "git log -p";
    glps = "DELTA_FEATURES=+side-by-side git log -p";
    gp = "git push";
    gpf = "git push --force-with-lease";
    gr = "git reset";
    gra = "git reset :/";
    grp = "git reset -p";
    gt = "git stash";
    gtp = "git stash pop";
    gu = "git pull";
  };

  programs.bash = lib.mkIf config.programs.bash.enable {
    historyIgnore = [ "gs" ];
    initExtra = (lib.strings.optionalString config.programs.fzf.enable ''
      gbc () {
        git checkout $(git branch --list | fzf)
      }

      gbd () {
        git branch -d $(git branch --list | fzf)
      }
    '') + ''
      grbi() {
        if [[ "$#" -gt 0 ]]; then
          git rebase -i "HEAD~$1"
        elif [[ $(git rev-list --root HEAD --count) -le 10 ]]; then
          git rebase -i --root
        else
          git rebase -i "HEAD~10"
        fi
      }
    '';
  };

  programs.eza = lib.mkIf config.programs.eza.enable {
    extraOptions = [ "--git" ];
  };

  programs.git = {
    enable = true;
    userName = "Newton Ni";
    userEmail = "nwtnni@gmail.com";

    # https://jvns.ca/blog/2024/02/16/popular-git-config-options/#rebase-autostash-true
    extraConfig = {
      core.commentChar = ";";
      branch.sort = "-committerdate";
      commit.verbose = true;
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

    ignores = [
      ".DS_Store"
      ".direnv"
      ".envrc"
      "*.tags"
      "*.swp"
    ];

    delta = {
      enable = true;
      options = {
        dark = true;
        hyperlinks = true;
        line-numbers = true;
        navigate = true;
        syntax-theme = lib.optionalAttrs config.programs.bat.enable config.programs.bat.config.theme;

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
}
