---
name: Knowledge Condenser
description: This skill should be used when the user asks to "extract knowledge", "condense this text", "summarize for agents", "create a knowledge file", "compress this document", "extract principles", "distill this", or provides text/files to be converted into token-efficient knowledge representations for LLM agent consumption.
version: 0.3.1
---

# Knowledge Condenser

Extract, condense, and structure knowledge from any text source into token-efficient representations optimized for LLM agent consumption. Output includes machine-readable metadata for discoverability and a compressed body preserving all distinct ideas.

## When to Use

- Extracting reusable knowledge from articles, reports, conversations, documentation
- Creating agent-readable knowledge files from verbose source material
- Building a knowledge base where token budget matters
- Converting human-oriented docs into agent-oriented references

## Core Process

### Phase 1: Intake & Schema Selection

1. **Identify source.** Accept text inline, file path, or URL. Record source identifier for metadata.
2. **Classify domain.** Determine primary domain and tags (see tag taxonomy in `references/output-format.md`).
3. **Choose output schema.** Default to the Core schema from `references/output-format.md`. Use a preset only when it clearly improves compression, scanability, or reduces ambiguity relative to plain Core for this source.
4. **Map information roles before compressing.** Separate the source into:
   - primary claims: principles, findings, decisions, lessons, requirements, definitions
   - support structure: rationale, mechanism, procedure, dependency, comparison, chronology
   - applicability signals: assumptions, scope limits, audience, jurisdiction, time bounds, prerequisites, exceptions
   - confidence signals: evidence, examples, metrics, counterpoints, limitations, unresolved questions
   - low-value narrative/setup: scene-setting, repetition, rhetorical framing, stylistic padding

Compression is allowed to delete low-value narrative/setup, not the other four categories. If a detail changes meaning, applicability, confidence, or reconstructability, it is not "mere context."

| Preset | Signals | Use Only When | Closing Section |
|---|---|---|---|
| **Prescriptive** | Best practices, standards, rules, how-to | Most items are normative guidance | `Anti-Patterns` |
| **Ideation** | Plans, proposals, brainstorms, future capabilities | Most items are possibilities, constraints, or unknowns | `Risks & Open Questions` |
| **Analytical** | Research, evaluations, comparisons, postmortems | Most items are findings backed by evidence | `Limitations & Open Questions` |
| **Decisional** | Meeting notes, ADRs, tradeoff records | Most items are choices plus reasons | `Revisit Conditions` |
| **Narrative** | Case studies, interviews, experience reports | Story sequence materially matters | `Key Takeaways` |
| **Referential** | Specs, APIs, schemas, catalogs | Structured tables/key-value are more efficient than tagged sentences | `Gotchas` |

If no preset clearly dominates, stay in the Core schema. Mixed documents should usually remain Core rather than forcing a preset. When in doubt, omit the preset.

See `references/output-format.md` for the Core schema, optional presets, and examples.

### Phase 2: Extract & Compress

Apply these rules strictly, in order:

1. **Assign each item a Core role** unless the Referential preset makes tags unnecessary. Use only the roles actually needed:
   - `K` key claim
   - `S` support: rationale, mechanism, process, dependency, chronology
   - `X` applicability or qualifier: assumptions, caveats, constraints, exceptions, scope
   - `E` evidence or example
   - `Q` open question, unresolved issue, or explicit unknown
   - `A` agent-specific note, only when behavior genuinely changes for agents

2. **Maximize compression ratio.** Cut every word without information content. One item = one tight sentence, two max. If it needs three, it is not condensed enough.

3. **Group by theme, not source order.** Surface the underlying knowledge structure, not the document structure.

4. **Preserve all distinct ideas.** Fewer words, not fewer ideas. Nothing silently dropped — merge redundancies explicitly into broader items.

5. **Preserve source faithfulness.** Do not strengthen, universalize, or clean up the source's uncertainty:
   - keep modality: "can", "may", "often", "suggests", "appears", "in this case", "so far"
   - keep applicability: if the source limits who, when, where, or under what conditions a claim holds, preserve that
   - keep support structure when it explains the claim: cause -> effect, problem -> response, evidence -> conclusion, premise -> decision
   - keep unresolved uncertainty when it bounds confidence or actionability
   - do not convert descriptive observations into universal prescriptions unless the source clearly does so

6. **Apply symbolic compression.** Use shorthand, symbols, and structured formats where they save tokens without losing clarity:
   - Tables over prose for comparisons/mappings
   - `→` for implications/consequences
   - `∴` for conclusions
   - Nested bullets over paragraphs
   - Key-value pairs over sentences

7. **Compress examples selectively, not reflexively.** Drop examples only if they are pure illustration. Keep at least one compressed example or evidence anchor when it does one of these:
   - substantiates the claim rather than merely decorating it
   - calibrates magnitude, confidence, frequency, or scale
   - specifies a mechanism, procedure, exception, or edge case the abstract statement would hide
   - narrows applicability or clarifies who/when the claim is for

