# Prompt Caching and Prefix Stability
> Purpose: current invariant layer for Anthropic-style prefix caching
> Scope: provider-specific caching constraints that strongly affect latency and cost
> Status markers: `Core` / `Default` / `Conditional` / `Experimental`

**Legend:** `P` = Principle · `E` = Example / Fact · `A` = Agent-specific

---

## Scope

`[PC-01][Conditional]` `P` **These rules are provider-mechanism specific.** They are highly actionable where prefix-based prompt caching exists, but they should not be generalized blindly to every model provider.

---

## Prefix Stability

`[PC-02][Core]` `P` **Prompt caching is prefix-based.** Any change in the cached prefix invalidates everything after it.

`[PC-03][Core]` `P` **Lay out prompts static-first, dynamic-last.** Put the most stable content earliest so more requests and sessions share the same prefix.

`[PC-04][Default]` `P` **Deterministic serialization matters.** Tool order, tool params, system text, and other prefix content must be emitted consistently or caching silently degrades.

---

## Session Discipline

`[PC-05][Core]` `P` **Use messages for updates instead of editing the system prompt mid-session.** Changing state through follow-up messages preserves the cached prefix better than mutating the prompt foundation.

`[PC-06][Core]` `P` **Do not switch models mid-session unless the tradeoff is truly worth rebuilding cache state.** If you need a different model, isolate it behind a subagent or handoff.

`[PC-07][Core]` `P` **Do not add or remove tools mid-session.** Design state transitions so the tool universe remains stable.

`[PC-08][Default]` `P` **Prefer deferred loading to tool removal.** For large tool sets, keep stable stubs and load full schemas only when needed.

---

## Feature Design Around the Cache

`[PC-09][Default]` `P` **Design harness features so state changes happen inside the stable tool/prompt frame.** Plan mode and similar behaviors should be represented as stable tools or in-message state changes, not by swapping the prompt foundation.

`[PC-10][Core]` `P` **Fork operations should reuse the parent prefix.** Compaction, summarization, and similar side computations should share the same cached foundation whenever possible.

`[PC-11][Default]` `P` **Leave compaction buffer on purpose.** Cache-safe compaction needs room for the compaction instruction and summary output.

`[PC-12][Core]` `P` **Monitor cache hit rate like a production health metric.** Silent cache regressions directly hit cost and latency.

---

## Anti-Patterns

- Editing the system prompt every time state changes.
- Switching models mid-conversation for a “cheap question” without accounting for cache rebuild.
- Adding or removing tools as modes change.
- Reordering tool definitions or other prefix content non-deterministically.
- Running compaction or summarization with a different prompt foundation and losing cache reuse.
