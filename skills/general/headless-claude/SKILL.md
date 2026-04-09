---
name: headless-claude
description: Delegate a clearly defined task to an independent Claude Code session running headlessly via `claude -p`. Standard runs use full permissions plus access to `P0_HOME` and always write a centralized JSONL session log under `~/.p0/sessions/...`.
allowed-tools: Bash
---

# Headless Claude Code Session Launcher

Delegate a well-defined task to a separate Claude Code process running non-interactively with `claude -p`.

Use this skill when:
- the task has clear inputs and outputs,
- the work should happen in a fresh context window,
- the task is long-running or parallelizable,
- the session can run without continuous user interaction.

## Standard contract

- Standard Claude runs use full permissions with `--dangerously-skip-permissions`.
- Standard Claude runs should also add `P0_HOME` as an extra accessible directory.
- Standard Claude runs always emit a JSONL event log with `--output-format stream-json --verbose`.
- Standard Claude runs always save that JSONL log under `${P0_HOME:-$HOME/.p0}/sessions/{YYYY-MM-DD}/{name}.jsonl`.
- Session names must include the project code.
- Never invent the session filename or log path manually. Use this skill's launcher script.
- The launcher delegates to the shared orchestrator scripts at `${P0_HOME}/orchestrator/headless/scripts/`.
- The detailed reference files in this skill remain available for future specialized variants, but they are not part of the standard launch flow.

## Launching a session

The launcher script handles all the complexity: project root detection, session naming, path creation, environment setup, and the actual `claude -p` invocation. The model should call the script, not reconstruct the command manually.

**Minimal invocation** (uses defaults: model=claude-sonnet-4-6, effort=high, attempt=01, project-root=auto-detected):

```bash
"${P0_HOME:-$HOME/.p0}/skills/claude/headless-claude/scripts/p0-launch-claude.sh" \
  --prompt-file /path/to/prompt.md \
  --task analysis
```

**Full invocation** (all flags explicit):

```bash
"${P0_HOME:-$HOME/.p0}/skills/claude/headless-claude/scripts/p0-launch-claude.sh" \
  --prompt-file /path/to/prompt.md \
  --task refactor-auth \
  --model claude-opus-4-6 \
  --effort high \
  --attempt 02 \
  --project-root /path/to/project \
  --project-code myproj
```

The launcher prints JSON metadata including `session_name`, `pid`, `jsonl_path`, `stderr_path`, and `project_code`.
Use `${P0_HOME}/orchestrator/headless/templates/headless-launch-response.md` when reporting the launched session back to the user.

## Bigger-picture principle

Every scoped task must carry a compressed understanding of the larger mission.

A headless session starts without the parent conversation's context. Before the narrow task, include a short bigger-picture brief that explains:
- the larger project or initiative,
- where this task fits,
- what will consume the result,
- what constraints come from the bigger picture.

Keep this brief short and stable. It aligns the child session and also helps prompt caching when multiple related sessions share the same prefix.

Use `${P0_HOME:-$HOME/.p0}/orchestrator/headless/templates/headless-mission-context.md` as the shared prompt skeleton when helpful.

## Working method

1. Confirm the prompt contents, expected outputs, and task slug. Model, effort, and attempt have sensible defaults.
2. Write the prompt to a file if it's non-trivial (rather than inlining it).
3. Call the launcher script. It resolves everything else automatically.
4. If launching from inside a Claude Code session, the launcher already unsets `CLAUDECODE`.
5. After launch, verify the JSONL log exists at the path reported in the JSON output.

## Sub-agent guidance (experimental)

> **Status: experimental.** In practice, models sometimes abandon subagents that take too long and redo the work themselves, duplicating labor and creating noise instead of helping. Only use subagents when the task has clearly independent, well-bounded subtasks.

When the task has **clearly separable, independent tracks** where each track has its own inputs and outputs, you may instruct the Claude session to use the Agent tool. This works best when:
- tracks do not depend on each other's results,
- each track can be described in a self-contained paragraph,
- the total number of tracks is small (2-4).

If the task is sequential, has shared state, or is ambiguous about how to split, **do not use subagents** — let the session work through it linearly.

When using subagents, ask the parent session to:
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

## Monitoring and resuming

```bash
# Check if the process is still running
ps -p <PID> -o pid,etime,cmd --no-headers

# Tail assistant text from the JSONL log
tail -f <jsonl-path> | jq -r 'select(.type == "assistant") | .message.content[]? | select(.type == "text") | .text'

# Extract the session ID for resume
grep '"type":"result"' <jsonl-path> | jq -r '.session_id'
```

## Optional background references

These are for future specialized skills or more custom launch shapes. They are not part of the standard flow:

- `references/cli-flags-noninteractive.md`
- `references/settings-and-permissions.md`
- `references/skills-in-headless.md`

## Notes for this repo

- This skill assumes the shared `~/.p0` home has been installed with `install.sh`.
- Standard non-interactive Claude runs should keep session persistence enabled, since the JSONL log and resume path are both useful.
- The shared naming/storage convention lives in `${P0_HOME}/orchestrator/headless/session-naming.md`.
- The harness-specific launcher lives at `scripts/p0-launch-claude.sh` inside this skill.
- The shared orchestrator scripts live at `${P0_HOME}/orchestrator/headless/scripts/`.
