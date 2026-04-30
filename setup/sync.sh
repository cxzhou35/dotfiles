#!/usr/bin/env bash

set -euo pipefail

original_dir="$(pwd)"
script_dir="$(
  cd "$(dirname "$0")"
  pwd
)"
repo_dir="$(
  cd "${script_dir}/.."
  pwd
)"

cleanup() {
  cd "${original_dir}" || exit 1
}

trap cleanup EXIT

rich_print() {
  if command -v rich >/dev/null 2>&1; then
    rich "$@"
  else
    printf '%s\n' "$1"
  fi
}

info() {
  rich_print "[INFO]$1" -p --style "on blue"
}

warn() {
  rich_print "[WARN]$1" -p --style "on orange3"
}

error() {
  rich_print "[ERROR]$1" -p --style "bold white on red"
}

supports_color() {
  [[ -t 1 ]] && [[ -z "${NO_COLOR:-}" ]]
}

print_line() {
  local text="$1"
  printf '%s\n' "$text"
}

color_text() {
  local color_code="$1"
  shift
  local text="$*"

  if supports_color; then
    printf '\033[%sm%s\033[0m' "$color_code" "$text"
  else
    printf '%s' "$text"
  fi
}

colorize_tag() {
  local tag="$1"
  local color_code

  case "$tag" in
    zsh)
      color_code="1;38;5;39"
      ;;
    neovim)
      color_code="1;38;5;42"
      ;;
    setup)
      color_code="1;38;5;208"
      ;;
    git)
      color_code="1;38;5;141"
      ;;
    misc)
      color_code="1;38;5;250"
      ;;
    ghostty)
      color_code="1;38;5;45"
      ;;
    kitty)
      color_code="1;38;5;171"
      ;;
    tmux)
      color_code="1;38;5;220"
      ;;
    *)
      color_code="1;38;5;81"
      ;;
  esac

  color_text "$color_code" "[#${tag}]"
}

print_commit_message() {
  local commit_message="$1"
  local remaining="$commit_message"
  local summary=""
  local colored_message="Commit message: "

  while [[ "$remaining" =~ ^(\[#([^]]+)\])(.*)$ ]]; do
    colored_message+="$(colorize_tag "${BASH_REMATCH[2]}")"
    remaining="${BASH_REMATCH[3]}"
  done

  summary="${remaining# }"
  if [[ -n "$summary" ]]; then
    colored_message+=" $(color_text '1;38;5;120' "$summary")"
  fi

  printf '%b\n' "$colored_message"
}

print_confirmation_prompt() {
  if ! supports_color; then
    printf 'Press Enter to commit, type l to open lazygit, or q to abort: '
    return
  fi

  printf 'Press '
  color_text '1;38;5;220' 'Enter'
  printf ' to commit, type '
  color_text '1;38;5;45' 'l'
  printf ' to open lazygit, or '
  color_text '1;38;5;196' 'q'
  printf ' to abort: '
}

contains_item() {
  local needle="$1"
  shift
  local item

  for item in "$@"; do
    if [[ "$item" == "$needle" ]]; then
      return 0
    fi
  done

  return 1
}

append_unique() {
  local value="$1"
  shift

  if [[ -z "$value" ]]; then
    return 0
  fi

  if contains_item "$value" "$@"; then
    return 1
  fi

  return 0
}

join_with() {
  local delimiter="$1"
  shift

  if [[ $# -eq 0 ]]; then
    return 0
  fi

  local output="$1"
  shift
  local item

  for item in "$@"; do
    output+="${delimiter}${item}"
  done

  printf '%s' "$output"
}

top_level_to_tag() {
  local path="$1"
  local top_level="${path%%/*}"

  case "$top_level" in
    nvim)
      printf 'neovim'
      ;;
    setup)
      printf 'setup'
      ;;
    .gitignore|.stow-local-ignore|README.md|LICENSE)
      printf 'misc'
      ;;
    *)
      if [[ "$path" == "$top_level" ]]; then
        printf 'misc'
      else
        printf '%s' "$top_level"
      fi
      ;;
  esac
}

scope_label() {
  local tag="$1"

  case "$tag" in
    neovim)
      printf 'neovim config'
      ;;
    zsh)
      printf 'zsh config'
      ;;
    git)
      printf 'git config'
      ;;
    setup)
      printf 'setup script'
      ;;
    misc)
      printf 'local configs'
      ;;
    *)
      printf '%s config' "$tag"
      ;;
  esac
}

