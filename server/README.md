# Server Setup

Run the following command to setup the server:
```bash
# 1. install oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# 2. main setup script(make sure you have installed zsh)
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/cxzhou35/dotfiles/main/server/setup.sh)"

# 2.1. or modify the script to fit your needs
wget https://raw.githubusercontent.com/cxzhou35/dotfiles/main/server/setup.sh

HOME_DIR="$HOME"
TMP_DIR="$HOME/tmp"
TARGET_DIRS=("codes" "datasets" "miniconda3")
LINK_DIR="/mnt/data/home/username"
DOTFILES=(".zshrc" ".vimrc" ".tmux.conf" ".condarc" ".gitconfig")

# 3. reload zsh config
source ~/.zshrc

# 4. initialize conda
~/miniconda3/bin/conda init zsh
```

## Structure

```
├── .condarc
├── .gitconfig
├── .tmux.conf
├── .vimrc
├── .zshrc
├── pip.conf
├── README.md
└── setup.sh
```

## Functionality

- Configurations for some utilities across the server
- Set soft link for common directories
- Install miniconda3

## TODOs

- [ ] Use interactive mode for setup script for better config like git etc.
- [ ] Deal with the internet proxy problem.
- [ ] Check local status and update the dotfiles.
