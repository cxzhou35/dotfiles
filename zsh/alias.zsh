# Paths
alias ..="cd .."
alias ...="cd ..."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Directories
alias cd-="cd -"
alias cdh="cd $HOME"
alias cdc="cd $HOME/Code/"
alias cdn="cd /Users/vercent/Library/CloudStorage/OneDrive-zju.edu.cn/Notes"
alias cdd="cd $HOME/Downloads/"
alias cdg="cd $HOME/Github/"
alias cdv="cd $HOME/Github/dotfiles/nvim/"
alias cdz="cd $HOME/Github/dotfiles/zsh/"
alias cdnb="cd $HOME/Github/site/notebook/"
alias cdb="cd $HOME/Github/site/blog/"

# Eza
alias l="eza --icons"
alias ll="eza -l --icons --git -a"
alias la="eza -la --icons"
alias lt="eza --tree --level=2 --long --icons --git"

# Python
alias py="python3"
alias pdt="python3 -m doctest -v"
alias jp="jupyter notebook"
alias jl="jupyter lab --log-level=40"

# Misc
alias c="clear"
alias t="tmux"
alias m="h-m-m"
alias f="fzf"
alias y="yazi"
alias ra="yazi"
alias g="git"
alias cc="clear"
alias ssh="trzsz -d ssh"
alias grep="grep --color"
alias lg="lazygit"
alias lzd="lazydocker"
alias neo="fastfetch"
alias vi="nvim"
alias top="btop"
alias yg="you-get"
alias dash="gh dash"
alias tb="tensorboard"
alias askgpt="shell-genie ask"
alias pc="pokemon-colorscripts"
alias pbc="pbcopy <"
alias onef="onefetch"
alias erd="erd -H -I -s rsize -L"
alias viewmd="frogmouth"
alias g++c="g++ -std=c++17 -Wall"
alias cleanpip="rm -rf $HOME/Library/Caches/pip"
alias color="npx iroiro"
alias broz="npx broz"

# Config
alias sz="source $ZSHRC; echo '$ZSHRC reloaded'"
alias sr="\"/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel\" --reload"
alias vz="vi $HOME/Github/dotfiles/zsh/.zshrc"
alias vzp="vi $HOME/Github/dotfiles/zsh/.zprofile"
alias vt="vi $HOME/Github/dotfiles/tmux.tmux.conf"
alias vc="vi $HOME/Github/dotfiles/nvim/init.lua"

# Proxy
alias proxy="export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890"
alias unproxy="unset http_proxy https_proxy all_proxy"

# Weather
alias cwt="curl wttr.in"
alias cwthz="curl wttr.in/Hangzhou"

# Applications
alias chrome="open -a 'Google Chrome'"
alias ob="open -a 'Obsidian'"
alias brave="open -a 'Brave Browser'"

alias rd="reveal-md"
alias rdsite="reveal-md --static site"

alias hs="hugo server -D"
alias hp="hugo"

alias mkd="mkdocs gh-deploy --force"
alias mks="mkdocs serve --dirtyreload"

# Conda
alias condaa="conda activate"
alias condad="conda deactivate"
alias condae="conda env list"
alias condai="conda info"
alias condac="conda clean -a"

# Brew
alias bl="brew list"
alias bi="brew install"
alias br="brew remove"
alias bs="brew search"
alias bu="brew uninstall"
alias bd="brew doctor"

# Git
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

# Tmux
alias tn="tmux new -s"
alias tl="tmux ls"
alias td="tmux detach"
alias ta="tmux attach -t"
alias ts="tmux switch -t"
alias tk="tmux kill-session -t"
alias tr="tmux rename-session -t"

# Asciinema
alias asr="asciinema rec"
alias asu="asciinema upload"
