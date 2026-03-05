# YPI Agent CLI Guide

This document teaches an agent how to use `ypi` from bash as an execution tool.

## 1) What YPI Is

`ypi` is a recursive wrapper around the Pi coding agent CLI (`pi`).

- You invoke `ypi` as the root agent process.
- `ypi` injects recursion support (`rlm_query`) into the runtime.
- Child calls are created by running `rlm_query` from bash.
- Each child is another Pi run with the same recursive setup, bounded by guardrails.

Use `ypi` when a task is too large for one context window and benefits from decomposition.

## 2) Runtime Components

When you run `ypi`, these components matter:

- `ypi`: root launcher command.
- `rlm_query`: recursive sub-agent call command.
- `rlm_cost`: cumulative cost reporting for the current recursive tree.
- `rlm_sessions`: inspect session logs for current project/trace.

Key environment variables used by ypi runtime:

- `RLM_MAX_DEPTH`: recursion depth limit.
- `RLM_MAX_CALLS`: global recursive call cap.
- `RLM_TIMEOUT`: wall clock limit for the tree.
- `RLM_BUDGET`: max spend for the tree.
- `RLM_CHILD_MODEL` / `RLM_CHILD_PROVIDER`: cheaper routing for children.
- `RLM_JJ`: workspace isolation toggle (`1` default, `0` disable).
- `RLM_SHARED_SESSIONS`: cross-session visibility toggle.
- `PI_TRACE_FILE`: optional trace log path.

## 3) How It Works

### Root invocation

`ypi` starts Pi with a system prompt specialized for recursive operation.

### Child invocation

`rlm_query "..."` spawns a child Pi process.

- Child inherits recursion context.
- Child receives bounded runtime constraints.
- If `jj` is available in a `jj` repo, child can run in isolated workspace.

### Recursion boundary

Recursion stops at `RLM_MAX_DEPTH`.

- At depth boundary, additional recursion is blocked.
- Guardrails (calls, timeout, budget) can stop execution earlier.

### Session and trace linkage

All runs in the same tree share trace/session metadata.

- Use `rlm_sessions --trace` to inspect this tree.
- Use `rlm_cost --json` to check cumulative usage.

## 4) When to Use YPI

Use ypi if one or more apply:

- Task spans many files or subsystems.
- You need parallel investigation.
- You need iterative decomposition with independent sub-results.

Do not use heavy recursion for tiny, local edits.

## 5) Invocation Patterns

### A) Interactive root session

```bash
ypi
```

### B) One-shot root task

```bash
ypi "Summarize architecture and identify risky modules"
```

### C) Provider/model override at root

```bash
ypi --provider anthropic --model claude-sonnet-4-5-20250929 "Map TODO hotspots"
```

### D) Child call from inside an active ypi run (sync)

```bash
rlm_query "Audit auth module and return top 5 risks with file:line"
```

### E) Child call with piped context

```bash
sed -n '200,340p' src/auth/service.ts | rlm_query "Find defects and propose minimal patch"
```

### F) Parallel child fan-out (async)

```bash
J1=$(rlm_query --async "Analyze src/auth for error handling bugs")
J2=$(rlm_query --async "Analyze src/billing for retry/idempotency bugs")
J3=$(rlm_query --async "Analyze src/api for input validation gaps")
```

## 6) Recommended Delegation Contract

When prompting child calls, always include:

- Objective: one bounded outcome.
- Scope: exact files/paths.
- Constraints: what not to change.
- Output format: strict shape (diff, checklist, JSON, etc).
- Validation: exact checks to run.

Example:

```bash
rlm_query "Objective: patch null handling in src/api/user.ts only. Constraints: no refactor, no rename. Output: unified diff only. Validation: npm test -- user-api"
```

## 7) Guardrail Baseline

Set before non-trivial runs:

```bash
export RLM_MAX_DEPTH=3
export RLM_MAX_CALLS=20
export RLM_TIMEOUT=1800
export RLM_BUDGET=1.50
export RLM_CHILD_MODEL="<cheaper-child-model>"
```

Optional observability:

```bash
export PI_TRACE_FILE=/tmp/ypi-trace.log
```

## 8) Operational Workflow

1. Start root task with `ypi`.
2. Size/scope with fast shell commands (`rg`, `find`, `wc`, targeted `sed`).
3. Decide direct vs delegated work.
4. Delegate independent chunks with `rlm_query --async`.
5. Validate child outputs before integration.
6. Monitor `rlm_cost --json` and `rlm_sessions --trace`.
7. Summarize integrated result and remaining risks.

## 9) Observability and Inspection

Cost:

```bash
rlm_cost
rlm_cost --json
```

Sessions:

```bash
rlm_sessions
rlm_sessions --trace
rlm_sessions read --last
rlm_sessions grep "auth"
```

## 10) Failure Handling

`rlm_query` fails with depth/calls/timeout/budget issues:

- Reduce delegation fan-out.
- Tighten scope and rerun smaller chunks.
- Increase guardrail only if necessary and justified.

`pi`/model auth failures:

- Verify provider credentials are set.
- Verify provider/model names are valid.

No `jj` isolation:

- Ensure `jj` is installed.
- Ensure current repo is a `jj` workspace.
- Or explicitly continue without isolation (`RLM_JJ=0`).

## 11) Anti-Patterns

Avoid:

- Vague child prompts with no output contract.
- Full-file ingestion when targeted extraction is enough.
- Large synchronous recursion loops when `--async` is suitable.
- Accepting child output without validation.
- Running unbounded recursion without guardrails.

## 12) Minimal Agent Checklist

Before execution:

- `ypi` available.
- provider/model authenticated.
- guardrails set for task size.

During execution:

- bounded prompts.
- explicit output formats.
- periodic cost/session checks.

Before completion:

- output validated.
- integrated result summarized.
- open risks listed.
