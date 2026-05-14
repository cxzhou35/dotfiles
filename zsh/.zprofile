# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# mysql
export PATH="/usr/local/mysql/bin:$PATH"

# llvm
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# pipx
export PATH="$HOME/.local/bin:$PATH"

# npm
export PATH="$HOME/.npm-packages/bin:$PATH"

# local user bin
export PATH="$HOME/.config/bin:$PATH"

# Added by OrbStack: command-line tools and integration
source $HOME/.orbstack/shell/init.zsh 2>/dev/null || :
