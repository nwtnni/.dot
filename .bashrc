# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

shopt -s cdspell
shopt -s histappend
shopt -s checkwinsize

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
HISTIGNORE="l:la:ls:p:gs"

set -o vi &> /dev/null
bind '"jk":vi-movement-mode'
bind -m vi-insert "\C-l":clear-screen
bind "set completion-ignore-case on"
bind "set completion-map-case on"
bind "set show-all-if-ambiguous on"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion &> /dev/null
  elif [ -f /etc/bash_completion ]; then
    echo "eslse"
    . /etc/bash_completion
  fi
fi

# Prevent C-s from causing vim to hang
stty -ixon

__prompt_setc () {
  printf "\x1b[38;2;%s;%s;%sm" "$1" "$2" "$3"
}

__prompt_clear () {
  printf "\x1b[0m"
}

__prompt_branch () {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    if [[ -z $(git status --porcelain) ]]; then
      # Blue for git branch
      __prompt_setc 131 165 152
    else
      # Orange for dirty
      __prompt_setc 254 128 25
    fi
  else
    # White for no version control
    __prompt_setc 235 219 178
  fi
}

__prompt_last () {
  if [[ "$?" -eq 0 ]]; then
    # Green for good
    __prompt_setc 152 151 26
  else
    # Red for bad
    __prompt_setc 251 73 52
  fi
}

export PS1='\[$(__prompt_last)\]>\[$(__prompt_clear)$(__prompt_branch)\]> \[$(__prompt_clear)\]'
export PS2='>> '

# rvm, fzf, up
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
[[ -f ~/.config/up/up.sh ]] && source ~/.config/up/up.sh
eval "$(direnv hook bash)"

bind -x '"\C-o": eval $(__fzf_cd__)'
bind -x '"\C-e": fe'
