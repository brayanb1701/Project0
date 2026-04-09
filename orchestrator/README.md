# Orchestrator

Shared foundation layer for the P0 agent orchestrator.

This directory contains the **harness-agnostic** references, templates, guides, and scripts that all harness-specific skills build on top of. Think of it as the abstraction layer: everything here is general-purpose, and each individual skill adapts from this base for its particular harness (Claude Code, Codex, etc.).

## Core Design Rule: Scripts Absorb Complexity From Models

**This is the most important principle for every script in this directory and in the skills that extend it.**

Models are bad at assembling multi-step shell invocations from scratch. They hallucinate flags, forget environment variables, misconstruct paths, and produce fragile one-off commands. Every time a model has to write a command by hand, there's a chance it gets something wrong.

The solution: **scripts should do the heavy lifting so that the model only needs a simple call with a few required arguments.** Sensible defaults, auto-detection (project root, project code, session naming), and all the wiring should live inside the script, not in the model's prompt or SKILL.md launch template.

This means:
- A model launching a headless session should call one script with `--prompt-file` and `--task`. Everything else should have a working default.
- A script should auto-detect what it can (git root, P0_HOME, project code) rather than requiring the caller to resolve and pass it.
- If the model needs to customize something, it passes an optional flag. But the happy path should require the minimum.

**This rule applies to all orchestrator scripts, not just headless.** Any future subsystem added to this directory (analysis pipelines, deployment workflows, etc.) should follow the same principle: the script absorbs the complexity, the model makes a simple call.

## Directory Structure

```text
orchestrator/
├── README.md              This file
├── install.md             Documents what install.sh does and why
└── headless/              Headless session abstraction layer
    ├── README.md          Explains the headless subsystem
    ├── scripts/           Shared scripts (lib, session wrapper, naming)
    ├── templates/         Prompt and response templates
    ├── launcher-template.md   Guide for creating new harness launchers
    ├── project-codes.md       Project code conventions
    └── session-naming.md      Session naming and storage conventions
```

## Key Principle

**This folder is the base. Harness-specific code does not live here.**

Harness-specific launcher scripts (e.g., `p0-launch-claude.sh`, `p0-launch-codex.sh`) live inside each skill under `skills/general/<skill-name>/scripts/`. Those launchers import the shared library and delegate to the shared session wrapper from this directory.

## What Belongs Here

- Shared shell libraries and harness-neutral session management scripts
- Prompt templates and response templates reusable across harnesses
- Naming conventions, project code schemes, and storage layout docs
- Guides for how to create new harness integrations (launcher-template.md)

## What Does NOT Belong Here

- Harness-specific launcher scripts (those go in the skill's `scripts/` folder)
- Harness-specific CLI flag references (those go in the skill's `references/` folder)
- Anything that only applies to one particular harness

## Relationship to install.sh

The root `install.sh` copies this entire directory into `~/.p0/orchestrator/`. At runtime, harness-specific launchers find the shared scripts via `$P0_HOME/orchestrator/headless/scripts/`.

See [install.md](install.md) for full installation details.
