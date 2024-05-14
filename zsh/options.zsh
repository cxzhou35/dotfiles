# Basic config
DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false"
DISABLE_UPDATE_PROMPT="true"

export TERM="xterm-256color"

# Bat config
export BAT_THEME="Catppuccin Macchiato"

# History config
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

autoload -Uz compinit
compinit

# Completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# zoxide
eval "$(zoxide init zsh)"

# Alias for my os
eval $(thefuck --alias fk)

# atuin
export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"
bindkey '^h' _atuin_search_widget

# Fzf config
eval "$(fzf --zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS='--height 98% --layout=reverse --bind=ctrl-j:down,ctrl-k:up --border --preview "echo {} | '${HOME}'/share/fzf_preview.py" '
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# Conda config
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

