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
