#!/usr/bin/env bash
set -euo pipefail
unset LC_ALL
export LANG="en_US.UTF-8"

state_dir="${AGENT_TMUX_STATUS_DIR:-${TMPDIR:-/tmp}/agent-tmux-status-${UID}}"
pane_dir="$state_dir/panes"
mkdir -p "$pane_dir"

codex_icon="${AGENT_TMUX_CODEX_ICON:-}"
claude_icon="${AGENT_TMUX_CLAUDE_ICON:-}"
mixed_icon="${AGENT_TMUX_MIXED_ICON:-}"

pane_key() {
  local pane="$1"
  printf '%s' "${pane//[^[:alnum:]_.-]/_}"
}

lower() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

contains_item() {
  local item="$1"
  shift
  local value

  for value in "$@"; do
    [[ "$value" == "$item" ]] && return 0
  done

  return 1
}

write_pane_status() {
  local pane="$1"
  local agent="$2"
  local status="$3"
  local window_id=""
  local window_index=""
  local key=""

  IFS='|' read -r window_id window_index < <(
    tmux display-message -pt "$pane" '#{window_id}|#{window_index}' 2>/dev/null || true
  )
  [[ -n "$window_id" && -n "$window_index" ]] || return 0

  key="$(pane_key "$pane")"
  {
    printf 'pane=%s\n' "$pane"
    printf 'window_id=%s\n' "$window_id"
    printf 'window_index=%s\n' "$window_index"
    printf 'agent=%s\n' "$agent"
    printf 'status=%s\n' "$status"
    printf 'updated_at=%s\n' "$(date +%s)"
  } > "$pane_dir/$key.status"
}

status_from_codex_event() {
  case "$1" in
    PermissionRequest) printf 'ask' ;;
    UserPromptSubmit|PreToolUse|PostToolUse|PostToolUseFailure) printf 'working' ;;
    SessionStart|Stop) printf 'done' ;;
    *) printf 'done' ;;
  esac
}

status_from_claude_event() {
  local event="$1"
  local payload="$2"
  local notification_type=""
  local message=""

  case "$event" in
    Notification)
      if command -v jq >/dev/null 2>&1; then
        notification_type="$(printf '%s' "$payload" | jq -r '.notification_type // empty' 2>/dev/null || true)"
        message="$(printf '%s' "$payload" | jq -r '.message // empty' 2>/dev/null || true)"
      else
        notification_type="$(printf '%s' "$payload" | tr -d '\n' | sed -n 's/.*"notification_type"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
        message="$(printf '%s' "$payload" | tr -d '\n' | sed -n 's/.*"message"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
      fi

      if [[ "$notification_type" == "permission_prompt" ]]; then
        printf 'ask'
      elif [[ "$(lower "$message")" =~ permission|approve|confirm|needs[[:space:]]+your ]]; then
        printf 'ask'
      else
        printf 'done'
      fi
      ;;
    UserPromptSubmit|PreToolUse) printf 'working' ;;
    Stop) printf 'done' ;;
    *) printf 'done' ;;
  esac
}

recompute_status() {
  local alive_panes=()
  local window_ids=()
  local agent_window_ids=()
  local approval_window_ids=()
  local approval_windows=()
  local has_any=0
  local has_codex=0
  local has_claude=0
  local pane=""
  local window_id=""
  local window_index=""
  local file=""
  local line=""
  local agent=""
  local status=""
  local key=""
  local icon=""
  local widget=""

  while IFS='|' read -r pane window_id window_index; do
    [[ -n "$pane" && -n "$window_id" ]] || continue
    alive_panes+=("$pane")
    contains_item "$window_id" "${window_ids[@]}" || window_ids+=("$window_id")
  done < <(tmux list-panes -a -F '#{pane_id}|#{window_id}|#{window_index}' 2>/dev/null || true)

  for file in "$pane_dir"/*.status; do
    [[ -f "$file" ]] || continue
    pane=""
    agent=""
    status=""
    window_id=""
    window_index=""

    while IFS='=' read -r key line; do
      case "$key" in
        pane) pane="$line" ;;
        agent) agent="$line" ;;
        status) status="$line" ;;
        window_id) window_id="$line" ;;
        window_index) window_index="$line" ;;
      esac
    done < "$file"

    if ! contains_item "$pane" "${alive_panes[@]}"; then
      rm -f "$file"
      continue
    fi

    has_any=1
    case "$agent" in
      codex) has_codex=1 ;;
      claude) has_claude=1 ;;
    esac
    contains_item "$window_id" "${agent_window_ids[@]}" || agent_window_ids+=("$window_id")

    if [[ "$status" == "ask" ]]; then
      contains_item "$window_id" "${approval_window_ids[@]}" || approval_window_ids+=("$window_id")
      contains_item "$window_index" "${approval_windows[@]}" || approval_windows+=("$window_index")
    fi
  done

  for window_id in "${window_ids[@]}"; do
    if contains_item "$window_id" "${agent_window_ids[@]}"; then
      tmux set-window-option -t "$window_id" -q @agent_window_has_agent 1 2>/dev/null || true
      tmux set-window-option -t "$window_id" -q @codex_window_has_codex 1 2>/dev/null || true
    else
      tmux set-window-option -t "$window_id" -q @agent_window_has_agent 0 2>/dev/null || true
      tmux set-window-option -t "$window_id" -q @codex_window_has_codex 0 2>/dev/null || true
    fi

    if contains_item "$window_id" "${approval_window_ids[@]}"; then
      tmux set-window-option -t "$window_id" -q @agent_window_approval_waiting 1 2>/dev/null || true
      tmux set-window-option -t "$window_id" -q @codex_window_approval_waiting 1 2>/dev/null || true
    else
      tmux set-window-option -t "$window_id" -q @agent_window_approval_waiting 0 2>/dev/null || true
      tmux set-window-option -t "$window_id" -q @codex_window_approval_waiting 0 2>/dev/null || true
    fi
  done

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
  tmux refresh-client -S 2>/dev/null || true
}

seed_status() {
  local pane=""
  local window_name=""
  local command=""
  local haystack=""

  while IFS='|' read -r pane window_name command; do
    haystack="$(lower "$window_name $command")"
    case "$haystack" in
      *claude*) write_pane_status "$pane" claude done ;;
      *codex*) write_pane_status "$pane" codex done ;;
    esac
  done < <(tmux list-panes -a -F '#{pane_id}|#{window_name}|#{pane_current_command}' 2>/dev/null || true)
}

main() {
  local command="${1:-refresh}"
  local agent="${1:-}"
  local event="${2:-}"
  local payload=""
  local status=""
  local pane="${TMUX_PANE:-}"

  case "$command" in
    refresh)
      recompute_status
      return
      ;;
    seed)
      seed_status
      recompute_status
      return
      ;;
  esac

  payload="$(cat 2>/dev/null || true)"
  [[ -n "$pane" ]] || return 0

  case "$agent" in
    codex) status="$(status_from_codex_event "$event")" ;;
    claude) status="$(status_from_claude_event "$event" "$payload")" ;;
    *) return 0 ;;
  esac

  write_pane_status "$pane" "$agent" "$status"
  recompute_status
}

main "$@"
