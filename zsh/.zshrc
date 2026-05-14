# Created by Zap installer
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

export ZSH=$HOME/.config/zsh

# load plugins
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"
plug "hlissner/zsh-autopair"
plug "jeffreytse/zsh-vi-mode"
plug "MichaelAquilina/zsh-you-should-use"
plug "zap-zsh/supercharge"

# my config file
source "$ZSH/options.zsh"
source "$ZSH/apps/init.zsh"
source "$ZSH/secret.zsh"
