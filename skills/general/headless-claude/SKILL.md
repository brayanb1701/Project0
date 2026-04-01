---
name: headless-claude
description: Delegate a clearly defined task to an independent Claude Code session running headlessly via `claude -p`. Standard runs use full permissions plus access to `P0_HOME`, always write a centralized JSONL session log under `~/.p0/sessions/...`, and should use internal sub-agents when the task is decomposable.
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
- Never invent the session filename or log path manually. Use `${P0_HOME:-$HOME/.p0}/conventions/headless/scripts/p0-launch-claude.sh`.
- The detailed reference files in this skill remain available for future specialized variants, but they are not part of the standard launch flow.

## Bigger-picture principle

Every scoped task must carry a compressed understanding of the larger mission.

A headless session starts without the parent conversation's context. Before the narrow task, include a short bigger-picture brief that explains:
- the larger project or initiative,
- where this task fits,
- what will consume the result,
- what constraints come from the bigger picture.

Keep this brief short and stable. It aligns the child session and also helps prompt caching when multiple related sessions share the same prefix.

Use `${P0_HOME:-$HOME/.p0}/conventions/headless/templates/headless-mission-context.md` as the shared prompt skeleton when helpful.

## Working method

1. Confirm the project root, prompt contents, expected outputs, task slug, model, effort, and attempt number.
2. Let the shared Claude launcher resolve the project code, session name, JSONL path, and stderr sidecar path.
3. If launching from inside a Claude Code session, unset `CLAUDECODE` before starting the child.
4. If the prompt is large or reusable, store it in a file instead of inlining it.
5. Launch `claude -p` from the project root with full permissions and centralized logging.
6. If the task is decomposable, explicitly instruct the session to use sub-agents and give each child a narrow scope plus a compact bigger-picture brief.
7. After launch or completion, verify that the JSONL log exists at the generated path.

## Sub-agent guidance

When the task has multiple independent tracks, tell the Claude session to use the Agent tool rather than doing everything in the main thread.

Ask the parent session to:
- size the work first,
- split independent tracks,
- run them in parallel when helpful,
- synthesize and validate returned results,
- keep the main thread focused on orchestration.

## Standard launch template

```bash
project_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
p0_home="${P0_HOME:-$HOME/.p0}"
launcher="$p0_home/conventions/headless/scripts/p0-launch-claude.sh"
prompt_file="/abs/path/to/prompt.md"

P0_HOME="$p0_home" \
"$launcher" \
  --prompt-file "$prompt_file" \
  --model claude-sonnet-4-6 \
  --effort high \
  --task analysis \
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
- require evidence-backed findings,
- require separation of confirmed facts from inferences,
- require an explicit final recommendation or decision output,
- require sub-agent usage when the task naturally decomposes.

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
- The shared naming/storage convention lives in `${P0_HOME:-$HOME/.p0}/conventions/headless/session-naming.md`.
- The standard harness wrapper lives at `${P0_HOME:-$HOME/.p0}/conventions/headless/scripts/p0-launch-claude.sh`.
