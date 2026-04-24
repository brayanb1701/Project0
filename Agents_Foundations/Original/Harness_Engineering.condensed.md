---
title: "Harness Engineering: Principles for Agent-First Software Development"
source: "Harness_Engineering.md"
source_type: article
tags: [agent-design, architecture, coding, orchestration, tool-use, context-management, principles, patterns]
domain: software-engineering
density: "~750 tokens"
compression_ratio: "3.5:1"
extracted: "2026-03-20"
summary: "Principles and practices from OpenAI's experiment building a product with 0 human-written code (~1M LoC, 5 months, 3→7 engineers). Core thesis: engineering shifts from writing code to designing environments, specifying intent, and building feedback loops for agents."
key_concepts: [repo-as-system-of-record, agent-legibility, mechanical-enforcement, progressive-disclosure, entropy-management, layered-architecture, autonomy-escalation]
staleness_risk: medium
authority: primary
---

**Archetype:** Prescriptive
**Legend:** `P` = Core Principle · `E` = Implementation Example · `A` = Agent-specific

---

## Role of the Engineer

`P` **Humans steer, agents execute.** Engineer's job → design environments, specify intent, build feedback loops. Not writing code.

`P` **Failure = missing capability, not insufficient effort.** When agent struggles, ask "what tool/guardrail/doc is missing?" — then have the agent build it.

`E` Team of 3→7 engineers, ~1500 PRs in 5 months, 3.5 PRs/engineer/day. Throughput *increased* with team growth.

`A` Agent-to-agent review loops ("Ralph Wiggum Loop"): agent reviews own changes, requests additional agent reviews, iterates until all satisfied. Humans review optionally.

---

## Repository as System of Record

`P` **AGENTS.md = table of contents, not encyclopedia.** ~100 lines, pointers to deeper sources. Enables progressive disclosure.

> `E` Structured `docs/` directory: design-docs, exec-plans (active/completed), product-specs, references, generated schemas. Plans are first-class versioned artifacts.

`P` **What agents can't access in-context doesn't exist.** Slack discussions, Google Docs, tacit knowledge → invisible. Must be encoded as repo-local markdown/schemas.

`A` Agents lack cross-session memory. All context must be discoverable from repo at task start. Knowledge in external systems = knowledge that doesn't exist for the agent.

`P` **Enforce knowledge freshness mechanically.** Linters + CI validate docs are up-to-date, cross-linked, structured. "Doc-gardening" agent scans for stale docs → opens fix PRs.

---

## Agent Legibility

`P` **Optimize codebase for agent readability first.** Code need not match human stylistic preferences — must be correct, maintainable, legible to future agent runs.

`P` **Make the full application inspectable by agents.** App bootable per git worktree → one instance per change. Wire browser automation + observability into agent runtime.

> `E` Chrome DevTools Protocol → DOM snapshots, screenshots, navigation. Local ephemeral observability stack (Vector → VictoriaLogs/Metrics/Traces) queryable via LogQL/PromQL/TraceQL.

`P` **Favor boring technology.** Composable, stable APIs, well-represented in training data → easier for agents to model. Sometimes cheaper to reimplement than wrap opaque libraries.

> `E` Built custom map-with-concurrency helper instead of `p-limit` — tightly integrated with OpenTelemetry, 100% tested, predictable behavior.

---

## Enforcing Architecture & Taste

`P` **Enforce invariants, not implementations.** Strict boundaries + freedom within them. Like platform engineering: enforce centrally, allow autonomy locally.

> `E` Layered domain architecture: Types → Config → Repo → Service → Runtime → UI. Cross-cutting concerns (auth, telemetry, feature flags) enter via single explicit Providers interface. Enforced by custom linters + structural tests.

`A` Custom linter error messages should inject remediation instructions directly into agent context — the error *is* the prompt.

`P` **Human taste → code, not docs.** When documentation falls short, promote the rule into a linter or structural test. Taste captured once, enforced continuously on every line.

---

## Throughput & Merge Philosophy

`P` **At high throughput, corrections are cheap and waiting is expensive.** Minimal blocking merge gates, short-lived PRs. Test flakes → follow-up runs, not blocking.

`A` This only works with sufficient automated validation. Without mechanical enforcement, fast merging compounds errors.

---

## Entropy Management

`P` **Agent-generated code drifts.** Agents replicate existing patterns including suboptimal ones → entropy accumulates.

`P` **Treat tech debt as garbage collection, not spring cleaning.** Encode "golden principles" in repo. Recurring background agents scan for deviations, update quality grades, open targeted refactoring PRs. Pay debt continuously in small increments.

> `E` Team initially spent 20% of time (every Friday) manually cleaning "AI slop" → replaced with automated recurring scans + automerge-able fix PRs.

---

## Increasing Autonomy

`P` **Autonomy emerges from encoded feedback loops.** As testing, validation, review, and recovery get encoded into the system, agents can drive end-to-end.

> `E` Single prompt → validate codebase → reproduce bug → record video → implement fix → validate fix → record resolution video → open PR → respond to feedback → remediate build failures → escalate when judgment needed → merge. Single runs last 6+ hours.

---

## Anti-Patterns

- Giant monolithic AGENTS.md → context crowding, non-guidance, instant staleness, unverifiable
- Knowledge in Slack/Docs/heads instead of repo → invisible to agents
- "Try harder" as fix for agent failure → missing capability is the real issue
- Manual code cleanup at scale → doesn't scale; encode as automated scans
- Opaque third-party libraries when agent can't reason about behavior → reimplement subset
- Blocking merge gates at high throughput → waiting costs more than corrections
- Optimizing code for human aesthetic preferences over agent legibility
