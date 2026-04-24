---
title: "Harness Engineering: Agent-First Software Development with Codex"
source: "Harness_Engineering.md"
source_type: article
tags: [agent-design, architecture, context-management, coding, devops, orchestration, principles, patterns]
domain: software-engineering
extracted: "2026-03-31"
applicability: bounded
summary: "Lessons from a 5-month OpenAI experiment building a product with 0 manually-written code using Codex agents. Covers how engineering roles shift, how to structure repositories for agent legibility, enforce architecture mechanically, manage entropy, and scale agent autonomy — bounded by one team's experience with a specific toolchain."
key_concepts: [agent-legibility, progressive-disclosure, mechanical-enforcement, repo-as-system-of-record, entropy-management, layered-architecture, harness-engineering]
---

**Schema:** Core
**Legend:** `K` = Key Claim · `S` = Support · `X` = Scope / Qualifier · `E` = Evidence / Example · `Q` = Open Question · `A` = Agent-Specific

---

## Project Context

`K` **0 manually-written code, end to end.** A small OpenAI team built and shipped an internal product over 5 months where every line — app logic, tests, CI, docs, tooling, observability — was written by Codex agents. Estimated 10x speed vs. hand-written.

`E` ~1M lines of code, ~1,500 PRs merged, 3.5 PRs/engineer/day average. Throughput *increased* as team grew from 3 to 7 engineers. Product used daily by hundreds of internal users plus external alpha testers.

`X` **Single team, single product, Codex-specific.** Results are bounded by this team's 5-month experience with Codex (GPT-5) and their specific repo structure/tooling. Explicitly: "should not be assumed to generalize without similar investment."

---

## Redefined Engineering Role

`K` **Humans steer, agents execute.** Engineers no longer write code — they design environments, specify intent, and build feedback loops. Primary job: enable agents to do useful work.

`S` Early progress was slower than expected because the environment was underspecified, not because the agent was incapable. The bottleneck was missing tools, abstractions, and structure.

`K` **Depth-first decomposition.** Break goals into building blocks → prompt agent to construct them → use results to unlock more complex tasks.

`S` When something failed, the fix was never "try harder." Engineers asked: "what capability is missing, and how do we make it legible and enforceable for the agent?"

`K` **Review shifted to agent-to-agent.** Humans may review PRs but aren't required to. Over time, nearly all review was handled agent-to-agent via a feedback loop (Ralph Wiggum Loop): agent reviews its own changes, requests additional agent reviews, iterates until all reviewers are satisfied.

---

## Context & Knowledge Management

`K` **Give agents a map, not a manual.** A short `AGENTS.md` (~100 lines) serves as table of contents with pointers to deeper sources in a structured `docs/` directory.

`S` The monolithic "one big AGENTS.md" approach failed for four reasons:
- Context is scarce → large files crowd out the task and relevant code
- Too much guidance becomes non-guidance → agents pattern-match locally instead of navigating intentionally
- Monolithic files rot instantly → stale rules become attractive nuisances
- Hard to verify mechanically → drift is inevitable

`A` **Progressive disclosure is critical for agents.** Start with a small, stable entry point; teach agents where to look next rather than overwhelming up front.

`K` **Repository knowledge = system of record.** Structured `docs/` directory with design docs, execution plans, product specs, references, architecture docs, quality scores, and tech-debt tracker — all versioned and co-located.

`S` Plans are first-class artifacts: ephemeral lightweight plans for small changes, execution plans with progress/decision logs for complex work. Active plans, completed plans, and tech debt all versioned together → agents operate without external context.

`K` **Mechanically enforce knowledge freshness.** Dedicated linters and CI jobs validate the knowledge base is up to date, cross-linked, and structured correctly. A recurring "doc-gardening" agent scans for stale docs and opens fix-up PRs.

---

## Agent Legibility

`K` **Anything the agent can't access in-context doesn't exist.** Google Docs, Slack threads, tacit knowledge — all invisible to agents. Repository-local, versioned artifacts (code, markdown, schemas, plans) are the only accessible knowledge.

`S` Push context into the repo continuously. A Slack discussion aligning on an architectural pattern is illegible to the agent the same way it would be unknown to a new hire joining months later.

