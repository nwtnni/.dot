# Newton Ni

# Initial setup
PATH="$HOME/bin:$HOME/local/bin:$HOME/.local/bin:$PATH:/usr/local/bin"

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

name () {
  if [[ $? == 0 ]]; then
    # Green for good
    setc 184 187 38
  else
    # Red for bad
    setc 251 73 52
  fi
}

network () {
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    # Purple for ssh
    setc 211 134 155
  else
    # Yellow for local
    setc 250 189 47
  fi
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
  # Orange for pwd
  setc 254 128 25
  local len="$(echo $1 | tr -dc '/' | wc -c)"
  if [[ $len -lt 2 ]]; then
    echo "$1"
  elif [[ $len == 2 ]]; then
    echo "~"
  elif [[ $len -lt 8 ]]; then
    echo "~/$(echo $1 | cut -d '/' -f 4-$((len+1)))"
  else
    echo "~/.../$(echo $1 | cut -d '/' -f $((len-3))-$((len+1)))"
  fi
}

export PS1='╭[$(name)\u$(clear)@$(network)\H$(clear)]-[$(branch)$(clear)]-[$(dir \w)$(clear)]\n╰→$(setc 142 192 124) λ $(clear)'
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
