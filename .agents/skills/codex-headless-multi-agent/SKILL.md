---
name: codex-headless-multi-agent
description: Use when asked to launch a separate headless `codex exec` session for a clearly defined task with explicit inputs and outputs, especially when the task should be decomposed with Codex's built-in multi-agent subagents.
---

# Codex Headless Multi-Agent

Use this skill when the job should run in a separate non-interactive Codex session instead of inside the current conversation.

Typical triggers:
- The user asks to "run Codex headless", "launch another Codex session", "use codex exec", or "analyze this in a separate Codex run".
- The task has clear inputs and deliverables, such as a report, generated files, a focused review, or a structured artifact.
- The task is large enough that parallel read-heavy investigation or narrow delegated tracks will reduce context pollution in the main thread.

Do not use this skill for:
- Small tasks that are faster to complete directly in the current session.
- Work that depends on tight back-and-forth interaction every few minutes.
- Ambiguous tasks without a clear output path, working directory, or acceptance criteria.

## Defaults

- Default to `--model gpt-5.4`.
- If the user explicitly asks for a different model, override that default in the command.
- Set reasoning explicitly with `-c model_reasoning_effort=\"medium\"` unless the task clearly needs higher or lower effort.
- Use `codex exec` for headless runs.
- Use `--full-auto` only when the delegated session must write files or run project commands.
- Prefer `--sandbox workspace-write` / `--full-auto` over dangerous bypass flags.
- Use `--enable multi_agent` for tasks that benefit from built-in subagents or when you want the run to be portable across machines/configs.

## Working method

1. Confirm the target working directory, the required inputs, and the exact output files or artifacts the run must produce.
2. If the prompt is large, store it in a file and pass it through stdin with `codex exec -`.
3. For read-only analysis, default to a read-only sandbox.
4. For artifact-producing analysis or code changes, use `--full-auto` so the child session can write outputs inside the workspace.
5. If the task is parallelizable, instruct the root Codex agent to:
   - size the work first,
   - explicitly spawn sub-agents,
   - keep the parent focused on orchestration and synthesis,
   - use narrow scopes per sub-agent,
   - validate returned findings before producing the final output.
6. After the run finishes, inspect whether the required files were actually written. If not, either resume the same session or rerun with a tighter prompt.

## Built-in multi-agent guidance

When the delegated Codex run should use subagents, tell it so directly. Prefer the built-in roles documented by Codex:

- `explorer`: read-heavy repo exploration, architecture tracing, docs mining, evidence gathering.
- `worker`: focused execution or artifact-producing subtasks.
- `default`: fallback role or synthesis/cross-check work.
- `monitor`: long waits or repeated polling, if the environment/config exposes it.

Ask the root agent to:
- decompose only after a quick sizing pass,
- run independent tracks in parallel,
- avoid duplicate investigations,
- keep the main thread free of noisy intermediate output,
- return summaries with evidence, not raw logs.

Good sub-agent uses:
- source/docs investigation split by theme,
- one agent per major subsystem,
- one agent per review dimension,
- one agent per repeated work item via CSV fan-out when appropriate.

Be cautious with many concurrent write-heavy agents. Prefer parallel exploration and synthesis over parallel edits unless the write scopes are clearly disjoint.

## Command templates

Read-only analysis:

```bash
codex exec \
  --enable multi_agent \
  --model gpt-5.4 \
  -c model_reasoning_effort="medium" \
  --sandbox read-only \
  -C /abs/path/to/project \
  - < prompt.txt
```

Artifact-producing analysis:

```bash
codex exec \
  --enable multi_agent \
  --model gpt-5.4 \
  -c model_reasoning_effort="medium" \
  --full-auto \
  -C /abs/path/to/project \
  - < prompt.txt
```

Machine-readable trace capture:

```bash
codex exec \
  --enable multi_agent \
  --model gpt-5.4 \
  -c model_reasoning_effort="medium" \
  --full-auto \
  --json \
  -C /abs/path/to/project \
  - < prompt.txt > output/session_artifacts/exec-events.jsonl
```

## Prompt-shaping rules

When writing the delegated prompt:
- State the exact files to read first.
- State the exact output files to produce.
- Require explicit use of built-in multi-agent delegation when the task is large enough.
- Tell the root agent not to do all substantive investigation itself.
- Require evidence-backed findings.
- Require separation of confirmed facts from inferences.
- Require an explicit final recommendation or decision output.

For repeated project analyses, make the prompt include:
- reference files,
- target project metadata,
- category,
- project-specific focus questions,
- special deliverables,
- output locations,
- acceptance criteria.

## Notes for this repo

- The installed CLI on this machine is `codex-cli 0.110.0`.
- `multi_agent` is already enabled globally here, but still pass `--enable multi_agent` in reusable commands when you want portability and explicitness.
- `codex exec` supports `--model`, `--full-auto`, `--sandbox`, `--json`, `--output-schema`, `--output-last-message`, `--ephemeral`, and config overrides via `-c`.
- The default headless model for this repo is `gpt-5.4`.
- `codex exec` does not expose a dedicated reasoning flag, so set reasoning through config override: `-c model_reasoning_effort=\"medium\"`.
- Although some Codex docs discuss live web search, this installed `codex exec` build does not accept a `--search` flag, so do not rely on that flag in headless commands here.
