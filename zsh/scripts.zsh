# clean homebrew cache files
function cleanbrew () {
  folder_paths=($HOME/Library/Caches/Homebrew/downloads $HOME/Library/Caches/Homebrew/Cask)

  for folder_path in "${folder_paths[@]}"; do
    if [ -d "$folder_path" ] && [ "$(ls $folder_path)" ]; then
      rm -rf $folder_path/*
      rich "[bold blue][Info][/]The folder [bold magenta]$(echo $folder_path)[/] has been emptied." -p
    else
      rich "[bold blue][Info][/]The folder [bold magenta]$(echo $folder_path)[/] does not exist." -p
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

# copy neovim config file to github repo
function loadnvim() {
  cd $HOME/Github/neovim && cp -r $HOME/Github/dotfiles/nvim/* .
}

function loadvsc ()
{
  cp $HOME/Library/Application\ Support/Code/User/*.json $HOME/Github/dotfiles/vscode/
}
# create folder and cd into it
function mkcd() {
  mkdir -p "$@"  && cd $_
}

# hugo reload
# receive one paramater with commit
function hp(){
  cd $HOME/Github/site/blog && hugo && cd ./public && git add . && git commit -m "$1" && git push && cd $HOME/Github/site/blog
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

# pomodoro timer
function work() {
  # ms/s/m/h
  timer 45m --format 24h && say 'Mola verme zamanı dostum! Kalk ve biraz yürüyüşe çık! Biraz su iç!' \
                  && terminal-notifier -message 'Pomodoro'\
          -title 'Work Timer is up! Take a Break 😊'\
          -appIcon 'http://vjeantet.fr/images/logo.png' \
          -sound Crystal
}

function rest() {
  # ms/s/m/h
  timer 10m --format 24h && say 'Mola bitti, hadi ders çalışma zamanı' \
                  && terminal-notifier -message 'Pomodoro'\
          -title 'Break is over! Get back to work 😬'\
          -appIcon 'http://vjeantet.fr/images/logo.png' \
          -sound Crystal
}

# add apple quarantine for application
function appsec() {
  # param1: application path
  sudo xattr -r -d com.apple.quarantine $1
}

# get local ip address and copy to clipboard
function getip() {
  # ipconfig getifaddr en0
  ipinfo=($(ifconfig en0 | grep "inet " 2>&1))
  rich "[bold blue][Info][/]Local ip address is: [bold magenta]$(awk '{print $2}' <<< $ipinfo)[/]" -p
  # copy to clipboard
  ipaddress=$(awk '{print $2}' <<< $ipinfo)
  echo $ipaddress | cb
  rich "[bold blue][Info][/]Copy to clipboard" -p
}

function sshaws() {
  ssh -i $HOME/.config/aws/aws-gpu-4dv-key.pem ubuntu@$1
}

function cpaws() {
	cb copy "ssh -i $HOME/.config/aws/aws-gpu-4dv-key.pem ubuntu@$1"
}

# open target directory with vscode
function vscw(){
  # param1: target directory
  target=$(zoxide query "$1")
  rich "[bold blue][Info][/]Opening [bold magenta]$(echo $target)[/] with VSCode" -p
  # then check whether the target directory has *.code-workspace
  if [ -d "$target" ]; then
    if [ -n "$(find "$target" -name '*.code-workspace' -print -quit)" ]; then
      code "$target"/*.code-workspace
    else
      code "$target"
    fi
  else
    rich "[bold red3][Error][/]Directory not found" -p
  fi
}

# easy warpper for zju-connect
function zjucc(){
    CONFIG_PATH="$HOME/share/zju_connect_config.toml"
    # check if config file exists
    if [ ! -f "$CONFIG_PATH" ]; then
        rich "[bold red3][Error][/]Config file not found at [bold magenta]$(echo $CONFIG_PATH)[/]" -p
        rich "[bold blue][Info][/]Create a new config file" -p
        wget -O "$CONFIG_PATH" https://raw.githubusercontent.com/Mythologyli/zju-connect/refs/heads/main/config.toml.example
        # open with editor
        vim "$CONFIG_PATH"
    else
        rich "[bold blue][Info][/]Load zju-connect config from [bold magenta]$(echo $CONFIG_PATH)[/]" -p
        zju-connect -config "$CONFIG_PATH"
    fi
}


# terminal-notifier wrapper for job completion
function tn() {
  terminal-notifier -message "$1" -title "$2" -appIcon "$3" -sound "$4"
}

# Run a command and notify when it's done
function notify() {
  # Save start time
  local start_time=$(date +%s)

  # Run the command
  "$@"
  local exit_code=$?

  # Calculate duration
  local end_time=$(date +%s)
  local duration=$((end_time - start_time))
  local duration_str
  if [ $duration -lt 60 ]; then
    duration_str="${duration}s"
  else
    duration_str="$((duration/60))m$((duration%60))s"
  fi

    # Prepare notification
    local cmd_name="$@"
    local cmd_status="Success ✅"
    local sound="Crystal"

    if [ $exit_code -ne 0 ]; then
      cmd_status="Failed ❌ (exit code: $exit_code)"
      sound="Basso"
    fi

    # Send notification
    terminal-notifier -message "Duration: $(echo ${duration_str})" \
          -title "Job '${cmd_name}'" \
		      -subtitle "Command ${cmd_status}" \
          -sound "${sound}" \
          -activate "com.googlecode.iterm2"

  # Return the original exit code
  return $exit_code
}

# Sync local configs to github repo
function syncc() {
	bash /Users/vercent/Github/dotfiles/setup/sync.sh "$@"
}
