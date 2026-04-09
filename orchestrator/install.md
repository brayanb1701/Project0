# Installing The Centralized P0 Home

The shared home for all P0 orchestrator assets is:

```text
${P0_HOME:-$HOME/.p0}
```

The installer copies the orchestrator foundation and harness-specific skills into that home, then bridges each harness back to it through the harness's documented user skill location.

## What Gets Installed

```text
~/.p0/
├── orchestrator/              Shared foundation layer
│   └── headless/              Headless session abstraction (scripts, templates, guides)
├── skills/
│   ├── codex/
│   │   └── headless-codex/    Codex headless skill (includes p0-launch-codex.sh)
│   └── claude/
│       ├── headless-claude/   Claude headless skill (includes p0-launch-claude.sh)
│       └── knowledge-condenser/
├── sessions/                  Centralized JSONL session logs
└── install-backups/           Backups from previous installs
```

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

1. Creates the `~/.p0` directory structure
2. Copies the shared orchestrator layer into `~/.p0/orchestrator/`
3. Copies each harness-specific skill (including its launcher) into `~/.p0/skills/<harness>/`
4. Creates centralized session storage under `~/.p0/sessions/`
5. Repoints `~/.agents/skills` to `~/.p0/skills/codex`
6. Repoints `~/.claude/skills` to `~/.p0/skills/claude`

## Limitation

This setup centralizes maintenance and distribution, but it does not give `~/.p0` higher documented precedence than repo-local Codex skills.
