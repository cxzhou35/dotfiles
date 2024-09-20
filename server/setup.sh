#!/usr/bin/zsh

# Console color
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Paths
HOME_DIR="$HOME"
TMP_DIR="$HOME/tmp"
LINK_DIR=""
TARGET_DIRS=("codes" "datasets" "miniconda3")
PIP_PATH="$HOME_DIR/.pip"
GITHUB_REPO_PATH="https://raw.githubusercontent.com/cxzhou35/dotfiles/main/server"
DOTFILES=(".zshrc" ".vimrc" ".tmux.conf" ".condarc" ".gitconfig")

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

check_proxy() {
  local proxy=$(env | grep -i proxy)

  if [[ -z "$proxy" ]]; then
    echo -e "${RED}Warning: Proxy is not set${NC}"
    return 1
  else 
    echo -e "${RED}The proxy is $proxy${NC}"
  fi

  if [[ "$proxy" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+$ ]]; then
    echo -e "${GREEN}Proxy format is set correctly${NC}"
    echo -e "${GREEN}===== Set env proxy ====="
    export http_proxy=http://${proxy}
    export https_proxy=http://${proxy}
  else
    echo -e "${RED}Proxy format is incorrect. It should be {IP:PORT}${NC}"
    return 1
  fi
}

read_path() {
  echo "Please enter the path of the link directorie(default value: /mnt/data/home/username):"
  read -r path
  if [ -z "$path" ]; then
    LINK_DIR="/mnt/data/home/$(whoami)"
  else 
    LINK_DIR=$path
  fi
}

install_omz_plugins(){
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git-open
}

write_dotfiles() {
  for dotfile in "${DOTFILES[@]}"; do
    # check if the dotfile exists and not empty
    if [ -s "$HOME_DIR/$dotfile" ]; then
      echo -e "${RED}Skip: $TMP_DIR/$dotfile already exists and is not empty${NC}"
      echo -e "${RED}Warning: Backup $dotfile now${NC}"
      cp "$HOME_DIR/$dotfile" "$HOME_DIR/$dotfile.bak"
    fi
    wget "$GITHUB_REPO_PATH/$dotfile" -O "$HOME_DIR/$dotfile"
  done

  echo -e "${RED}Warning: Don't forget to modify your gitconfig in .gitconfig${NC}"
}

create_target_dirs() {
  for target in "${TARGET_DIRS[@]}"; do
    create_dir "$LINK_DIR/$target"
    create_symlink "$LINK_DIR/$target" "$HOME_DIR/$target"
  done
}

install_miniconda3(){
  # check if the link directory exists
  if [ ! -d "$LINK_DIR/miniconda3" ]; then
    echo -e "${RED}Error: Please download miniconda3 and put it in $LINK_DIR${NC}"
  else
    # check if miniconda3 exists
    if [ -s "$LINK_DIR/miniconda3" ]; then
      echo -e "${RED}Skip: Miniconda3 already exists in $LINK_DIR$ and not empty{NC}"
    else
      echo -e "${GREEN}===== Install miniconda3 ====="
      wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $LINK_DIR/miniconda3/miniconda.sh
      bash $LINK_DIR/miniconda3/miniconda.sh -b -u -p $LINK_DIR/miniconda3
      rm -rf $LINK_DIR/miniconda3/miniconda.sh
      $LINK_DIR/miniconda3/bin/conda init zsh
    fi
  fi
}

main() {
  echo -e "${GREEN}===== Start setup ====="

  echo -e "${GREEN}===== Check proxy ====="
  check_proxy

  echo -e "${GREEN}===== Read link directory ====="
  read_path 

  create_dir "$TMP_DIR"
  create_dir "$LINK_DIR"

  # install zsh plugins
  echo -e "${GREEN}===== Install omz plugins ====="
  install_omz_plugins

  # download and write dotfiles
  echo -e "${GREEN}===== Download and write dotfiles ====="
  write_dotfiles

  # create target directories and soft links
  echo -e "${GREEN}===== Create target directories and soft links ====="
  create_target_dirs

  # set pip mirror(zju)
  echo -e "${GREEN}===== Set pip mirror ====="
  if [ ! -d "$PIP_PATH" ]; then
    create_dir "$PIP_PATH"
  fi
  wget "$GITHUB_REPO_PATH/pip.conf" -O "$PIP_PATH/pip.conf"

  # install miniconda3 according to the link dir path exists
  install_miniconda3

  rm -rf "$TMP_DIR"

  echo -e "${GREEN}===== Setup finished! ====="

  source ${HOME_DIR}/.zshrc
}

main
