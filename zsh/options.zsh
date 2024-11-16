# Basic config
DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false"
DISABLE_UPDATE_PROMPT="true"

export TERM="xterm-256color"

# Bat
export BAT_THEME="Catppuccin Macchiato"

# History
HISTFILE=$HOME/.zhistory
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# autoload -Uz compinit
# compinit

# Completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Conda
__conda_setup="$('/Users/vercent/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/vercent/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/vercent/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/vercent/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
