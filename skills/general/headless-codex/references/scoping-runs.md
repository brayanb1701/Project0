# Scoping Runs

Use this reference when you want a headless child run to have intentionally narrower tools, skills, network, or integration surfaces.

## Sources

- https://developers.openai.com/codex/config-reference
- https://developers.openai.com/codex/config-basic
- https://developers.openai.com/codex/config-advanced

## Main scoping levers

Use config and profiles for operational boundaries; use the prompt to explain intent.

Relevant documented keys:

- `approval_policy`
- `sandbox_mode`
- `sandbox_workspace_write.*`
- `shell_environment_policy.*`
- `skills.config`
- `apps.<id>.enabled`
- `apps.<id>.default_tools_enabled`
- `apps.<id>.tools.<tool>.enabled`
- `apps.<id>.default_tools_approval_mode`
- `apps.<id>.tools.<tool>.approval_mode`
- `mcp_servers.<id>.enabled_tools`
- `mcp_servers.<id>.disabled_tools`
- `mcp_servers.<id>.required`
- `tools.web_search`
- `web_search`
- `tools.view_image`
- `default_permissions`
- `permissions.<name>.*`

## What each lever is good for

- `approval_policy` and `sandbox_mode`: decide how much the child can do without intervention and how much filesystem/network access command execution gets.
- `shell_environment_policy.*`: pass only the environment variables the child actually needs.
- `skills.config`: disable a skill path when a run should not auto-load it.
- `apps.*`: allow, deny, or force-approval for specific connector families and individual app tools.
- `mcp_servers.*.enabled_tools` / `disabled_tools`: narrow an MCP server to the exact tools the run may use.
- `tools.web_search` and `web_search`: disable search entirely or constrain it, including allowed domains in the object form.
- `tools.view_image`: turn the local image-view tool on or off.
- `permissions.<name>.*`: define named filesystem/network permission profiles for sandboxed tool calls.

## Example patterns

Disable a specific skill:

```toml
[[skills.config]]
path = "/abs/path/to/skills/general/headless-codex"
enabled = false
```

Keep an app enabled but narrow it to one tool:

```toml
[apps.github]
default_tools_enabled = false

[apps.github.tools."repos/list"]
enabled = true
approval_mode = "prompt"
```

Limit an MCP server to read-only lookup tools:

```toml
[mcp_servers.docs]
enabled = true
enabled_tools = ["search", "fetch"]
disabled_tools = ["delete", "write"]
required = true
```

Constrain search to official documentation:

```toml
web_search = "cached"

[tools.web_search]
context_size = "low"
allowed_domains = ["developers.openai.com", "platform.openai.com"]
```

Harden the shell environment:

```toml
[shell_environment_policy]
inherit = "core"
include_only = ["PATH", "HOME"]
exclude = ["AWS_SESSION_TOKEN", "GITHUB_TOKEN"]
```

## Run-shaping strategy

- Use a profile when the scoping pattern is reused.
- Use repeated `-c` flags for one-off narrowing during a single headless run.
- Prefer positive allow-lists over broad access plus prompt warnings.
- Restate critical restrictions in the delegated prompt even when config already enforces them.
- Give the child a compact bigger-picture brief plus a narrow local scope; scoping controls reduce the blast radius, but they do not explain why the task exists.
