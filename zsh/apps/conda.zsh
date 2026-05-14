alias condaa="conda activate"
alias condad="conda deactivate"
alias condae="conda env list"
alias condai="conda info"
alias condac="conda clean -a"

__conda_bin=""
if command -v conda >/dev/null 2>&1; then
    __conda_bin="$(command -v conda)"
elif [ -x "$HOME/miniconda3/bin/conda" ]; then
    __conda_bin="$HOME/miniconda3/bin/conda"
elif [ -x "$HOME/anaconda3/bin/conda" ]; then
    __conda_bin="$HOME/anaconda3/bin/conda"
fi

if [ -n "$__conda_bin" ]; then
    __conda_setup="$("$__conda_bin" shell.zsh hook 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        __conda_base="$("$__conda_bin" info --base 2> /dev/null)"
        if [ -n "$__conda_base" ] && [ -f "$__conda_base/etc/profile.d/conda.sh" ]; then
            . "$__conda_base/etc/profile.d/conda.sh"
        elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
            . "$HOME/miniconda3/etc/profile.d/conda.sh"
        elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
            . "$HOME/anaconda3/etc/profile.d/conda.sh"
        fi
        unset __conda_base
    fi
    unset __conda_setup
fi
unset __conda_bin
