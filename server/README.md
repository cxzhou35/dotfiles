# Server Setup

Run the following command to setup the server:
```bash
# 1. install oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# 2. main setup script(make sure you have installed zsh)
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/cxzhou35/dotfiles/main/server/setup.sh)"

# you need to check the `LINK_DIR` in `setup.sh` to make sure the directories are correct
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
