# Draft Oracle Prompt — Iteration 2

**Drafted by**: Claude (Opus 4.6)
**Date**: 2026-04-09
**Status**: Draft for Brayan's review and refinement before sending to Oracle

---

## Prompt begins here

---

# Project0 — Iteration 2 Prompt

## Recap of Iteration 1

In iteration 1, you analyzed my comprehensive brief on Project0 — an agent swarm orchestrator for coding tasks. You produced four artifacts:

- **Foundation recommendation** — chose Option C (thin runtime-agnostic orchestration layer) with Claude Code + Codex as initial backends
- **Backlog and next steps** — proposed an A→F iteration sequence from contract freeze to first demo
- **Parking lot** — deferred ideas organized by category
- **Session handoff** — high-confidence conclusions, open questions, source pattern recommendations

Both I (Brayan) and an independent Claude analyst reviewed your output. The reviews are in `Iterations/Claude/` and my own notes are appended to each of your documents. Key feedback:

1. **Architecture direction accepted** — Option C, runtime-agnostic layer, worktrees, runtime-owned spawning. All confirmed.
2. **Sequencing challenged** — the A→F serial sequence is too documentation-heavy for our timeline. We're adopting a phased approach: working wrappers first (days 1-3), extract abstractions (days 4-7), polish (days 8-14).
3. **Role count reduced** — v0 uses 3 active roles (Planner, Worker, Reviewer), not 6. Architect folds into Planner. Manager folds into Planner. Researcher deferred entirely.
4. **Parking lot flagged as too thin** — the independent analysis identified 30+ specific ideas that were lost or over-summarized. A comprehensive version is needed.
5. **Backend adapter interface deferred** — we'll extract the interface from working code, not design it upfront.
6. **Key missing topics identified** — prompt templates for each role, cost analysis, fellowship demo scope, testing strategy for the orchestrator itself.

## Frozen Decisions

Do not re-debate these. Reference `Iterations/Claude/iteration2_packet.md` Section A for the full list. Summary:

1. Option C via phased A→C implementation
2. Python, using `uv`
3. Claude Code + Codex only for v0
4. Git worktrees by default
5. Runtime owns spawning
6. Markdown + YAML frontmatter for workflow files
7. Three roles: Planner, Worker, Reviewer
8. Active state in `repo/.p0/`, archives in `~/.p0/`
9. Deterministic checks + one reviewer + human escalation
10. Web search fully deferred
11. No bash + internet on same agent
12. Coding orchestration only, one project at a time
13. Synchronous orchestrator for v0
14. No silent retries
15. Anti-drift rules in effect

## Open Questions (Prioritized)

### Critical — resolve in this session

1. **Exact file contract schemas**: What YAML frontmatter fields should each of the 7 file types use? Need precise specifications with field names, types, required/optional, and complete examples.

2. **Prompt templates for v0 roles**: What system prompt + user prompt structure should we use for Planner, Worker, and Reviewer? Need concrete drafts, not abstractions.

3. **Backend integration details**: Based on current `claude -p` and `codex exec` documentation, what are the exact invocation patterns, useful flags, output handling, and error patterns?

4. **Fellowship demo scope**: What specific capability should be demoable by May 3? How does the orchestrator story map to "agentic oversight" for the OpenAI Safety Fellowship?

### High priority

5. **Cost budget estimate**: Rough token cost for one Planner→Worker→Reviewer cycle on each backend.

6. **Resume/compaction algorithm**: Draft the decision algorithm for resume vs restart.

7. **Error handling specification**: When Worker fails, Reviewer rejects, or backend errors — what does the runtime do?

## Current Repo State

**Exists**: Full research corpus, 90+ skills, iteration 1 Oracle documents, iteration 1 Claude analysis (7 files), basic headless session scripts.

**Does NOT exist**: Running Python code, backend adapters, prompt templates, file contract schemas, test suite, DECISIONS.md file.

**Ready to build**: All architectural decisions are made. The gap is between decision and implementation.

## Target Artifacts for This Session

You should produce these **five specific deliverables**:

### 1. Exact YAML Frontmatter Schemas (PRIMARY)

For each of these 7 file types, provide:
- Complete YAML frontmatter with all fields, types, required/optional markers
- A filled-in example showing realistic values
- Brief notes on how the runtime parses and uses each field

Files: `FEATURE_SPEC.md`, `TASKSET.md`, `TASK.md`, `REVIEW.md`, `SESSION_SUMMARY.md`, `DECISIONS.md`, `TODO.md`

