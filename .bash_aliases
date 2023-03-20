alias l='exa --group-directories-first --color=auto'
alias p="cd .. && exa --group-directories-first --color=auto"

alias ll='exa --group-directories-first -alF'
alias la='exa --group-directories-first -a'
alias ls='exa --group-directories-first --color=auto'

e () {
  if [ -z "$1" ]; then
    file=$(goldfish -cfiles get | fzf)
    if [ ! -z "$file" ]; then
      goldfish -cfiles put -tf "$file"
      nvim "$file" > /dev/tty
    fi
  else
    goldfish -cfiles put -tf "$1"
    nvim "$1" > /dev/tty
  fi
}

o () {
  if [ -z "$1" ]; then
    dir=$(goldfish -cdirectories get | fzf)
    if [ ! -z "$dir" ]; then o "$dir"; fi
  else
    goldfish -cdirectories put -td "$1" \
        && cd "$1" \
        && exa --group-directories-first --color=auto
  fi
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

alias vim="nvim"
alias fzf="fzf-tmux"
alias keyon="echo 3 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness"
alias keyoff="echo 0 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness"
alias battery="upower -i $(upower -e | rg battery) | rg percentage | rg -o '[0-9]*%'"
alias dim="xbacklight -set 10"

alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gca="git commit --amend"
alias gd="git diff"
alias gl="git log"
alias gp="git pull --rebase && git push"
alias gu="git pull --rebase"
alias gpf="git push --force-with-lease"

gch () {
  git checkout $(git branch -l | fzf)
}

gdh () {
  git branch -d $(git branch -l | fzf)
}

gri() {
  if [ ! -z "$1" ]; then
    git rebase -i "HEAD~$1"
  fi
}

alias gb="./gradlew build"
alias gr="./gradlew run"
alias gj="./gradlew jar"

alias cc="cargo check"
alias cb="cargo build"
alias cbr="cargo build --release"
alias ct="cargo test"
alias cr="cargo run"
alias crr="cargo run --release"

alias cxb="cargo xbuild"
alias cxc="cargo xcheck"
alias cxt="cargo xtest"
alias cxr="cargo xrun"

alias k="kubectl"
alias ke="kubectl exec"
alias kg="kubectl get"
alias kl="kubectl logs"
alias kd="kubectl describe"
alias kc="kubectl create"

kf () {
  kubectl get -ndev $1 | cut -f 1 -d " " | tail -n +2 | fzf
}
kef () {
  kubectl exec -ndev -it $(kf pods) /bin/bash
}
klf () {
  kubectl logs -ndev $(kf pods) --follow
}
kdf () {
  kubectl describe -ndev pod $(kf pods)
}

alias ssh="TERM=xterm-256color ssh"
