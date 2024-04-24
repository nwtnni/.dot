{ config, lib, pkgs, ... }:
let
  path = ./neovim;

  # https://github.com/NixOS/nixpkgs/blob/35d04eadef630a045d25101d9394f04a3237707f/lib/generators.nix#L525
  inline = expr: { _type = "lua-inline"; inherit expr; };

  data = lib.pipe (builtins.readDir path) [
    # Restrict ourselves to .nix files
    (lib.filterAttrs (_: kind: kind == "regular"))
    (lib.filterAttrs (name: _: lib.hasSuffix "nix" name))
    builtins.attrNames

    # Convert each .nix file into (1) a nixpkgs package and (2) a lazy.nvim spec.
    (builtins.map (name:
      let
        plugin = lib.getAttr (lib.removeSuffix ".nix" name) pkgs.vimPlugins;
        spec = import (path + "/${name}");
      in
      {
        plugins = { inherit plugin; optional = true; };
        specs = lib.generators.toLua { } ((spec inline) // { dir = plugin.outPath; });
      }
    ))
    lib.zipAttrs
  ];
  specs = (builtins.concatStringsSep ",\n" data.specs)
    + (lib.optionalString (builtins.length data.specs > 0) ",\n");
in
{
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    extraLuaConfig = builtins.readFile ./neovim/init.lua;
    withRuby = false;
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (languages: with languages; [
        asm
        bash
        bibtex
        c
        cmake
        cpp
        css
        csv
        diff
        disassembly
        dockerfile
        dot
        ebnf
        git_config
        git_rebase
        gitattributes
        gitcommit
        gitignore
        go
        haskell
        helm
        html
        ini
        java
        javascript
        jq
        json
        kconfig
        lalrpop
        latex
        linkerscript
        llvm
        lua
        luadoc
        make
        markdown
        markdown_inline
        nasm
        ninja
        nix
        ocaml
        objdump
        python
        rust
        sql
        ssh_config
        strace
        tlaplus
        tmux
        toml
        tsv
        typescript
        vim
        vimdoc
        xml
        yaml
      ]))
      {
        plugin = lazy-nvim;
        type = "lua";
        optional = false;
        config = ''
          	  require("lazy").setup(
                      ${specs}
          	    {
          	      change_detection = { enabled = false },
                        defaults = { lazy = true },
          	      install = { missing = false },
          	      performance = {
                          reset_packpath = false,
          	        rtp = { reset = false },
          	      },
          	      readme = { enabled = false },
          	    }
          	  )
          	'';
      }
    ] ++ data.plugins;
  };
}
