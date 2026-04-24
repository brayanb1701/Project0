# Repository Architecture, Modularity, and Control
> Purpose: current invariant layer
> Scope: repository shape, architectural constraints, legibility, maintainability, autonomy
> Status markers: `Core` / `Default` / `Conditional` / `Experimental`

**Legend:** `P` = Principle · `E` = Example / Fact · `A` = Agent-specific

---

## Repository as Operating System

`[RA-01][Core]` `P` **Treat the repository as the system of record.** Durable knowledge should live in versioned repo artifacts: maps, architecture docs, design docs, specs, plans, generated schemas, quality docs, scripts, and tests.

`[RA-02][Core]` `P` **Top-level agent docs are maps, not manuals.** `AGENTS.md`, `CLAUDE.md`, and `ARCHITECTURE.md` should orient, define boundaries, and point onward. They should not try to carry the entire knowledge base.

`[RA-03][Default]` `P` **Plans are first-class repo artifacts.** Long-horizon work needs checked-in plans, progress notes, and decision logs rather than disposable chat history.

`[RA-04][Core]` `P` **Documentation freshness should be mechanically checked.** Cross-links, structure, ownership, and staleness should be validated by tooling or recurring maintenance tasks.

---

## Modularity and Layered Complexity

`[RA-05][Core]` `P` **Design the codebase as a modular system with a small legible core and complexity pushed into layers above it.** This keeps local reasoning possible and limits blast radius when agents modify the system.

`[RA-05.A]` `A` Agents work best when they can change one bounded area without needing the full repo in context.

`[RA-06][Core]` `P` **Make boundaries and dependency direction unambiguous.** Every layer should know what it may depend on, what may depend on it, and where cross-cutting concerns are injected.

`[RA-07][Core]` `P` **Known patterns and conventions are infrastructure.** Agents pattern-match. Give them patterns worth matching and enforce them structurally.

`[RA-08][Default]` `P` **Prefer boring, inspectable, composable technology.** Stable APIs and internals the agent can inspect are usually more valuable than opaque black-box convenience.

> `[RA-08.E1]` `E` One recurring pattern in the corpus is preferring a small internal helper over an opaque upstream abstraction when the internal version is easier to test, inspect, and evolve.

---

## Legibility and Validation

`[RA-09][Core]` `P` **Your codebase is infrastructure for the agent.** It should be easy for the agent to navigate, run, inspect, validate, and repair — not only pleasant for humans to browse.

`[RA-10][Default]` `P` **Make the running system inspectable.** Give the agent access to the real application surface it changes: UI, logs, metrics, traces, and reproducible local environments.

`[RA-11][Default]` `P` **Isolate task environments.** Per-task worktrees or equivalent isolation reduce contamination and make validation attributable to the current change.

`[RA-12][Core]` `P` **Encode taste as checks, not repeated review comments.** If a rule keeps recurring in review, promote it into a linter, structural test, template, or other reusable mechanism.

---

## Control, Throughput, and Autonomy

`[RA-13][Core]` `P` **Optimize for controllable maintainability, not raw throughput.** Throughput should be tracked, but the real objective is a codebase that remains understandable and governable by you and the system as autonomy increases.

`[RA-13.A]` `A` Throughput without control is just accelerated entropy.

`[RA-14][Conditional]` `P` **Choose the operating mode by risk tier.** Prototype and showroom work can run with lighter constraints and higher autonomy. Long-lived, critical, or cross-cutting systems need stricter review depth, narrower task scope, and stronger enforcement.

`[RA-15][Default]` `P` **Autonomy should graduate in tiers.** Start with more supervision, encode missing feedback loops and checks, then widen autonomy as the system proves it can remain stable.

`[RA-15.A]` `A` It is useful to compare the same class of work under different supervision levels and watch what changes in error rate, maintainability, and review burden.

`[RA-16][Default]` `P` **Measure throughput as one signal among others.** Track it alongside reviewability, defect containment, merge quality, cleanup burden, and how much of the codebase still feels legible.

---

## Entropy Management

`[RA-17][Core]` `P` **Entropy is self-reinforcing.** Messier code reduces recall, increases duplication, and invites more mess. Cleanup therefore belongs in the core operating loop.

`[RA-18][Default]` `P` **Treat technical debt like garbage collection.** Small recurring cleanup, background scans, and narrow refactor PRs scale better than occasional large cleanup pushes.

`[RA-19][Default]` `P` **Autonomy grows out of encoded feedback loops.** The more validation, recovery, review, and observability are encoded into the repo, the further agents can safely drive work end-to-end.

---

## Anti-Patterns

- Monolithic top-level docs that try to explain everything at once.
- Architecture without explicit boundaries or dependency direction.
- A codebase with no clear core and no layered containment of complexity.
- Optimizing for PR count while losing control of maintainability.
- Allowing autonomy to rise faster than validation and review capacity.
- Treating cleanup as an occasional rescue instead of part of normal operation.
