alias l="ls --group-directories-first --color=auto -F"
alias p="cd .."
alias g="git"

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

alias ssh="TERM=xterm-256color ssh"
alias vi="nvim"
alias vim="nvim"
alias z="yazi"
