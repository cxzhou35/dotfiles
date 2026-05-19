export ZSH=$HOME/.config/zsh

# Run the locale fix from options.zsh early so non-interactive shells also stop
# inheriting unsupported values like C.UTF-8.
if [[ -f "$ZSH/options.zsh" ]]; then
  export ZSH_EARLY_INIT=1
  source "$ZSH/options.zsh"
  unset ZSH_EARLY_INIT
fi

if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi
