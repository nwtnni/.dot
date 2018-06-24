# Newton Ni

# Initial setup
PATH="$HOME/bin:$HOME/local/bin:$HOME/.local/bin:$PATH:/usr/local/bin"

export RANGER_LOAD_DEFAULT_RC="FALSE"

# C
export PATH="$PATH:/usr/local/lib/cquery/bin"
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"

# Go
export PATH="$PATH:/usr/lib/go-1.9/bin"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/nwtnni/.google/google-cloud-sdk/path.bash.inc' ]; then source '/home/nwtnni/.google/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/nwtnni/.google/google-cloud-sdk/completion.bash.inc' ]; then source '/home/nwtnni/.google/google-cloud-sdk/completion.bash.inc'; fi

# JS
export NPM_PACKAGES="/home/nwtnni/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules${NODE_PATH:+:$NODE_PATH}"
export PATH="$NPM_PACKAGES/bin:$PATH"
# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH  # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# Haskell
export PATH="$PATH:$HOME/.cabal/bin:/opt/cabal/2.0/bin:/opt/ghc/8.2.2/bin"

# Python
export PATH="$HOME/.pyenv/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export LD_LIBRARY_PATH="$(rustc --print sysroot)/lib:$LD_LIBRARY_PATH"

# Ruby
export PATH="$PATH:$HOME/.rvm/bin"

export EDITOR="nvim"

export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_ALT_C_COMMAND="fd --type d"
export FZF_CTRL_T_COMMAND="$FZF_ALT_C_COMMAND"
export FZF_TMUX=1

export TERM="xterm-256color-italic"

setc () {
  printf "\x1b[38;2;%s;%s;%sm" "$1" "$2" "$3"
}

clear () {
  printf "\x1b[0m"
}

branch () {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    if [[ -z $(git status --porcelain) ]]; then
      # Blue for git branch
      setc 131 165 152
    else
      # Orange for dirty
      setc 254 128 25
    fi
  else
    # White for no version control
    setc 235 219 178
  fi
}


last () {
  if [[ "$?" -eq 0 ]]; then
    # Green for good
    setc 152 151 26
  else
    # Red for bad
    setc 251 73 52
  fi
}

export PS1='\[$(last)\]λ \[$(clear)$(branch)\]→ \[$(clear)\]'

export PS2='>>>> '

# If running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
    fi
	if [ -f "$HOME/.bash_aliases" ]; then
		. "$HOME/.bash_aliases"
	fi
fi
