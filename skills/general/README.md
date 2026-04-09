# General Skills

Skills in this directory are designed to work across multiple harnesses or are general-purpose enough to be useful in any context.

## Directory Structure

```text
skills/general/
├── README.md               This file
├── headless-claude/        Headless Claude Code session launcher
│   ├── SKILL.md            Skill definition and usage guide
│   ├── scripts/            Harness-specific launcher (p0-launch-claude.sh)
│   └── references/         Claude Code CLI and settings references
├── headless-codex/         Headless Codex session launcher
│   ├── SKILL.md            Skill definition and usage guide
│   ├── scripts/            Harness-specific launcher (p0-launch-codex.sh)
│   └── references/         Codex CLI and config references
└── knowledge-condenser/    Knowledge condensation and synthesis skill
    ├── SKILL.md
    └── references/
```

## Headless Skills Pattern

Each headless skill follows the same architecture:

1. **SKILL.md** at the root defines when to trigger, the standard contract, and the launch examples
2. **scripts/** contains the harness-specific launcher that knows how to invoke that particular CLI
3. **references/** contains optional deep-dive docs about the harness's flags, config, and behavior

The harness-specific launchers in `scripts/` delegate to the shared orchestrator layer at `orchestrator/headless/scripts/` for session naming, path creation, and metadata output. This separation means:

- **Shared logic** (naming, storage, sidecars) is maintained once in `orchestrator/headless/`
- **Harness specifics** (CLI flags, sandbox modes, output formats) are maintained in each skill

### Scripts absorb complexity

Following the [orchestrator design rule](../../orchestrator/README.md), launcher scripts are designed so that the model only needs a minimal call:

```bash
"$P0_HOME/skills/<harness>/<skill>/scripts/p0-launch-<harness>.sh" \
  --prompt-file /path/to/prompt.md \
  --task my-task
```

All other parameters (model, effort, attempt, project root, session naming) have sensible defaults. The model should call the script as-is — not disassemble and rebuild the command manually.

### Sub-agents are experimental

Sub-agent / multi-agent delegation inside headless sessions is marked **experimental**. In practice, models sometimes don't wait for subagents to finish and redo the work themselves, duplicating labor and creating noise. Sub-agents should only be used when the task has clearly independent, well-bounded subtasks that don't depend on each other. See each skill's SKILL.md for details.

## Adding a New Headless Skill

1. Create `skills/general/headless-<harness>/`
2. Write a `SKILL.md` following the pattern of the existing headless skills
3. Add `scripts/p0-launch-<harness>.sh` following `orchestrator/headless/launcher-template.md`
4. Ensure the launcher has sensible defaults so the minimal call only needs `--prompt-file` and `--task`
5. Add any harness-specific reference docs under `references/`
6. Update `install.sh` to copy the new skill into `~/.p0/skills/<target>/`
