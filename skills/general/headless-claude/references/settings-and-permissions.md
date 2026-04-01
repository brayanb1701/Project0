# Settings Files & Permission Configuration

How to configure Claude Code behavior via settings files for headless session customization.

## Settings File Locations & Precedence

From highest to lowest priority:

| Scope | Location | Shared? |
|---|---|---|
| **Managed** | Server/MDM/system-level | Yes (IT deploys) |
| **CLI args** | `--allowedTools`, `--settings`, etc. | No (session only) |
| **Local** | `.claude/settings.local.json` | No (gitignored) |
| **Project** | `.claude/settings.json` | Yes (committed) |
| **User** | `~/.claude/settings.json` | No (personal) |

**Array settings merge across scopes** (concatenated + deduplicated). If denied at any level, no other level can override.

## Key Settings for Headless Personalization

```json
{
  "model": "claude-sonnet-4-6",
  "defaultMode": "acceptEdits",
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(npm run *)",
      "Read",
      "Edit(/src/**)"
    ],
    "deny": [
      "Bash(git push *)",
      "Read(./.env)",
      "Read(./.env.*)",
      "WebFetch"
    ]
  }
}
```

## All Available Settings Keys (Subset Relevant to Headless)

| Key | Description | Example |
|---|---|---|
| `model` | Default model override | `"claude-sonnet-4-6"` |
| `defaultMode` | Permission mode | `"acceptEdits"` |
| `permissions` | `{allow, deny, ask}` arrays of permission rules | See above |
| `additionalDirectories` | Extra working directories | `["../libs"]` |
| `language` | Response language | `"spanish"` |
| `outputStyle` | Adjust system prompt style | `"Explanatory"` |
| `includeGitInstructions` | Include git workflow instructions (default: true) | `false` |
| `availableModels` | Restrict model selection | `["sonnet", "haiku"]` |
| `cleanupPeriodDays` | Session retention (default: 30). `0` = no persistence | `0` |

## Permission Modes

| Mode | Behavior |
|---|---|
| `default` | Prompts for permission on first use of each tool |
| `acceptEdits` | Auto-accepts file edit permissions for session |
| `plan` | Read-only: analyze but not modify files or execute commands |
| `auto` | Auto-approves with background safety classifier |
| `dontAsk` | Auto-denies unless pre-approved via permissions.allow |
| `bypassPermissions` | Skips prompts (except .git, .claude, .vscode writes) |

**For headless**: `bypassPermissions` or tight `--allowedTools` + `dontAsk` are the two main approaches. `bypassPermissions` is simpler but less controlled. `dontAsk` with explicit `allow` rules is more secure.

## Using `--settings` for Per-Task Configuration

Create task-specific settings files and pass them at launch:

```bash
# settings-readonly.json — for analysis tasks
{
  "defaultMode": "dontAsk",
  "permissions": { "allow": ["Read", "Glob", "Grep"] }
}

# settings-codegen.json — for code generation tasks
{
  "defaultMode": "acceptEdits",
  "permissions": {
    "allow": ["Read", "Edit", "Write", "Bash(npm test *)", "Bash(npm run build *)"],
    "deny": ["Bash(git push *)", "Bash(rm *)"]
  }
}
```

Launch with: `claude -p "task" --settings ./settings-readonly.json`

## Sandbox Settings (for Hardened Headless)

```json
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["docker"],
    "filesystem": {
      "allowWrite": ["/tmp/build"],
      "denyRead": ["~/.aws/credentials"]
    },
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"]
    }
  }
}
```
