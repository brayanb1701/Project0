---
title: "Guidelines for Writing ARCHITECTURE.md"
source: "Architecture_Doc.md"
source_type: article
tags: [architecture, documentation, open-source, principles]
domain: software-engineering
density: "~210 tokens"
compression_ratio: "3:1"
extracted: "2026-03-20"
summary: "Prescriptive guide for adding an ARCHITECTURE.md to mid-size open-source projects (10k-200k LOC). Covers what to include — codemap, invariants, boundaries, cross-cutting concerns — and how to keep it maintainable."
key_concepts: [codemap, architectural-invariants, layer-boundaries, naming-over-linking, low-maintenance-docs]
---

**Archetype:** Prescriptive
**Legend:** `P` = Core Principle · `E` = Implementation Example · `A` = Agent-specific

---

## Why It Matters

`P` **Knowledge gap is navigational, not intellectual.** Finding WHERE to change code costs 10x more than writing the patch itself; core devs have a mental map, newcomers don't. ARCHITECTURE.md bridges that gap with low effort.

`A` Agents lack persistent mental maps across sessions → an ARCHITECTURE.md is the single highest-leverage file for agent onboarding to a codebase.

---

## Document Principles

`P` **Brevity and stability over completeness.** Only document things unlikely to change frequently. Shorter → every contributor reads it, less likely to go stale.

`P` **Don't sync with code.** Revisit ~2x/year rather than maintaining continuous accuracy.

---

## Content Structure

`P` **Bird's eye problem statement first, then codemap.** Codemap = coarse-grained modules + relationships. Answers "where is X?" and "what does this do?" — NOT how each module works internally.

> `E` Map of a country, not an atlas of state maps. Detail of HOW belongs in inline docs.

`P` **Use codemap as structural reflection.** Check if conceptually adjacent modules are physically adjacent (`tree .`).

`P` **Name entities, don't link them.** Name important files/modules/types explicitly; avoid direct links (go stale). Reader uses symbol search → discovers related items. Zero maintenance.

`A` Agents should `Grep`/`Glob` for named entities rather than expecting clickable paths.

---

## Invariants & Boundaries

`P` **Explicitly state architectural invariants — especially absences.** Invariants expressed as "X does NOT depend on Y" are invisible in code and critical to document.

> `E` Model layer has no dependency on views — undetectable by reading code alone.

`P` **Call out layer/system boundaries.** Boundaries constrain all possible implementations behind them; "good boundaries have measure zero" — nearly impossible to find by browsing code.

`A` Agents cannot infer invariants from absence → these must be stated explicitly or agents will violate them.

---

## Cross-Cutting Concerns

`P` **Dedicated section after the codemap.** Separate from per-module descriptions.

---

## Anti-Patterns

- Over-documenting volatile details → rapid staleness, contributors stop reading
- Linking directly to code locations → links rot silently
- Describing HOW modules work → belongs in inline docs, bloats the map
- Omitting invariants expressed as absences → invisible constraints get violated
