#! /bin/bash

# Console color
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Paths
HOME_DIR="$HOME"
TMP_DIR="$HOME/tmp"
TARGET_DIRS=("codes" "datasets" "miniconda3")
DOTFILES=(".zshrc" ".vimrc" ".tmux.conf" ".condarc" ".gitconfig") # dotfiles we need
PIP_PATH="$HOME_DIR/.pip"
GITHUB_REPO_PATH="https://raw.githubusercontent.com/cxzhou35/dotfiles/main/server"

if [ $# -gt 0 ]; then
  LINK_DIR="$1"
else
  LINK_DIR="/mnt/data/home/zhouchenxu"  # default path
fi

create_dir() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
    echo -e "${GREEN}Try to creat directory: $1${NC}"
    if [ ! -d "$1" ]; then
      echo -e "${RED}Error: Fail to create directory $1${NC}"
      exit 1
    fi
  fi
}

create_symlink() {
  if [ -e "$2" ]; then
    if [ -L "$2" ]; then
      ln -sf "$1" "$2"
      echo -e "${GREEN}Relinked: $2 -> $1${NC}"
    else
      echo -e "${RED}Error: $2 already exists and is not a symlink${NC}"
    fi
  else
    ln -s "$1" "$2"
    echo -e "${GREEN}Linked: $2 -> $1${NC}"
  fi
}

create_dir "$TMP_DIR"
create_dir "$LINK_DIR"

# install omz
echo -e "${GREEN}Install oh-my-zsh..."
cd HOME_DIR
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && exit 0

# install zsh plugins
echo -e "${GREEN}Install omz plugins..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git-open

# download and write dotfiles
echo -e "${GREEN}Download and write dotfiles..."
for dotfile in "${DOTFILES[@]}"; do
  wget "$GITHUB_REPO_PATH/$dotfile" -O "$TMP_DIR/$dotfile"
  # write content to dotfiles
  cat "$TMP_DIR/$dotfile" >"$HOME_DIR/$dotfile"
done

# create target directories and soft links
echo -e "${GREEN}Create target directories and soft links..."
for target in "${TARGET_DIRS[@]}"; do
  create_dir "$LINK_DIR/$target"
  create_symlink "$LINK_DIR/$target" "$HOME_DIR/$target"
done

# set pip mirror(zju)
echo -e "${GREEN}Set pip mirror..."
if [ ! -d "$PIP_PATH" ]; then
  create_dir "$PIP_PATH"
fi
wget "$GITHUB_REPO_PATH/pip.conf" -O "$PIP_PATH/pip.conf"

# install miniconda3 according to the link dir path exists
if [ ! -d "$LINK_DIR/miniconda3" ]; then
  echo -e "${RED}Error: Please download miniconda3 and put it in $LINK_DIR${NC}"
  exit 1
else
  echo -e "${GREEN}Install miniconda3..."
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $LINK_DIR/miniconda3/miniconda.sh
  bash $LINK_DIR/miniconda3/miniconda.sh -b -u -p $LINK_DIR/miniconda3
  rm -rf $LINK_DIR/miniconda3/miniconda.sh
  $LINK_DIR/miniconda3/bin/conda init zsh
  fi
fi

rm -rf "$TMP_DIR"
