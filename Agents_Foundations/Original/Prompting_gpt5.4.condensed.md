---
title: "GPT-5.4 Prompting Patterns for Agents and Long-Running Workflows"
source: "Prompting_gpt5.4.md"
source_type: documentation
tags: [prompt-engineering, agent-design, tool-use, context-management, evaluation, orchestration]
domain: software-engineering
extracted: "2026-04-09"
summary: "GPT-5.4 performs best when prompts make output contracts, tool discipline, completion rules, citation boundaries, and reasoning-effort choice explicit. The guide is mainly about reliable long-running agents, coding workflows, research tasks, and prompt migration."
key_concepts: [output-contracts, tool-persistence, completeness-and-verification, phase-and-compaction, reasoning-effort, migration-and-small-models]
applicability: bounded
preset: prescriptive
---

**Schema:** Core
**Legend:** `K` = Key Claim · `S` = Support · `X` = Scope / Qualifier · `E` = Evidence / Example · `A` = Agent-Specific
**Preset:** Prescriptive

---

## Model Strengths and Failure Patterns

`K` **GPT-5.4 is strongest on long-running, production-grade assistant work.** It sustains multi-step execution, adheres to style/personality more consistently, handles long-context synthesis well, and performs strongly on evidence-rich/tool-heavy workflows.

`E` Strong areas called out: long-context analysis, modular/skill-based prompts, parallel tool use, spreadsheet/finance workflows, disciplined execution over long horizons.

`K` **Explicit prompting still matters in predictable weak spots.** The model benefits from extra structure for early-session tool routing, dependency-aware workflows, research with citation discipline, irreversible actions, and coding/terminal environments with strict tool boundaries.

`X` The guide frames these as observed defaults, not guarantees; start with the smallest prompt that passes evals, then add blocks only for measured failures.

---

## Core Prompt Controls

`K` **Use explicit output contracts to control both brevity and shape.** State exact sections/order, scope length limits to the intended section, and require emitting only the requested format when parse sensitivity matters.

`K` **Define a default follow-through policy.** Proceed on clear, low-risk, reversible next steps; ask only for irreversible actions, external side effects, or missing sensitive/decision-critical input.

`K` **Make instruction priority explicit.** User instructions override earlier style/format defaults, but not higher-level safety/privacy constraints; newer user instructions override older conflicting ones.

`K` **Handle mid-conversation task changes with scoped update blocks.** State scope, override, and carry-forward rules explicitly, especially when switching from execute -> plan/review-only.

`A` GPT-5.4 responds well to block-structured prompts where each control has a narrow job and clear local scope.

---

## Tool Use, Dependencies, and Completion

`K` **Make tool persistence explicit when correctness depends on it.** Instruct the model to keep calling tools until the task is complete and verification passes; retry with alternate strategies on partial/empty results.

`K` **Dependency checks reduce “obvious end-state” errors.** Require prerequisite discovery/lookups before action, even if the intended final action seems clear.

`K` **Parallelize only independent evidence gathering.** Use parallel retrieval for independent lookups, then synthesize before further calls; do not parallelize dependency chains or irreversible paths.

`K` **Long-horizon tasks need an explicit completeness contract.** Track required deliverables internally, confirm coverage for lists/batches/pages, and mark items `[blocked]` with exact missing inputs.

`K` **Add empty-result recovery.** Treat empty/narrow results as suspicious until at least one or two fallback searches or alternate sources have been tried.

`K` **Always run a lightweight verification loop before finalizing.** Check requirement coverage, grounding, formatting, and whether permission is needed before any external side effect.

`K` **Missing context should trigger lookup before questions when retrievable.** If context cannot be retrieved, ask minimally or proceed only with explicit assumptions and reversible actions.

`E` Suggested action frame for active agents: pre-flight summary -> tool execution -> post-flight confirmation/validation.

---

## Research, Grounding, and Structured Outputs

`K` **Research tasks benefit from a disciplined 3-pass mode.** Plan 3-6 subquestions -> retrieve each plus 1-2 second-order leads -> synthesize with contradiction resolution and citations.

`X` Use research mode for research/review/synthesis, not short deterministic execution tasks.

`K` **Lock source boundaries and citation format.** Cite only sources retrieved in the current workflow, never invent references, and attach citations to the specific claims they support.

`K` **Grounding rules should distinguish fact from inference.** Base claims only on provided context/tool outputs, label conflicts explicitly, and mark unsupported conclusions as inferences or abstain.

`K` **Clamp parse-sensitive outputs aggressively.** For JSON/SQL/XML-like outputs: output only the target format, validate balance, avoid invented schema elements, and return an explicit error if required schema is missing.

`K` **OCR/bbox tasks need coordinate and drift contracts.** Define exact coordinate system, required fields, vertical-drift checks, and page-by-page fallback for dense layouts.

---

## Coding-Agent Patterns

