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
  "$p0_home/conventions/headless" \
  "$p0_home/sessions" \
  "$p0_home/install-backups"

copy_dir "$repo_root/skills/general/headless-codex" "$p0_home/skills/codex/headless-codex"
copy_dir "$repo_root/skills/general/headless-claude" "$p0_home/skills/claude/headless-claude"
copy_dir "$repo_root/conventions/headless" "$p0_home/conventions/headless"

chmod +x \
  "$p0_home/conventions/headless/scripts/p0-headless-lib.sh" \
  "$p0_home/conventions/headless/scripts/p0-session-name.sh" \
  "$p0_home/conventions/headless/scripts/p0-headless-session.sh" \
  "$p0_home/conventions/headless/scripts/p0-launch-codex.sh" \
  "$p0_home/conventions/headless/scripts/p0-launch-claude.sh"

# Codex official user skill root per docs: $HOME/.agents/skills
ensure_linked_root "$p0_home/skills/codex" "$HOME/.agents/skills"

# Claude official user skill root per docs: $HOME/.claude/skills
ensure_linked_root "$p0_home/skills/claude" "$HOME/.claude/skills"

cat <<EOF
Installed centralized headless assets into:
  $p0_home

Skill roots:
  Codex  -> $HOME/.agents/skills -> $p0_home/skills/codex
  Claude -> $HOME/.claude/skills -> $p0_home/skills/claude

Important notes:
- Codex docs do not expose a config key to replace the user skill root. This installer uses the official user skill path with a symlink back to ~/.p0.
- Claude docs likewise use the official user scope under ~/.claude. This installer uses that path with a symlink back to ~/.p0.
- Codex repo-local .agents/skills still outrank user-level skills. This installer centralizes the user layer, but does not invert that documented precedence.
- Shared headless conventions live in:
  $p0_home/conventions/headless
- Centralized sessions live in:
  $p0_home/sessions
- Restart Codex and Claude Code after installation so they rescan skills.
EOF
