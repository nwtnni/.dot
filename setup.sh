#!/bin/bash

# Trace for debugging
set -x

# Install dotfiles
apt-get install stow && stow .

# Make .local directory for software installation
mkdir -p ~/.local/lib && cd ~/.local/lib

# Install neovim and build dependencies
apt-get install libtool libtool-bin
git clone https://github.com/neovim/neovim.git && cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
make install

# Install alacritty and build dependencies
curl https://sh.rustup.rs -sSf | sh
