# Headless Session Abstraction Layer

This directory contains the shared foundation for all headless (non-interactive) session workflows. It provides the base scripts, templates, and conventions that every harness-specific headless skill builds on.

## Purpose

When you launch a headless session (Claude Code via `claude -p`, Codex via `codex exec`, or any future harness), there are common concerns that every harness shares:

- **Session naming**: A standard `{harness}_{model}_{effort}_{project}_{task}_{attempt}` format
- **Centralized storage**: All JSONL logs go to `~/.p0/sessions/{YYYY-MM-DD}/`
- **Sidecar files**: stderr and PID files alongside each session log
- **Project code resolution**: Consistent project identity across all sessions
- **Structured launch metadata**: A standard JSON payload reported after every launch

This directory solves those common concerns once, so that harness-specific launchers only need to handle their own CLI peculiarities.

## Scripts Absorb Complexity

Following the [orchestrator design rule](../README.md), every script here is designed so that **models make simple calls, not multi-step shell constructions.** The shared library auto-detects project root, resolves project codes, generates session names, and creates output paths. The harness-specific launchers (which live in each skill) wrap all of this plus the harness CLI into a single command with sensible defaults.

A model launching a headless session should only need:

```bash
"$P0_HOME/skills/<harness>/<skill>/scripts/p0-launch-<harness>.sh" \
  --prompt-file /path/to/prompt.md \
  --task my-task
```

Everything else (model, effort, attempt, project root, session naming, log paths) has a working default. Optional flags exist for when the model needs to override, but the happy path is minimal.

## Directory Structure

```text
headless/
├── README.md                          This file
├── scripts/
│   ├── p0-headless-lib.sh            Shared shell library (naming, paths, codes)
│   ├── p0-headless-session.sh        Harness-neutral session wrapper
│   └── p0-session-name.sh            Standalone session-name query tool
├── templates/
│   ├── headless-launch-response.md   Template for reporting a launched session
│   └── headless-mission-context.md   Template for bigger-picture prompt prefix
├── launcher-template.md              Guide for creating a new harness launcher
├── project-codes.md                  Project code conventions
└── session-naming.md                 Session naming and storage conventions
```

## How It Works

```text
┌─────────────────────────────────────────────────────────────┐
│  Harness-specific launcher (lives in each skill)            │
│  e.g. skills/general/headless-claude/scripts/p0-launch-claude.sh │
│       skills/general/headless-codex/scripts/p0-launch-codex.sh   │
└────────────────────────┬────────────────────────────────────┘
                         │ delegates to
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  p0-headless-session.sh (this directory)                    │
│  Resolves metadata, creates paths, launches in background   │
└────────────────────────┬────────────────────────────────────┘
                         │ sources
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  p0-headless-lib.sh (this directory)                        │
│  Naming functions, code resolution, path helpers            │
└─────────────────────────────────────────────────────────────┘
```

## Adding a New Harness

To add support for a new harness (e.g., a hypothetical `aider` or `cursor` headless mode):

1. Create a new skill: `skills/general/headless-<harness>/`
2. Add a `SKILL.md` describing when and how to use it
3. Add a `scripts/p0-launch-<harness>.sh` that:
   - Accepts harness-specific flags
   - Maps them to the shared metadata contract
   - Delegates to `$P0_HOME/orchestrator/headless/scripts/p0-headless-session.sh`
   - **Provides sensible defaults so the minimal call only needs `--prompt-file` and `--task`**
4. Follow `launcher-template.md` in this directory as the guide

The shared scripts handle session naming, path creation, and structured output. Your launcher only handles the harness-specific command construction.

## Key Documents

- **[session-naming.md](session-naming.md)**: The naming format, storage layout, and launch rules
- **[launcher-template.md](launcher-template.md)**: Step-by-step guide for building a new harness launcher
- **[project-codes.md](project-codes.md)**: How project identity is resolved and embedded in session names
