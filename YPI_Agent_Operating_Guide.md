# YPI Agent Operating Guide

This document explains how to use `ypi` as a CLI tool.

Scope:

- This is for the agent or operator that invokes `ypi`.
- This is not a guide to modifying `ypi` internals.
- Non-interactive usage is the primary workflow.
- Interactive usage is a secondary option, preferably through `tmux`.

## 1. What `ypi` Is

`ypi` is a CLI wrapper around Pi that starts Pi with a recursive system prompt and the extra runtime needed for recursive work.

As a user of the tool, the command you normally invoke is:

```bash
ypi
```

or, more commonly for automation and agent use:

```bash
ypi "your task here"
```

## 2. Primary Way To Use It

The default mental model should be:

```bash
ypi "task"
```

This is the primary workflow because it is the clearest, easiest to automate, and the best fit for agents.

Example:

```bash
ypi "Analyze this repository and summarize the architecture"
```

Use this style when:

- you want a one-shot task
- you are invoking `ypi` from another tool or script
- you want reproducible command lines
- you want to avoid mixing operator chat behavior with the actual task request

## 3. Installation

### npm

```bash
npm install -g ypi
```

### Run without installing

```bash
npx ypi "What does this repo do?"
bunx ypi "What does this repo do?"
```

### Install script

```bash
curl -fsSL https://raw.githubusercontent.com/rawwerks/ypi/master/install.sh | bash
```

### Manual checkout

```bash
git clone https://github.com/rawwerks/ypi.git
cd ypi
git submodule update --init --depth 1
export PATH="$PWD:$PATH"
```

## 4. Prerequisites

Required:

- Node.js 18+
- Pi available through the `@mariozechner/pi-coding-agent` dependency
- provider credentials configured for the model you want to use

Recommended:

- `jj` for isolated child workspaces
- `tmux` if you want long-lived interactive sessions

## 5. Basic Command Patterns

### Non-interactive one-shot

```bash
ypi "Refactor the error handling in this repo"
```

### Interactive session

```bash
ypi
```

### Provider and model override

```bash
ypi --provider anthropic --model claude-sonnet-4-5-20250929 "Map the TODO hotspots in this repo"
```

### Add extra instructions without replacing the built-in recursive prompt

```bash
ypi --append-system-prompt "Prefer concise answers and always cite file paths" "Audit the auth flow"
```

### Replace the system prompt entirely

```bash
ypi --system-prompt ./custom-prompt.md "Analyze the build pipeline"
```

Use `--system-prompt` only if you intentionally want to override `ypi`'s recursive behavior.

## 6. Recommended CLI Usage Pattern

Use this sequence by default:

1. Enter the target repository directory.
2. Invoke `ypi "task"`.
3. Pass provider or model flags only when you need an override.
4. Use environment variables for recursion guardrails.
5. Reserve interactive mode for cases where you deliberately want a persistent shell.

Good default:

```bash
cd /path/to/repo
ypi "Understand the billing subsystem and identify concrete reliability risks"
```

## 7. CLI Arguments

`ypi` passes most arguments through to Pi. In practice, you should think of the CLI surface like this:

### Common pass-through arguments

- `--provider <name>`
- `--model <name>`
- prompt as the final positional argument

Example:

```bash
ypi --provider anthropic --model claude-sonnet-4-5-20250929 "Explain the test architecture"
```

### `ypi`-specific handling

#### `--append-system-prompt <text>`

Appends additional system instructions to the recursive prompt that `ypi` builds.

```bash
ypi --append-system-prompt "Prefer plans before edits" "Review the deployment scripts"
```

#### `--system-prompt <file-or-text>`

Overrides the built-in `ypi` system prompt.

If the argument is a readable file, `ypi` uses that file's contents. Otherwise it uses the literal string.

```bash
ypi --system-prompt ./my-prompt.md "Inspect the API layer"
```

#### `--quiet` or `-q`

Suppresses the warning that appears when you override the system prompt.

```bash
ypi -q --system-prompt ./my-prompt.md "Inspect the API layer"
```

## 8. Environment Variables

These are the main runtime controls exposed by `ypi`.

### Core recursion controls

