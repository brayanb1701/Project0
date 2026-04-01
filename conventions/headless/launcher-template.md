# Headless Launcher Template

Use the shared launcher stack when adding a new harness-specific headless workflow.

## Layers

1. `scripts/p0-headless-lib.sh`
   Common helpers for `P0_HOME`, project-root detection, project-code resolution, session naming, and output paths.

2. `scripts/p0-headless-session.sh`
   Harness-neutral session wrapper. It computes session metadata, creates the centralized paths, launches a command in the background, and prints standardized JSON metadata including the PID.

3. Harness-specific launcher
   A small wrapper like `p0-launch-codex.sh` or `p0-launch-claude.sh` that:
   - accepts harness-specific flags,
   - maps them onto the shared metadata inputs,
   - constructs the actual harness command,
   - delegates the launch to `p0-headless-session.sh`.

## Standard Output Contract

Harness launchers should print the same JSON payload:

```json
{
  "session_name": "...",
  "pid": "...",
  "jsonl_path": "...",
  "stderr_path": "...",
  "pid_path": "...",
  "project_root": "...",
  "project_code": "...",
  "harness": "...",
  "model": "...",
  "effort": "...",
  "task": "...",
  "attempt": "..."
}
```

This lets skills and future tooling consume launches consistently regardless of harness.

## Design Rules

- Keep session naming and path creation in the shared library, never in the harness wrapper.
- Keep stdout as pure JSONL when the harness supports JSONL output.
- Send human-readable stderr to a sibling sidecar.
- Let project code be inferred unless the caller explicitly overrides it.
- Keep the wrapper small and focused on harness peculiarities.

## Typical Harness Inputs

- `--project-root`
- `--project-code`
- `--prompt-file`
- `--model`
- `--effort`
- `--task`
- `--attempt`

Harness-specific launchers may add more flags, but they should preserve the shared contract above.
