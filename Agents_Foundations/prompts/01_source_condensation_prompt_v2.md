# Source Condensation Prompt v2

Use this for **one source at a time** when the goal is to preserve nearly everything useful in a compact, agent-friendly format.

Do **not** use this prompt to produce the final invariant layer across many sources. That is a different task and has a different prompt.

---

## Goal

Extract all meaningful knowledge from a single source while preserving:

- transferable principles
- source-specific implementations and facts
- scope qualifiers and caveats
- agent-specific implications
- failure modes / anti-patterns

Condense words, **not ideas**.

---

## Rules

### 1. Keep source fidelity above elegance
Do not smooth away edge cases, metrics, caveats, or “this only worked here” qualifiers just because they make the summary less clean.

### 2. Separate principle from evidence
Tag each item as one of:

- `P` — transferable principle, rule, or design belief
- `E` — example, case-study detail, implementation, metric, or fact from this source
- `A` — agent-specific implication or adjustment
- `Q` — scope qualifier, limit, caveat, or non-generalization note

Use `Q` whenever a source says or strongly implies “this depends”, “this may change”, “this is not universal”, or “this only worked under these conditions”.

### 3. Preserve facts explicitly
Numbers, named tools, concrete workflows, sequence order, and case-study outcomes are never “minor details” if they anchor the claim.

### 4. Group by theme, not source order
Reorganize for usefulness, but do not silently merge distinct ideas.

### 5. Preserve uncertainty
If the source is speculative, note-like, anecdotal, or self-contradictory, say so in `Q` items.

### 6. End with anti-patterns
Include explicit warnings and implied failure modes.

---

## Agent-specific augmentation

After extraction, review each principle through the agent lens:

- what becomes fragile when the reader is an agent, not a human?
- where is the silent failure mode?
- what exact placement rule or injection point would an agent need?
- what could be enforced mechanically?
- what would go stale and therefore should be agent-maintained?

Only add `A` items when they materially improve actionability.

---

## Output format

```md
# [Topic]
> Source: [file]
> Purpose: source-local condensation
> Source type: [primary / refined synthesis / condensed / notes]
> Authority: [high / medium / low]
> Staleness risk: [low / medium / high]

**Legend:** `P` = Principle · `E` = Example / Fact · `A` = Agent-specific · `Q` = Qualifier

---

## [Theme]

`P` **...**
`Q` ...
> `E` ...
`A` ...

---

## Anti-Patterns

- ...
```

---

## Important boundary

A source-local condensation is **not** yet the invariant layer.  
Do not turn source-specific tactics into universal rules unless the source itself clearly does so.
