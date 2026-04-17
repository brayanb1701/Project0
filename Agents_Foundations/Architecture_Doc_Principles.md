# ARCHITECTURE.md Principles
> Source: "ARCHITECTURE.md" — matklad.github.io
> Augmented for LLM agent contexts

**Legend:** `P` = Core Principle · `E` = Implementation Example · `A` = Agent-specific consideration

---

## Why It Exists

`P` **The bottleneck is navigation, not capability.** Writing a patch takes 2x longer when unfamiliar with a project; finding *where* to make the change takes 10x longer. An ARCHITECTURE file bridges that gap.

`A` **Agents have no persistent mental map.** A human contributor builds intuition over time. An agent starts cold every run. ARCHITECTURE.md is the only persistent orientation it gets — it must compensate for the absence of accumulated context.

`P` **A map, not an atlas.** Describe coarse-grained structure and relationships. Do not document how modules work — that belongs in inline docs or separate files.

---

## What to Write

`P` **Start with a bird's-eye overview of the problem being solved.** Ground the reader before showing structure.

`P` **Write a codemap that answers two questions:** "where is the thing that does X?" and "what does this thing I'm looking at do?"

`A` **Explicitly answer "where does new code go?"** Humans infer this from convention and osmosis. Agents generating new files need an explicit rule — otherwise they extrapolate from the nearest existing pattern, which may be wrong or inconsistent.

`P` **Name important files, modules, and types explicitly.** High-value, low-maintenance orientation. Do not link to them — links go stale. Use names and encourage symbol search.

`A` **State naming conventions in the codemap.** Agents pattern-match on names when deciding where to place things. Consistent, documented naming conventions directly reduce misplacement.

`P` **Explicitly state architectural invariants, especially absences.** Important constraints are often expressed as what *doesn't* exist or *doesn't* depend on something else — invisible from reading code alone.

`A` **Tie each invariant to its mechanical enforcement.** Stating "X never depends on Y" is good. Stating "X never depends on Y — enforced by `lint:deps`" is better. Agents can then verify compliance and understand the failure mode when they violate it.

`P` **Call out layer and system boundaries.** A boundary constrains all possible implementations behind it. Boundaries have measure zero — nearly impossible to discover by reading code randomly.

`A` **Make dependency direction explicit and unambiguous.** When an agent writes new code, it needs to know exactly what it can and cannot import from its current layer. Vague descriptions produce architectural drift at scale.

`P` **Add a dedicated section on cross-cutting concerns.** Things that cut across modules (auth, logging, telemetry, error handling) deserve explicit treatment separate from the codemap.

`A` **For cross-cutting concerns, name the exact injection point.** Agents hooking in telemetry or auth need to know the single correct place — not discover it by reading usage patterns across the codebase.

`A` **Include the rationale for key decisions, not just the decision.** Agents asked to modify or extend the architecture benefit from knowing *why* a constraint exists. Without rationale, a "helpful" agent may refactor away a load-bearing invariant.

---

## Maintenance

`P` **Only specify things unlikely to frequently change.** The goal is a document that stays valid without active effort.

`P` **Shorter = more durable.** Length increases staleness risk and maintenance burden.

`A` **Let agents maintain ARCHITECTURE.md as part of their workflow.** Don't schedule periodic human reviews — instead, have agents check whether their changes affect anything described in ARCHITECTURE.md. During PR review, flag drift. At the end of tasks that touch referenced modules or boundaries, update the doc as part of the task itself. The document stays fresh because the agents that change the code also own the map.

`A` **Staleness is silent for agents.** A human notices when a doc contradicts the code. An agent trusts the stale version and generates code based on a false model. Agent-driven maintenance (above) solves this at the source.

---

## Anti-Patterns

- Linking directly to files or symbols — use names + symbol search instead
- Documenting *how* modules work — belongs in inline docs
- Making it long — increases staleness and reduces reading compliance
- Skipping invariants because they seem obvious — absences are invisible from code
- Omitting boundaries because they're implicit — they're nearly impossible to find otherwise
- Stating invariants without referencing their enforcement — agents can't verify what they can't locate
- Omitting "where does new code go" — agents will guess, and guesses compound into drift
- Omitting rationale for constraints — agents may optimize them away as unnecessary complexity
