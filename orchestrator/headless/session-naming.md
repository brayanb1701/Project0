# Headless Session Storage And Naming

All standard headless runs write their canonical JSONL log to the centralized home-level store:

```text
${P0_HOME:-$HOME/.p0}/sessions/{YYYY-MM-DD}/{name}.jsonl
```

The path is intentionally outside individual project trees so sessions, the orchestrator layer, and installed skills can live under one shared `~/.p0` home.

## Home Layout

```text
${P0_HOME:-$HOME/.p0}/
├── orchestrator/headless/   Shared abstraction layer (scripts, templates, guides)
├── skills/                  Harness-specific skills (each with its own launcher)
├── sessions/                Centralized JSONL session logs
└── install-backups/
```

## Name Format

```text
{harness}_{model}_{effort}_{project}_{task}_{attempt}
```

### Segments

| Segment | Description | Examples |
| --- | --- | --- |
| `harness` | Short harness code | `cc`, `cx` |
| `model` | Short model code | `sn46`, `op46`, `g54`, `o3` |
| `effort` | Short effort code | `df`, `lo`, `md`, `hi`, `mx` |
| `project` | Project code for the owning project | `proj0`, `svc-api` |
| `task` | Short lowercase slug for the workstream | `analysis`, `code-review` |
| `attempt` | Zero-padded attempt number | `01`, `02` |

Example:

```text
cx_g54_md_proj0_code-review_01.jsonl
cc_sn46_hi_proj0_refactor-auth_02.jsonl
```

## Project Code

Project code is now part of the standard session name.

The registry for project codes is not finalized yet, so the shared scripts infer it in this order:

1. `--project-code`
2. `P0_PROJECT_CODE`
3. `<project-root>/.p0/project-code`
4. a sanitized fallback derived from the project root directory name

That lets normal launches avoid passing the project code manually while still leaving room for a future explicit registry.

## Standard Sidecars

The JSONL stream must stay clean. Keep sibling sidecars next to the JSONL log as:

- `{name}.stderr.log`
- `{name}.pid`

These sidecars are produced by the shared launcher.

## Standard Launch Rule

For a normal headless run:

1. Resolve the project root.
2. Use the harness-specific launcher from the skill, or the shared naming script under `${P0_HOME}/orchestrator/headless/scripts/`.
3. Let the script determine the session name and log path.
4. Launch the harness.
5. Keep stdout as pure JSONL and keep stderr outside the JSONL file.

Do not invent the log filename or PID file manually inside a skill.

## Shared Scripts

- `scripts/p0-headless-lib.sh`
- `scripts/p0-session-name.sh`
- `scripts/p0-headless-session.sh`

## Shared Templates

- `templates/headless-launch-response.md`
- `templates/headless-mission-context.md`

## Status

v0.2 — centralized under `~/.p0`, with project code support added to the session name.

- Project code inference is temporary until the formal registry exists.
- Sidecar conventions beyond stderr and pid remain intentionally loose.
