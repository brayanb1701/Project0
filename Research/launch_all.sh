#!/usr/bin/env bash
# Launch Claude Code headless analysis sessions in separate tmux sessions
# Each runs from its project folder with the prepared prompt.txt
#
# Usage:
#   ./launch_all.sh              # Launch all remaining (no report.md yet)
#   ./launch_all.sh all          # Launch all projects (skip completed)
#   ./launch_all.sh <project>    # Launch a single project
#   ./launch_all.sh --force <p>  # Re-launch even if report exists

set -euo pipefail

RESEARCH_DIR="/home/brayan/Project0/Research"

# Projects to skip (already completed or excluded)
SKIP_PROJECTS=(adaf)

# All projects in analysis order
ALL_PROJECTS=(
  codex
  claude-code
  pi-mono
  oh-my-pi
  hermes-agent
  codex-autorunner
  agent-of-empires
  symphony
  openclaw
  agent-stuff
  ypi
)

# Tools to auto-approve for analysis sessions
ALLOWED_TOOLS="Read,Write,Glob,Grep,Bash,Agent,WebFetch,WebSearch"

# Delay between launches (seconds) to avoid rate limits
LAUNCH_DELAY=3

is_skipped() {
  local project="$1"
  for skip in "${SKIP_PROJECTS[@]}"; do
    [ "$project" = "$skip" ] && return 0
  done
  return 1
}

has_report() {
  local project="$1"
  [ -f "${RESEARCH_DIR}/${project}/output/report.md" ]
}

launch_project() {
  local project="$1"
  local force="${2:-false}"
  local project_dir="${RESEARCH_DIR}/${project}"
  local prompt_file="${project_dir}/prompt.txt"
  local session_name="analysis-${project}"

  if [ ! -f "$prompt_file" ]; then
    echo "SKIP: No prompt.txt found for ${project}"
    return 1
  fi

  if is_skipped "$project"; then
    echo "SKIP: ${project} is in skip list"
    return 0
  fi

  if [ "$force" != "true" ] && has_report "$project"; then
    echo "SKIP: ${project} already has output/report.md (use --force to re-run)"
    return 0
  fi

  # Ensure output directory exists
  mkdir -p "${project_dir}/output"

  # Kill existing session if any
  tmux kill-session -t "$session_name" 2>/dev/null || true

  echo "Launching: ${session_name} in ${project_dir}"
  tmux new-session -d -s "$session_name" -c "$project_dir" \
    "unset CLAUDECODE; claude -p \"\$(cat prompt.txt)\" \
      --allowedTools '${ALLOWED_TOOLS}' \
      --output-format json \
      > output/session_output.json 2>&1; \
    echo ''; echo '=== SESSION COMPLETE ==='; \
    echo 'Press Enter to close this tmux session.'; read"
}

# --- Main ---

FORCE=false
TARGET=""

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=true ;;
    all)     TARGET="all" ;;
    *)       TARGET="$arg" ;;
  esac
done

if [ -z "$TARGET" ] || [ "$TARGET" = "all" ]; then
  count=0
  for project in "${ALL_PROJECTS[@]}"; do
    if launch_project "$project" "$FORCE"; then
      ((count++)) || true
    fi
    # Brief pause between launches
    sleep "$LAUNCH_DELAY"
  done

  echo ""
  echo "Sessions launched."
  echo ""
  echo "To list sessions:   tmux ls"
  echo "To attach:          tmux attach -t analysis-<project>"
  echo "To detach:          Ctrl+B then D"
  echo "To monitor all:     watch 'for s in \$(tmux ls -F \"#S\" 2>/dev/null | grep ^analysis-); do echo \"=== \$s ===\"; tmux capture-pane -t \$s -p | tail -3; echo; done'"
else
  launch_project "$TARGET" "$FORCE"
fi
