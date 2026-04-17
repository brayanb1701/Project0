# Knowledge Extraction & Condensation Prompt

## Prompt

You are given a document or text. Your task is to extract and condense all meaningful knowledge from it, then improve the result for LLM agent contexts.

This is a two-phase process: **Extract**, then **Augment**.

---

### Phase 1: Extract & Condense

Follow these rules strictly:

**1. Separate principles from implementations.**
Every insight must be tagged as one of:
- `P` — Core Principle: a universal, transferable idea, rule, or belief. The "what" and "why."
- `E` — Implementation Example: how a specific team/project applied a principle. Useful as reference, not prescription. Always subordinate to its parent principle.

**2. Be maximally concise.**
Cut every word that doesn't carry information. No filler, no restatements, no transitions. One principle = one tight sentence or two. If an idea can't be stated in under three sentences, it isn't condensed enough.

**3. Group by theme, not by source structure.**
Don't follow the original document's order if a better logical grouping exists. Surface the underlying structure of the knowledge, not the structure of the text.

**4. Preserve all distinct ideas.**
Condensing means fewer words, not fewer ideas. Nothing that appears once in the source should be silently dropped — if it's worth capturing, tag it; if it's redundant, omit it explicitly by merging it into a broader principle.

**5. End with an anti-patterns list.**
Close the document with a flat checklist of things explicitly warned against or implied as failure modes in the source.

---

### Phase 2: Augment for LLM Agents

After completing Phase 1, review every principle through the lens of LLM agent operation. For each principle, ask:

- **Does this change when the reader is an agent, not a human?** If yes, add an `A` (Agent-specific) tag with the adjusted or additional consideration.
- **Is there a silent failure mode for agents?** Humans notice contradictions, infer conventions, and accumulate context across sessions. Agents don't. Call out where this matters.
- **Can this be tied to mechanical enforcement?** Agents benefit from knowing not just the rule but where the rule is enforced (linter, CI, test). Add this if relevant.
- **Does this need an explicit "where to act" answer?** Agents need exact injection points, placement rules, and naming conventions — not just conceptual descriptions.
- **Should agents maintain this knowledge themselves?** If a principle concerns documentation or knowledge that could go stale, consider whether agents should update it as part of their own workflow (during review, at task completion) rather than relying on periodic human maintenance.

Use the following reference principles when reasoning about agent-specific additions (do not include these verbatim — they inform your thinking):

- Agents start cold every run — no persistent mental map
- Context is finite — maps beat manuals, progressive disclosure beats exhaustive loading
- If it's not in the repo, it doesn't exist for the agent
- Agents trust what they read silently — staleness is a silent corruption vector
- Explicit beats implicit — conventions, directions, rationale must be stated
- Error messages are agent instructions — write them to remediate
- Agents replicate existing patterns including bad ones — encode the right pattern once
- Unexplained constraints get optimized away — always include rationale
- Mechanical enforcement beats documented rules

---

## Output Format

Use this structure:

```
# [Topic] Principles
> Source: [document name or description]
> Augmented for LLM agent contexts

**Legend:** `P` = Core Principle · `E` = Implementation Example · `A` = Agent-specific consideration

---

## [Theme 1]

`P` **[Principle title].** [One or two sentence explanation.]

`A` **[Agent consideration].** [How this changes or matters specifically for agents.]

`P` **[Principle title].** [One or two sentence explanation.]

> `E` [Specific implementation detail, indented as a quote block.]

---

## [Theme 2]
...

---

## Anti-Patterns

- [Thing to avoid]
- [Thing to avoid — agent-specific failure mode noted if relevant]
...
```

---

## Input

Apply this to the following:

[PASTE TEXT OR FILE CONTENT HERE]
