# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# navi
eval "$(navi widget zsh)"

# added by Toolbox App
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# mysql
export PATH="/usr/local/mysql/bin:$PATH"

# llvm
export PATH="/opt/homebrew/Cellar/llvm/16.0.3/bin:$PATH"

# php
export PATH="/opt/homebrew/opt/php@8.0/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.0/sbin:$PATH"

# homebrew config(only for mac)
export EDITOR="/opt/homebrew/bin/nvim"

# ruby
export PATH="/opt/homebrew/Cellar/ruby/3.2.1/bin:$PATH"

# pipx
export PATH="$HOME/.local/bin:$PATH"

# local user bin
export PATH="$HOME/.config/bin:$PATH"

# npm
export PATH="$HOME/.npm-packages/bin:$PATH"

# Added by OrbStack: command-line tools and integration
source $HOME/.orbstack/shell/init.zsh 2>/dev/null || :

# zoxide
eval "$(zoxide init zsh)"

# thefuck
eval $(thefuck --alias fk)

# Fzf
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
