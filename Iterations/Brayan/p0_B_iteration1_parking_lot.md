# Project0 — Oracle Iteration 1: Parking Lot (Retained, Deferred, Not Rejected)

Date: 2026-04-09
Status: preserve these ideas without letting them block v0

## Why this file exists

You have many good ideas.
The problem is not idea quality.
The problem is letting near-term execution be controlled by long-horizon possibility.

Everything below stays in play.
Nothing below should block the first working coding-orchestration loop.

## A. Personal assistant / OpenClaw-like horizon

Retained:
- multi-channel messaging
- images and arbitrary input
- 24/7 persistent operation
- reminders/escalations for pending user decisions
- proactive topic recommendation
- OCR pipeline for handwritten notes
- encrypted / special-access information mode
- community-of-agents direction
- personality / identity experiments
- agent email / social layer

Deferred because:
- these are product/platform features, not required to validate the coding-orchestration core

## B. Knowledge base / LLM wiki horizon

Retained:
- Karpathy-style raw/wiki/schema layering
- Obsidian integration
- ingest/query/lint workflow
- synthesized knowledge as a compounding artifact
- wiki as operational substrate for agents
- domain-separated vaults
- archival of analyses, plans, and session history
- structured frontmatter, links, tags, staleness metadata
- query answers written back into the wiki

Important extra insights to retain:
- deterministic retrieval / pointer patterns can outperform freeform generation in some domains
- confidence-tagged claims are useful
- link resolution should happen against existing canonical entities
- indexes/logs alone may not scale forever; metadata/query layers may emerge later

Deferred because:
- the orchestrator can begin with a project-scoped wiki and grow later

## C. Self-evolution / optimization horizon

Retained:
- DSPy and GEPA for prompt/workflow optimization
- Darwinian evolver / DGM style search
- post-training data collection
- per-model failure notes
- SFT / RFT / RL adaptation
- experiment-driven model routing
- recursion parameter optimization

Deferred because:
- v0 first needs stable artifacts, workflows, and logs
- optimization without a stable baseline will mostly optimize noise

## D. Advanced review and autonomy horizon

Retained:
- multi-model consensus review
- consensus-by-best-model synthesis
- reviewer constructive criticism accumulation
- reviewer deciding when to escalate to a stronger model
- worker/session self-refinement under guardrails
- model-specific best-role assignments tuned by data
- autonomous background cleanup/gardening
- issue synthesis for “rewrite from scratch with lessons learned”

Deferred because:
- first you need one reliable reviewer loop with one reviewer

## E. Broader runtime/backend horizon

Retained:
- pi-mono as future runtime/backend option
- oh-my-pi as a source of tool/runtime ideas
- OpenCode as a strong integration/base candidate
- Cursor CLI experiments
- GitHub Copilot CLI / cloud agent experiments
- Kimi / Grok / OpenRouter cheap-worker experiments
- tmux/PTTY wrappers as fallback
- ACP/MCP-based interoperability
- Kiro / Copilot / Cursor style global vs workspace skill layering

Deferred because:
- backend count should stay tiny until the contract stabilizes

## F. UI / operator control horizon

Retained:
- TUI dashboard
- web dashboard
- Kanban/task board style control
- live diff review surfaces
- minimap/Factorio-like org visualization
- phone/voice control later
- status and analytics views
- per-model dashboards

Deferred because:
- terminal logs and markdown artifacts are enough to validate the core loop

## G. Shared-space coordination and social workflows

Retained:
- markdown coordination files
- inter-agent questions
- presence registry
- async communication by artifact
- upper-management escalation
- agent names that hide model identity from peer agents

Deferred / narrowed:
- keep markdown handoffs immediately
- delay true shared-folder concurrency
- start with worktrees for all code-writing tasks

## H. Additional project ideas for future testing

Retained:
- small webapps
- research-oriented projects
- orchestrator-adjacent internal CLIs
- safe-evals / oversight adjacent tools
- projects aligned with fellowship applications
- parameter-golf-related experimentation
- research artifacts demonstrating agentic oversight, logging, or reproducibility

