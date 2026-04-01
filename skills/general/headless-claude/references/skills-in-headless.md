# Skills Configuration in Headless Sessions

How skills interact with headless (`-p`) mode and how to control them.

## Key Facts

- **User-invoked skills (`/commit`, `/deploy`) are NOT available in `-p` mode.** Only interactive sessions can type `/skill-name`.
- **Claude CAN still auto-invoke skills** in `-p` mode if the skill's description matches the task and `disable-model-invocation` is not set.
- Use `--disable-slash-commands` to disable all skills and commands entirely.
- Use `--bare` to skip skill discovery altogether (fastest startup).

## Controlling Skill Access in Headless

### Disable all skills
```bash
claude -p "query" --disable-slash-commands
# or
claude --bare -p "query"  # also skips skills
```

### Allow/deny specific skills via permissions
```json
{
  "permissions": {
    "allow": ["Skill(commit)", "Skill(review-pr *)"],
    "deny": ["Skill(deploy *)"]
  }
}
```

Or via CLI: `--allowedTools "Skill(knowledge-condenser)" --disallowedTools "Skill(deploy *)"`

### Preload skills into headless sessions
Skills from `~/.claude/skills/` and `.claude/skills/` are auto-discovered unless `--bare` is used. To load skills from another directory:
```bash
claude -p "task" --add-dir /path/to/skills-repo
```

## SKILL.md Frontmatter Reference

| Field | Description |
|---|---|
| `name` | Display name / slash command. Lowercase, hyphens, max 64 chars. |
| `description` | What the skill does. Claude uses this for auto-invocation. Truncated at 250 chars in listings. |
| `allowed-tools` | Tools auto-approved when skill is active |
| `model` | Model override when skill is active |
| `effort` | Effort level override: `low`, `medium`, `high`, `max` |
| `context` | Set to `fork` to run in isolated subagent |
| `agent` | Subagent type when `context: fork` (`Explore`, `Plan`, `general-purpose`, or custom agent name) |
| `disable-model-invocation` | `true` = only user can invoke (not Claude) |
| `user-invocable` | `false` = hidden from `/` menu (only Claude can invoke) |
| `argument-hint` | Autocomplete hint, e.g. `[issue-number]` |
| `paths` | Glob patterns limiting when skill auto-activates |
| `hooks` | Lifecycle hooks scoped to this skill |
| `shell` | `bash` (default) or `powershell` |

## String Substitutions in Skills

| Variable | Description |
|---|---|
| `$ARGUMENTS` | All arguments passed to the skill |
| `$ARGUMENTS[N]` or `$N` | Nth argument (0-based) |
| `${CLAUDE_SESSION_ID}` | Current session ID |
| `${CLAUDE_SKILL_DIR}` | Directory containing the skill's SKILL.md |

## Dynamic Context Injection

`` !`command` `` syntax runs shell commands before skill content is sent to Claude:

```yaml
---
name: pr-summary
context: fork
agent: Explore
---
PR diff: !`gh pr diff`
Changed files: !`gh pr diff --name-only`
Summarize this pull request.
```

The command output replaces the placeholder — Claude sees the result, not the command.
