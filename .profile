# Newton Ni

export PATH="$PATH:$HOME/.local/bin"
export TZ="America/Chicago"
export EDITOR="nvim"

# Must match ~/.config/systemd/user/ssh-agent.service
# https://wiki.archlinux.org/title/SSH_keys#Start_ssh-agent_with_systemd_user
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

if command -v vivid > /dev/null; then
    export LS_COLORS=$(vivid generate gruvbox)
elif command -v dircolors > /dev/null && [[ -x "$HOME/.dircolors" ]]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
fi

if command -v rustc > /dev/null; then
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
    export RUST_DOC_PATH="$(rustc --print sysroot)"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$(rustc --print sysroot)"
    source "$HOME/.cargo/env"
fi

if command -v opam > /dev/null; then
    eval $(opam env)
fi

if command -v fzf > /dev/null && command -v fd > /dev/null; then
    export FZF_DEFAULT_COMMAND="fd --type f -j 8"
    export FZF_ALT_C_COMMAND="fd --type d -j 8"
fi

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
