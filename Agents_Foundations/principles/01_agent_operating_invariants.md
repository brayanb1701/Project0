# Agent Operating Invariants
> Purpose: current invariant layer
> Scope: cross-cutting rules for agent-oriented software work
> Status markers: `Core` / `Default` / `Conditional` / `Experimental`

**Legend:** `P` = Principle · `E` = Example / Fact · `A` = Agent-specific

---

## Context, Memory, and Knowledge

`[OI-01][Core]` `P` **Agents start cold every run.** Assume no accumulated intuition, no remembered conventions, and no durable mental map. Every important artifact must re-orient a fresh agent within a constrained context window.

`[OI-01.A]` `A` Cold-start makes orientation a runtime requirement, not documentation polish.

`[OI-02][Core]` `P` **Context is scarce; maps beat manuals.** Use short entry points, progressive disclosure, and pointers to deeper artifacts instead of giant front-loaded instruction blobs.

`[OI-03][Core]` `P` **If the knowledge is not repo-local or bundled with the runtime, it does not reliably exist for the agent.** Load-bearing decisions should be encoded as versioned markdown, schemas, plans, scripts, or skill assets.

`[OI-04][Core]` `P` **Staleness is a silent corruption vector.** Agents usually trust stale documents instead of noticing contradictions. Any document that an agent depends on should be checked and updated as part of the work that touches it.

---

## Explicitness and Placement

`[OI-05][Core]` `P` **Explicit beats implicit.** Conventions, dependency directions, naming rules, placement logic, and rationale should be stated directly instead of being left to team osmosis.

`[OI-06][Core]` `P` **Always answer “where does new code go?”** New modules, files, handlers, and types need explicit placement rules. Otherwise agents copy the nearest visible pattern, including accidental or outdated ones.

`[OI-06.A]` `A` Placement rules should name the layer, directory, interface, or file pattern — not just the concern.

`[OI-07][Core]` `P` **State the injection point and the rationale.** A concern without a named integration point is hard to act on; a rule without rationale is easy for an optimizing agent to remove.

---

## Enforcement and Drift

`[OI-08][Core]` `P` **Mechanical enforcement beats prose.** Important rules should become linters, structural tests, CI checks, templates, or hooks wherever possible.

`[OI-09][Core]` `P` **Error messages are agent instructions.** Diagnostics should tell the agent not only what failed, but how to fix it and where to do so.

`[OI-10][Core]` `P` **Agents replicate existing patterns, including bad ones.** Whatever is common in the codebase becomes the template. Encode the preferred pattern once and enforce it continuously.

`[OI-11][Default]` `P` **Drift should be paid down continuously, not in occasional cleanup campaigns.** Background scanning, small refactors, and pre-submission normalization keep entropy from compounding.

---

## Invariants About the Invariants

`[OI-12][Core]` `P` **Treat invariants as versioned stable defaults, not eternal truths.** A useful invariant is something worth encoding as the current operating truth now; it may still change when models, harnesses, or product needs change.

`[OI-13][Default]` `P` **Separate invariant layer from playbook layer.** Stable repo/architecture defaults belong in principles; evolving workflows, supervision routines, and current tactics belong in playbooks.

`[OI-14][Conditional]` `P` **Risk changes the operating mode.** Prototypes, MVPs, and exploratory work can tolerate looser rules and higher autonomy. Critical, cross-cutting, or safety-relevant work requires tighter review and stronger guardrails.

---

## Anti-Patterns

- Treating a long chat transcript as if it were durable project memory.
- Hiding load-bearing decisions in Slack, tickets, or human memory.
- Leaving boundaries, placement rules, or rationale implicit.
- Writing policy only in prose and expecting it to survive scale.
- Presenting current workflow habits as if they were timeless invariants.
