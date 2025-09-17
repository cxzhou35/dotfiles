export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="ys"

plugins=(git z sudo extract zsh-syntax-highlighting zsh-autosuggestions web-search git-open)

source $ZSH/oh-my-zsh.sh

DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false"
DISABLE_UPDATE_PROMPT="true"

export TERM="xterm-256color"

alias sz="source ~/.zshrc echo '~/.zshrc sourced'"
alias vz="vi ~/.zshrc"
alias vc="vi ~/.vimrc"

# CLI alias
alias nvs="nvidia-smi"
alias nv="nvitop"
alias lg="lazygit"
alias tb="tensorboard"
alias py="python3"
alias python="python3"
alias pip="pip3"
alias jp="jupyter notebook"
alias jl="jupyter lab --log-level=40"

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

# proxy
function proxy_on() {
    export proxy_ip="127.0.0.1"
    export proxy_port="11890"
    export socks_port="7891"
    export http_proxy="http://${proxy_ip}:${proxy_port}"
    export https_proxy="http://${proxy_ip}:${proxy_port}"
    export all_proxy="socks5://${proxy_ip}:${socks_port}"
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
    echo -e "Proxy opened"
}

function proxy_off(){
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo -e "Proxy closed"
}

function set_cuda() {
    export CUDA_VISIBLE_DEVICES=$1
    echo "CUDA_VISIBLE_DEVICES set to $1"
}

export CUDA_VERSION="12.1"
export CUDA_HOME="/usr/local/cuda-${CUDA_VERSION}"
export PATH=/usr/local/cuda-${CUDA_VERSION}/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-${CUDA_VERSION}/lib64:$LD_LIBRARY_PAT
export CPATH=/usr/local/cuda-${CUDA_VERSION}/targets/x86_64-linux/include:$CPATH

export PATH=/home/zhouchenxu/.local/bin:$PATH
