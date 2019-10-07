# Newton Ni

# Initial setup
PATH="$HOME/bin:$HOME/local/bin:$HOME/.local/bin:$PATH:/usr/local/bin"

o () {
  cd "$1" && ls --group-directories-first --color=auto
}

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
