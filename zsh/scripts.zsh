# clean homebrew cache files
function cleanbrew () {
  folder_paths=(~/Library/Caches/Homebrew/downloads ~/Library/Caches/Homebrew/Cask)

  for folder_path in "${folder_paths[@]}"; do
    if [ -d "$folder_path" ] && [ "$(ls $folder_path)" ]; then
      rm -rf $folder_path/*
      echo "The folder $folder_path has been emptied."
    else
      echo "The folder $folder_path is already empty."
    fi
  done

  brew cleanup --prune=all
}

# cd folder with fzf
function fcd(){
  cd $(du -a ./ | awk '{print $2}' | fzf)
}

# edit file with fzf
function fe(){
  nvim $(du -a ./ | awk '{print $2}' | fzf)
}

function skf (){
  rg --files | sk --preview="bat {} --color=always"
}

function ske (){
  nvim $(find . | sk -m --preview="bat {} --color=always")
}

# copy neovim config file to repo
function loadnvim() {
  cd ~/Github/neovim && cp -r ~/Github/dotfiles/nvim/* .
}

function loadvsc ()
{
  cd ~/Github/dotfiles/vscode && cp -r ~/Library/Application\ Support/Code/User/*.json .
}
# create folder and cd into it
function mkcd() {
  mkdir -p "$@"  && cd $_
}

# hugo reload
# receive one paramater with commit
function hp(){
  cd ~/Github/site/blog && hugo && cd ./public && git add . && git commit -m "$1" && git push && cd ~/Github/site/blog
}

function sc(){
  sesh connect "$(sesh list -i | gum filter --limit 1 --placeholder 'Pick a sesh' --prompt='⚡')"
}

function ys() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
