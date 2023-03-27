alias l="ls --group-directories-first --color=auto -F"
alias p="cd .."

alias ll='ls --group-directories-first --color=auto -alF'
alias la='ls --group-directories-first --color=auto -aF'
alias ls='ls --group-directories-first --color=auto -F'

# https://github.com/junegunn/fzf/wiki/Examples#opening-files
# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf --query="$1" --select-1 --exit-0 --preview '[[ $(file --mime {}) =~ binary ]] && echo "" || bat --theme gruvbox --style full --color always {} 2> /dev/null'))
  [[ -n "$files" ]] && ${EDITOR:-nvim} "${files[@]}"
}

# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#switching-between-ripgrep-mode-and-fzf-mode
# Switch between Ripgrep launcher mode (CTRL-R) and fzf filtering mode (CTRL-F)
fr() {
    rm -f /tmp/rg-fzf-{r,f}
    local RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    local INITIAL_QUERY="${*:-}"
    FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --disabled --query "$INITIAL_QUERY" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind "ctrl-t:unbind(change,ctrl-t)+change-prompt(2. fzf> )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
        --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-t)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
        --bind "start:unbind(ctrl-r)" \
        --prompt '1. ripgrep> ' \
        --delimiter : \
        --header '╱ CTRL-R (ripgrep mode) ╱ CTRL-T (fzf mode) ╱' \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind "enter:become("$EDITOR" {1} +{2})"
}

pas() {
    pacman -Slq | fzf --multi --preview "pacman -Si {1}" | xargs -ro sudo pacman -Syu
}
par() {
    pacman -Qq | fzf --multi --preview "pacman -Qi {1}" | xargs -ro sudo pacman -Rns
}
yas() {
    yay -Slq | fzf --multi --preview "yay -Si {1}" | xargs -ro yay -Syu
}
yar() {
    yay -Qq | fzf --multi --preview "yay -Qi {1}" | xargs -ro yay -Rns
}

ss() {
    systemctl list-unit-files \
        | fzf \
            --nth 1 \
            --height 50% \
            --multi \
            --preview "systemctl status {1}" \
            --preview-window=wrap \
        | awk "{print \$1}"
}
sd() { systemctl disable $(ss); }
se() { systemctl enable $(ss); }
ssta() { systemctl --user start $(ss); }
ssto() { systemctl --user stop $(ss); }
sr() { systemctl restart $(ss); }

sus() {
    systemctl --user list-unit-files \
        | fzf \
            --nth 1 \
            --height 50% \
            --multi \
            --preview "systemctl --user status {1}" \
            --preview-window=wrap \
        | awk "{print \$1}"
}
sud() { systemctl --user disable $(sus); }
sue() { systemctl --user enable $(sus); }
susta() { systemctl --user start $(sus); }
susto() { systemctl --user stop $(sus); }
sur() { systemctl --user restart $(sus); }

alias keyon="echo 3 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness"
alias keyoff="echo 0 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness"
alias dim="xbacklight -set 10"

battery() {
    upower -i $(upower -e | rg battery) | rg percentage | rg -o '[0-9]*%'
}

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
