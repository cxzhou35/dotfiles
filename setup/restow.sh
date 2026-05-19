#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STOW_BIN="${STOW_BIN:-stow}"
HOME_DIR="${HOME}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME_DIR/.config}"
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: bash setup/restow.sh [--dry-run] [package...]

Re-stow dotfiles packages to their expected targets.

Examples:
  bash setup/restow.sh
  bash setup/restow.sh --dry-run
  bash setup/restow.sh zsh tmux nvim
EOF
}

ensure_stow() {
  if ! command -v "$STOW_BIN" >/dev/null 2>&1; then
    echo "stow not found: $STOW_BIN" >&2
    exit 1
  fi
}

target_for_package() {
  local package="$1"

  case "$package" in
    codex)
      printf '%s/.codex' "$HOME_DIR"
      ;;
    zsh)
      printf '%s/.config/zsh' "$HOME_DIR"
      ;;
    tmux)
      printf '%s' "$HOME_DIR"
      ;;
    bin)
      printf '%s/.config' "$HOME_DIR"
      ;;
    *)
      printf '%s' "$CONFIG_DIR"
      ;;
  esac
}

package_exists() {
  local package="$1"
  [ -d "$ROOT_DIR/$package" ]
}

link_file() {
  local src="$1"
  local dst="$2"

  if [ "$DRY_RUN" -eq 1 ]; then
    echo "dry-run link $dst -> $src"
    return 0
  fi

  ln -sf "$src" "$dst"
}

remove_path() {
  local dst="$1"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "dry-run unlink $dst"
    return 0
  fi

  rm -f "$dst"
}

restow_zsh() {
  local target="$CONFIG_DIR/zsh"

  mkdir -p "$target"
  stow_package "zsh" "$target"
  remove_path "$target/.zshrc"
  remove_path "$target/.zprofile"
  remove_path "$target/.zshenv"
  remove_path "$target/locale.zsh"
  remove_path "$target/theme.zsh"
  link_file "$ROOT_DIR/zsh/.zshrc" "$HOME_DIR/.zshrc"
  link_file "$ROOT_DIR/zsh/.zprofile" "$HOME_DIR/.zprofile"
  link_file "$ROOT_DIR/zsh/.zshenv" "$HOME_DIR/.zshenv"
}

stow_package() {
  local package="$1"
  local target="$2"
  local -a cmd=("$STOW_BIN" -R -t "$target")

  mkdir -p "$target"
  if [ "$DRY_RUN" -eq 1 ]; then
    cmd+=(-n -v)
    echo "dry-run restow $package -> $target"
  else
    echo "restow $package -> $target"
  fi
  cmd+=("$package")
  "${cmd[@]}"
}

main() {
  local -a packages=()
  local arg

  for arg in "$@"; do
    case "$arg" in
      -h|--help)
        usage
        exit 0
        ;;
      --dry-run|-n)
        DRY_RUN=1
        ;;
      *)
        packages+=("$arg")
        ;;
    esac
  done

  ensure_stow

  if [ "${#packages[@]}" -eq 0 ]; then
    packages=(
      alacritty
      atuin
      bat
      bewlybewly
      bin
      bottom
      btop
      codex
      fastfetch
      gh
      ghostty
      git
      iterm2
      karabiner
      kitty
      lazygit
      mpv
      neofetch
      nvim
      obsidian
      pip
      screenshot
      sesh
      starship
      stylus
      switchyomega
      tmux
      vim
      vscode
      wezterm
      yazi
      zathura
      zsh
    )
  fi

  local package
  local target
  for package in "${packages[@]}"; do
    if ! package_exists "$package"; then
      echo "skip missing package: $package" >&2
      continue
    fi
    if [ "$package" = "zsh" ]; then
      restow_zsh
      continue
    fi
    target="$(target_for_package "$package")"
    stow_package "$package" "$target"
  done
}

main "$@"
