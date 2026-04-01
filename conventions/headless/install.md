# Installing The Centralized Headless Home

The shared home for centralized headless assets is:

```text
${P0_HOME:-$HOME/.p0}
```

The installer copies the curated headless assets into that home and then bridges each harness back to it through the harness’s documented user skill location.

## What Gets Installed

- `~/.p0/skills/codex/headless-codex`
- `~/.p0/skills/claude/headless-claude`
- `~/.p0/conventions/headless`
- `~/.p0/sessions`

## Why The Installer Uses Symlinks

The goal is for `~/.p0` to be the source of truth while still using the harness-native discovery paths.

### Codex

Official Codex docs say skills are loaded from:

- repo `.agents/skills`
- user `~/.agents/skills`
- admin `/etc/codex/skills`
- bundled system skills

The same docs explicitly say symlinked skill folders are supported.

Practical implication:

- `~/.p0/skills/codex` can be the centralized source of truth
- `~/.agents/skills` can point at it
- repo-local `.agents/skills` still outrank user-level skills, so `~/.p0` cannot invert that precedence by itself

### Claude Code

Official Claude Code docs say personal skills live in:

- `~/.claude/skills/<skill-name>/SKILL.md`

Practical implication:

- `~/.p0/skills/claude` can be the centralized source of truth
- `~/.claude/skills` can point at it

## What The Installer Does

1. Copies the current curated headless skills into `~/.p0/skills/<harness>/`
2. Copies the grouped conventions into `~/.p0/conventions/headless/`
3. Creates centralized session storage under `~/.p0/sessions/`
4. Repoints `~/.agents/skills` to `~/.p0/skills/codex`
5. Repoints `~/.claude/skills` to `~/.p0/skills/claude`

## Limitation

This setup centralizes maintenance and distribution, but it does not give `~/.p0` higher documented precedence than repo-local Codex skills.
