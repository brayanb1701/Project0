# Evaluation & Iteration Guide

## Why Evaluate

Knowledge condensation has a fundamental tension: compression vs. fidelity. Without measurement, the output drifts toward either verbose paraphrasing (low compression) or lossy summarization (lost details). Evaluation closes this loop.

## Metrics

### 1. Compression Ratio (CR)

```
CR = source_tokens / output_tokens
```

| Source Type | Target CR | Notes |
|---|---|---|
| Prose (articles, reports) | 3:1 – 8:1 | High redundancy in natural language |
| Technical docs | 2:1 – 4:1 | Already denser, less compressible |
| Conversations | 5:1 – 15:1 | Extremely redundant (greetings, hedging, repetition) |
| Code comments/READMEs | 2:1 – 3:1 | May already be concise |

Measure with: `echo "SOURCE_TEXT" | wc -w` vs output word count (approximate token proxy).

### 2. Information Preservation Score (IPS)

Manual or LLM-assisted check. Extract N key claims from the source, then verify each appears in the output:

```
IPS = claims_preserved / total_claims
```

Target: **≥0.95** (lose <5% of distinct ideas).

**Methodology:**
1. Have one agent extract 10-20 key claims from the source as a flat list
2. Have a separate agent check each claim against the condensed output
3. Claims not found → information loss. Log which claims were lost and why.

When building the claims list, include not just headline ideas but also:
- applicability signals: caveats, assumptions, scope limits, audience/time/jurisdiction bounds
- support structure: rationale, evidence, process, dependency, chronology, or causal links behind major claims
- claim qualifiers: whether a statement is observed, proposed, tentative, normative, or unresolved
- limitations and open questions when the source contains them

### 3. Agent Utility Score (AUS)

Functional test: can a fresh agent session answer questions using only the condensed output?

1. Generate 5-10 questions from the source material (mix of factual, inferential, procedural)
2. Give only the condensed output to a fresh agent
3. Have the agent answer the questions
4. Score accuracy: `correct_answers / total_questions`

Target: **≥0.85** accuracy.

### 4. Filler Ratio (FR)

Count tokens in the output that carry no information: transitions, hedging, redundant framing, filler phrases.

```
FR = filler_tokens / total_output_tokens
```

Target: **≤0.05** (under 5% filler).

Common filler patterns to flag:
- "It's important to note that..." → delete, just state the thing
- "In other words..." → merge with prior statement
- "As mentioned above..." → remove back-reference
- "Generally speaking..." → remove hedge or make specific

### 5. Applicability Fidelity Score (AFS)

Check whether the output preserves the source's applicability limits and material qualifiers.

```
AFS = applicability_items_preserved / total_applicability_items
```

Applicability items include:
- explicit caveats, assumptions, prerequisites, and exceptions
- audience, jurisdiction, or time bounds
- phrases that limit generality, such as "typically", "in this context", "for X only", "as of now"
- statements that a claim is context-bound, conditional, or non-generalizable

Target: **1.0** when such items exist.

### 6. Support-Structure Fidelity Score (SSFS)

Check whether major claims still retain the structure that supports them.

```
SSFS = support_links_preserved / total_support_links
```

Examples:
- evidence -> conclusion
- premise -> decision
- problem -> response
- process step -> outcome
- cause -> effect

Target: **≥0.9**.

### 7. Metadata Completeness

Check frontmatter against required fields in `output-format.md`:

```
MC = filled_required_fields / total_required_fields
```

Target: **1.0** (all required fields present).

Do not treat `density` or `compression_ratio` as metadata completeness requirements. They are evaluation metrics and should remain outside the normal condensed artifact unless computed automatically and reliably.

## Iteration Workflow

### After Each Use

1. **Quick check (30s):** Scan output for obvious filler, missing themes, broken formatting.
2. **CR check:** Is the ratio within target range for this source type?
3. **Spot-check claims:** Pick 3 specific details from the source — are they in the output?
4. **Spot-check applicability:** Pick 1 qualifier, assumption, exception, or scope limiter from the source — is it still present?

### Periodic Deep Eval (Every 5-10 Uses)

1. Run full IPS on one output using the two-agent methodology above.
2. Run AFS and SSFS on the same output.
3. Run AUS with question generation.
4. Compare CR across outputs — is it improving or regressing?
5. Review anti-patterns list — are the same filler patterns recurring?

### Updating the Skill

Based on eval findings, update the skill:

