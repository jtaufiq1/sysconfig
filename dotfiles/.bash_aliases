# eza | exa Enhanced ls
alias ls=eza
alias ll='eza -lh'
#alias ls=eza

alias vi=vim
alias update='sudo apt update'
alias upgrade='sudo apt -y upgrade'
alias show-pkg='apt show'
alias pkg-install='sudo apt -y install'
alias list-upgrades='apt list --upgradable 2>/dev/null | tee /home/taufiq/upgrade.txt'

alias ff='fastfetch'
alias zx='zoxide'
alias cd='z' # Smart cd using zoxide

# Niri WM
alias niri-monitor-off='niri msg action power-off-monitors'
alias niri-lock='niri msg action spawn -- cosmic-greeter'
alias niri-logout='niri msg action quit'
