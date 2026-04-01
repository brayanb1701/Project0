# Project Codes

Project codes are a compact identifier embedded in every headless session name:

```text
{harness}_{model}_{effort}_{project}_{task}_{attempt}
```

## Why This Exists

The session name should immediately tell us which project a run belongs to, even when all logs are centralized under `~/.p0/sessions/`.

The code scheme is not final yet, but we should still start recording project identity now rather than waiting for the perfect taxonomy.

## Current Resolution Order

The shared scripts resolve the project code in this order:

1. Explicit `--project-code`
2. `P0_PROJECT_CODE`
3. `<project-root>/.p0/project-code`
4. Fallback inferred from the project root basename

This keeps standard launches lightweight while still allowing an authoritative project-local override.

## Current Shape

- lowercase
- alphanumeric plus hyphen normalization
- truncated to 12 characters

Examples:

- `proj0`
- `svcapi`
- `agentlab`
- `authweb`

## Project-Local Override

If a repo wants to pin its code explicitly, create:

```text
<project-root>/.p0/project-code
```

Example:

```text
svcapi
```

This file is currently the best place to stabilize a project code before a central registry exists.

## Status

This is provisional.

Likely future work:

- a shared registry
- richer semantics for project type and ownership
- automatic inference from centralized metadata instead of basename fallback
