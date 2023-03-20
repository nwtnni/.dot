# Newton Ni

export PATH="$PATH:$HOME/.local/bin"
export TZ="America/Chicago"
export EDITOR="nvim"

# Rust
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export RUST_DOC_PATH="$(rustc --print sysroot)"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$(rustc --print sysroot)"
source "$HOME/.cargo/env"

# OCaml
eval $(opam env)

# fzf
export FZF_DEFAULT_COMMAND="fd --type f -j 8"
export FZF_ALT_C_COMMAND="fd --type d -j 8"

# ssh
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

[[ -x /usr/bin/dircolors ]] && eval "$(dircolors -b ~/.dircolors)"

# If running bash or zsh
if [ -n "$BASH_VERSION" ] || [ "$SHELL" == *zsh ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
    fi
	if [ -f "$HOME/.bash_aliases" ]; then
		. "$HOME/.bash_aliases"
	fi
fi
