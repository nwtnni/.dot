{ config, lib, pkgs, ... }:
let
  # Replace upstream bundled tree-sitter parsers with nvim-treesitter
  # Also remove support for NVIM_SYSTEM_RPLUGIN_MANIFEST.
  neovim = lib.pipe pkgs.neovim-unwrapped [
      (neovim: neovim.override { treesitter-parsers = { }; })
      (neovim: neovim.overrideAttrs ({ patches = [ ]; }))
  ];

  # Convert each .lua file into a nixpkgs package
  plugins = lib.pipe (builtins.readDir ./neovim/lua/plugins) [
    builtins.attrNames
    (builtins.map (lib.removeSuffix ".lua"))
    (builtins.map (name: {
      name = builtins.replaceStrings [ "-nvim" ] [".nvim" ] name;
      path = lib.getAttr name pkgs.vimPlugins;
    }))
  ] ++ [
    {
      name = "lazy.nvim";
      path = pkgs.vimPlugins.lazy-nvim.overrideAttrs (prevAttrs: {
        patches = prevAttrs.patches ++ [ ./neovim/lazy-nvim.patch ];
      });
    }
    {
      name = "tree-sitter-parsers";
      path = pkgs.callPackage (import ./neovim/tree-sitter.nix) {};
    }
  ];
in
{
  home.packages = [ neovim ];
  home.sessionVariables.EDITOR = "nvim";

  xdg.configFile.nvim-init = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dot/neovim/init.lua";
    target = "nvim/init.lua";
  };

  xdg.configFile.nvim-lazy-configuration = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dot/neovim/lua";
    target = "nvim/lua";
  };

  xdg.dataFile.nvim-lazy-plugins = {
    source = pkgs.linkFarm "nvim-lazy" (builtins.trace (builtins.typeOf (builtins.elemAt plugins 0)) plugins);
    target = "nvim/lazy";
  };
}
