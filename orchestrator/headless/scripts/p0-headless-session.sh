#!/usr/bin/env bash
# Generic launcher template for headless harness sessions.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=./p0-headless-lib.sh
source "$SCRIPT_DIR/p0-headless-lib.sh"

usage() {
  cat <<'EOF'
Usage:
  p0-headless-session.sh --harness <name> --model <model> --effort <level> --task <slug>
                         --project-root <path>
                         [--attempt <n>] [--project-code <code>] [--prompt-file <path>]
                         -- [command ...]

Behavior:
  - Without a command after `--`, prints resolved metadata as JSON.
  - With a command after `--`, launches it in the background with:
      stdout -> centralized JSONL path
      stderr -> sibling stderr sidecar
      pid    -> sibling pid sidecar
    and prints structured launch metadata including the PID.
EOF
}

harness=""
model=""
effort=""
task=""
attempt="01"
project_root=""
project_code=""
prompt_file=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --harness) harness="${2:?}"; shift 2 ;;
    --model) model="${2:?}"; shift 2 ;;
    --effort) effort="${2:?}"; shift 2 ;;
    --task) task="${2:?}"; shift 2 ;;
    --attempt) attempt="${2:?}"; shift 2 ;;
    --project-root) project_root="${2:?}"; shift 2 ;;
    --project-code) project_code="${2:?}"; shift 2 ;;
    --prompt-file) prompt_file="${2:?}"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    --) shift; break ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 1 ;;
  esac
done

if [[ -z "$harness" || -z "$model" || -z "$effort" || -z "$task" ]]; then
  usage >&2
  exit 1
fi

if [[ -z "$project_root" ]]; then
  project_root=$(p0_project_root)
fi

resolved_project_root=$(p0_project_root "$project_root")
resolved_project_code=$(p0_project_code "$resolved_project_root" "$project_code")
padded_attempt=$(printf '%02d' "$attempt" 2>/dev/null || printf '%s' "$attempt")
session_name=$(p0_session_name "$harness" "$model" "$effort" "$task" "$attempt" "$resolved_project_root" "$resolved_project_code")
jsonl_path=$(p0_session_path "$harness" "$model" "$effort" "$task" "$attempt" "$resolved_project_root" "$resolved_project_code")
stderr_path=$(p0_session_stderr_path "$harness" "$model" "$effort" "$task" "$attempt" "$resolved_project_root" "$resolved_project_code")
pid_path=$(p0_session_pid_path "$harness" "$model" "$effort" "$task" "$attempt" "$resolved_project_root" "$resolved_project_code")

if [[ $# -eq 0 ]]; then
  p0_emit_launch_json \
    "$session_name" "" "$jsonl_path" "$stderr_path" "$pid_path" \
    "$resolved_project_root" "$resolved_project_code" "$harness" "$model" "$effort" "$task" "$padded_attempt"
  exit 0
fi

P0_HOME="$(p0_home)" \
P0_PROJECT_ROOT="$resolved_project_root" \
P0_PROJECT_CODE="$resolved_project_code" \
P0_HARNESS="$harness" \
P0_HARNESS_CODE="$(_p0_harness_code "$harness")" \
P0_MODEL="$model" \
P0_MODEL_CODE="$(_p0_model_code "$model")" \
P0_EFFORT="$effort" \
P0_EFFORT_CODE="$(_p0_effort_code "$effort")" \
P0_TASK="$task" \
P0_TASK_SLUG="$(p0_task_slug "$task")" \
P0_ATTEMPT="$padded_attempt" \
P0_PROMPT_FILE="$prompt_file" \
P0_SESSION_NAME="$session_name" \
P0_SESSION_JSONL="$jsonl_path" \
P0_SESSION_STDERR="$stderr_path" \
P0_SESSION_PID_FILE="$pid_path" \
"$@" >"$jsonl_path" 2>"$stderr_path" < /dev/null &

pid=$!
printf '%s\n' "$pid" > "$pid_path"

p0_emit_launch_json \
  "$session_name" "$pid" "$jsonl_path" "$stderr_path" "$pid_path" \
  "$resolved_project_root" "$resolved_project_code" "$harness" "$model" "$effort" "$task" "$padded_attempt"
