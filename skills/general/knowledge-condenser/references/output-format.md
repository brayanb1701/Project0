# Output Format Specification

## Frontmatter Schema

Every condensed knowledge file starts with a YAML frontmatter block. This block is the "card catalog entry" — agents read only this to decide whether to load the full document.

```yaml
---
title: "<descriptive title of the extracted knowledge>"
source: "<original document name, file path, or URL>"
source_type: "<article|report|conversation|documentation|book|video_transcript|code|mixed>"
tags: [<tag1>, <tag2>, ...]          # from tag taxonomy below
domain: "<primary domain>"            # broadest applicable category
extracted: "<YYYY-MM-DD>"
summary: "<1-2 sentences — the single most important takeaway and scope of content>"
key_concepts: [<concept1>, <concept2>, ...]  # 3-7 top-level concepts for quick scanning
---
```

### Required Fields

| Field | Purpose | Example |
|---|---|---|
| `title` | Descriptive name | `"API Design Principles"` |
| `source` | Origin reference | `"path/to/doc.md"` or `"Clean Code Ch.3"` |
| `source_type` | Content classification | `article`, `documentation`, `conversation` |
| `tags` | Categorization | `[api-design, rest, backend]` |
| `domain` | Broadest category | `software-engineering` |
| `summary` | Key takeaway + scope | `"REST API design principles emphasizing..."` |
| `extracted` | Date of extraction | `2026-03-19` |

### Optional Fields

| Field | Purpose | When to include |
|---|---|---|
| `key_concepts` | Top concepts list | When >3 distinct themes extracted |
| `related` | Paths to related knowledge files | When part of a knowledge base |
| `staleness_risk` | `low\|medium\|high` | When content may become outdated |
| `authority` | `primary\|secondary\|tertiary` | When source reliability matters |
| `applicability` | `general\|bounded\|source-specific` | When the source explicitly limits how broadly its lessons apply |
| `preset` | `prescriptive\|ideation\|analytical\|decisional\|narrative\|referential` | Only when a named preset materially shaped the output |

Do not include `density` or `compression_ratio` in normal outputs. If you want them for evaluation, store them separately in eval artifacts or compute them automatically outside the condensed file.

## Tag Taxonomy

Use specific tags from these domains. Combine freely. Prefer specific over general.

### Technical
`coding`, `architecture`, `api-design`, `database`, `devops`, `testing`, `security`, `performance`, `frontend`, `backend`, `infrastructure`, `ml-ai`, `data-engineering`, `mobile`, `systems`

### Process
`project-management`, `agile`, `documentation`, `code-review`, `debugging`, `incident-response`, `planning`, `estimation`

### Domain Knowledge
`finance`, `healthcare`, `legal`, `education`, `science`, `business`, `marketing`, `product`

### Agent-Specific
`agent-design`, `prompt-engineering`, `tool-use`, `context-management`, `orchestration`, `evaluation`

### Meta
`principles`, `patterns`, `anti-patterns`, `decision-framework`, `mental-model`, `tradeoffs`

Create new tags when none fit. Keep them lowercase, hyphenated, 1-3 words.

## Core Schema

The default output schema is a small set of semantic roles that works across mixed documents. Use this unless a named preset clearly improves the result.

| Tag | Meaning | Usage |
|---|---|---|
| `K` | Key Claim | Main point, decision, principle, finding, lesson, requirement, or definition |
| `S` | Support | Rationale, mechanism, process, dependency, chronology, comparison, or consequence supporting a claim |
| `X` | Scope / Qualifier | Assumption, caveat, prerequisite, exception, limitation, audience/time/jurisdiction bound |
| `E` | Evidence / Example | Example, metric, observation, case, or data point that substantiates a claim |
| `Q` | Open Question | Unknown, unresolved issue, future investigation, revisit condition |
| `A` | Agent-Specific | Only when the behavior or implication changes specifically for LLM agents |

Legend rule: include only the tags actually used in the output.

## Optional Presets

Presets are output-shaping shortcuts, not mandatory ontologies. They influence section naming, emphasis, and closing section title. They do not replace the Core schema unless the Referential preset makes tags unnecessary.

| Preset | Use When | Dominant Core Tags | Closing Section |
|---|---|---|---|
| `prescriptive` | The source is mainly norms, standards, or recommendations | `K`, `S`, `X`, `A` | `Anti-Patterns` |
| `ideation` | The source is mainly proposals, future capabilities, and uncertainties | `K`, `X`, `Q` | `Risks & Open Questions` |
| `analytical` | The source is mainly findings backed by evidence | `K`, `E`, `S`, `Q` | `Limitations & Open Questions` |
| `decisional` | The source is mainly choices and tradeoffs | `K`, `S`, `X`, `Q` | `Revisit Conditions` |
| `narrative` | Sequence and experiential lessons materially matter | `K`, `S`, `E`, `Q` | `Key Takeaways` |
| `referential` | Tables, fields, or enumerations are more efficient than tagged sentences | Structured tables / key-value | `Gotchas` |

