#!/bin/bash

STATUS=$(which brew)

if [ -z "$STATUS" ]; then
	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "Homebrew is already installed..."
fi

echo "Installing homebrew packages..."

# cli
brew install bash
brew install bat
brew install fd
brew install fzf
brew install gh
brew install git
brew install git-delta
brew install lf
brew install eza
brew install neofetch
brew install pgcli
brew install ripgrep
brew install starship
brew install tealdeer
brew install wakatime-cli
brew install jq
brew install poppler
brew install btop
brew install navi
brew install zoxide
brew install tmux
brew install lazydocker
brew install lazygit
brew install yazi --HEAD
brew install joshmedeski/sesh/sesh
brew install neovim

exit 0
