# Source Weighting and Output Contract

## Why this exists

The first extraction prompt was good for **single-source condensation**.  
It was not sufficient for **multi-source invariant synthesis**.

The main failure mode was flattening unlike things together:

- primary sources
- note-like fragments
- user-refined syntheses
- source-local condensed summaries

Those should not carry equal weight.

---

## Source roles

### 1. Primary
Direct article, essay, talk transcript, or substantive first-order note from the original author/source.

Use as the strongest evidence for what a source actually claims.

### 2. User-refined synthesis
A manually iterated principles document or refined memo that the user intentionally evolved.

This is not “raw evidence” in the same way as a primary source, but it may still deserve **high practical weight** if the user says it reflects settled thinking.

### 3. Source-local condensation
A compressed file derived from another source, usually intended to preserve content in a tighter format.

Useful for:
- quick recall
- checking what was preserved
- style examples

Do not let it override the primary source unless the user explicitly says it should.

### 4. Notes / fragment
Conference notes, tweet captures, partial fragments, or truncated working notes.

Useful as:
- hypothesis generators
- supporting evidence
- candidate principles

Do not promote note-only ideas into core invariants without corroboration or explicit experimental labeling.

---

## Stability classes

### Core
Current invariant worth encoding into the repo as a stable default.

### Default
Strong current default. Usually right today, but likely to evolve as models, harnesses, or workflows change.

### Conditional
Depends on risk tier, repo type, application type, or supervision model.

### Experimental
Promising but immature. Keep visible, but do not present as settled.

---

## Output contract

The synthesis should produce four different kinds of output.

### 1. Principles
Stable or reusable defaults.  
These are the closest thing to “invariants”.

### 2. Playbooks
Current best-known process patterns.  
These should be expected to change as workflows evolve.

### 3. Reviews
Assessment of prior condensed / refined artifacts according to their intended role.

### 4. Traceability
Best-effort evidence chain from canonical item back to source support.

---

## Conflict handling

When two sources disagree:

1. prefer user-marked higher-weight sources
2. prefer primary over derived
3. prefer refined synthesis over raw condensation when the user says it reflects deliberate iteration
4. turn scope mismatches into conditional rules instead of fake consensus
5. if still unresolved, record the conflict explicitly

---

## What should be emphasized more than before

### Modularity and layered complexity
The synthesis should actively look for:
- small legible core
- layers on top of that core
- bounded modules
- explicit dependency directions
- named injection points
- clear “where does new code go?” rules

### Controllability over raw throughput
Track throughput, but optimize for:
- manageability of the codebase
- reviewability
- supervision level
- autonomy maturity
- defect containment

### Mutable invariants
Treat invariants as versioned stable defaults, not eternal truths.
The right question is not “will this ever change?”  
It is “should we encode this as the current operating truth now?”
