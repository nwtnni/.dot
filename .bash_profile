# Newton Ni

# Initial setup
PATH="$HOME/bin:$HOME/local/bin:$HOME/.local/bin:$PATH:/usr/local/bin"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export RUST_DOC_PATH="$(rustc --print sysroot)"
export LD_LIBRARY_PATH="$(rustc --print sysroot)/lib:$LD_LIBRARY_PATH"
export OPENSSL_DIR="/usr/local/opt/openssl"

# Ruby
export PATH="$HOME/.rbenv/bin:$PATH"

export EDITOR="nvim"

export fend="$HOME/commure/fend"
export PATH="$HOME/commure/fend/bin:$PATH"

export FZF_DEFAULT_COMMAND="fd --type f -j 8"
export FZF_ALT_C_COMMAND="fd --type d -j 8"

# Mirror displays
mirror() {
    xrandr --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-2 --off --output DP-1 --off --output DP-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal
}

# External display on right
right() {
    xrandr --output HDMI-0 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-2 --off --output DP-1 --off --output DP-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal
}

# https://github.com/junegunn/fzf/wiki/Examples#opening-files
# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --select-1 --exit-0 --preview '[[ $(file --mime {}) =~ binary ]] && echo "" || bat --theme gruvbox --style full --color always {} 2> /dev/null'))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

o () {
  cd "$1" && exa
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

export PS1='\[$(last)\]>\[$(clear)$(branch)\]> \[$(clear)\]'

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
