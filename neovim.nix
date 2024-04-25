{ config, lib, pkgs, ... }:
let
  parsers = pkgs.callPackage (import ./tree-sitter.nix) { };

  space = n: lib.strings.replicate n " ";
  indent = n: s: lib.pipe s [
    (builtins.split "\n")
    (builtins.filter builtins.isString)
    (builtins.map (line: (space n) + line))
    (builtins.concatStringsSep "\n")
  ];

  root = ./neovim;

  # Convert each .nix file into (1) a nixpkgs package and (2) a lazy.nvim spec.
  data = lib.pipe (builtins.readDir root) [
    (lib.filterAttrs (_: kind: kind == "regular"))
    builtins.attrNames
    (builtins.filter (lib.hasSuffix "nix"))
    (builtins.map (path:
      let
        inline = expr: (lib.pipe expr [
          (expr: "\n" + expr)
          (indent 4)
          lib.generators.mkLuaInline
        ]);
        name = (lib.removeSuffix ".nix" path);
        plugin = lib.getAttr name pkgs.vimPlugins;
        spec = import (root + "/${path}") inline;
        specs = lib.generators.toLua { } (spec // { inherit name; dir = plugin; });
      in
      {
        plugins = plugin;
        specs = builtins.replaceStrings [ "<TREE_SITTER_PARSERS>" ] [ "${parsers}" ] specs;
      }
    ))
    lib.zipAttrs
  ];
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = [ pkgs.neovim-unwrapped ];

  xdg.configFile."nvim/init.lua" = {
    text = ''
      -- Include tree-sitter and lazy-nvim in runtimepath
      vim.opt.rtp:prepend([[${parsers}]])
      vim.opt.rtp:prepend([[${pkgs.vimPlugins.lazy-nvim}]])

      require("lazy").setup(
        {
      ${builtins.concatStringsSep ",\n" (builtins.map (indent 4) data.specs) }
        },
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

      ${builtins.readFile ./neovim/init.lua}
    '';
  };
}