- `RLM_MAX_DEPTH`: maximum recursion depth. Default: `3`
- `RLM_MAX_CALLS`: maximum total recursive calls
- `RLM_TIMEOUT`: wall-clock limit in seconds for the whole recursive tree
- `RLM_BUDGET`: maximum spend for the whole recursive tree

Example:

```bash
export RLM_MAX_DEPTH=3
export RLM_MAX_CALLS=20
export RLM_TIMEOUT=1800
export RLM_BUDGET=1.50
ypi "Analyze the codebase and propose a minimal refactor plan"
```

### Model routing

- `RLM_PROVIDER`: provider for recursive calls
- `RLM_MODEL`: model for recursive calls
- `RLM_CHILD_PROVIDER`: provider override for child calls
- `RLM_CHILD_MODEL`: cheaper model override for child calls

Example:

```bash
export RLM_CHILD_MODEL=haiku
ypi --provider anthropic --model claude-sonnet-4-5-20250929 "Review the repo for architectural risks"
```

### Workspace and visibility

- `RLM_JJ=0`: disable `jj` workspace isolation
- `RLM_SHARED_SESSIONS=0`: disable shared session visibility

### Output and tracing

- `RLM_JSON=0`: disable JSON mode and cost tracking for recursive calls
- `PI_TRACE_FILE=/tmp/ypi-trace.log`: write trace logs to a file

### Extensions

- `RLM_EXTENSIONS=0`: disable Pi extensions
- `RLM_CHILD_EXTENSIONS=0`: disable extensions for child calls only

## 9. Non-Interactive Examples

### Repository summary

```bash
ypi "Summarize this repository in one paragraph"
```

### Targeted architectural review

```bash
ypi "Inspect the authentication and billing subsystems. Return the top 5 risks with concrete evidence."
```

### Provider/model selection

```bash
ypi --provider anthropic --model claude-sonnet-4-5-20250929 "Find the main test gaps in this repo"
```

### Use extra instructions

```bash
ypi --append-system-prompt "Return findings first, summary second" "Review the webhook handling path"
```

### Run with guardrails

```bash
RLM_MAX_DEPTH=3 RLM_MAX_CALLS=15 RLM_TIMEOUT=1200 ypi "Audit the deployment scripts and list operational risks"
```

## 10. Interactive Mode Is Secondary

You can run `ypi` with no prompt to start an interactive root session:

```bash
ypi
```

Use this only when you actually want a persistent conversation loop.

This is useful for:

- manual steering across several steps
- exploratory work where you expect to intervene repeatedly
- long-lived operator sessions

But it should not be the primary form shown in the guide. For most agent use, `ypi "task"` is the better default.

## 11. If You Use Interactive Mode, Prefer `tmux`

If you want interactive usage, run it inside `tmux`.

Example:

```bash
tmux new -s ypi
tmux send-keys -t ypi 'cd /path/to/repo && ypi' Enter
```

Why:

- the session survives terminal disconnects
- you can return to the same interactive root agent later
- it is a cleaner operator workflow for long-running sessions

For longer orchestrated runs, `Research/ypi/AGENTS.md` also documents `tmux` plus sentinel-file patterns.

## 12. What The User Of `ypi` Should Care About

As a CLI user, the important things are:

- how to invoke `ypi`
- when to use one-shot vs interactive mode
- which flags you can pass
- which environment variables control recursion behavior
- how to set provider and model
- how to run it safely with time, call, or budget limits

You do not need to understand `ypi` internals to use the tool correctly.

## 13. Minimal Cheat Sheet

### Primary

```bash
ypi "task"
```

### Interactive

```bash
ypi
```

### Provider/model override

```bash
ypi --provider anthropic --model claude-sonnet-4-5-20250929 "task"
```

### Add extra instructions

```bash
ypi --append-system-prompt "extra instruction" "task"
```

### Guardrails

```bash
RLM_MAX_DEPTH=3 RLM_MAX_CALLS=20 RLM_TIMEOUT=1800 RLM_BUDGET=1.50 ypi "task"
```

### Interactive through `tmux`

```bash
tmux new -s ypi
tmux send-keys -t ypi 'cd /path/to/repo && ypi' Enter
```
