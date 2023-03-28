# Newton Ni

export PATH="$PATH:$HOME/.local/bin"
export LANG="en_US.UTF-8"

if [[ -n "$SSH_CONNECTION" ]]; then
    export EDITOR="vim"
else
    export EDITOR="nvim"
    export TZ="America/Chicago"

    # Must match ~/.config/systemd/user/ssh-agent.service
    # https://wiki.archlinux.org/title/SSH_keys#Start_ssh-agent_with_systemd_user
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

[[ -f "$HOME/.ls-colors" ]] && export LS_COLORS=$(cat $HOME/.ls-colors)

if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
    export RUST_DOC_PATH="$(rustc --print sysroot)"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$(rustc --print sysroot)"
fi

if command -v opam > /dev/null; then
    eval $(opam env)
fi

if command -v fzf > /dev/null; then
    # https://github.com/junegunn/fzf/blob/master/ADVANCED.md#color-themes
    export FZF_DEFAULT_OPTS='--color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'

    if command -v fd > /dev/null; then
        export FZF_DEFAULT_COMMAND="fd --type f -j 8"
        export FZF_ALT_C_COMMAND="fd --type d -j 8"
    fi
fi
