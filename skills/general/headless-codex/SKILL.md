---
name: headless-codex
description: Use when asked to launch a separate headless `codex exec` session for a clearly defined task with explicit inputs and outputs. Standard runs use workspace-write access for the current project plus `P0_HOME` and always write a centralized JSONL session log under `~/.p0/sessions/...`.
---

# Headless Codex Session Launcher

Use this skill when the work should run in a separate non-interactive Codex session instead of inside the current conversation.

Typical triggers:
- The user asks to run Codex headlessly, launch another Codex session, or use `codex exec`.
- The task has clear inputs and deliverables, such as a report, generated files, or a focused implementation track.
- The task is large enough that a fresh context window is useful.

Do not use this skill for:
- small tasks that are faster to complete directly in the current session,
- work that depends on tight back-and-forth every few minutes,
- ambiguous tasks without a clear output path or acceptance criteria.

## Standard contract

- Standard Codex runs use workspace-write access rooted at the project plus `P0_HOME`, not unrestricted filesystem access.
- Standard Codex runs always emit a JSONL event log with `--json`.
- Standard Codex runs always save that JSONL log under `${P0_HOME:-$HOME/.p0}/sessions/{YYYY-MM-DD}/{name}.jsonl`.
- Session names must include the project code.
- Never invent the session filename or log path manually. Use this skill's launcher script.
- The launcher delegates to the shared orchestrator scripts at `${P0_HOME}/orchestrator/headless/scripts/`.
- The reference files in this skill are optional background only. Do not read them during normal use unless you are designing a more specialized headless skill later.

## Launching a session

The launcher script handles all the complexity: project root detection, session naming, path creation, environment setup, and the actual `codex exec` invocation. The model should call the script, not reconstruct the command manually.

**Minimal invocation** (uses defaults: model=gpt-5.4, effort=medium, attempt=01, project-root=auto-detected):

```bash
"${P0_HOME:-$HOME/.p0}/skills/codex/headless-codex/scripts/p0-launch-codex.sh" \
  --prompt-file /path/to/prompt.md \
  --task code-review
```

**Full invocation** (all flags explicit):

```bash
"${P0_HOME:-$HOME/.p0}/skills/codex/headless-codex/scripts/p0-launch-codex.sh" \
  --prompt-file /path/to/prompt.md \
  --task refactor-auth \
  --model gpt-5.4 \
  --effort high \
  --attempt 02 \
  --project-root /path/to/project \
  --project-code myproj
```

The launcher prints JSON metadata including `session_name`, `pid`, `jsonl_path`, `stderr_path`, and `project_code`.
Use `${P0_HOME}/orchestrator/headless/templates/headless-launch-response.md` when reporting the launched session back to the user.

## Bigger-picture principle

Every scoped child task must still carry a compact understanding of the larger mission.

Before the narrow task instructions, include a short bigger-picture brief that explains:
- the overall goal,
- why this workstream exists,
- what downstream artifact or decision will consume the result,
- any hard constraints that come from the parent objective.

Keep the brief short, but do include it. A child with only local instructions often optimizes for the wrong thing.

Use `${P0_HOME:-$HOME/.p0}/orchestrator/headless/templates/headless-mission-context.md` as the shared prompt skeleton when helpful.

## Working method

1. Confirm the prompt contents, expected outputs, and task slug. Model, effort, and attempt have sensible defaults.
2. Write the prompt to a file if it's non-trivial (rather than inlining it).
3. Call the launcher script. It resolves everything else automatically.
4. After launch, verify the JSONL log exists at the path reported in the JSON output.

## Sub-agent guidance (experimental)

> **Status: experimental.** In practice, models sometimes abandon subagents that take too long and redo the work themselves, duplicating labor and creating noise instead of helping. Only use subagents when the task has clearly independent, well-bounded subtasks.

When the task has **clearly separable, independent tracks** where each track has its own inputs and outputs, you may instruct the Codex session to use built-in multi-agent delegation. This works best when:
- tracks do not depend on each other's results,
- each track can be described in a self-contained paragraph,
- the total number of tracks is small (2-4).

If the task is sequential, has shared state, or is ambiguous about how to split, **do not use subagents** — let the session work through it linearly.

Codex built-in roles:
- `explorer`: read-heavy repo exploration, architecture tracing, docs mining, evidence gathering.
- `worker`: focused execution or artifact-producing subtasks.
- `default`: fallback role or synthesis/cross-check work.

When using subagents, ask the root agent to:
- size the work first and confirm the split is clean,
- give each child a narrow scope plus a compact bigger-picture brief,
- wait for all children to complete before synthesizing,
- validate returned results before producing final output.

## Prompt-shaping rules

When writing the delegated prompt:
- start with a short bigger-picture brief,
- state the exact files or sources to read first,
- state the exact output files or deliverables,
- require evidence-backed findings,
- require separation of confirmed facts from inferences,
- require an explicit final recommendation or decision output.

## Optional background references

These are for future specialized skills or more custom launch shapes. They are not part of the standard flow:

- `references/config-and-profiles.md`
- `references/scoping-runs.md`
- `references/codex-exec-flags.md`

## Notes for this repo

- This skill assumes the shared `~/.p0` home has been installed with `install.sh`.
- At update time, the local CLI was `codex-cli 0.117.0`.
- `codex exec --help` on this machine supports `--sandbox`, `--add-dir`, `--json`, `--output-schema`, `--output-last-message`, `--ephemeral`, and `resume`.
- The shared naming/storage convention lives in `${P0_HOME}/orchestrator/headless/session-naming.md`.
- The harness-specific launcher lives at `scripts/p0-launch-codex.sh` inside this skill.
- The shared orchestrator scripts live at `${P0_HOME}/orchestrator/headless/scripts/`.
