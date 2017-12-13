alias ll='ls -alF'
alias la='ls -A'
alias l='ls --group-directories-first --color=auto'
alias ls='ls --group-directories-first --color=auto'

alias cd..="cd .."

alias open="xdg-open"
alias eclipse="~/eclipse/java-oxygen/eclipse/eclipse > /dev/null 2>&1 &"
alias rstudio="/usr/bin/rstudio > /dev/null 2>&1 &"
alias vpnui="/opt/cisco/anyconnect/bin/vpnui > /dev/null 2>&1 &"
alias vim="nvim"
alias tmr="tmuxinator"
alias fzf="fzf-tmux"
alias keyon="echo 3 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness"
alias keyoff="echo 0 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness"

alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"

alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias ssh='TERM=xterm-256color ssh'
