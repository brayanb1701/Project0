#!/usr/bin/env bash
# Shared helpers for centralized headless launch conventions.

set -euo pipefail

p0_home() {
  printf '%s\n' "${P0_HOME:-$HOME/.p0}"
}

p0_project_root() {
  if [[ $# -gt 0 && -n "${1:-}" ]]; then
    printf '%s\n' "$1"
    return
  fi

  if [[ -n "${P0_PROJECT_ROOT:-}" ]]; then
    printf '%s\n' "$P0_PROJECT_ROOT"
    return
  fi

  if git rev-parse --show-toplevel >/dev/null 2>&1; then
    git rev-parse --show-toplevel
    return
  fi

  pwd
}

_p0_slug() {
  local raw="${1:-value}"
  local max_len="${2:-20}"
  local slug

  slug=$(printf '%s' "$raw" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-{2,}/-/g')

  if [[ -z "$slug" ]]; then
    slug="value"
  fi

  if [[ "${#slug}" -gt "$max_len" ]]; then
    slug="${slug:0:max_len}"
    slug="${slug%-}"
  fi

  printf '%s\n' "$slug"
}

_p0_harness_code() {
  case "${1,,}" in
    cc|claude|claude-code) printf 'cc\n' ;;
    cx|codex) printf 'cx\n' ;;
    *) printf '%s\n' "$(_p0_slug "${1,,}" 4)" ;;
  esac
}

_p0_model_code() {
  case "${1,,}" in
    opus|claude-opus-4-6|op46) printf 'op46\n' ;;
    sonnet|claude-sonnet-4-6|sn46) printf 'sn46\n' ;;
    haiku|claude-haiku-4-5|hk45) printf 'hk45\n' ;;
    gpt-5.4|gpt54|g54) printf 'g54\n' ;;
    o3) printf 'o3\n' ;;
    *)
      local raw="${1,,}"
      raw="${raw//./}"
      raw="${raw//-/}"
      if [[ "${#raw}" -gt 4 ]]; then
        raw="${raw: -4}"
      fi
      printf '%s\n' "$raw"
      ;;
  esac
}

_p0_effort_code() {
  case "${1,,}" in
    default|df) printf 'df\n' ;;
    low|lo) printf 'lo\n' ;;
    medium|md) printf 'md\n' ;;
    high|hi) printf 'hi\n' ;;
    max|mx) printf 'mx\n' ;;
    *) printf 'df\n' ;;
  esac
}

p0_project_code() {
  local project_root="${1:-$(p0_project_root)}"
  local explicit="${2:-}"

  if [[ -n "$explicit" ]]; then
    _p0_slug "$explicit" 12
    return
  fi

  if [[ -n "${P0_PROJECT_CODE:-}" ]]; then
    _p0_slug "$P0_PROJECT_CODE" 12
    return
  fi

  if [[ -f "$project_root/.p0/project-code" ]]; then
    local from_file
    from_file=$(tr -d '[:space:]' < "$project_root/.p0/project-code")
    if [[ -n "$from_file" ]]; then
      _p0_slug "$from_file" 12
      return
    fi
  fi

  _p0_slug "$(basename "$project_root")" 12
}

p0_project_code_file() {
  local project_root="${1:-$(p0_project_root)}"
  printf '%s\n' "$project_root/.p0/project-code"
}

p0_session_date() {
  date +%Y-%m-%d
}

p0_task_slug() {
  _p0_slug "${1:-task}" 20
}

p0_session_name() {
  local harness="${1:?Usage: p0_session_name <harness> <model> <effort> <task> [attempt] [project_root] [project_code]}"
  local model="${2:?}"
  local effort="${3:?}"
  local task="${4:?}"
  local attempt_raw="${5:-01}"
  local project_root="${6:-$(p0_project_root)}"
  local project_code="${7:-$(p0_project_code "$project_root")}"

  local attempt
  attempt=$(printf '%02d' "$attempt_raw" 2>/dev/null || printf '%s' "$attempt_raw")

  printf '%s_%s_%s_%s_%s_%s\n' \
    "$(_p0_harness_code "$harness")" \
    "$(_p0_model_code "$model")" \
    "$(_p0_effort_code "$effort")" \
    "$(_p0_slug "$project_code" 12)" \
    "$(p0_task_slug "$task")" \
    "$attempt"
}

p0_session_dir() {
  local dir
  dir="$(p0_home)/sessions/$(p0_session_date)"
  mkdir -p "$dir"
  printf '%s\n' "$dir"
}

p0_session_relpath() {
  local name
  name=$(p0_session_name "$@")
  printf '.p0/sessions/%s/%s.jsonl\n' "$(p0_session_date)" "$name"
}

p0_session_path() {
  local name
  name=$(p0_session_name "$@")
  printf '%s/%s.jsonl\n' "$(p0_session_dir)" "$name"
}

p0_session_stderr_path() {
  local jsonl_path
  jsonl_path=$(p0_session_path "$@")
  printf '%s\n' "${jsonl_path%.jsonl}.stderr.log"
}

p0_session_pid_path() {
  local jsonl_path
  jsonl_path=$(p0_session_path "$@")
  printf '%s\n' "${jsonl_path%.jsonl}.pid"
}

p0_emit_launch_json() {
  python3 - "$@" <<'PY'
import json
import sys

keys = [
    "session_name",
    "pid",
    "jsonl_path",
    "stderr_path",
    "pid_path",
    "project_root",
    "project_code",
    "harness",
    "model",
    "effort",
    "task",
    "attempt",
]

values = sys.argv[1:]
payload = dict(zip(keys, values))
print(json.dumps(payload, sort_keys=True))
PY
}
