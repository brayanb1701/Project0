# Project0 — Oracle Iteration 1: Session Handoff Summary

Date: 2026-04-09

## What this session did

This session did four things:

1. Synthesized your prompt and the uploaded docs into a coherent starting stance.
2. Checked a targeted set of live references to validate current assumptions.
3. Chose an initial v0 foundation strategy.
4. Produced a concrete backlog and a retained-but-deferred parking lot.

## High-confidence conclusions from this session

### 1. v0 should be a thin orchestration layer, not a deep fork of one runtime
This is the central decision.

### 2. Claude should enter through official Anthropic surfaces
That means Claude Code `-p` / Agent SDK, not third-party subscription routing.

### 3. Codex is a strong official execution backend for scripted build/review work
It already supports `codex exec`, structured output, resume, and safety modes.

### 4. Worktrees should be the default isolation unit for code-writing tasks
Not shared-folder concurrency.

### 5. The first demo should be small and internal
Project0 itself is the best first testbed.

## Link / source accessibility notes

### Successfully accessed directly
- Project0 GitHub repository
- Claude Code docs
- Codex docs
- OpenCode docs
- Symphony repository and SPEC
- Agent Skills docs
- Karpathy’s `llm-wiki` gist
- OpenAI Safety Fellowship page
- Constellation Astra Fellowship page
- Parameter Golf repository
- GitHub Copilot CLI and cloud agent docs

### Partially accessible
- Cursor docs: I could confirm the existence of Cursor CLI, headless mode, ACP, terminal sandboxing, and skills from search/index results, but the opened docs pages themselves returned no parsed line content in this environment.
- Karpathy’s original X post: I did not get a useful direct parse of the original X post itself here. I used the gist plus visible gist discussion content instead.

### Not fully audited yet in this first pass
These remain on the backlog rather than “done”:
- mcporter
- vet
- darwinian_evolver deeper implementation details
- full simonwillison pattern collection
- every lower-priority inspiration repo you listed

## Live facts validated in this session

### Claude Code
- official programmatic path exists through `claude -p` / Agent SDK
- Python and TypeScript SDKs exist
- bare mode is recommended for scripted runs
- non-interactive mode supports JSON / stream-json output
- Claude subscription usage is intended for ordinary Claude Code / native Anthropic application use
- Anthropic explicitly does not permit third-party developers to route user requests through Pro/Max credentials

### Codex
- official non-interactive execution exists through `codex exec`
- default automation mode is read-only sandbox
- broader write/access modes exist but should be used only in controlled environments
- JSONL output and resume support exist
- Codex is included in ChatGPT Plus/Pro/Business/Edu/Enterprise plans

### OpenCode
- has primary agents and subagents
- has granular per-tool and per-agent permissions
- has non-interactive `run`, headless `serve`, and `web`
- supports multiple providers and custom OpenAI-compatible providers
- previous Claude Pro/Max plugin path was removed and docs note Anthropic explicitly prohibits that usage

### Symphony
- is a strong reference for policy/runtime separation
- uses a repo-defined `WORKFLOW.md`
- emphasizes per-issue isolated workspaces
- deliberately keeps business logic in the workflow prompt, not in the scheduler core

### GitHub Copilot
- Copilot CLI supports interactive and programmatic modes
- Copilot cloud agent can research, plan, code on branches, and work in ephemeral GitHub Actions environments
- custom agents live in `.github/agents/*.agent.md`

## Source patterns to reuse

### Reuse as architecture patterns
- Symphony -> workflow/policy contract split
- adaf -> orchestration state and session logs outside target repo
- CAR -> tickets as code / control plane simplicity
- OpenCode -> permission grammar and agent config style
- pi-mono -> runtime/skill philosophy and future backend possibilities

### Reuse as execution backends
- Claude Code
- Codex
- maybe Cursor / OpenCode / Copilot later

### Do not reuse as foundation code right now
- OpenClaw
- full personal-assistant stacks
- any backend whose main value lies outside coding-orchestration v0

## Open questions to resolve next session

These are the best next questions:

1. Is Python acceptable for the thin orchestration core, or do you want to force TypeScript?
2. Which exact first demo do we build:
   - worktree manager
   - task dispatcher
   - reviewer runner
3. Do you want the third experimental backend to be Cursor or OpenCode?
4. Should Architect stay a separate role in v0, or be folded into Manager for now?
5. Do you want web research fully deferred from the first end-to-end build, or present as a separate document-only role?

## Recommended next packet from you

For the next iteration, send only:

### A. Frozen decisions
A short list of decisions you now want treated as fixed.

### B. One target artifact
For example:
- “draft the exact v0 backend contract docs”
- “design the filesystem layout in detail”
- “write the first TASKSET/TASK/REVIEW templates”
- “produce the initial Python package scaffold plan”

### C. Any disagreement with my current stance
Especially on:
- Option C vs pi
- worktrees by default
- role taxonomy
- Python vs TypeScript

## Suggested immediate next task

The single best next task is:

**Draft the five v0 contract docs**
- `DECISION_RECORD.md`
- `ROLE_TAXONOMY.md`
- `FILESYSTEM_LAYOUT.md`
- `BACKEND_CONTRACT.md`
- `WORKFLOW_CONTRACT.md`

Once those exist, building becomes much less ambiguous.

## Files created this session

- `p0_iteration1_foundation_recommendation.md`
- `p0_iteration1_backlog_and_next_steps.md`
- `p0_iteration1_parking_lot.md`
- `p0_iteration1_session_handoff.md`
