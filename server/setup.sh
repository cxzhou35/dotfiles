#! /bin/bash

# download config files
mkdir ~/tmp
wget https://raw.githubusercontent.com/cxzhou35/dotfiles/main/server/zshrc -O ~/tmp/zshrc
wget https://raw.githubusercontent.com/cxzhou35/dotfiles/main/server/vimrc -O ~/tmp/vimrc
wget https://raw.githubusercontent.com/cxzhou35/dotfiles/main/server/tmux.conf -O ~/tmp/tmux.conf
wget https://raw.githubusercontent.com/cxzhou35/dotfiles/main/server/condarc -O ~/tmp/condarc
wget https://raw.githubusercontent.com/cxzhou35/dotfiles/main/server/gitconfig -O ~/tmp/gitconfig

# install omz
cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git-open

cd ~/tmp

# write zsh config
zshrc_file="$HOME/.zshrc"
zshrc_content_file="./zshrc"

if [ -f "$zshrc_content_file" ]; then
  echo "Find $zshrc_content_file file."

  cat "$zshrc_content_file" >"$zshrc_file"

  echo "Done!"
else
  echo "File $zshrc_content_file not found." >&2
  exit 1
fi

# write vim config
vimrc_file="$HOME/.vimrc"
vimrc_content_file="./vimrc"

if [ -f "$vimrc_content_file" ]; then
  echo "Find $vimrc_content_file file."

  cat "$vimrc_content_file" >"$vimrc_file"

  echo "Done!"
else
  echo "File $vimrc_content_file not found." >&2
  exit 1
fi

# write tmux config
tmux_file="$HOME/.tmux.conf"
tmux_content_file="./tmux.conf"

if [ -f "$tmux_content_file" ]; then
  echo "Find $tmux_content_file file."

  cat "$tmux_content_file" >"$tmux_file"

  echo "Done!"
else
  echo "File $tmux_content_file not found." >&2
  exit 1
fi

# set path link
base_path="/mnt/data/home/zhouchenxu"

mkdir -p ${base_path}/codes
mkdir -p ${base_path}/datasets
mkdir -p ${base_path}/miniconda3

ln -s ${base_path}/codes ~/codes
ln -s ${base_path}/datasets ~/datasets
ln -s ${base_path}/miniconda3 ~/miniconda3

# set pip mirror(zju)
pip install pip -U
pip config set global.index-url https://mirrors.zju.edu.cn/pypi/web/simple

# install miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
~/miniconda3/bin/conda init zsh

cd ~/tmp

# write conda config
conda_file="$HOME/.condarc"
conda_content_file="./condarc"

if [ -f "$conda_content_file" ]; then
  echo "Find $conda_content_file file."

  cat "$conda_content_file" >"$conda_file"

  echo "Done!"
else
  echo "File $conda_content_file not found." >&2
  exit 1
fi

# write git config
git_file="$HOME/.gitconfig"
git_content_file="./gitconfig"

if [ -f "$git_content_file" ]; then
  echo "Find $git_content_file file."

  cat "$git_content_file" >"$git_file"

  echo "Done!"
else
  echo "File $git_content_file not found." >&2
  exit 1
fi
