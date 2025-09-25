#!/usr/bin/bash

# Console color
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Paths
HOME_DIR="$HOME"
TMP_DIR="$HOME/tmp"
LINK_DIR="/mnt/data"
TARGET_DIRS=("codes" "datasets" "miniconda3" ".cache" ".conda")
ZSH_PLUGINS=("zsh-syntax-highlighting" "zsh-autosuggestions" "git-open")
PIP_PATH="$HOME_DIR/.pip"
GITHUB_REPO_PATH="https://raw.githubusercontent.com/cxzhou35/dotfiles/main/server"
DOTFILES=(".zshrc" ".vimrc" ".tmux.conf" ".condarc" ".gitconfig")

create_dir() {
	if [[ ! -d "$1" ]]; then
		mkdir -p "$1"
		echo -e "${GREEN}Try to creat directory: $1${NC}"
		if [[ ! -d "$1" ]]; then
			echo -e "${RED}Error: Fail to create directory $1${NC}"
			exit 1
		fi
	fi
}

create_symlink() {
	if [[ -e "$2" ]]; then
		if [[ -L "$2" ]]; then
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
	unset http_proxy https_proxy socks_proxy
	local proxy=$(env | grep -i proxy | awk -F '=' '{print $2}' | sed 's/^"//' | sed 's/"$//')
	# proxy format: ip:port

	if [[ -z "$proxy" ]]; then
		echo -e "${YELLOW}Warning: proxy is not set${NC}"
		return 1
	else
		echo -e "${YELLOW}The proxy is $proxy${NC}"
	fi

	if [[ "$proxy" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+$ ]]; then
		echo -e "${GREEN}===== Set env proxy ====="
		export http_proxy=http://${proxy}
		export https_proxy=https://${proxy}
		echo -e "${GREEN}The proxy is $http_proxy and $https_proxy${NC}"
	else
		echo -e "${RED}Error: Proxy format is incorrect. It should be {IP:PORT}${NC}"
		return 1
	fi
}

read_path() {
	echo "Please enter the path of the link directorie(default value: /mnt/data/home/username):"
	read -r path
	if [[ -z "$path" ]]; then
		LINK_DIR="/mnt/data/home/$(whoami)"
	else
		LINK_DIR=$path
	fi
}

install_omz_plugins() {
	for plugin in "${ZSH_PLUGINS[@]}"; do
		plugin_path="${ZSH_CUSTOM:-$HOME_DIR/.oh-my-zsh/custom}/plugins/$plugin"
		if [[ -s $plugin_path ]]; then
			echo -e "${YELLOW}Skip: $plugin already exists${NC}"
		else
			git clone https://github.com/zsh-users/$plugin.git $plugin_path
		fi
	done
}

write_dotfiles() {
	for dotfile in "${DOTFILES[@]}"; do
		# check if the dotfile exists and not empty
		if [[ -s "$HOME_DIR/$dotfile" ]]; then
			echo -e "${YELLOW}Skip: $TMP_DIR/$dotfile already exists and is not empty${NC}"
			echo -e "${YELLOW}Warning: Backup $dotfile now${NC}"
			cp "$HOME_DIR/$dotfile" "$HOME_DIR/$dotfile.bak"
		fi
		wget "$GITHUB_REPO_PATH/$dotfile" -O "$HOME_DIR/$dotfile"
	done

	echo -e "${YELLOW}Warning: Don't forget to modify your git user information in .gitconfig${NC}"
}

create_target_dirs() {
	for target in "${TARGET_DIRS[@]}"; do
		if [[ -e $HOME_DIR/$target ]]; then
			echo -e "${YELLOW}Skip: $HOME_DIR/$target link already exists, skip it${NC}"
		else
			create_dir "$LINK_DIR/$target"
			create_symlink "$LINK_DIR/$target" "$HOME_DIR/$target"
		fi
	done
}

set_pip_mirror() {
	if [ ! -d "$PIP_PATH" ]; then
		create_dir "$PIP_PATH"
	fi
	wget "$GITHUB_REPO_PATH/pip.conf" -O "$PIP_PATH/pip.conf"
}

install_miniconda3() {
	# check if the link directory exists
	if [[ ! -e "$HOME_DIR/miniconda3" ]]; then
		echo -e "${RED}Error: Please download miniconda3 and put it in $HOME_DIR${NC}"
	else
		# check if miniconda3 exists
		if [[ -s "$HOME_DIR/miniconda3/bin" ]]; then
			echo -e "${YELLOW}Skip: Miniconda3 already exists in $HOME_DIR and not empty${NC}"
		else
			wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $HOME_DIR/miniconda3/miniconda.sh
			bash $HOME_DIR/miniconda3/miniconda.sh -b -u -p $HOME_DIR/miniconda3
			rm -rf $HOME_DIR/miniconda3/miniconda.sh
			$HOME_DIR/miniconda3/bin/conda init bash
		fi
	fi
}

install_lazygit() {
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
	# try to download the binary file
	curl -Lo $TMP_DIR/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	# check whether the binary file exists
	if [[ ! -f "$TMP_DIR/lazygit.tar.gz" ]]; then
		echo -e "${RED}Error: Fail to download lazygit${NC}"
		exit 1
	else
		tar xf $TMP_DIR/lazygit.tar.gz $TMP_DIR/lazygit
	fi
	# check whether the .local/bin exists
	INSTALL_DIR="$HOME_DIR/.local/bin"
	create_dir "$INSTALL_DIR"
	cp $TMP_DIR/lazygit $INSTALL_DIR/lazygit
	echo -e "${GREEN}Lazygit installed in $INSTALL_DIR/lazygit${NC}"
}

main() {
	echo -e "${GREEN}===== Start setup =====${NC}"

	echo -e "${GREEN}===== Check proxy =====${NC}"
	check_proxy

	echo -e "${GREEN}===== Read link directory =====${NC}"
	read_path

	create_dir "$TMP_DIR"
	create_dir "$LINK_DIR"

	# install zsh plugins
	echo -e "${GREEN}===== Install omz plugins =====${NC}"
	install_omz_plugins

	# download and write dotfiles
	echo -e "${GREEN}===== Download and write dotfiles =====${NC}"
	write_dotfiles

	# create target directories and soft links
	echo -e "${GREEN}===== Create target directories and soft links =====${NC}"
	create_target_dirs

	# set pip mirror(zju)
	echo -e "${GREEN}===== Set pip mirror =====${NC}"
	set_pip_mirror

	# install miniconda3 according to the link dir path exists
	echo -e "${GREEN}===== Install miniconda3 =====${NC}"
	install_miniconda3

	# install lazygit
	echo -e "${GREEN}===== Install lazygit =====${NC}"
	install_lazygit

	rm -rf "$TMP_DIR"

	echo -e "${GREEN}===== Setup finished! =====${NC}"
	return 0
}

main
