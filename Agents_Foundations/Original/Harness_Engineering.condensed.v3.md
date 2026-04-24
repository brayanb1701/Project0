---
title: "Harness Engineering: Agent-First Software Development with Codex"
source: "Harness_Engineering.md"
source_type: article
tags: [agent-design, architecture, devops, context-management, code-review, documentation, orchestration, principles]
domain: software-engineering
density: "~950 tokens"
compression_ratio: "4:1"
extracted: "2026-03-20"
summary: "Experience report from an OpenAI team that built a production product with 0 manually-written code using Codex agents over 5 months. Covers the shift in engineering role from code-writing to environment design, repository knowledge architecture, architecture enforcement, and entropy management in fully agent-generated codebases."
key_concepts: [agent-first-development, harness-engineering, repository-as-system-of-record, progressive-disclosure, architecture-enforcement, agent-legibility, entropy-management]
applicability: bounded
preset: narrative
---

**Schema:** Core
**Legend:** `K` = Key Claim · `S` = Support · `X` = Scope / Qualifier · `E` = Evidence / Example · `Q` = Open Question · `A` = Agent-Specific
**Preset:** Narrative

---

## Project Scale & Core Constraint

`K` **Zero manually-written code.** Team of 3→7 engineers built production product entirely via Codex agents over 5 months, starting from empty repo. Humans steer; agents execute all code.

`E` ~1M LOC, ~1,500 PRs merged, 3.5 PRs/engineer/day. Throughput *increased* as team grew. Estimated 1/10th time vs. hand-written. Hundreds of internal users including daily power users.

`S` **Intentional constraint drove tooling investment.** Forcing all code through agents meant every bottleneck had to be solved by improving agent capabilities, not by humans coding around problems.

---

## Redefined Engineering Role

`K` **Engineers design environments, specify intent, build feedback loops** — not write code. Primary question on failure: "what capability is missing, and how to make it legible and enforceable for the agent?"

`S` **Early bottleneck was underspecified environment**, not agent capability. Work was depth-first: build small blocks via agent → use them to unlock complex tasks.

`K` **Interaction model is prompt-driven.** Engineer describes task → agent executes → opens PR → self-reviews → requests agent reviews → iterates until all reviewers satisfied → merges. Humans may review but aren't required.

---

## Repository Knowledge Architecture

`K` **`AGENTS.md` as table of contents, not encyclopedia.** ~100-line map pointing to deeper sources in structured `docs/` directory.

`S` **Monolithic `AGENTS.md` fails because:** context is scarce (crowds out task), too much guidance = non-guidance, rots instantly, hard to verify mechanically.

`K` **Progressive disclosure.** Agents start with small stable entry point, taught where to look next. Knowledge base includes: design docs (indexed, verified), architecture map, quality grades, execution plans (active/completed/debt), product specs, references.

`K` **Plans as first-class versioned artifacts.** Ephemeral plans for small changes; execution plans with progress/decision logs for complex work. All checked into repo.

`S` **Mechanical enforcement of docs.** Linters + CI validate freshness, cross-linking, structure. Recurring "doc-gardening" agent scans for stale docs → opens fix-up PRs.

`A` Anything not accessible in-context during agent runtime effectively doesn't exist. Slack discussions, Google Docs, tacit knowledge must be encoded as repo-local markdown to be legible.

---

## Agent Legibility & Application Observability

`K` **Optimize codebase for agent legibility first**, not human stylistic preferences. Code must be correct, maintainable, legible to future agent runs.

`K` **App bootable per git worktree** → Codex launches isolated instance per change. Chrome DevTools Protocol wired into agent runtime for DOM snapshots, screenshots, navigation → agents reproduce bugs, validate fixes, reason about UI directly.

`K` **Full local observability stack per worktree** (ephemeral, torn down after task). Agents query logs (LogQL), metrics (PromQL), traces (TraceQL). Enables prompts like "ensure startup <800ms" or "no span >2s in critical journeys."

`E` Single Codex runs regularly work 6+ hours on one task, often while humans sleep.

`S` **Favor "boring" tech.** Composable, API-stable, well-represented in training data → easier for agents to model. Sometimes cheaper to reimplement subset than work around opaque library behavior.

> `E` Reimplemented `p-limit`-style concurrency helper instead of importing package — tighter OTel integration, 100% test coverage, exact runtime-expected behavior.

---

## Architecture Enforcement

`K` **Rigid layered architecture enforced mechanically** — prerequisite for agent speed, not post-hoc optimization. Strict dependency direction per business domain: Types → Config → Repo → Service → Runtime → UI. Cross-cutting concerns enter via single Providers interface.

`S` **Enforce invariants, not implementations.** E.g., require boundary parsing but don't prescribe Zod specifically. Custom linters + structural tests enforce rules; lint error messages inject remediation instructions into agent context.

`K` **Taste invariants encoded as lints.** Structured logging, naming conventions, file size limits, platform reliability requirements — all enforced mechanically. Once encoded, applies everywhere at once.

`S` **Enforce boundaries centrally, allow autonomy locally.** Agents have freedom in solution expression within enforced boundaries.

---

## Throughput & Merge Philosophy

`K` **Minimal blocking merge gates.** Short-lived PRs. Test flakes addressed with follow-up runs rather than blocking. When agent throughput >> human attention, corrections are cheap, waiting is expensive.

`X` Would be irresponsible in low-throughput environments. Right tradeoff only when correction cost is low relative to blocking cost.

---

## Entropy Management

`K` **Drift is inevitable** — agents replicate existing patterns, including suboptimal ones. Requires continuous "garbage collection."

`S` Manual Friday cleanup (20% of week) didn't scale → replaced with **golden principles** encoded in repo + recurring automated cleanup. Background Codex tasks scan for deviations, update quality grades, open targeted refactoring PRs. Most reviewable in <1 minute, automerged.

`S` **Technical debt as high-interest loan.** Continuous small payments > periodic large bursts. Human taste captured once → enforced continuously on every line.

---

## Increasing Autonomy

`K` **End-to-end agent-driven features now possible** given sufficient scaffolding. Single prompt → validate codebase → reproduce bug → record video → implement fix → validate → record resolution video → open PR → respond to feedback → remediate build failures → escalate only when judgment needed → merge.

`X` Depends heavily on this specific repository's structure and tooling. **Should not be assumed to generalize without similar investment.**

---

## Key Takeaways

- `K` Discipline shifts from code to scaffolding: tooling, abstractions, feedback loops that maintain codebase coherence
- `Q` Long-term architectural coherence in fully agent-generated systems unproven — 5-month experiment, years unknown
- `Q` Where human judgment adds most leverage and how to encode it so it compounds remains open
- `Q` How system evolves as models become more capable is unknown
- `K` Core challenges now: designing environments, feedback loops, and control systems for agents to build/maintain complex reliable software at scale
