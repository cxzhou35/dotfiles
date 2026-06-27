alias bl="brew list"
alias bi="brew install"
alias br="brew remove"
alias bs="brew search"
alias bu="brew uninstall"
alias bd="brew doctor"

cleanbrew() {
    local folder_path
    local folder_paths=("$HOME/Library/Caches/Homebrew/downloads" "$HOME/Library/Caches/Homebrew/Cask")
    local found_any=0

    for folder_path in "${folder_paths[@]}"; do
        if [ ! -d "$folder_path" ]; then
            rich "[bold blue][Info][/]The folder [bold magenta]${folder_path}[/] does not exist." -p
            continue
        fi

        if find "$folder_path" -mindepth 1 -maxdepth 1 | read -r _; then
            find "$folder_path" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
            found_any=1
            rich "[bold blue][Info][/]Cleared [bold magenta]${folder_path}[/]." -p
        else
            rich "[bold blue][Info][/]The folder [bold magenta]${folder_path}[/] is already empty." -p
        fi
    done

    if [ "$found_any" -eq 1 ]; then
        brew cleanup --prune=all
    fi
}
