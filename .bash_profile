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
    if [[ -z $(git status --porcelain) ]]; then
      # Blue for git branch
      setc 131 165 152
    else
      # Red for dirty
      setc 251 73 52
    fi
    echo "⎇  $(git branch 2>/dev/null | sed -n "s/* \(.*\)/\1/p")"
  else
    # Gray for no version control
    setc 168 153 132
    echo "∅"
  fi
}

last () {
  if [[ "$success" == 0 ]]; then
    # Green for good
    setc 184 187 38
  else
    # Red for bad
    setc 251 73 52
  fi
}

timer_start () {
  success="$?"
  timer=${timer:-$(date +%s.%N)}
}

timer_stop () {
  timer_show=$(printf "%.3fs" $(bc <<< "$(date +%s.%N) - $timer"))
  unset timer
}

trap 'timer_start' DEBUG

if [ "$PROMPT_COMMAND" == "" ]; then
  PROMPT_COMMAND="timer_stop"
else
  PROMPT_COMMAND="$PROMPT_COMMAND timer_stop"
fi

dir () {
  setc 250 189 47

  local root="$(pwd | cut -d '/' -f 1-3)"
  local len="$(pwd | tr -dc '/' | wc -c)"

  if [[ "$root" != "/home/nwtnni" ]] || [[ $len -lt 2 ]]; then
    echo $(pwd | sed 's@\(.\)//@\1 → @g')
  elif [[ $len == 2 ]]; then
    echo "~"
  elif [[ $len -lt 6 ]]; then
    echo "~ → $(pwd | cut -d '/' -f 4- | sed 's@/@ → @g')"
  else
    echo "~ → ... → $(pwd | cut -d '/' -f $((len - 1))- | sed 's@/@ → @g')"
  fi
}

export PS1='| $(dir)$(clear) | $(branch)$(clear) | $(last)$timer_show$(clear) |\n╰→\[$(setc 142 192 124)\] λ \[$(clear)\]'
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

# Launch tmux
if command -v tmux>/dev/null; then
  [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
fi