`K` **Coding prompts should default toward execution, not endless planning.** Unless the user clearly asks for brainstorming/planning/explanation only, the model should implement changes and carry the task through verification.

`K` **Intermediary updates should be sparse and outcome-based.** Send short progress updates at major phase changes, avoid narrating routine tool calls, and keep the user informed roughly every 30 seconds during longer work.

`K` **Clamp final formatting if you want clean answers.** GPT-5.4 may over-structure by default; explicitly ban nested bullets and constrain numbered-list style when needed.

`K` **Terminal tool hygiene should stay explicit.** Run shell only via the terminal tool, do not fake tool usage with bash, prefer edit/patch tools for file changes, and do a lightweight verification step after edits.

`X` Extra frontend rules are optional and only worth including when frontend/design quality is central to the task.

`A` For coding harnesses, pair autonomy/persistence with explicit commentary-channel update rules and strict tool-boundary instructions.

---

## Runtime and Session Contracts

`K` **Preserve assistant `phase` in long-running/tool-heavy flows.** Missing or dropped `phase` can cause preambles or intermediate commentary to be mistaken for final answers.

`S` `phase` is optional at API level but strongly recommended for GPT-5.4, `gpt-5.3-codex`, and later Responses models when replaying assistant history manually.

`X` Do not attach `phase` to user messages; if using `previous_response_id`, replay is often unnecessary because the platform can recover state.

`K` **Use compaction as opaque session state.** Compact after major milestones, keep prompts functionally identical after compaction, and pass the returned encrypted item forward rather than unpacking/reformatting it yourself.

`K` **Separate persistent personality from per-response writing controls.** Personality sets session-wide tone/decision style; per-response controls set channel/register/format/length for the specific artifact.

`K` **Professional memo mode benefits from explicit synthesis rules.** Require exact names/dates/entities when supported, domain-specific structure when requested, and uncertainty tied to specific missing/conflicting facts.

---

## Reasoning Effort

`K` **Treat reasoning effort as a last-mile tuning knob, not the first fix.** Stronger prompt contracts, tool rules, completeness, and verification often recover quality before higher effort is needed.

| Setting | Best fit |
|---|---|
| `none` | fast execution-heavy or cost/latency-sensitive work with little true reasoning |
| `low` | latency-sensitive tasks that benefit from small extra thinking, especially with complex instructions |
| `medium` / `high` | research-heavy, long-context, conflict-resolution, or long-horizon agent work |
| `xhigh` | only when evals show clear value on very long, reasoning-heavy tasks |

`K` **Default most teams to `none`, `low`, or `medium`.** Start `none` for workflow steps, extraction, triage, short transforms; start `medium` or higher for research-heavy synthesis/review/strategy tasks.

`K` **Before increasing effort, first add structural controls.** The guide explicitly prioritizes `<completeness_contract>`, `<verification_loop>`, and `<tool_persistence_rules>`.

`K` **If the model is too literal or shallow, add an initiative nudge before raising effort.** Instruct it not to stop at the first plausible answer and to look for edge cases/second-order issues.

---

## Migration and Smaller Models

`K` **Migrate to GPT-5.4 one change at a time.** Switch model first, pin `reasoning_effort`, run evals, then iterate.

| Current setup | Suggested GPT-5.4 start | Rationale |
|---|---|---|
| `gpt-5.2` | match current effort | preserve latency/quality profile first |
| `gpt-5.3-codex` | match current effort | keep coding workflow behavior stable |
| `gpt-4.1` / `gpt-4o` | `none` | preserve snappy behavior; raise only if evals regress |
| research-heavy assistants | `medium` / `high` | pair with research mode + citation gating |
| long-horizon agents | `medium` / `high` | add tool persistence + completeness accounting |

`K` **`gpt-5.4-mini` is more literal and needs more scaffolding.** Put critical rules first, specify exact execution order, define ambiguity behavior, separate action from report, and package outputs explicitly.

`E` Recommended mini prompt order: task -> critical rule -> exact step order -> edge cases/clarification behavior -> output format -> one correct example.

`K` **Do not over-prompt `gpt-5.4-nano` into doing planning-heavy work.** Use it only for narrow, closed, well-bounded outputs; escalate ambiguous/planning tasks to a stronger model.

`K` **Research-agent migrations should add prompt structure before extra reasoning.** Add research mode, citation rules, and empty-result recovery, then increase `reasoning_effort` by only one notch if needed.

---

## Anti-Patterns

- Raising `reasoning_effort` before fixing missing output contracts, tool rules, or verification gaps
- Letting intermediate commentary or preambles be replayed without preserving `phase`
- Treating empty search results as final without fallback queries or alternate sources
- Using generic “be careful” language instead of explicit dependency, completeness, and verification blocks
- Leaving citation format or source boundaries implicit on research tasks
- Letting coding agents narrate tool calls instead of giving short, high-signal progress updates
- Relying on implicit workflow inference for `gpt-5.4-mini` or pushing orchestration-heavy work onto `gpt-5.4-nano`
