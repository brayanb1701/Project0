# Workflow: Research, Planning, Implementation, and Review
> Purpose: current best-known operating pattern
> Status: evolving
> Not a timeless invariant

**Legend:** `P` = Principle · `E` = Example / Fact · `A` = Agent-specific

---

## Workflow Shape

`[WF-01][Default]` `P` **Use an explicit research -> plan -> implement flow for complex work.** Keep the phases conceptually distinct even if a task skips one, repeats one, or compresses them.

`[WF-02][Default]` `P` **Treat research as compression of truth, not early implementation.** First define the right questions; then gather and distill evidence.

`[WF-03][Default]` `P` **Plan in layers.** A useful sequence is:
1. design discussion / decisions
2. structure outline
3. final vertical implementation plan

`[WF-04][Default]` `P` **The final plan should be vertically executable.** Avoid broad horizontal wish lists that the agent cannot actually follow.

---

## Context Handling

`[WF-05][Default]` `P` **Do intentional compaction before the context is unusable.** Distill goal, current approach, completed work, open failure, and next step into a durable artifact.

`[WF-06][Default]` `P` **Compact verified status back into the plan.** The plan should become the current truth of the task, not stay as a stale pre-implementation artifact.

`[WF-07][Conditional]` `P` **Intermediate markdown artifacts should stay bounded.** Shorter artifacts are usually easier to review, maintain, and reload than sprawling prose.

> `[WF-07.E1]` `E` The corpus includes concrete habits like keeping intermediate markdown around a few hundred lines and operating well below full context saturation.

---

## Human Leverage

`[WF-08][Core]` `P` **Do not outsource the thinking.** The highest-leverage human work remains framing, acceptance criteria, design judgment, and intervention at the right abstraction layer.

`[WF-09][Default]` `P` **Review the highest-leverage artifact, not only the final diff.** Research mistakes can explode into thousands of bad lines; planning mistakes into hundreds.

`[WF-10][Default]` `P` **Preserve mental alignment with compact artifacts.** Plans, research docs, and specs are often more reviewable than giant PRs and help the team stay oriented as throughput rises.

---

## Task Selection and Risk

`[WF-11][Default]` `P` **Prefer scoped, closed-loop, reviewable tasks.** Reproduction cases, debugging tools, verification flows, boring experiments, and bounded product work are strong agent tasks.

`[WF-12][Conditional]` `P` **Cap task size and generated code by review capacity and criticality.** Review depth should scale with risk.

`[WF-13][Conditional]` `P` **Choose supervision level deliberately.** For some work you may want close human steering; for other work you may intentionally loosen supervision and compare outcomes.

`[WF-13.A]` `A` A useful experiment design is to run comparable tasks under several supervision levels and compare maintainability, review burden, and defect rate — not just speed.

`[WF-14][Core]` `P` **There is no magic prompt.** Better workflow improves odds, but hard problems still need engagement, iteration, and sometimes domain expertise.

---

## Anti-Patterns

- Letting the main chat transcript become the only durable state of the task.
- Treating research as permission to start implementation immediately.
- Writing plans too broad for the agent to execute coherently.
- Reviewing only the final diff while ignoring research and plan quality.
- Measuring success only by speed instead of speed plus controllability.
