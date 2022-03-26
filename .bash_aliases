alias l='exa --group-directories-first --color=auto'
alias p="cd .. && exa --group-directories-first --color=auto"

alias ll='exa --group-directories-first -alF'
alias la='exa --group-directories-first -a'
alias ls='exa --group-directories-first --color=auto'

alias eclipse="~/eclipse/java-oxygen/eclipse/eclipse > /dev/null 2>&1 &"
alias rstudio="/usr/bin/rstudio > /dev/null 2>&1 &"
alias vpnui="/opt/cisco/anyconnect/bin/vpnui > /dev/null 2>&1 &"
alias vim="nvim"
alias tmr="tmuxinator"
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
alias kp="kubectl get -ndev pods"

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

alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias ssh='TERM=xterm-256color ssh'