Rule of thumb: if a document feels mixed, stay with the Core schema and omit `preset`.

## Body Format

The body structure is the same across Core outputs and preset-guided outputs:

```markdown
**Schema:** Core
**Legend:** `[tag1]` = [meaning] · `[tag2]` = [meaning] · ...
**Preset:** [preset-name]   # optional; omit unless it clearly helps a future reader

---

## [Theme 1]

`[tag]` **[Title].** [One-two sentence explanation.]

`[tag]` **[Title].** [Explanation.]

> `[example-tag]` [Specific detail, indented as quote.]

---

## [Theme 2]
...

---

## [Closing Section Title]

- [Item]
- [Item]
```

### Body Rules

1. **No preamble.** Start directly with schema declaration and legend.
2. **No transitions.** Each item stands alone.
3. **No source attribution within body.** Source is in frontmatter.
4. **Tables for comparisons.** When comparing >2 items, use a table.
5. **Inline code for identifiers.** File names, commands, variable names in backticks.
6. **Quote blocks for subordinate items only.** Indented details under a parent item, not emphasis.
7. **Preserve applicability economically.** Assumptions, qualifiers, prerequisites, caveats, exceptions, and scope limits may be compressed, but not omitted when they materially bound a claim.
8. **Keep claim type distinct.** Do not rewrite observations, proposals, hypotheses, decisions, or local practices as universal rules unless the source does.
9. **Prefer Core over cleverness.** If a preset does not clearly simplify the output, omit it.

## Examples

### Example 1: Core Schema with Prescriptive Preset

```markdown
---
title: "REST API Error Handling"
source: "internal/docs/api-standards.md"
source_type: documentation
tags: [api-design, rest, error-handling, backend]
domain: software-engineering
extracted: "2026-03-19"
summary: "Standardized error response format and status code usage for REST APIs. Covers error body structure, retry semantics, and client-facing message guidelines."
key_concepts: [error-response-format, status-codes, retry-semantics, client-messages]
preset: prescriptive
---

**Schema:** Core
**Legend:** `K` = Key Claim · `E` = Evidence / Example · `A` = Agent-Specific
**Preset:** Prescriptive

---

## Error Response Structure

`K` **Single canonical error shape.** Every error response uses `{error: {code, message, details?}}` — no variations.

`A` Agents generating API clients must hardcode this shape; do not infer structure from individual responses.

`K` **Machine code + human message.** `code` is a stable enum for programmatic handling; `message` is a localizable string, never parsed.

> `E` `code: "RATE_LIMITED"`, `message: "Too many requests, retry after 30s"`

---

## Status Codes

| Range | Meaning | Retry? |
|---|---|---|
| 400-499 | Client error | No (except 429) |
| 429 | Rate limited | Yes, with `Retry-After` |
| 500-599 | Server error | Yes, with backoff |

`A` When generating retry logic, always check for `Retry-After` header before applying default backoff.

---

## Anti-Patterns

- Returning 200 with error body → breaks client error detection
- Leaking stack traces in `message` → security risk
- Using string matching on `message` for control flow → breaks on localization
```

### Example 2: Core Schema with Ideation Preset

```markdown
---
title: "Local-First Collaborative Editor"
source: "brainstorm-session-2026-03-15.md"
source_type: conversation
tags: [architecture, collaboration, local-first, crdt]
domain: software-engineering
extracted: "2026-03-19"
summary: "Design concept for a local-first document editor with real-time collaboration via CRDTs. Covers sync architecture, conflict resolution strategy, and offline-first UX."
key_concepts: [local-first, crdt-sync, offline-ux, conflict-resolution, plugin-system]
preset: ideation
---

**Schema:** Core
**Legend:** `K` = Key Claim · `X` = Scope / Qualifier · `Q` = Open Question
**Preset:** Ideation

---

## Core Architecture

`K` **Local-first with CRDT sync.** All edits happen locally; sync via CRDTs eliminates conflict resolution UI. Server is optional relay, not authority.

`K` **Offline queue with automatic merge.** Edits accumulate offline → merge on reconnect with no user intervention.

`X` **CRDT payload size.** Operation history grows unbounded → need compaction strategy for documents >10k operations.

---

## Collaboration Model

`K` **Presence without accounts.** Show cursors/selections of peers via ephemeral session tokens. No login required for read/edit in shared sessions.

`K` **Branch-and-merge for async work.** Fork a document version, edit independently, merge back — git-like but for rich text.

`Q` How to handle semantic conflicts (e.g., two users restructure same section differently)? CRDTs resolve syntactically but not semantically.

---

## Extension System

`K` **Plugin API for custom block types.** Third-party blocks (diagrams, embeds, code cells) via sandboxed iframes with message-passing protocol.

`X` **Plugin sandbox must prevent DOM access** to host document → security boundary.

---

## Risks & Open Questions

- CRDT library maturity — Yjs vs. Automerge vs. custom? Evaluate performance at 100+ concurrent editors
- Revenue model unclear if server is optional
- `Q` How to handle permissions granularity below document level?
```
