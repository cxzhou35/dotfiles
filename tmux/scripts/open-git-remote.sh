#!/usr/bin/env bash
set -euo pipefail

target_path="${1:-${PWD}}"
mode="${2:-open}"
preferred_remote="${TMUX_GIT_REMOTE:-origin}"

fail() {
  local message="$1"
  if command -v tmux >/dev/null 2>&1 && [[ -n "${TMUX:-}" ]]; then
    tmux display-message "$message"
  else
    printf '%s\n' "$message" >&2
  fi
  exit 1
}

normalize_remote_url() {
  local remote_url="$1"

  remote_url="${remote_url%.git}"

  case "$remote_url" in
    git@*:*|*@*:* )
      remote_url="${remote_url#*@}"
      remote_url="https://${remote_url/:/\/}"
      ;;
    ssh://git@*|ssh://*@* )
      remote_url="${remote_url#ssh://}"
      remote_url="${remote_url#*@}"
      remote_url="https://${remote_url}"
      ;;
    http://*|https://*)
      ;;
    *)
      return 1
      ;;
  esac

  printf '%s' "$remote_url"
}

if ! repo_root="$(git -C "$target_path" rev-parse --show-toplevel 2>/dev/null)"; then
  fail "tmux: current path is not inside a git repo"
fi

remote_name="$preferred_remote"
if ! git -C "$repo_root" remote get-url "$remote_name" >/dev/null 2>&1; then
  remote_name="$(git -C "$repo_root" remote | head -n 1)"
fi

if [[ -z "${remote_name:-}" ]]; then
  fail "tmux: no git remote found for $repo_root"
fi

remote_url="$(git -C "$repo_root" remote get-url "$remote_name" 2>/dev/null || true)"
if [[ -z "$remote_url" ]]; then
  fail "tmux: could not read remote URL for $remote_name"
fi

if ! browser_url="$(normalize_remote_url "$remote_url")"; then
  fail "tmux: unsupported remote URL $remote_url"
fi

if [[ "$mode" == "--print-url" ]]; then
  printf '%s\n' "$browser_url"
  exit 0
fi

open "$browser_url"

if command -v tmux >/dev/null 2>&1 && [[ -n "${TMUX:-}" ]]; then
  tmux display-message "Opened ${remote_name}: ${browser_url}"
fi
