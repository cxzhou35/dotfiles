# Server Setup

Run the following command to setup the server:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/cxzhou35/dotfiles/main/server/setup.sh)" "/mnt/data/home/username" # target directory
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