| Finding | Action |
|---|---|
| Low CR, output too verbose | Add specific compression rules to SKILL.md Phase 2 |
| Lost information (low IPS) | Tighten "preserve all distinct ideas" rule, add examples of what gets lost |
| Applicability lost (low AFS) | Strengthen rules for assumptions, qualifiers, and scope limits |
| Support structure lost (low SSFS) | Strengthen preservation of rationale/evidence/process/dependency links |
| Agent can't answer questions (low AUS) | Check if context/rationale is being dropped; strengthen "rationale survives" principle |
| Recurring filler patterns | Add patterns to explicit filler blocklist |
| Missing metadata fields | Update frontmatter template with better defaults/examples |
| Tags too generic | Expand tag taxonomy in `output-format.md` |

## Building Automated Evals

For systematic iteration, build a lightweight eval pipeline:

### Structure

```
evals/
├── sources/           # Original documents (input)
│   ├── source-01.md
│   └── source-02.md
├── outputs/           # Condensed outputs (generated)
│   ├── output-01.md
│   └── output-02.md
├── claims/            # Extracted claims per source (ground truth)
│   ├── claims-01.json # [{claim: "...", id: 1}, ...]
│   └── claims-02.json
├── questions/         # Generated questions per source
│   ├── questions-01.json
│   └── questions-02.json
└── results/           # Eval scores per run
    └── run-YYYY-MM-DD.json
```

### Eval Script Pseudocode

```
for each source:
  1. Run knowledge-condenser skill → output
  2. Calculate CR (source tokens / output tokens)
  3. Load claims file → check each against output → IPS
  4. Check applicability items against output → AFS
  5. Check support links against output → SSFS
  6. Load questions → feed output to fresh agent → score answers → AUS
  7. Count filler tokens → FR
  8. Check metadata completeness → MC
  9. Log all scores to results/
```

### Bootstrapping Claims & Questions

For a new source without ground truth:

1. Feed source to an agent with prompt: "Extract every distinct claim, decision, recommendation, warning, qualifier, limitation, and major support relation (rationale, evidence, process, dependency, chronology, or causality) as a flat JSON array."
2. Manually review and trim the claims list (remove trivial/duplicate claims).
3. Generate questions: "Given these claims, generate 5-10 questions that test whether someone who only read a summary would know the answers."
4. Save both to `claims/` and `questions/`.

This creates a reusable test fixture. As the skill improves, re-run against the same fixtures to measure progress.

## Compression Technique Experiments

Track which techniques improve CR without hurting IPS:

| Technique | Typical CR gain | Risk |
|---|---|---|
| Tables for comparisons | +15-25% | May lose nuance in edge cases |
| Symbolic operators (→, ∴, ≠) | +5-10% | Readability for humans (agents handle fine) |
| Key-value pairs over prose | +10-20% | Loses narrative flow (usually a feature) |
| Merging related principles | +10-15% | May over-generalize |
| Dropping all examples | +20-40% | Significant IPS loss — keep selective examples |
| Abbreviation glossary | +5-10% | Requires consistent use; adds overhead |

Run A/B: condense same source with and without technique, compare CR and IPS.

## Preset Usefulness

The Core schema is the default. Presets are optional shortcuts and should earn their keep.

### Selection Rule

Start with Core. Choose a preset only when it materially improves one or more of:
- compression ratio
- readability / scanability
- closing section fit
- reduced tag ambiguity

If the document feels mixed, stay Core.

### Preset Fit Eval

When a preset is used, check:

- **Core baseline**: Would a plain Core output be at least as clear with similar length?
- **Unused emphasis**: Does the preset imply a structure the document barely uses?
- **Forced framing**: Did the preset push observations into rules, or rules into observations?
- **Mixed signals**: Does a large share of the document obviously belong to another preset or no preset at all?
- **Token overhead**: Did `preset` metadata or section shaping add tokens without improving retrieval or fidelity?

If yes to any of the last four, drop the preset next time.

### Preset Evolution

Only add a new preset when all of these are true:

- **Recurrence**: The same document shape appears across multiple sources
- **Compression benefit**: The preset consistently beats Core on CR without hurting IPS/AFS/SSFS
- **Semantic clarity**: The preset reduces ambiguity instead of creating it
- **Stable closing section**: The preset implies a reliable closing checklist type

### Promotion Process

1. Prove the pattern across multiple sources with A/B comparisons against Core.
2. Define the preset in `references/output-format.md`.
3. Add the preset-selection rule to `SKILL.md`.
4. Add one example that shows why the preset beats Core for that document family.
