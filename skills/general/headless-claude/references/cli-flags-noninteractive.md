# CLI Flags for Non-Interactive (`-p`) Mode

Complete reference for flags relevant to headless/programmatic Claude Code usage.

## Core Flags

| Flag | Description | Example |
|---|---|---|
| `--print`, `-p` | Run non-interactively, print response and exit | `claude -p "query"` |
| `--bare` | Skip auto-discovery of hooks, skills, plugins, MCP, auto memory, CLAUDE.md. Faster startup. Only explicit flags take effect. Recommended for scripted calls. | `claude --bare -p "query"` |
| `--verbose` | Enable verbose logging (required for `stream-json`) | `claude --verbose` |

## Model & Effort

| Flag | Description | Example |
|---|---|---|
| `--model` | Set model: alias (`sonnet`, `opus`) or full name | `claude --model claude-sonnet-4-6` |
| `--effort` | Effort level: `low`, `medium`, `high`, `max` (Opus only) | `claude --effort high` |
| `--fallback-model` | Auto-fallback when default model is overloaded (print mode only) | `claude -p --fallback-model sonnet "query"` |

## Tool & Permission Control

| Flag | Description | Example |
|---|---|---|
| `--allowedTools` | Tools that execute without permission prompts. Uses permission rule syntax. | `"Bash(git log *)" "Read"` |
| `--disallowedTools` | Tools removed from model context entirely | `"Edit" "WebFetch"` |
| `--tools` | Restrict which built-in tools are available. `""` = none, `"default"` = all | `claude --tools "Bash,Read"` |
| `--permission-mode` | Permission mode: `default`, `acceptEdits`, `plan`, `auto`, `dontAsk`, `bypassPermissions` | `claude --permission-mode plan` |
| `--dangerously-skip-permissions` | Equivalent to `--permission-mode bypassPermissions` | |
| `--permission-prompt-tool` | MCP tool to handle permission prompts non-interactively | `claude -p --permission-prompt-tool mcp_tool "query"` |

### Permission Rule Syntax (for `--allowedTools` / `--disallowedTools`)

```
Tool                          # Match all uses of a tool
Tool(specifier)               # Match specific uses
Bash(npm run *)               # Glob wildcards (space before * = word boundary)
Bash(git commit *)            # Prefix match with word boundary
Read(./.env)                  # File path match
Edit(/src/**/*.ts)            # Gitignore-style globs
WebFetch(domain:example.com)  # Domain match
mcp__server__tool             # MCP tool match
Agent(Explore)                # Subagent match
Skill(commit)                 # Skill match
Skill(deploy *)               # Skill prefix match
```

**Important**: `Bash(ls *)` (with space) enforces word boundary -- matches `ls -la` but NOT `lsof`. `Bash(ls*)` (no space) matches both. Claude Code is aware of shell operators (`&&`) so `Bash(safe-cmd *)` won't permit `safe-cmd && evil-cmd`.

## Output Control

| Flag | Description | Example |
|---|---|---|
| `--output-format` | `text` (default), `json` (structured + metadata), `stream-json` (NDJSON streaming) | `claude -p "query" --output-format json` |
| `--json-schema` | Get validated JSON output matching a schema (print mode only) | `--json-schema '{"type":"object",...}'` |
| `--include-partial-messages` | Include partial streaming events (requires `-p`, `stream-json`, `--verbose`) | |
| `--input-format` | Input format: `text`, `stream-json` | `--input-format stream-json` |

## Session Management

| Flag | Description | Example |
|---|---|---|
| `-n`, `--name` | Session display name (for `/resume` and `--resume`) | `claude -n "my-task"` |
| `-c`, `--continue` | Continue most recent conversation in current directory | `claude -c -p "follow-up"` |
| `-r`, `--resume` | Resume by session ID or name | `claude -r "auth-refactor" "query"` |
| `--session-id` | Use a specific UUID for the session | `--session-id "550e8400-..."` |
| `--fork-session` | Create new session ID when resuming (use with `--resume`/`--continue`) | `claude --resume abc --fork-session` |
| `--no-session-persistence` | Don't save session to disk (print mode only) | |

## System Prompt

| Flag | Description |
|---|---|
| `--system-prompt` | Replace entire default system prompt |
| `--system-prompt-file` | Replace with file contents |
| `--append-system-prompt` | Append to default prompt (preserves built-in capabilities) |
| `--append-system-prompt-file` | Append file contents to default prompt |

`--system-prompt` and `--system-prompt-file` are mutually exclusive. Append flags can combine with either. **For most cases, use append** -- it preserves Claude Code's built-in capabilities.

## Budget & Limits

| Flag | Description | Example |
|---|---|---|
| `--max-turns` | Limit agentic turns (print mode only). Exits with error at limit. | `claude -p --max-turns 10 "query"` |
| `--max-budget-usd` | Max dollar spend before stopping (print mode only) | `claude -p --max-budget-usd 5.00 "query"` |

## Context & Configuration

| Flag | Description | Example |
|---|---|---|
| `--add-dir` | Add working directories for file access | `claude --add-dir ../apps ../lib` |
| `--settings` | Load settings from JSON file or string | `claude --settings ./settings.json` |
| `--setting-sources` | Which setting sources to load: `user`, `project`, `local` | `claude --setting-sources user,project` |
| `--mcp-config` | Load MCP servers from JSON files (space-separated) | `claude --mcp-config ./mcp.json` |
| `--strict-mcp-config` | Only use MCP from `--mcp-config`, ignore all other MCP | |
| `--agents` | Define subagents dynamically via JSON | `--agents '{"reviewer":{"description":"...","prompt":"..."}}'` |
| `--agent` | Use a specific agent for the session | `claude --agent my-custom-agent` |
| `--disable-slash-commands` | Disable all skills and commands | |
| `--plugin-dir` | Load plugins from a directory (repeatable) | `claude --plugin-dir ./plugins` |
| `--chrome` / `--no-chrome` | Enable/disable Chrome browser integration | |

## Bare Mode Details

`--bare` skips: hooks, skills, plugins, MCP servers, auto memory, CLAUDE.md. Claude still has Bash, Read, Edit tools. Load what you need explicitly:

| To load | Use |
|---|---|
| System prompt additions | `--append-system-prompt`, `--append-system-prompt-file` |
| Settings | `--settings <file-or-json>` |
| MCP servers | `--mcp-config <file-or-json>` |
| Custom agents | `--agents <json>` |
| A plugin directory | `--plugin-dir <path>` |

**Note**: `--bare` skips OAuth/keychain reads. Auth must come from `ANTHROPIC_API_KEY` or `apiKeyHelper` in `--settings`.

## Key Environment Variables

| Variable | Purpose |
|---|---|
| `ANTHROPIC_API_KEY` | API key for authentication |
| `ANTHROPIC_MODEL` | Override default model |
| `CLAUDE_CODE_SIMPLE` | Set by `--bare`; equivalent effect |
| `SLASH_COMMAND_TOOL_CHAR_BUDGET` | Override skill description context budget |
| `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` | Load CLAUDE.md from `--add-dir` directories (set to `1`) |
