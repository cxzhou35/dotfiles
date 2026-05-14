#!/usr/bin/env bash
set -euo pipefail

watcher_script="$HOME/Github/dotfiles/tmux/scripts/agent-approval-watcher.sh"
widget='#{@agent_status_widget}'
base="$(tmux show-option -gv status-right 2>/dev/null || true)"
base="$(printf '%s' "$base" | perl -pe 's/#\([^)]*(codex|agent)-status-widget\.sh[^)]*\)//g; s/#\{@codex_status_widget\}//g; s/#\{@agent_status_widget\}//g; s/^ +//')"

tmux set-option -gq @agent_status_widget ""
tmux set-option -gq @codex_status_widget ""
tmux set-option -g status-right "${widget}${base}"

# Reloads should replace the long-running watcher so it picks up icon/script changes.
pkill -f "$watcher_script" 2>/dev/null || true
tmux run-shell -b "$watcher_script"