8. **Close with a flat checklist section.** Use the preset-specific closing title when a preset is chosen; otherwise default to `Notes`, `Risks`, or `Open Questions`, whichever best matches the source.

### Phase 3: Agent Augmentation

Review extracted items through the agent lens. Not every item needs an agent note — add only where behavior genuinely differs. For relevant items, ask:

- Does this change when the reader is an agent? → Add agent note inline
- Silent failure mode for agents? → Call it out (agents don't infer conventions or accumulate cross-session context)
- Mechanical enforcement available? → Note where rule is enforced (linter, CI, test)
- Explicit injection point needed? → Agents need exact file paths, naming conventions, placement rules
- Should agents maintain this knowledge? → Flag if knowledge could go stale and agent should update it during workflow

For ideation- or narrative-heavy sources, agent augmentation is often minimal — focus it on actionability (what would an agent need to do differently?) rather than repeating the source.

### Phase 4: Faithfulness Audit

Before formatting the final output, run this short audit:

1. **Reconstructability check.** Can a fresh reader recover the source's main claims, support structure, and material limits from the condensed file alone?
2. **Applicability check.** Did any explicit assumption, exception, scope limiter, audience qualifier, or time bound disappear?
3. **Support-structure check.** If the source justified a claim via reasoning, evidence, process, dependency, chronology, or causality, is that structure still present?
4. **Evidence check.** Is at least one anchor example or evidence signal preserved where otherwise the output would become an unsupported slogan?
5. **Claim-type check.** Did any local observation, tentative finding, proposal, or hypothesis become a settled rule by accident?
6. **Narrative trim check.** If something was dropped, was it actually setup or repetition rather than a support, applicability, or confidence signal?

If any answer is "no," revise before saving.

### Phase 5: Metadata & Output

Generate complete output with frontmatter metadata header and compressed body. Follow the exact format specification in `references/output-format.md`.

The frontmatter serves as a "card catalog entry" — other agents read only this block to decide whether to load the full document. Optimize it for stable retrieval metadata, not derived statistics.

When the source contains strong scope or generalization limits, include `applicability` in frontmatter (see `references/output-format.md`).
Only include `preset` in frontmatter when a named preset materially shaped the output and is useful to a future reader.
Do not include `density` or `compression_ratio` in normal outputs. Those are eval metrics, not default metadata.

### Phase 6: Save

Save the condensed output to a file automatically after generation.

**File naming:** `<source_filename_without_ext>.condensed.md`

**Location rules (in priority order):**
1. If user specifies a path → use that path exactly.
2. Otherwise → save in the same directory as the source file.

For inline text with no source file, ask the user where to save.

## Compression Principles

These govern all extraction decisions:

- **Density over length.** A 200-token output from a 2000-token source with zero information loss is ideal.
- **Structure is compression.** Tables, hierarchies, and key-value pairs encode relationships that prose wastes tokens describing.
- **Redundancy is the enemy.** If two sentences convey the same idea in different words, keep the more precise one.
- **Context is expensive.** Do not repeat what is already in the metadata frontmatter within the body.
- **Rationale survives.** The "why" behind a rule is often more valuable than the rule itself — never drop rationale to save tokens.
- **Applicability survives.** Caveats, assumptions, scope notes, exceptions, and audience/time bounds are high-information tokens, not optional hedging.
- **Support structure survives.** If a claim depends on rationale, evidence, process, dependency, chronology, or causality, keep that linkage.
- **Narrative is compressible; epistemics are not.** Setup can shrink aggressively. Confidence, uncertainty, and applicability cannot.
- **Do not over-normalize.** Preserve whether the source is reporting, proposing, deciding, specifying, or prescribing.

## Evaluation & Iteration

This skill is designed for iterative improvement. After each use:

1. **Measure compression ratio**: `source_tokens / output_tokens`. Target: 3:1 minimum for prose, 2:1 for already-dense technical content.
2. **Check information preservation**: Can the original document's key decisions, recommendations, and warnings be reconstructed from the output alone?
3. **Test agent utility**: Give the output to a fresh agent session — can it answer questions about the source material accurately?
4. **Identify leakage**: Look for filler words, redundant framing, verbose transitions that survived compression.
5. **Check applicability fidelity**: Verify that assumptions, qualifiers, and scope limits were preserved when present.
6. **Check support-structure fidelity**: Verify that major claims still retain the rationale/evidence/process links that made them true.

See `references/eval-guide.md` for the full evaluation framework and iteration methodology.

## Additional Resources

### Reference Files

- **`references/output-format.md`** — Complete output format specification with frontmatter schema, tag taxonomy, and examples
- **`references/eval-guide.md`** — Evaluation framework, metrics, iteration workflow, and ideas for building automated evals
