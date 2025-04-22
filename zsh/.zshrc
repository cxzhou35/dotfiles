# Created by Zap installer
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

export ZSH=$HOME/.config/zsh

# load plugins
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "MichaelAquilina/zsh-you-should-use"
plug "zap-zsh/supercharge"
plug "jeffreytse/zsh-vi-mode"

# my config file
plug "$ZSH/scripts.zsh"
plug "$ZSH/alias.zsh"
plug "$ZSH/options.zsh"
plug "$ZSH/secret.zsh"

# starship prompt theme
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi

eval "$(starship init zsh)"

# atuin
export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"
bindkey '^h' atuin-search