Recommendation:
- after v0, choose projects that exercise the orchestrator but remain simple enough to evaluate quickly

## I. Strong principles worth preserving

These should survive into v0 and beyond:
- simpler interfaces beat clever interfaces
- all important knowledge must live in the repo or structured archive
- deterministic enforcement beats prose-only rules
- prompt cache preservation is a structural concern
- routing/constraints should be structural, not left to the agent’s judgment
- agents need explicit placement rules and rationale for constraints
- code drift must be managed continuously, not periodically
- every important process should leave queryable traces
- docs touched by a task are part of the task
- specialized agents beat omniscient agents

## J. Ideas to revisit once v0 works

When the first reliable loop exists, revisit these in roughly this order:
1. project-scoped wiki ingest/lint/query
2. gardener/doc-gardener
3. third backend
4. multi-model consensus review
5. light experimentation framework
6. per-model notes
7. dashboard/TUI
8. personal assistant features
9. evolutionary/self-improving loops

---

## Feedback impact analysis

> Cross-reference of how the Consolidated Brayan Feedback and Claude Feedback from the foundation recommendation affect this document.

---

### Items that should be added to the parking lot

These ideas surfaced in the feedback but are not currently tracked here:

| Idea | Source | Suggested section |
|------|--------|-------------------|
| **Application-level observability** — browser automation, DevTools, per-worktree stacks for agents that build frontend/backend code. Treat as a skill when the time comes. | CF-7 | New item under **E. Broader runtime/backend horizon** or new section |
| **Output sanitization between agents** — reviewing/sanitizing agent outputs before they feed into other agents as inputs. Defense against drift or adversarial influence. | CF-8 | New item under **D. Advanced review and autonomy horizon** |
| **Cost optimization as first-class concern** — frontier models for planning, cheap models for building, cost budgets per taskset. | CF-10 | New item under **C. Self-evolution / optimization horizon** |

---

### Items already here that the feedback reinforces or adjusts

| Section | Feedback | Adjustment |
|---------|----------|------------|
| **B. Knowledge base / LLM wiki horizon** | C-14 | The user's vision for the KB is stronger than "project-scoped wiki deferred." The KB is seen as a **fundamental context-management system** — a core layer for how agents access information, with a coding-projects layer on top. This section should reflect that the KB is not just a deferred wiki but a near-term architectural component. Consider moving it closer to v0 scope or at minimum noting that a minimal version is expected early. |
| **G. Shared-space coordination** | CF-9 | Confirmed as deferred. Worktrees-only for v0. No change needed — already aligned. |
| **I. Strong principles** | C-12 | Add principle: **reference documents for classification rules (e.g., severity categories) should live in the knowledge base**, not only in prompt text. Agents need stable, queryable definitions. |
| **I. Strong principles** | C-15 | Add principle: **skill usage and effectiveness should be logged per session.** This feeds evaluation and skill refinement. |
| **I. Strong principles** | C-11 | Add principle: **agents should self-verify before handoff.** A self-reflection pass is part of the Worker contract, not an optional behavior. |

---

### Section J — Revisit order adjustment

The current revisit order may need reordering based on feedback priority:

| Current position | Item | Suggested change |
|------------------|------|------------------|
| 1 | project-scoped wiki | Keep at #1, but reframe: this is the **core KB system** (C-14), not just a wiki feature. It may move into v0 scope. |
| — | skill design and resolution | **Not listed.** Should be added near the top. Skills are fundamental (C-1, C-10, Q-1) and their design directly affects roles, the backend contract, and prompt assembly. |
| — | application-level observability | **Not listed.** Add after third backend, treat as a skill (CF-7). |
| — | output sanitization | **Not listed.** Add after multi-model consensus review (CF-8). |
| — | cost optimization | **Not listed.** Add after experimentation framework (CF-10). |