Key additions identified in Claude's analysis that the Oracle's iteration 1 schemas missed:
- Cost budget fields (estimated, actual) on TASKSET and TASK
- Context requirements (files to inject) on TASK
- Retry policy per task on TASKSET
- Tokens consumed on SESSION_SUMMARY
- The DECISIONS.md and TODO.md contracts which were referenced but never defined

### 2. Draft Prompt Templates for v0 Roles

Three concrete, ready-to-test prompt templates:

**Planner**: System prompt + user prompt that takes a feature description and project context, produces FEATURE_SPEC.md + TASKSET.md. Should include instructions about YAML frontmatter format, task decomposition principles, and how to handle ambiguity (ask questions vs make assumptions).

**Worker**: System prompt + user prompt that takes a TASK.md + workspace path, implements the task, runs verification, and produces a SESSION_SUMMARY.md. Should include instructions about the TODO checklist, when to stop, and how to signal blockers.

**Reviewer**: System prompt + user prompt that takes a TASK.md + diff + test results, produces a REVIEW.md with S0-S3 severity classification. Should include instructions about when to approve vs reject, how to write actionable feedback, and how to classify root causes.

For each: specify what the orchestrator injects vs what the agent discovers, and how output format is enforced.

### 3. Comprehensive Deferred-Ideas Document

Extract ALL ideas not in v0 scope from these source files:
- `Iterations/prompt_iteration1.md`
- `ORCHESTRATOR_PLANNING_PROMPT.md`
- `Inspirations_and_Early_Ideas.md`
- `Iterations/Oracle/Response_iteration1.md`

Cross-reference against `Iterations/Claude/analysis_parking_lot.md` which identifies 30+ specific ideas that were lost from your iteration 1 parking lot. The Claude analysis provides the specific section references and preserved idea descriptions — use these as a checklist.

Requirements:
- Each idea preserved at **full fidelity** — do not over-summarize. Include enough detail that someone can understand and act on the idea without reading the original source.
- For each idea: source document/section, the idea itself, why it was deferred, when it becomes relevant.
- Organized in three tiers: Tier 1 (soon after v0, weeks 4-6), Tier 2 (v1, months 2-3), Tier 3 (v2+, longer horizon).
- Cover at minimum these specific ideas that were lost (non-exhaustive — find others):
  - ToDo-skill linking (skills carry associated ToDo templates)
  - Multi-purpose CLI tool for agent context access
  - Agent feedback/reporting on skills and tools after sessions
  - Desloppifier/code cleaner agent
  - Rebuilding projects from scratch with accumulated feedback
  - Feature refinement iterative loop (user ↔ planner before implementation)
  - Project architect automated setup (runtime handles mechanical scaffolding)
  - Inter-agent sub_comms folder structure
  - Per-model self-improvement notes (living documents per model)
  - Agent names hiding model identity
  - Two-tier cost optimization (frontier for planning, cheap for building)
  - Comprehensive post-training data collection
  - Context window management algorithm (pre-resume checks)
  - Kanban/task board for managers
  - Event-driven architecture
  - Interactive agent mode for ad-hoc tasks
  - File-watch triggers for async coordination
  - Structured feedback schema for skill/tool failures
  - Root-cause diagnostic before escalation
  - Three-tier review rigor system
  - Application-level observability (browser automation, DevTools)
  - Output sanitization between agents
  - Experimentation framework (A/B testing infrastructure)
  - Coordination failure metrics
  - Role-specific self-spawning evaluation
  - Agent email/social messaging system
  - RLM implementation specifics (skill vs wrapper vs node)
  - NanoClaw container isolation model
  - NullClaw hybrid vector+FTS5 memory

### 4. Structured Principles and Rules Document

Organize all principles and rules found across the source documents into these categories:

**A. Universal Coding Agent Principles**
Rules that apply to ALL coding agents in ALL projects. Examples from the sources:
- Simpler interfaces beat clever interfaces
- Deterministic enforcement beats prose-only rules
- Specialized agents beat omniscient agents
- Docs touched by a task are part of the task
- Every important process should leave queryable traces
- etc.

**B. Agent-Generated Project Principles**
Rules for code PRODUCED by agents:
- Functionality > Optimization > Modularity > Simplification
- Fully documented, always up to date
- Tests must pass, new tests for every change
- Deterministic formatting (linters/formatters are authority, not agent judgment)
- Prefer reimplementation over dependency when only a subset is needed
- etc.

