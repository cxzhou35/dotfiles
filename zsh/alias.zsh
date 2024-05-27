# Paths
alias ..="cd .."
alias ...="cd ..."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

alias cd-="cd -"
alias cdh="cd ~"
alias cod="cd ~/Code/"
alias dod="cd ~/Downloads/"
alias vid="cd ~/Github/dotfiles/nvim/"
alias ghd="cd ~/Github/"
alias nbd="cd ~/Github/site/notebook/"
alias bod="cd ~/Github/site/blog/"

alias l="eza --icons"
alias ll="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias la="eza -la --icons"
alias rmi="rm -i"
alias rmf="rm -f"

alias ssh="trzsz -d ssh"

alias cc="clear"
alias grep="grep --color"

alias py="python3"
alias python="python3"
alias pdt="python3 -m doctest -v"
alias jp="jupyter notebook"
alias jl="jupyter lab --log-level=40"

alias lg="lazygit"
alias lzd="lazydocker"
alias f="fzf"
alias neo="fastfetch"
alias vi="nvim"
alias top="btop"
alias t="tmux"
alias m="h-m-m"
alias yg="you-get"
alias dash="gh dash"
alias tb="tensorboard"
alias cleanpip="rm -rf ~/Library/Caches/pip"
alias askgpt="shell-genie ask"
alias pc="pokemon-colorscripts"
alias color="npx iroiro"
alias broz="npx broz"
alias onef="onefetch"
alias erd="erd -H -I -s rsize -L"
alias viewmd="frogmouth"

alias g++c="g++ -std=c++17 -Wall"

alias sz="source ~/.zshrc; echo '~/.zshrc sourced'"
alias sr="\"/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel\" --reload"
alias vz="vi ~/Github/dotfiles/zsh/.zshrc"
alias vzp="vi ~/Github/dotfiles/zsh/.zprofile"
alias vt="vi ~/Github/dotfiles/tmux.tmux.conf"
alias vc="vi ~/Github/dotfiles/nvim/init.lua"

alias proxy="export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890"
alias lab_proxy="export https_proxy=http://10.76.7.216:9053 http_proxy=http://10.76.7.216:9053"

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
alias gh="git push"
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
