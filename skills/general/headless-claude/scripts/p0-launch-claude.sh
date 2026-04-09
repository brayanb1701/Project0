#!/usr/bin/env bash
# Launch a standardized background Claude Code headless session.

set -euo pipefail

P0_HOME="${P0_HOME:-$HOME/.p0}"
SESSION_SCRIPT="$P0_HOME/orchestrator/headless/scripts/p0-headless-session.sh"

usage() {
  cat <<'EOF'
Usage:
  p0-launch-claude.sh --prompt-file <path> --task <slug>
                      [--project-root <path>] [--project-code <code>]
                      [--model <model>] [--effort <level>] [--attempt <n>]

Defaults:
  --model claude-sonnet-4-6
  --effort high
  --attempt 01
EOF
}

project_root=""
project_code=""
prompt_file=""
task=""
model="claude-sonnet-4-6"
effort="high"
attempt="01"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root) project_root="${2:?}"; shift 2 ;;
    --project-code) project_code="${2:?}"; shift 2 ;;
    --prompt-file) prompt_file="${2:?}"; shift 2 ;;
    --task) task="${2:?}"; shift 2 ;;
    --model) model="${2:?}"; shift 2 ;;
    --effort) effort="${2:?}"; shift 2 ;;
    --attempt) attempt="${2:?}"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 1 ;;
  esac
done

if [[ -z "$prompt_file" || -z "$task" ]]; then
  usage >&2
  exit 1
fi

if [[ -z "$project_root" ]]; then
  if git rev-parse --show-toplevel >/dev/null 2>&1; then
    project_root=$(git rev-parse --show-toplevel)
  else
    project_root=$(pwd)
  fi
fi

args=(
  --harness claude
  --model "$model"
  --effort "$effort"
  --task "$task"
  --attempt "$attempt"
  --project-root "$project_root"
)

if [[ -n "$project_code" ]]; then
  args+=(--project-code "$project_code")
fi

PROMPT_FILE="$prompt_file" \
"$SESSION_SCRIPT" \
  "${args[@]}" \
  --prompt-file "$prompt_file" \
  -- bash -lc '
    cd "$P0_PROJECT_ROOT"
    unset CLAUDECODE
    claude -p "$(cat "$P0_PROMPT_FILE")" \
      --model "$P0_MODEL" \
      --effort "$P0_EFFORT" \
      --add-dir "$P0_HOME" \
      --dangerously-skip-permissions \
      --output-format stream-json \
      --verbose \
      -n "$P0_SESSION_NAME"
  '
