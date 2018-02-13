# Newton Ni

# Initial setup
PATH="$HOME/bin:$HOME/local/bin:$HOME/.local/bin:$PATH:/usr/local/bin"

# C
export PATH="$PATH:/usr/local/lib/cquery/bin"
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"

# Go
export PATH="$PATH:/usr/lib/go-1.9/bin"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Haskell
export PATH="$PATH:$HOME/.cabal/bin:/opt/cabal/2.0/bin:/opt/ghc/8.2.2/bin"

# Python
export PATH="/home/nwtnni/.pyenv/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export LD_LIBRARY_PATH="$(rustc --print sysroot)/lib:$LD_LIBRARY_PATH"

# Ruby
export PATH="$PATH:$HOME/.rvm/bin"

export EDITOR="nvim"
export TERM="xterm-256color-italic"

setc () {
  printf "\x1b[38;2;%s;%s;%sm" "$1" "$2" "$3"
}

clear () {
  printf "\x1b[0m"
}

branch () {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    # Blue for git branch
    setc 131 165 152
    echo "⎇  $(git branch 2>/dev/null | sed -n "s/* \(.*\)/\1/p")"
  else
    # Gray for no version control
    setc 168 153 132
    echo "∅"
  fi
}

dir () {
  if [[ $? == 0 ]]; then
    # Green for good
    setc 184 187 38
  else
    # Red for bad
    setc 251 73 52
  fi
  local root="$(pwd | cut -d '/' -f 1-3)"
  local len="$(pwd | tr -dc '/' | wc -c)"
  if [[ $COLUMNS -lt 40 ]]; then
    local path="$(pwd)"
    echo "${path##*/}"
    return 0
  fi
  if [[ "$root" != "/home/nwtnni" ]]; then
    pwd
  elif [[ $len -lt 2 ]]; then
    pwd
  elif [[ $len == 2 ]]; then
    echo "~"
  elif [[ $len -lt 6 ]]; then
    echo "~/$(pwd | cut -d '/' -f 4-)"
  else
    echo "~/.../$(pwd | cut -d '/' -f $((len))-)"
  fi
}

export PS1='| $(dir)$(clear) | $(branch)$(clear) |\n╰→\[$(setc 142 192 124)\] λ \[$(clear)\]'
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
