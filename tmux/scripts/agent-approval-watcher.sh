#!/usr/bin/env bash
set -euo pipefail
unset LC_ALL
export LANG="en_US.UTF-8"

# Content-based approval tracker for agent CLIs in tmux.
# Track state at the window level because a window can contain multiple panes.

interval="${AGENT_TMUX_APPROVAL_INTERVAL:-2}"
agent_pattern="${AGENT_TMUX_COMMAND_PATTERN:-codex|claude}"
state_dir="${TMPDIR:-/tmp}/agent-tmux-approval-watcher-${UID}"
lock_dir="${state_dir}.lock"

mkdir -p "$state_dir"
if ! mkdir "$lock_dir" 2>/dev/null; then
  exit 0
fi
trap 'rm -rf "$lock_dir"' EXIT

is_agent_pane() {
  local command="${1,,}"
  local window_name="${2,,}"
  [[ "$command" =~ $agent_pattern || "$window_name" =~ $agent_pattern ]]
}

detect_agent_kind() {
  local command="${1,,}"
  local window_name="${2,,}"
  local haystack="${command} ${window_name}"

  if [[ "$haystack" == *claude* ]]; then
    printf 'claude'
    return
  fi

  if [[ "$haystack" == *codex* ]]; then
    printf 'codex'
  fi
}

has_approval_prompt() {
  local pane="$1"
  local content
  content="$(tmux capture-pane -pt "$pane" -S -35 -E - 2>/dev/null | tr -d '\r')"

  # Match active approval UI only. Avoid stale transcript lines such as "You approved...".
  printf '%s\n' "$content" | grep -Eiq '(^|[[:space:]])(Do you want|Would you like|allow this command|approve command|approval required|requires approval|sandbox_permissions|require_escalated|授权|允许.*(执行|操作|命令))' || return 1
  printf '%s\n' "$content" | grep -Eiq '^[[:space:]┃│>›❯●○-]*([0-9]+[.)][[:space:]]*)?(Yes|No)([[:space:],.)]|$)|^[[:space:]┃│>›❯●○-]*[\[(](y|Y)/(n|N)[\])]'
}

update_status_widget() {
  local has_any="$1"
  local has_codex="$2"
  local has_claude="$3"
  shift 3
  local approval_windows=("$@")
  local widget=""
  local codex_icon="${AGENT_TMUX_CODEX_ICON:-}"
  local claude_icon="${AGENT_TMUX_CLAUDE_ICON:-}"
  local mixed_icon="${AGENT_TMUX_MIXED_ICON:-}"
  local icon=""

  if [[ "$has_codex" == "1" && "$has_claude" == "1" ]]; then
    icon="$mixed_icon"
  elif [[ "$has_claude" == "1" ]]; then
    icon="$claude_icon"
  else
    icon="$codex_icon"
  fi

  if (( ${#approval_windows[@]} > 0 )); then
    widget="#[fg=#f7768e,bold]${icon} ${#approval_windows[@]}:${approval_windows[*]}#[default] "
  elif [[ "$has_any" == "1" ]]; then
    widget="#[fg=#7dcfff,bold]${icon}#[default] "
  fi

  tmux set-option -gq @agent_status_widget "$widget" 2>/dev/null || true
  tmux set-option -gq @codex_status_widget "$widget" 2>/dev/null || true
}

while tmux list-sessions >/dev/null 2>&1; do
  has_any=0
  has_codex=0
  has_claude=0
  window_ids=()
  agent_windows=()
  approval_windows=()

  while IFS= read -r window_id; do
    [[ -n "$window_id" ]] && window_ids+=("$window_id")
  done < <(tmux list-windows -a -F '#{window_id}' 2>/dev/null || true)

  while IFS='|' read -r pane window_id window_index window_name command; do
    local_agent_kind=""
    [[ -n "$pane" && -n "$window_id" ]] || continue
    is_agent_pane "$command" "$window_name" || continue

    has_any=1
    local_agent_kind="$(detect_agent_kind "$command" "$window_name")"
    case "$local_agent_kind" in
      codex) has_codex=1 ;;
      claude) has_claude=1 ;;
    esac
    case " ${agent_windows[*]} " in
      *" $window_id "*) ;;
      *) agent_windows+=("$window_id") ;;
    esac

    if has_approval_prompt "$pane"; then
      case " ${approval_windows[*]} " in
        *" $window_index "*) ;;
        *) approval_windows+=("$window_index") ;;
      esac
      tmux set-window-option -t "$window_id" -q @agent_window_approval_waiting 1 2>/dev/null || true
      tmux set-window-option -t "$window_id" -q @codex_window_approval_waiting 1 2>/dev/null || true
    fi
  done < <(tmux list-panes -a -F '#{pane_id}|#{window_id}|#{window_index}|#{window_name}|#{pane_current_command}' 2>/dev/null || true)

  # Apply the collected state after scanning to avoid transient reset flicker.
  for window_id in "${window_ids[@]}"; do
    if [[ " ${agent_windows[*]} " == *" $window_id "* ]]; then
      tmux set-window-option -t "$window_id" -q @agent_window_has_agent 1 2>/dev/null || true
      tmux set-window-option -t "$window_id" -q @codex_window_has_codex 1 2>/dev/null || true
    else
      tmux set-window-option -t "$window_id" -q @agent_window_has_agent 0 2>/dev/null || true
      tmux set-window-option -t "$window_id" -q @codex_window_has_codex 0 2>/dev/null || true
    fi
  done

  # Clear approval marks for windows that were not detected this round.
  for window_id in "${window_ids[@]}"; do
    found=0
    while IFS='|' read -r idx id; do
      [[ "$id" == "$window_id" ]] || continue
      if [[ " ${approval_windows[*]} " == *" $idx "* ]]; then
        found=1
      fi
      break
    done < <(tmux list-windows -a -F '#{window_index}|#{window_id}' 2>/dev/null || true)
    if [[ "$found" == "0" ]]; then
      tmux set-window-option -t "$window_id" -q @agent_window_approval_waiting 0 2>/dev/null || true
      tmux set-window-option -t "$window_id" -q @codex_window_approval_waiting 0 2>/dev/null || true
    fi
  done

  update_status_widget "$has_any" "$has_codex" "$has_claude" "${approval_windows[@]}"
  tmux refresh-client -S 2>/dev/null || true
  sleep "$interval"
done
