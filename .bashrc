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

# rvm, fzf, up
[[ -x /usr/bin/dircolors ]] && eval "$(dircolors -b ~/.dircolors)"
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
[[ -f ~/.config/up/up.sh ]] && source ~/.config/up/up.sh
[[ -z "$SSH_AUTH_SOCK" ]] && eval "$(ssh-agent -s)"
eval "$(direnv hook bash)"

bind -x '"\C-o": eval $(__fzf_cd__)'
bind -x '"\C-e": fe'
