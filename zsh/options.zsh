# Basic config
DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false"
DISABLE_UPDATE_PROMPT="true"

export EDITOR="nvim"
export VISUAL="nvim"
export TERM="xterm-256color"

# Bat
export BAT_THEME="Catppuccin Macchiato"

# Completion matching
zstyle ':completion:*' menu yes select
zstyle ':completion:*' matcher-list \
    '' \
    'm:{a-zA-Z}={A-Za-z}' \
    'm:{a-zA-Z}={A-Za-z} l:|=* r:|=*'

# History
HISTFILE=$HOME/.zhistory
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^b' backward-word
bindkey '^f' forward-word
