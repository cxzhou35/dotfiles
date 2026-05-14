# === Aliases ===

# eza
alias l="eza --icons"
alias ll="eza -l --icons --git -a"
alias la="eza -la --icons"
alias lt="eza --tree --level=2 --long --icons --git"

# tmux
alias t="tmux"
alias tn="tmux new -s"
alias tl="tmux ls"
alias td="tmux detach"
alias ta="tmux attach -t"
alias ts="tmux switch -t"
alias tk="tmux kill-session -t"
alias tr="tmux rename-session -t"

# git
alias g="git"
alias ga="git add ."
alias gs="git status"
alias gg="git reflog"
alias gm="git commit -m"
alias gu="git remote -v"
alias gb="git checkout"
alias gr="git checkout -- ."
alias gl="git pull"
alias gp="git push"
alias gd="git diff"

alias py="python3"
alias jp="jupyter notebook"
alias jl="jupyter lab --log-level=40"
alias yg="you-get"
alias cc="clear"
alias grep="grep --color"
alias pbc="pbcopy <"
alias ssh="trzsz -d ssh"
alias lg="lazygit"
alias neo="fastfetch"
alias onef="onefetch"
alias tb="tensorboard"
alias top="btop"
alias vi="nvim"
alias cleanpip="rm -rf $HOME/Library/Caches/pip"
alias sz="source $ZSHRC; echo '$ZSHRC reloaded'"
alias sr="\"/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel\" --reload"
alias vz="vi $HOME/Github/dotfiles/zsh/.zshrc"
alias vx="vi $HOME/Github/dotfiles/zsh/.proxyenv"
alias vc="vi $HOME/Github/dotfiles/nvim/init.lua"

# codex
alias cx="codex"
alias cxfa="codex -- --full-auto"
alias cxd="codex --dangerously-bypass-approvals-and-sandbox"

# === Functions ===

mkcd() {
    mkdir -p "$@" && cd "$_"
}

getip() {
    local ipinfo ipaddress
    ipinfo=($(ifconfig en0 | grep "inet " 2>&1))
    rich "[bold blue][Info][/]Local ip address is: [bold magenta]$(awk '{print $2}' <<< "$ipinfo")[/]" -p
    ipaddress=$(awk '{print $2}' <<< "$ipinfo")
    echo "$ipaddress" | cb
    rich "[bold blue][Info][/]Copy to clipboard" -p
}

appsec() {
    sudo xattr -r -d com.apple.quarantine "$1"
}

skf() {
    rg --files | sk --preview="bat {} --color=always"
}

ske() {
    nvim "$(find . | sk -m --preview="bat {} --color=always")"
}
