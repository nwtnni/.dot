{ config, lib, pkgs, ... }:
let
  # Replace upstream bundled tree-sitter parsers with nvim-treesitter
  # Also remove support for NVIM_SYSTEM_RPLUGIN_MANIFEST.
  neovim = lib.pipe pkgs.neovim-unwrapped [
    (neovim: neovim.overrideAttrs ({ patches = [ ]; }))
  ];

  # Convert each .lua file into a nixpkgs package
  plugins = lib.pipe (builtins.readDir ./neovim/lua/plugins) [
    builtins.attrNames
    (builtins.map (lib.removeSuffix ".lua"))
    (builtins.map (name: {
      name = if lib.hasSuffix "-nvim" name then builtins.replaceStrings [ "-nvim" ] [ ".nvim" ] name else name;
      path = lib.getAttr name pkgs.vimPlugins;
    }))
    (builtins.filter (name: name != "coq-lsp"))
  ] ++ [
    {
      name = "lazy.nvim";
      path = pkgs.vimPlugins.lazy-nvim.overrideAttrs (prevAttrs: {
        patches = prevAttrs.patches ++ [ ./neovim/lazy-nvim.patch ];
      });
    }
    {
      name = "tree-sitter-parsers";
      path = pkgs.callPackage (import ./neovim/tree-sitter.nix) { };
    }
    {
      name = "coq-lsp.nvim";
      path = pkgs.vimUtils.buildVimPlugin {
        name = "coq-lsp.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "tomtomjhj";
          repo = "coq-lsp.nvim";
          rev = "6135ed25fc2a1b4b1b6451ed206dc38b493ff1a2";
          hash = "sha256-eceyZc9nIbpe1G/kzU3Y61ut+RKfYXI78zALxN4Un+4=";
        };
      };
    }
  ];
in
{
  home.packages = with pkgs; [
    nixd
    nixpkgs-fmt
  ] ++ [ neovim ];
  home.sessionVariables.EDITOR = "nvim";

  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dot/neovim";
    target = "nvim";
  };

  xdg.dataFile.nvim-lazy-plugins = {
    source = pkgs.linkFarm "nvim-lazy" plugins;
    target = "nvim/lazy";
  };
}
