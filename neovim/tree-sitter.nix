{ lib, runCommandLocal, vimPlugins, ... }:
let
  parserDerivations = with vimPlugins.nvim-treesitter.builtGrammars; [
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
  ];

  parserNames = lib.pipe parserDerivations [
    (builtins.map lib.getName)
    (builtins.map (lib.removeSuffix "-grammar"))
  ];
in
runCommandLocal "tree-sitter-parsers" {
  inherit parserDerivations parserNames;
  __structuredAttrs = true;
} /* bash */ ''
  local directory="$out/parser"
  mkdir -p "$directory"
  for i in "''${!parserDerivations[@]}"; do
    ln -s "''${parserDerivations[i]}/parser" "$directory/''${parserNames[i]}.so"
  done
''