**C. Orchestration Process Principles**
Rules for the iterative development process itself:
- Prompt cache preservation as a structural concern
- Routing/constraints must be structural, not left to agent judgment
- All knowledge must live in the repo — verbal agreements don't exist
- Every workflow is v1 by default and optimizable
- Code drift must be managed continuously
- etc.

**D. Model-Specific Guidelines**
Any model-specific behavioral notes found in the sources. Initially sparse — designed to grow as operational data accumulates.

**E. Security Principles**
- No agent gets both bash and internet
- Tool separation as security boundary
- Agent outputs sanitized before cross-agent use
- etc.

For each principle: the principle statement, source reference, and a brief "how to apply" note.

### 5. Knowledge Base Implementation Outline

Draft a plan for the knowledge base as the first real project built with the orchestrator. Include:

**A. Minimum viable feature set**
- What the KB can do in v0 (likely: ingest markdown, add structured frontmatter, query by tag/topic, detect staleness)
- What it cannot do yet (vector search, Obsidian integration, multi-domain federation)

**B. Recommended tech stack**
- Within the Python ecosystem, aligned with the orchestrator's own stack
- Lightweight — no heavy databases for v0 (filesystem + JSON/YAML metadata)

**C. Comparative analysis plan**
- Which 3-4 orchestrator projects to install (suggest from: agent-orchestrator, Symphony, CAR, adaf)
- How to adapt the KB task to each project's workflow (GitHub Issues, tickets, WORKFLOW.md, etc.)
- What to measure and compare across implementations
- What common failure patterns to watch for

**D. Orchestrator integration**
- How the KB project tests the orchestrator's capabilities
- What FEATURE_SPEC.md and TASKSET.md would look like for the KB's first feature
- How this validates the file contracts and prompt templates from deliverables 1 and 2

**E. Fellowship alignment**
- How to frame the KB project + orchestrator in fellowship applications
- What aspects demonstrate "agentic oversight" (logging, review loops, safety policies)
- What artifacts to produce for application materials

## Communication Preferences

Following your advice from iteration 1:
- This prompt contains only **frozen decisions**, **open questions**, **repo state**, and **target artifacts**. No historical narrative.
- Disagreements with your iteration 1 recommendations are stated explicitly in the frozen decisions (e.g., 3 roles not 6, phased A→C not clean-room C).
- Each deliverable is specified concretely — what it is, what it includes, what format.
- The analysis files in `Iterations/Claude/` contain detailed reasoning if you need to understand why a recommendation was changed.

## Files to Reference

If you need deeper context on any decision:
- `Iterations/Claude/analysis_foundation_recommendation.md` — why we're doing phased A→C
- `Iterations/Claude/analysis_backlog_and_next_steps.md` — why we compressed the iteration sequence
- `Iterations/Claude/analysis_parking_lot.md` — the 30+ ideas that were lost (use as checklist for deliverable 3)
- `Iterations/Claude/analysis_session_handoff.md` — missing strategic questions identified
- `Iterations/Claude/iteration1_decisions.md` — full reasoning for each decision
- `Iterations/Claude/iteration2_packet.md` — structured summary of everything above

Original source documents (for the comprehensive deferred-ideas extraction):
- `Iterations/prompt_iteration1.md` — Brayan's comprehensive brief
- `ORCHESTRATOR_PLANNING_PROMPT.md` — detailed orchestrator plan
- `Inspirations_and_Early_Ideas.md` — original ideas and references

---

## End of prompt

---

### Notes for Brayan (not part of the Oracle prompt)

**Before sending this prompt:**
1. Review the frozen decisions — are there any you disagree with or want to re-open?
2. Add your own feedback to each of the Oracle's iteration 1 documents (append a "Brayan's Feedback" section).
3. Cross-reference my analysis with your own review — where we agree strengthens the signal; where we disagree needs resolution.
4. Consider whether 5 deliverables is too many for one session — you might want to split into two parallel Oracle sessions (schemas + prompts in one, deferred ideas + principles + KB plan in another).
5. Attach or reference the specific files listed in the "Files to Reference" section so the Oracle has access.
6. Add any new constraints or context that emerged since this draft (e.g., subscription status changes, time availability, new deadline information).

**Potential optimizations:**
- If the Oracle session has limited context, prioritize deliverables 1 (schemas) and 2 (prompts) — these unblock building. Deliverables 3-5 are important but don't block the first line of code.
- Consider running deliverables 3 and 4 as a separate Claude headless session rather than consuming Oracle tokens on extraction work.
