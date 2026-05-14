() {
    local apps_dir="${${(%):-%x}:A:h}"
    local app_file

    for app_file in "$apps_dir"/*.zsh(.N); do
        case "${app_file:t}" in
            init.zsh|zoxide.zsh)
                continue
                ;;
        esac
        source "$app_file"
    done

    # Keep zoxide near the end so its chpwd hook is less likely to be overwritten.
    source "$apps_dir/zoxide.zsh"
}
