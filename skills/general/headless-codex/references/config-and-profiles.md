# Config And Profiles

Use this reference when you need to shape a headless `codex exec` run with config files, profiles, or one-off overrides.

## Sources

- https://developers.openai.com/codex/config-basic
- https://developers.openai.com/codex/config-advanced
- https://developers.openai.com/codex/config-reference

## Config locations and precedence

- User config lives at `~/.codex/config.toml`. The docs also describe local state under `CODEX_HOME`, which defaults to `~/.codex`.
- Project overrides live in `.codex/config.toml` inside the repo.
- System config can exist at `/etc/codex/config.toml` on Unix.
- Project-scoped config is loaded only for trusted projects.
- When multiple project `.codex/config.toml` files exist between the repo root and the current working directory, the closest one wins for conflicting keys.

Official precedence order, highest first:
1. CLI flags and `--config` overrides
2. Profile values loaded by `--profile <name>`
3. Project config layers from repo root down to the current working directory
4. User config
5. System config
6. Built-in defaults

## Profiles

- Profiles are defined as `[profiles.<name>]` in `config.toml`.
- The docs mark profiles as experimental.
- Profiles are currently CLI-only; the docs say they are not supported in the IDE extension.
- Set `profile = "<name>"` at the top level to make one the default startup profile.
- `profiles.<name>.*` can hold profile-scoped overrides for supported config keys.

Useful documented profile-scoped keys include:
- `model`
- `approval_policy`
- `sandbox_mode`
- `model_reasoning_effort`
- `web_search`
- `personality`
- `model_catalog_json`
- `model_instructions_file`
- `oss_provider`
- `tools_view_image`

## `-c` / `--config` overrides

- Prefer dedicated flags like `--model` or `--profile` when they exist.
- Use repeated `-c key=value` overrides for arbitrary or nested keys.
- Dotted keys are supported, for example `mcp_servers.context7.enabled=false`.
- Reach for `-c` mainly for scalar or small nested overrides. If you need to reshape arrays or many settings at once, prefer a profile or checked-in `.codex/config.toml`.

Official docs conflict slightly here:
- `config-advanced` says `--config` values are parsed as TOML.
- `cli/reference` still says values parse as JSON if possible.
- Local `codex exec --help` on this machine also says TOML and shows dotted-path examples.

Treat TOML-style values as the safer current expectation and verify locally when syntax is critical.

## Headless-friendly examples

Choose a reusable profile for a repeatable run shape:

```toml
[profiles.deep-review]
model = "gpt-5.4"
model_reasoning_effort = "high"
approval_policy = "never"
sandbox_mode = "read-only"
web_search = "cached"
```

Use one-off CLI overrides for narrow deltas:

```bash
codex -a never exec \
  -p deep-review \
  -c 'shell_environment_policy.include_only=["PATH","HOME"]' \
  -c 'mcp_servers.context7.enabled=false' \
  - < prompt.txt
```

Use a project-scoped config when a repo always needs the same local behavior:

```toml
# .codex/config.toml
model = "gpt-5.4"
approval_policy = "never"
sandbox_mode = "workspace-write"
model_instructions_file = "headless-instructions.md"
```

## Practical guidance

- Put stable policy bundles in profiles.
- Put repo defaults in `.codex/config.toml` only when they should apply broadly to work in that tree.
- Keep one-off child-run changes in CLI flags so the command itself shows the deviation.
- Favor config and profile shaping over prompt-only operational instructions when you care about repeatability and prompt caching.
- When paths matter, remember that relative paths in project config are resolved relative to the `.codex/` directory that contains that `config.toml`.
