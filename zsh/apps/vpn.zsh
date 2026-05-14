# aws
sshaws() {
    ssh -i "$HOME/.config/aws/aws-gpu-4dv-key.pem" "ubuntu@$1"
}

cpaws() {
    cb copy "ssh -i $HOME/.config/aws/aws-gpu-4dv-key.pem ubuntu@$1"
}

# zju
zjucc() {
    local CONFIG_PATH="$HOME/share/zju_connect_config.toml"
    if [ ! -f "$CONFIG_PATH" ]; then
        rich "[bold red3][Error][/]Config file not found at [bold magenta]$CONFIG_PATH[/]" -p
        rich "[bold blue][Info][/]Create a new config file" -p
        wget -O "$CONFIG_PATH" https://raw.githubusercontent.com/Mythologyli/zju-connect/refs/heads/main/config.toml.example
        vim "$CONFIG_PATH"
    else
        rich "[bold blue][Info][/]Load zju-connect config from [bold magenta]$CONFIG_PATH[/]" -p
        zju-connect -config "$CONFIG_PATH"
    fi
}
