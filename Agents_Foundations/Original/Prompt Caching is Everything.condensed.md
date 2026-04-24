---
title: "Prompt Caching Patterns for Agentic Systems"
source: "Prompt Caching is Everything.md"
source_type: article
tags: [prompt-engineering, context-management, performance, agent-design, caching]
domain: software-engineering
extracted: "2026-03-31"
summary: "Production lessons from Claude Code on designing agent harnesses around Anthropic's prefix-based prompt caching. Covers prompt layout, tool/model stability, cache-safe forking, and monitoring — all aimed at minimizing cost and latency."
key_concepts: [prefix-matching, prompt-ordering, cache-safe-forking, tool-stability, deferred-loading, compaction]
applicability: bounded
preset: prescriptive
---

**Schema:** Core
**Legend:** `K` = Key Claim · `S` = Support · `X` = Scope / Qualifier · `E` = Evidence / Example · `A` = Agent-Specific
**Preset:** Prescriptive

---

## Prefix Matching Fundamentals

`K` **Prompt caching is prefix-based.** API caches computation from request start to each `cache_control` breakpoint; any change anywhere in the prefix invalidates everything after it.

`S` Long-running agentic products depend on caching for feasible cost and latency — Claude Code treats cache hit rate like uptime, alerting on drops and declaring SEVs.

`X` Applies to Anthropic API prompt caching; other providers may differ.

---

## Prompt Layout

`K` **Static content first, dynamic content last.** Maximizes shared prefix across requests/sessions.

`E` Claude Code ordering: (1) static system prompt + tools → (2) `CLAUDE.md` project context → (3) session context → (4) conversation messages.

`K` **Fragility of prefix stability.** Seemingly minor changes break caching silently.

> `E` Broken by: timestamp in system prompt, non-deterministic tool ordering, dynamic tool parameter updates.

`A` Agent harnesses must ensure deterministic serialization of all prefix content — tool definitions, system instructions, context blocks — across every request in a session.

---

## Preserving Cache Mid-Session

`K` **Use messages for updates, not system prompt edits.** Inject changing information (time, file changes) via `<system-reminder>` tags in the next user message or tool result → cache stays intact.

`K` **Never change models mid-session.** Caches are per-model; switching from Opus to Haiku mid-conversation rebuilds the entire cache, often costing more than staying on Opus.

`S` If model switching is needed → use subagents with a handoff message so the parent's cache is unaffected.

> `E` Claude Code's Explore agents use Haiku as subagents while the parent stays on Opus.

---

## Tool Stability

`K` **Never add or remove tools mid-session.** Tools are part of the cached prefix; any change invalidates the entire conversation cache.

`K` **Model state transitions via tools, not tool-set changes.** Instead of swapping tool sets for different modes, use tools that represent the transition itself.

> `E` **Plan Mode:** Rather than replacing tools with read-only variants, Claude Code keeps all tools and adds `EnterPlanMode`/`ExitPlanMode` as callable tools + a system message explaining constraints. Bonus: model can autonomously enter plan mode on hard problems.

`K` **Deferred loading over removal.** For large tool sets (MCP tools), send lightweight stubs (`defer_loading: true` — name only) in a stable order; model discovers full schemas via `ToolSearch` tool on demand.

`S` Stubs maintain prefix stability while avoiding cost of including all full schemas in every request.

`A` When building agent harnesses with many tools: emit deterministic stub list at prompt construction time; never reorder or filter stubs between turns.

---

## Cache-Safe Forking (Compaction)

`K` **Fork operations must share the parent's prefix.** Side computations (compaction, summarization, skill execution) should reuse identical system prompt, tools, context, and conversation history so the parent's cache is hit.

`S` Naive approach — separate API call with different system prompt and no tools — gets zero cache hits, paying full price on all input tokens.

`E` Claude Code compaction: prepends parent's full conversation, appends compaction prompt as new user message at the end → API sees near-identical prefix → cache reuse.

`X` Requires reserving a "compaction buffer" in the context window for the compaction instruction + summary output tokens.

`A` Compaction is now available as an API feature (`/docs/en/build-with-claude/compaction#prompt-caching`) — use it rather than reimplementing.

---

## Anti-Patterns

- Editing system prompt to reflect state changes (time, mode) → cache break; use messages instead
- Switching models mid-conversation for "cheaper" questions → rebuilds cache, often costs more
- Adding/removing tools based on current need → prefix invalidation
- Running fork operations (compaction, summarization) with different system prompt/tool set → zero cache hits
- Non-deterministic tool ordering or dynamic tool parameters in prefix → silent cache misses
- Neglecting cache hit rate monitoring → undetected cost/latency regressions
