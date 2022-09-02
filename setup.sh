#!/bin/bash

# Trace for debugging
set -x

# Install dotfiles
apt-get install stow && stow .

# Make .local directory for software installation
mkdir -p ~/.local/lib
cd ~/.local/lib

# Install neovim and build dependencies
apt-get install libtool libtool-bin
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
make install
cd -
# Inside neovim
# :PlugInstall

# Install FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install Rust and co.
curl https://sh.rustup.rs -sSf | sh

cargo install alacritty
cargo install ripgrep
cargo install fd-find
cargo install bat
cargo install exa
cargo install tokei
cargo install --git https://github.com/nwtnni/goldfish.git

rustup component add rust-src
git clone https://github.com/rust-lang/rust-analyzer.git
cd rust-analyzer
cargo xtask install --server
cd -

# Install tmux plugins
mkdir -p ~/.tmux/plugins/
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# If tmux is already running:
# tmux source ~/.tmux.conf
cd ~/.tmux/plugins/tmux-copy
cargo build --release
cd -

# Install Iosevka font
IOSEVKA_VERSION="16.0.2"
mkdir ~/.fonts
wget -O "https://github.com/be5invis/Iosevka/releases/download/v${IOSEVKA_VERSION}/super-ttc-iosevka-${IOSEVKA_VERSION}.zip" | gunzip > ~/.fonts/iosevka.ttc
