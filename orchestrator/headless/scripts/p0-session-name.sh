#!/usr/bin/env bash
# Generate standardized centralized session metadata for headless runs.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=./p0-headless-lib.sh
source "$SCRIPT_DIR/p0-headless-lib.sh"

usage() {
  cat <<'EOF'
Usage:
  p0-session-name.sh --harness <name> --model <model> --effort <level> --task <slug>
                     [--attempt <n>] [--project-root <path>] [--project-code <code>]
                     [--format json|name|jsonl|stderr|pid]
EOF
}

harness=""
model=""
effort=""
task=""
attempt="01"
project_root=""
project_code=""
format="json"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --harness) harness="${2:?}"; shift 2 ;;
    --model) model="${2:?}"; shift 2 ;;
    --effort) effort="${2:?}"; shift 2 ;;
    --task) task="${2:?}"; shift 2 ;;
    --attempt) attempt="${2:?}"; shift 2 ;;
    --project-root) project_root="${2:?}"; shift 2 ;;
    --project-code) project_code="${2:?}"; shift 2 ;;
    --format) format="${2:?}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 1 ;;
  esac
done

if [[ -z "$harness" || -z "$model" || -z "$effort" || -z "$task" ]]; then
  usage >&2
  exit 1
fi

resolved_project_root=$(p0_project_root "$project_root")
resolved_project_code=$(p0_project_code "$resolved_project_root" "$project_code")
padded_attempt=$(printf '%02d' "$attempt" 2>/dev/null || printf '%s' "$attempt")
session_name=$(p0_session_name "$harness" "$model" "$effort" "$task" "$attempt" "$resolved_project_root" "$resolved_project_code")
jsonl_path=$(p0_session_path "$harness" "$model" "$effort" "$task" "$attempt" "$resolved_project_root" "$resolved_project_code")
stderr_path=$(p0_session_stderr_path "$harness" "$model" "$effort" "$task" "$attempt" "$resolved_project_root" "$resolved_project_code")
pid_path=$(p0_session_pid_path "$harness" "$model" "$effort" "$task" "$attempt" "$resolved_project_root" "$resolved_project_code")

case "$format" in
  json)
    p0_emit_launch_json \
      "$session_name" "" "$jsonl_path" "$stderr_path" "$pid_path" \
      "$resolved_project_root" "$resolved_project_code" "$harness" "$model" "$effort" "$task" "$padded_attempt"
    ;;
  name) printf '%s\n' "$session_name" ;;
  jsonl) printf '%s\n' "$jsonl_path" ;;
  stderr) printf '%s\n' "$stderr_path" ;;
  pid) printf '%s\n' "$pid_path" ;;
  *)
    printf 'Unsupported format: %s\n' "$format" >&2
    exit 1
    ;;
esac
