#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
p0_home="${P0_HOME:-$HOME/.p0}"
backup_root="$p0_home/install-backups/$(date +%Y%m%d-%H%M%S)"

copy_dir() {
  local src="$1"
  local dst="$2"

  mkdir -p "$dst"
  cp -a "$src"/. "$dst"/
}

ensure_linked_root() {
  local target="$1"
  local link_path="$2"

  mkdir -p "$(dirname "$link_path")" "$target"

  if [[ -L "$link_path" ]]; then
    local current
    current=$(readlink "$link_path")
    if [[ "$current" == "$target" ]]; then
      return
    fi
    mkdir -p "$backup_root"
    mv "$link_path" "$backup_root/$(basename "$link_path").symlink"
  elif [[ -e "$link_path" ]]; then
    local backup_path
    backup_path="$backup_root${link_path#"$HOME"}"
    mkdir -p "$(dirname "$backup_path")"
    copy_dir "$link_path" "$target"
    mv "$link_path" "$backup_path"
  fi

  ln -sfn "$target" "$link_path"
}

mkdir -p \
  "$p0_home/skills/codex" \
  "$p0_home/skills/claude" \
  "$p0_home/orchestrator/headless" \
  "$p0_home/sessions" \
  "$p0_home/install-backups"

# Shared orchestrator layer (templates, shared scripts, guides)
copy_dir "$repo_root/orchestrator" "$p0_home/orchestrator"

# Harness-specific skills (each includes its own launcher script)
copy_dir "$repo_root/skills/general/headless-codex" "$p0_home/skills/codex/headless-codex"
copy_dir "$repo_root/skills/general/headless-claude" "$p0_home/skills/claude/headless-claude"
copy_dir "$repo_root/skills/general/knowledge-condenser" "$p0_home/skills/claude/knowledge-condenser"

chmod +x \
  "$p0_home/orchestrator/headless/scripts/p0-headless-lib.sh" \
  "$p0_home/orchestrator/headless/scripts/p0-session-name.sh" \
  "$p0_home/orchestrator/headless/scripts/p0-headless-session.sh" \
  "$p0_home/skills/codex/headless-codex/scripts/p0-launch-codex.sh" \
  "$p0_home/skills/claude/headless-claude/scripts/p0-launch-claude.sh"

# Codex official user skill root per docs: $HOME/.agents/skills
ensure_linked_root "$p0_home/skills/codex" "$HOME/.agents/skills"

# Claude official user skill root per docs: $HOME/.claude/skills
ensure_linked_root "$p0_home/skills/claude" "$HOME/.claude/skills"

cat <<EOF
Installed P0 orchestrator assets into:
  $p0_home

Directory layout:
  $p0_home/orchestrator/         Shared foundation (headless scripts, templates, guides)
  $p0_home/skills/codex/         Codex-specific skills (each with its own launcher)
  $p0_home/skills/claude/        Claude-specific skills (each with its own launcher)
  $p0_home/sessions/             Centralized session logs

Skill roots:
  Codex  -> $HOME/.agents/skills -> $p0_home/skills/codex
  Claude -> $HOME/.claude/skills -> $p0_home/skills/claude

Important notes:
- Codex repo-local .agents/skills still outrank user-level skills.
  This installer centralizes the user layer but does not invert that precedence.
- Shared headless orchestrator assets live in:
  $p0_home/orchestrator/headless
- Harness-specific launchers live inside each skill:
  $p0_home/skills/codex/headless-codex/scripts/p0-launch-codex.sh
  $p0_home/skills/claude/headless-claude/scripts/p0-launch-claude.sh
- Centralized sessions live in:
  $p0_home/sessions
- Restart Codex and Claude Code after installation so they rescan skills.
EOF
