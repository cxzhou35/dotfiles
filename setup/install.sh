#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOMEBREW_FILE="$ROOT_DIR/setup/apps/homebrew.txt"
MAS_FILE="$ROOT_DIR/setup/apps/mas.txt"
DMG_FILE="$ROOT_DIR/setup/apps/dmg.txt"

info() {
  printf '[INFO] %s\n' "$1"
}

warn() {
  printf '[WARN] %s\n' "$1" >&2
}

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    warn "missing file: $path"
    exit 1
  fi
}

install_homebrew_apps() {
  require_file "$HOMEBREW_FILE"

  if ! command -v brew >/dev/null 2>&1; then
    warn "Homebrew is not installed. Install it first from https://brew.sh/"
    exit 1
  fi

  info "Installing Homebrew formulae and casks from $HOMEBREW_FILE"
  brew bundle --file="$HOMEBREW_FILE"
}

install_mas_apps() {
  require_file "$MAS_FILE"

  if ! command -v mas >/dev/null 2>&1; then
    warn "`mas` is not available after Homebrew install. Skipping Mac App Store apps."
    return 0
  fi

  local -a ids=()
  mapfile -t ids < <(awk '/^[0-9]+/{print $1}' "$MAS_FILE")

  if [[ ${#ids[@]} -eq 0 ]]; then
    info "No Mac App Store app IDs found in $MAS_FILE"
    return 0
  fi

  info "Installing Mac App Store apps from $MAS_FILE"
  if ! mas install "${ids[@]}"; then
    warn "Mac App Store install reported an error. Check App Store sign-in and purchased apps, then retry if needed."
  fi
}

manual_app_installed() {
  local app_name="$1"

  [[ -d "/Applications/${app_name}.app" || -d "$HOME/Applications/${app_name}.app" ]]
}

manual_cli_installed() {
  local command_name="$1"

  command -v "$command_name" >/dev/null 2>&1
}

check_manual_downloads() {
  require_file "$DMG_FILE"

  info "Checking manual download list from $DMG_FILE"

  local line=""
  local section=""
  local app_name=""
  local kind=""
  local source_type=""
  local source_url=""
  local download_url=""
  local notes=""
  local total=0
  local installed=0
  local pending=0

  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" == '## '* ]]; then
      section="${line#\#\# }"
      continue
    fi

    if [[ -z "$line" || "$line" == \#* ]]; then
      continue
    fi

    IFS='|' read -r app_name kind source_type source_url download_url notes <<<"$line"
    app_name="$(trim "$app_name")"
    kind="$(trim "$kind")"
    source_type="$(trim "$source_type")"
    source_url="$(trim "$source_url")"
    download_url="$(trim "$download_url")"
    notes="$(trim "$notes")"

    total=$((total + 1))

    case "$kind" in
      app)
        if manual_app_installed "$app_name"; then
          installed=$((installed + 1))
          continue
        fi
        ;;
      cli)
        if manual_cli_installed "$app_name"; then
          installed=$((installed + 1))
          continue
        fi
        ;;
    esac

    pending=$((pending + 1))
    printf '[TODO] %s [%s]\n' "$app_name" "$section"
    printf '       source_type: %s\n' "$source_type"
    printf '       source: %s\n' "$source_url"
    printf '       download: %s\n' "$download_url"
    if [[ -n "$notes" ]]; then
      printf '       notes: %s\n' "$notes"
    fi
  done <"$DMG_FILE"

  info "Manual download summary: installed=$installed pending=$pending total=$total"
}

info "Running dotfiles install..."

install_homebrew_apps
install_mas_apps
check_manual_downloads
