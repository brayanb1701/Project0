---
name: headless-codex
description: Use when asked to launch a separate headless `codex exec` session for a clearly defined task with explicit inputs and outputs. Standard runs use workspace-write access for the current project plus `P0_HOME`, always write a centralized JSONL session log under `~/.p0/sessions/...`, and should delegate internally with subagents when the task is decomposable.
---

# Headless Codex Session Launcher

Use this skill when the work should run in a separate non-interactive Codex session instead of inside the current conversation.

Typical triggers:
- The user asks to run Codex headlessly, launch another Codex session, or use `codex exec`.
- The task has clear inputs and deliverables, such as a report, generated files, or a focused implementation track.
- The task is large enough that a fresh context window or internal subagent decomposition is useful.

Do not use this skill for:
- small tasks that are faster to complete directly in the current session,
- work that depends on tight back-and-forth every few minutes,
- ambiguous tasks without a clear output path or acceptance criteria.

## Standard contract

- Standard Codex runs use workspace-write access rooted at the project plus `P0_HOME`, not unrestricted filesystem access.
- Standard Codex runs always emit a JSONL event log with `--json`.
- Standard Codex runs always save that JSONL log under `${P0_HOME:-$HOME/.p0}/sessions/{YYYY-MM-DD}/{name}.jsonl`.
- Session names must include the project code.
- Never invent the session filename or log path manually. Use `${P0_HOME:-$HOME/.p0}/conventions/headless/scripts/p0-launch-codex.sh`.
- The reference files in this skill are optional background only. Do not read them during normal use unless you are designing a more specialized headless skill later.

## Bigger-picture principle

Every scoped child task must still carry a compact understanding of the larger mission.

Before the narrow task instructions, include a short bigger-picture brief that explains:
- the overall goal,
- why this workstream exists,
- what downstream artifact or decision will consume the result,
- any hard constraints that come from the parent objective.

Keep the brief short, but do include it. A child with only local instructions often optimizes for the wrong thing.

Use `${P0_HOME:-$HOME/.p0}/conventions/headless/templates/headless-mission-context.md` as the shared prompt skeleton when helpful.

## Working method

1. Confirm the project root, prompt contents, expected outputs, task slug, model, effort, and attempt number.
2. Let the shared Codex launcher resolve the project code, session name, JSONL path, and stderr sidecar path.
3. If the prompt is large or reusable, store it in a file and pipe it through stdin with `-`.
4. Launch `codex exec` from the project root with workspace-write access plus `P0_HOME`.
5. If the task is decomposable, tell the root agent to do a quick sizing pass, then explicitly use built-in subagents.
6. If subagents are used, require each child to get a narrow scope plus a compact bigger-picture brief.
7. After launch or completion, verify that the JSONL log exists at the generated path.

## Built-in multi-agent guidance

When the delegated run should use subagents, tell the root agent so directly. Prefer the built-in roles documented by Codex:

- `explorer`: read-heavy repo exploration, architecture tracing, docs mining, evidence gathering.
- `worker`: focused execution or artifact-producing subtasks.
- `default`: fallback role or synthesis/cross-check work.

Ask the root agent to:
- size the work before decomposing,
- run independent tracks in parallel,
- avoid duplicate investigation,
- keep the main thread focused on orchestration and synthesis,
- validate returned findings before producing the final output.

## Standard launch template

```bash
project_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
p0_home="${P0_HOME:-$HOME/.p0}"
launcher="$p0_home/conventions/headless/scripts/p0-launch-codex.sh"
prompt_file="/abs/path/to/prompt.md"

P0_HOME="$p0_home" \
"$launcher" \
  --prompt-file "$prompt_file" \
  --model gpt-5.4 \
  --effort medium \
  --task code-review \
  --attempt 01 \
  --project-root "$project_root"
```

The launcher prints JSON metadata including `session_name`, `pid`, `jsonl_path`, `stderr_path`, and `project_code`.
Use `${P0_HOME:-$HOME/.p0}/conventions/headless/templates/headless-launch-response.md` when reporting the launched session back to the user.

## Prompt-shaping rules

When writing the delegated prompt:
- start with a short bigger-picture brief,
- state the exact files or sources to read first,
- state the exact output files or deliverables,
- require explicit use of built-in multi-agent delegation when the task is large enough,
- tell the root agent not to do all substantive investigation itself,
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
- The shared naming/storage convention lives in `${P0_HOME:-$HOME/.p0}/conventions/headless/session-naming.md`.
- The standard harness wrapper lives at `${P0_HOME:-$HOME/.p0}/conventions/headless/scripts/p0-launch-codex.sh`.
