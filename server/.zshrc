export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="ys"

plugins=(git z sudo extract zsh-syntax-highlighting zsh-autosuggestions git-open web-search)

source $ZSH/oh-my-zsh.sh

DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false"
DISABLE_UPDATE_PROMPT="true"

export TERM="xterm-256color"

alias py="python3"
alias python="python3"
alias pip="pip3"
alias jp="jupyter notebook"
alias jl="jupyter lab --log-level=40"
alias tb="tensorboard"

alias sz="source ~/.zshrc echo '~/.zshrc sourced'"
alias vz="vi ~/.zshrc"
alias vc="vi ~/.vimrc"
alias nvs="nvidia-smi"

# Alias for conda
alias condaa="conda activate"
alias condad="conda deactivate"
alias condae="conda env list"
alias condai="conda info"
alias condac="conda clean -a"

# Alias for git
alias ga="git add ."
alias gs="git status"
alias gg="git reflog"
alias gm="git commit -m"
alias gu="git remote -v"
alias gl="git pull"
alias gh="git push"
alias gd="git diff"
alias go="git open"

# alias for tmux
alias tn="tmux new -s"
alias tl="tmux ls"
alias td="tmux detach"
alias ta="tmux attach -t"
alias ts="tmux switch -t"
alias tk="tmux kill-session -t"
alias tr="tmux rename-session -t"
alias nvitop="python3 -m nvitop"

function set_cuda() {
    export CUDA_VISIBLE_DEVICES=$1
    echo "CUDA_VISIBLE_DEVICES set to $1"
}

export CUDA_VERSION="11.8"
export CUDA_HOME="/usr/local/cuda-${CUDA_VERSION}"
export PATH=/usr/local/cuda-${CUDA_VERSION}/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-${CUDA_VERSION}/lib64:$LD_LIBRARY_PAT
export CPATH=/usr/local/cuda-${CUDA_VERSION}/targets/x86_64-linux/include:$CPATH

export PATH=/home/zhouchenxu/.local/bin:$PATH