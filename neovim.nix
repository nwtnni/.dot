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
        specs = lib.generators.toLua { } ({ inherit name; dir = plugin; } // spec);
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
  home.packages = [ pkgs.neovim-unwrapped ];
  home.sessionVariables.EDITOR = "nvim";

  xdg.configFile."nvim/init.lua" = {
    text = ''
      vim.opt.rtp = {
        -- Use nvim-treesitter parsers for ABI compatibility
        [[${parsers}]],

        -- Manage all plugin loading with lazy.nvim
        [[${pkgs.vimPlugins.lazy-nvim}]],

        -- Include user configuration
        vim.fn.stdpath("config"),

        -- Include bundled runtime
        [[${pkgs.neovim-unwrapped}/share/nvim/runtime]],
      }

      -- Packpath is not used by lazy.nvim
      vim.opt.packpath = {}

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