`K` **Made application state directly observable to agents.** App bootable per git worktree → Codex launches and drives one instance per change. Chrome DevTools Protocol wired into agent runtime → DOM snapshots, screenshots, navigation for reproducing bugs and validating fixes.

`K` **Full local observability stack per worktree.** Logs, metrics, traces exposed via ephemeral Vector → Victoria Logs/Metrics/Traces stack. Agents query via LogQL, PromQL, TraceQL. Stack is torn down when the task completes.

> `E` Prompts like "ensure startup completes in <800ms" or "no span in these four critical journeys exceeds 2s" become tractable. Single Codex runs regularly work 6+ hours autonomously.

`K` **Favor "boring" technology.** Technologies with composability, API stability, and strong training-set representation are easier for agents to model. Sometimes cheaper to reimplement functionality than work around opaque upstream behavior.

> `E` Implemented own map-with-concurrency helper instead of pulling `p-limit` — tightly integrated with OpenTelemetry, 100% test coverage, behaves exactly as their runtime expects.

---

## Architecture & Enforcement

`K` **Enforce invariants, not implementations.** Strict architectural model with rigid boundaries enables agent speed without decay. Each business domain divided into fixed layers with validated dependency directions: Types → Config → Repo → Service → Runtime → UI. Cross-cutting concerns (auth, connectors, telemetry, feature flags) enter through a single explicit interface: Providers.

`S` This level of architecture is usually postponed until hundreds of engineers. With coding agents, it's an early prerequisite — constraints enable speed without architectural drift.

`K` **Custom linters encode taste mechanically.** Statically enforced: structured logging, naming conventions, file size limits, reliability requirements. Lint error messages written as remediation instructions injected into agent context.

`A` Custom lint error messages double as agent guidance — when a rule fires, the agent gets inline instructions on how to fix it. Enforced rules apply everywhere at once, unlike documentation.

`K` **Enforce boundaries centrally, allow autonomy locally.** Like leading a large platform org — care deeply about boundaries, correctness, reproducibility; allow freedom in how solutions are expressed within those bounds.

`S` Resulting code may not match human stylistic preferences — that's acceptable. Bar: correct, maintainable, legible to future agent runs.

`K` **Human taste feeds back continuously.** Review comments, refactoring PRs, user-facing bugs → captured as documentation updates or encoded directly into tooling. When documentation falls short, promote the rule into code.

---

## Throughput & Merge Philosophy

`K` **High throughput inverts merge norms.** Minimal blocking merge gates. PRs are short-lived. Test flakes addressed with follow-up runs rather than blocking indefinitely.

`S` When agent throughput far exceeds human attention, corrections are cheap and waiting is expensive. This would be irresponsible in low-throughput environments — here it's often the right tradeoff.

---

## Entropy Management

`K` **Agent-generated code drifts.** Codex replicates existing patterns — including suboptimal ones. Over time, this causes drift and inconsistency.

`S` Manual cleanup ("AI slop") initially consumed 20% of the week (every Friday). Didn't scale.

`K` **Automated garbage collection replaces manual cleanup.** "Golden principles" — opinionated, mechanical rules — encoded in repo. Recurring background Codex tasks scan for deviations, update quality grades, open targeted refactoring PRs. Most reviewable in <1 minute and automerged.

> `E` Two golden principles: (1) prefer shared utility packages over hand-rolled helpers to centralize invariants; (2) validate boundaries or use typed SDKs rather than probing data "YOLO-style."

`S` Technical debt as high-interest loan → better to pay continuously in small increments than let it compound. Human taste captured once, enforced continuously on every line.

---

## Increasing Autonomy

`K` **End-to-end feature delivery from a single prompt** (in this specific repo). Agent can: validate codebase state → reproduce bug → record failure video → implement fix → validate fix → record resolution video → open PR → respond to feedback → remediate build failures → escalate only when judgment needed → merge.

`X` **Heavily dependent on repo-specific structure and tooling.** Should not be assumed to generalize without similar investment.

---

## Key Takeaways

- Discipline shifts from code to scaffolding — tooling, abstractions, and feedback loops that keep the codebase coherent
- Biggest unsolved challenge: designing environments, feedback loops, and control systems for agents at scale
- `Q` How does architectural coherence evolve over years in a fully agent-generated system?
- `Q` Where does human judgment add the most leverage, and how to encode it so it compounds?
- `Q` How will the system evolve as models become more capable?
