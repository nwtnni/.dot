{ neovimUtils, pkgs, symlinkJoin, vimPlugins, ... }:
symlinkJoin {
  name = "tree-sitter-parsers";
  paths = builtins.map neovimUtils.grammarToPlugin (with vimPlugins.nvim-treesitter.builtGrammars; [
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
  ]);
}