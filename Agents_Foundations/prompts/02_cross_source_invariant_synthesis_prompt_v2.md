# Cross-Source Invariant Synthesis Prompt v2

Use this for a **multi-document corpus** when the goal is to extract the current invariant layer for an agent-oriented system.

This is **not** the same as source-local condensation. Your job here is to separate:

1. relatively stable invariants
2. current best-known defaults
3. evolving workflows / playbooks
4. experiments / hypotheses
5. supporting case-study evidence

The output should feel like a usable operating system for the repo, not just a compressed vault.

---

## Phase 0 — Build a source register first

For every source, record:

- source name
- source role:
  - `primary`
  - `user-refined synthesis`
  - `source-local condensation`
  - `notes / fragment`
- provisional authority / weight:
  - `high`
  - `medium`
  - `low`
- whether the user explicitly marked it as important
- whether it is intended as:
  - evidence
  - synthesis
  - methodology
  - workflow note
- notable limitations (draft, truncated, speculative, old, derivative, etc.)

If the user has already clarified that a file was manually iterated and refined, do **not** treat it as just another derived summary.

---

## Phase 1 — Extract atomic claims

Extract every meaningful claim from every source, including:

- principles
- operating rules
- decision criteria
- architecture constraints
- placement rules
- named workflows
- important caveats
- case-study facts
- anti-patterns

Do not yet flatten them.

---

## Phase 2 — Classify by stability

For every extracted claim, assign one of four stability classes:

- `Core` — current invariant worth treating as stable
- `Default` — strong current default, but likely to evolve with harness/model changes
- `Conditional` — valid only in certain repo/risk/runtime conditions
- `Experimental` — hypothesis, emerging tactic, or insufficiently corroborated idea

Important: “invariant” does **not** mean eternal.  
It means “stable enough to encode as the current operating truth until displaced.”

---

## Phase 3 — Split outputs by job, not just theme

Organize outputs into at least these layers:

### A. `principles/`
Only put relatively stable or reusable rules here.

### B. `playbooks/`
Put evolving workflows here: research flows, review routines, planning formats, escalation patterns, supervision strategies.

### C. `reviews/`
Evaluate existing condensed or synthetic files differently based on their role:
- source-local condensations → judge on fidelity and edge preservation
- refined syntheses → judge on usefulness, weighting, and alignment with the intended invariant layer

### D. `traceability/` or equivalent
Produce a best-effort mapping from canonical items back to source evidence.

---

## Phase 4 — Handle conflicts explicitly

When sources disagree:

1. prefer higher-weight / user-marked sources
2. prefer primary sources over notes
3. prefer refined syntheses over raw condensations when the user has marked them as intentional iterations
4. if the disagreement is really a scope split, write it as a conditional rule
5. if unresolved, keep both and mark the conflict

Never silently average away a tension.

---

## Non-negotiable extraction priorities

### 1. Preserve modularity and placement rules
Pay special attention to:
- modular decomposition
- simple core + layered complexity above it
- dependency direction
- architecture boundaries
- cross-cutting injection points
- “where does new code go?”

These are load-bearing for agent-built systems and are easy to under-extract.

### 2. Separate stable architecture from evolving process
Do not place “current workflow” next to “stable repo invariant” as if they were the same kind of truth.

### 3. Preserve controllability, not just speed
If a source discusses throughput, autonomy, or merge velocity, pair it with:
- reviewability
- maintainability
- supervision level
- risk tier
- ability to keep the codebase understandable

### 4. Keep facts as evidence
Numbers, examples, and case-study outcomes should survive as `E` items or equivalent support, not disappear during synthesis.

### 5. Treat traceability honestly
Traceability is best-effort evidence, not proof of perfect completeness. The mapping should help audit the synthesis, not pretend to guarantee it.

---

## Output format

Use this structure for principle files:

```md
# [Domain]
> Purpose: current invariant layer
> Source scope: [files]
> Status markers: Core / Default / Conditional / Experimental

**Legend:** `P` = Principle · `E` = Example / Fact · `A` = Agent-specific

---

## [Theme]

`[ID][Core]` `P` **...**
`[ID.A]` `A` ...
> `[ID.E1]` `E` ...

---
## Anti-Patterns
- ...
```

Use this structure for playbooks:

```md
# [Workflow / Playbook]
> Purpose: current best-known operating pattern
> Status: evolving
> Not a timeless invariant

...
```

---

## Final reporting requirements

In the final response, include:

- source files that were thin, redundant, contradictory, or note-like
- cross-cutting themes that appeared in 3+ files
- conflicts and how they were resolved
- verdicts on existing condensed / refined files:
  - keep
  - merge
  - replace
  - treat as canonical synthesis
