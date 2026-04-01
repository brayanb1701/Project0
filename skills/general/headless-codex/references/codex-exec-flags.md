# Codex Exec Flags

Use this reference when building or reviewing a non-interactive `codex exec` command.

## Sources

- https://developers.openai.com/codex/noninteractive
- https://developers.openai.com/codex/cli/reference
- https://developers.openai.com/codex/llms.txt
- Local cross-check: `codex --help` and `codex exec --help` on this machine

## Core non-interactive behavior

- `codex exec` is the non-interactive mode for scripted and CI-style work.
- By default, progress streams to `stderr` and the final assistant message goes to `stdout`.
- `--json` switches `stdout` to JSONL event output.
- `--output-last-message <path>` writes the final message to a file and still prints it to `stdout`.
- `--output-schema <path>` asks for a final response that conforms to a JSON Schema.
- `codex exec resume` can continue an earlier non-interactive session.

## Exec-specific flags from the official reference

- `-C`, `--cd`: set the working root.
- `--color`: `always`, `never`, or `auto`.
- `--dangerously-bypass-approvals-and-sandbox`, `--yolo`: no approvals and no sandbox. Only for externally hardened environments.
- `--ephemeral`: do not persist session rollout files to disk.
- `--full-auto`: low-friction local automation preset.
- `-i`, `--image`: attach images to the initial prompt.
- `--json`: emit JSONL events.
- `-m`, `--model`: override the configured model.
- `--oss`: use the local OSS provider.
- `-o`, `--output-last-message`: write the final assistant message to a file.
- `--output-schema`: require a schema-shaped final response.
- `-p`, `--profile`: select a config profile.
- `-s`, `--sandbox`: `read-only`, `workspace-write`, or `danger-full-access`.
- `--skip-git-repo-check`: allow running outside a Git repo.
- `-c`, `--config`: inline config override, repeatable.
- `PROMPT` or `-`: pass the prompt as an argument or read it from stdin.

Resume subcommand:
- `codex exec resume [SESSION_ID]`
- `--last`: pick the most recent session from the current working directory.
- `--all`: allow sessions from any directory.
- optional `PROMPT`: send a follow-up instruction immediately after resuming.
- `-i`, `--image`: attach images to the resumed turn.

## Global flags that still matter for headless runs

The CLI reference lists some flags globally rather than only under `codex exec`. The local CLI help on this machine also exposes them for non-interactive use. Re-check locally before depending on them in reusable scripts.

Useful ones:

- `-a`, `--ask-for-approval`: `untrusted`, `on-request`, or `never`.
- `--search`: switch web search from cached/default behavior to live.
- `--add-dir`: grant additional writable directories alongside the workspace.
- `--enable`: force-enable a feature flag.
- `--disable`: force-disable a feature flag.
- `--local-provider`: choose `lmstudio` or `ollama` when using OSS mode.

For maximum portability, place global flags before `exec`, for example:

```bash
codex -a never --enable multi_agent exec --sandbox read-only - < prompt.txt
```

## Recommended patterns

Unattended read-only analysis:

```bash
codex -a never exec \
  --sandbox read-only \
  --json \
  -o output/final.txt \
  - < prompt.txt
```

Unattended write-capable run with a reusable profile:

```bash
codex -a never exec \
  --profile write-worker \
  --sandbox workspace-write \
  - < prompt.txt
```

Structured output for downstream automation:

```bash
codex -a never exec \
  --output-schema schema.json \
  -o result.json \
  - < prompt.txt
```

## Notes

- The docs recommend `never` for non-interactive runs when you do not want approval pauses.
- If an enabled MCP server is marked `required = true` and it fails to initialize, `codex exec` exits with an error.
- The CLI reference currently documents aliases such as `--yolo` and emphasizes the `exec`-specific flags, but the installed `codex-cli 0.117.0` help is the safer final check for what this machine actually accepts.
- The doc surface and the installed CLI can drift. Before publishing a reusable command, check the local help output and prefer the flags that the installed CLI actually accepts.
