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
  local preview

  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    files+=("$path")
  done < <(collect_changed_files)

  if [[ ${#files[@]} -eq 0 ]]; then
    warn "No staged changes found after refresh"
    return
  fi

  info "Staged ${#files[@]} file(s)"
  preview="$(printf '%s\n' "${files[@]}" | head -n 10)"
  printf '%s\n' "$preview"

  if [[ ${#files[@]} -gt 10 ]]; then
    printf '... and %s more\n' "$(( ${#files[@]} - 10 ))"
  fi
}

ahead_count() {
  if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
    git rev-list --count '@{u}..HEAD'
  else
    printf '0'
  fi
}

commit_and_push() {
  local commit_message="$1"

  printf 'Commit message: %s\n' "$commit_message"
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

if [[ -t 1 ]] && command -v lazygit >/dev/null 2>&1 && [[ "${SYNC_SKIP_LAZYGIT:-0}" != "1" ]]; then
  info "Opening lazygit for review"
  lazygit
  info "Returned from lazygit"
fi

git add -A

if git diff --cached --quiet; then
  warn "No staged changes to commit after refresh"
  exit 0
fi

if ! git diff --cached --check; then
  error "Whitespace or merge-marker issues detected in staged changes"
  exit 1
fi

show_change_summary

commit_message="$(build_commit_message "$manual_tag" "$manual_summary")"
commit_and_push "$commit_message"

info "Sync Success!"
