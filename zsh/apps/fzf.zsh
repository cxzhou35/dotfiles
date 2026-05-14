alias f="fzf"
__fzf_app_dir="${${(%):-%x}:A:h}"

if command -v fzf >/dev/null 2>&1; then
    __fzf_init="$(fzf --zsh 2>/dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__fzf_init" 2>/dev/null
    elif [ -f "$HOME/.fzf.zsh" ]; then
        source "$HOME/.fzf.zsh"
    fi
    unset __fzf_init
fi

__fzf_preview_command='bat -n --color=always --line-range :500 {} 2>/dev/null || file {}'
if [ -n "${ZSH:-}" ] && [ -f "$ZSH/apps/fzf-preview" ]; then
    __fzf_preview_command="sh $ZSH/apps/fzf-preview {}"
elif [ -f "$__fzf_app_dir/fzf-preview" ]; then
    __fzf_preview_command="sh $__fzf_app_dir/fzf-preview {}"
elif [ -x "$HOME/share/fzf_preview.py" ]; then
    __fzf_preview_command="$HOME/share/fzf_preview.py {}"
fi

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 98% --layout=reverse --bind=ctrl-j:down,ctrl-k:up --border --preview '$__fzf_preview_command'"
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
        cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
        export|unset) fzf --preview "eval 'echo $'{}" "$@" ;;
        ssh) fzf --preview 'dig {}' "$@" ;;
        *) fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
    esac
}

fcd() {
    cd "$(du -a ./ | awk '{print $2}' | fzf)"
}

fe() {
    nvim "$(du -a ./ | awk '{print $2}' | fzf)"
}

unset __fzf_preview_command
unset __fzf_app_dir
