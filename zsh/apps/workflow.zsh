alias c="clear"
alias m="h-m-m"
alias ra="yazi"
alias lzd="lazydocker"
alias dash="gh dash"
alias tb="tensorboard"
alias askgpt="shell-genie ask"
alias pc="pokemon-colorscripts"
alias erd="erd -H -I -s rsize -L"
alias viewmd="frogmouth"
alias color="npx iroiro"
alias broz="npx broz"
alias pdt="python3 -m doctest -v"
alias g++c="g++ -std=c++17 -Wall"

alias cwt="curl wttr.in"
alias cwthz="curl wttr.in/Hangzhou"

alias chrome="open -a 'Google Chrome'"
alias ob="open -a 'Obsidian'"
alias brave="open -a 'Brave Browser'"

alias asr="asciinema rec"
alias asu="asciinema upload"

alias rd="reveal-md"
alias rdsite="reveal-md --static site"
alias hs="hugo server -D"
alias hp="hugo"
alias mkd="mkdocs gh-deploy --force"
alias mks="mkdocs serve --dirtyreload"

loadnvim() {
    cd "$HOME/Github/neovim" && cp -r "$HOME/Github/dotfiles/nvim/." .
}

loadvsc() {
    cp "$HOME/Library/Application Support/Code/User/"*.json "$HOME/Github/dotfiles/vscode/"
}

sc() {
    sesh connect "$(sesh list -i | gum filter --limit 1 --placeholder 'Pick a sesh' --prompt='⚡')"
}

work() {
    timer 45m --format 24h && say 'Mola verme zamani dostum! Kalk ve biraz yuruyuse cik! Biraz su ic!' \
        && terminal-notifier -message 'Pomodoro' \
            -title 'Work Timer is up! Take a Break :)' \
            -appIcon 'http://vjeantet.fr/images/logo.png' \
            -sound Crystal
}

rest() {
    timer 10m --format 24h && say 'Mola bitti, hadi ders calisma zamani' \
        && terminal-notifier -message 'Pomodoro' \
            -title 'Break is over! Get back to work :)' \
            -appIcon 'http://vjeantet.fr/images/logo.png' \
            -sound Crystal
}

notify() {
    local start_time
    local exit_code
    local end_time
    local duration
    local duration_str
    local cmd_name
    local cmd_status
    local sound

    start_time=$(date +%s)
    "$@"
    exit_code=$?

    end_time=$(date +%s)
    duration=$((end_time - start_time))
    if [ "$duration" -lt 60 ]; then
        duration_str="${duration}s"
    else
        duration_str="$((duration / 60))m$((duration % 60))s"
    fi

    cmd_name="$*"
    cmd_status="Success"
    sound="Crystal"
    if [ "$exit_code" -ne 0 ]; then
        cmd_status="Failed (exit code: $exit_code)"
        sound="Basso"
    fi

    terminal-notifier -message "Duration: $duration_str" \
        -title "Job '$cmd_name'" \
        -subtitle "Command $cmd_status" \
        -sound "$sound" \
        -activate "com.googlecode.iterm2"

    return "$exit_code"
}

vscw() {
    local target
    target="$(zoxide query "$1")"
    rich "[bold blue][Info][/]Opening [bold magenta]$(echo "$target")[/] with VSCode" -p

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

overleaf_push_realme() {
    local repo="/Users/vercent/Projects/3dv/ToG_2026_RealMe/overleaf"
    local project_id="69ce54f33f8522a7221cdefe"
    local proxy_host
    local proxy_port
    local proxy
    local branch="${1:-master}"
    local remote_url
    local ahead_count=0

    if (( $+functions[_load_proxy_config] )); then
        _load_proxy_config
    elif [[ -r "$HOME/Github/dotfiles/zsh/.proxyenv" ]]; then
        source "$HOME/Github/dotfiles/zsh/.proxyenv"
    fi

    proxy_host="${OVERLEAF_PROXY_IP:-10.130.136.134}"
    proxy_port="${OVERLEAF_PROXY_PORT:-9053}"
    proxy="${OVERLEAF_PROXY_URL:-http://${proxy_host}:${proxy_port}}"

    if [[ -z "${OVERLEAF_TOKEN:-}" ]]; then
        echo "OVERLEAF_TOKEN is not set."
        echo 'Run: export OVERLEAF_TOKEN="olp_xxx"'
        return 1
    fi

    if [[ ! -d "$repo/.git" ]]; then
        echo "Git repo not found: $repo"
        return 1
    fi

    remote_url="https://git:${OVERLEAF_TOKEN}@git.overleaf.com/${project_id}"

    if git -C "$repo" diff --quiet && git -C "$repo" diff --cached --quiet; then
        if git -C "$repo" rev-parse --verify "origin/${branch}" >/dev/null 2>&1; then
            ahead_count="$(git -C "$repo" rev-list --count "origin/${branch}..${branch}")"
        fi
        if [[ "$ahead_count" -eq 0 ]]; then
            echo "No local changes or commits to push on ${branch}."
            git -C "$repo" status -sb
            return 0
        fi
    fi

    GIT_TERMINAL_PROMPT=0 git -C "$repo" \
        -c http.proxy="$proxy" \
        -c https.proxy="$proxy" \
        push "$remote_url" "$branch:$branch" || return 1

    GIT_TERMINAL_PROMPT=0 git -C "$repo" \
        -c http.proxy="$proxy" \
        -c https.proxy="$proxy" \
        fetch "$remote_url" "${branch}:refs/remotes/origin/${branch}" || return 1

    git -C "$repo" status -sb
}

alias olpush="overleaf_push_realme"

syncc() {
    bash /Users/vercent/Github/dotfiles/setup/sync.sh "$@"
}