detect_summary_verb() {
  local -a status_codes=()
  local status

  while IFS= read -r status; do
    [[ -z "$status" ]] && continue
    if append_unique "$status" "${status_codes[@]}"; then
      status_codes+=("$status")
    fi
  done < <(git diff --cached --name-status --diff-filter=ACDMR | awk '{print substr($1, 1, 1)}')

  if [[ ${#status_codes[@]} -eq 1 ]]; then
    case "${status_codes[0]}" in
      A)
        printf 'add'
        return
        ;;
      D)
        printf 'remove'
        return
        ;;
      R)
        printf 'rename'
        return
        ;;
    esac
  fi

  printf 'update'
}

collect_changed_files() {
  git diff --cached --name-only --diff-filter=ACDMR
}

infer_tags() {
  local -a tags=()
  local path
  local tag

  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    tag="$(top_level_to_tag "$path")"
    if append_unique "$tag" "${tags[@]}"; then
      tags+=("$tag")
    fi
  done < <(collect_changed_files)

  if [[ ${#tags[@]} -eq 0 ]]; then
    tags=("misc")
  elif [[ ${#tags[@]} -gt 3 ]]; then
    tags=("misc")
  fi

  printf '%s\n' "${tags[@]}"
}

format_tags() {
  local -a tags=("$@")
  local tag
  local output=""

  if [[ ${#tags[@]} -eq 0 ]]; then
    tags=("misc")
  fi

  for tag in "${tags[@]}"; do
    tag="${tag#\#}"
    output+="[#${tag}]"
  done

  printf '%s' "$output"
}

build_auto_summary() {
  local -a tags=("$@")
  local verb

  verb="$(detect_summary_verb)"

  if [[ ${#tags[@]} -eq 0 ]]; then
    printf '%s local configs' "$verb"
    return
  fi

  if [[ ${#tags[@]} -eq 1 ]]; then
    printf '%s %s' "$verb" "$(scope_label "${tags[0]}")"
    return
  fi

  printf '%s %s configs' "$verb" "$(join_with ', ' "${tags[@]}")"
}

parse_tag_override() {
  local raw_tags="$1"
  local normalized="${raw_tags//,/ }"
  local -a tags=()
  local tag

  for tag in $normalized; do
    tag="${tag#\#}"
    [[ -z "$tag" ]] && continue
    if append_unique "$tag" "${tags[@]}"; then
      tags+=("$tag")
    fi
  done

  if [[ ${#tags[@]} -eq 0 ]]; then
    tags=("misc")
  fi

  printf '%s\n' "${tags[@]}"
}

build_commit_message() {
  local manual_tag_input="${1:-}"
  local manual_summary="${2:-}"
  local -a tags=()
  local summary=""
  local line

  if [[ -n "$manual_tag_input" ]]; then
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      tags+=("$line")
    done < <(parse_tag_override "$manual_tag_input")
  else
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      tags+=("$line")
    done < <(infer_tags)
  fi

  if [[ -n "$manual_summary" ]]; then
    summary="$manual_summary"
  else
    summary="$(build_auto_summary "${tags[@]}")"
  fi

  printf '%s %s' "$(format_tags "${tags[@]}")" "$summary"
}

show_change_summary() {
  local -a files=()
  local path
  local preview_line

  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    files+=("$path")
  done < <(collect_changed_files)

  if [[ ${#files[@]} -eq 0 ]]; then
    warn "No staged changes found after refresh"
    return
  fi

  info "Staged ${#files[@]} file(s)"

  while IFS= read -r preview_line; do
    [[ -z "$preview_line" ]] && continue
    print_line "$preview_line"
  done < <(printf '%s\n' "${files[@]}" | head -n 10)

  if [[ ${#files[@]} -gt 10 ]]; then
    print_line "... and $(( ${#files[@]} - 10 )) more"
  fi
}

refresh_staged_changes() {
  local check_output=""
  local -a check_lines=()
  local -a warning_lines=()
  local -a error_lines=()
  local line

  git add -A

  if git diff --cached --quiet; then
    warn "No staged changes to commit after refresh"
    return 1
  fi

  if ! check_output="$(git diff --cached --check 2>&1)"; then
    mapfile -t check_lines <<<"$check_output"

    for line in "${check_lines[@]}"; do
      [[ -z "$line" ]] && continue

      if [[ "$line" == *"new blank line at EOF."* ]]; then
        warning_lines+=("$line")
      else
        error_lines+=("$line")
      fi
    done

    for line in "${warning_lines[@]}"; do
      warn "$line"
    done

    if [[ ${#error_lines[@]} -gt 0 ]]; then
      for line in "${error_lines[@]}"; do
        error "$line"
      done
      error "Whitespace or merge-marker issues detected in staged changes"
      exit 1
    fi
  fi
}

ahead_count() {
  if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
    git rev-list --count '@{u}..HEAD'
  else
    printf '0'
  fi
}

confirm_commit_message() {
  local manual_tag_input="${1:-}"
  local manual_summary="${2:-}"
  local commit_message=""
  local response=""

  while true; do
    if ! refresh_staged_changes; then
      exit 0
    fi

    show_change_summary
    commit_message="$(build_commit_message "$manual_tag_input" "$manual_summary")"
    print_commit_message "$commit_message"

    if [[ ! -t 0 || "${SYNC_AUTO_CONFIRM:-0}" == "1" ]]; then
      CONFIRMED_COMMIT_MESSAGE="$commit_message"
      return 0
    fi

    print_confirmation_prompt
    IFS= read -r response

    case "$response" in
      "")
        CONFIRMED_COMMIT_MESSAGE="$commit_message"
        return 0
        ;;
      l|L|lg|LG|lazygit)
        if ! command -v lazygit >/dev/null 2>&1; then
          warn "lazygit is not installed"
          continue
        fi

        info "Opening lazygit for review"
        lazygit
        info "Returned from lazygit"
        ;;
      q|Q|quit|QUIT)
        warn "Commit aborted"
        exit 0
        ;;
      *)
        warn "Unknown input: ${response}"
        ;;
    esac
  done
}

commit_and_push() {
  local commit_message="$1"

  git commit -m "$commit_message"
  git push
}

cd "${repo_dir}"

info "Working on ${repo_dir}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  error "Not inside a git repository"
  exit 1
fi

if [[ $# -gt 2 ]]; then
  error "Usage: $0 [tag] [summary]"
  error "Examples:"
  error "  $0"
  error "  $0 \"update proxy helper\""
  error "  $0 zsh \"update proxy helper\""
  exit 1
fi

manual_tag=""
manual_summary=""

if [[ $# -eq 1 ]]; then
  manual_summary="$1"
elif [[ $# -eq 2 ]]; then
  manual_tag="$1"
  manual_summary="$2"
fi

if [[ -z "$(git status --porcelain)" ]]; then
  local_ahead="$(ahead_count)"
  if [[ "$local_ahead" -gt 0 ]]; then
    warn "No local file changes, but ${local_ahead} commit(s) are ahead of upstream. Pushing them now."
    git push
    info "Sync Success!"
    exit 0
  fi

  warn "No changes to commit"
  exit 0
fi

confirm_commit_message "$manual_tag" "$manual_summary"
commit_message="$CONFIRMED_COMMIT_MESSAGE"
commit_and_push "$commit_message"

info "Sync Success!"
