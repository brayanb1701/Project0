# Iteration 2 — Structured Packet

**Author**: Claude (Opus 4.6)
**Date**: 2026-04-09
**Purpose**: Structured input for the next Oracle session, following the Oracle's recommended communication format.

---

## A. Frozen Decisions

These should be treated as settled. Do not re-debate.

1. **Foundation**: Option C — thin runtime-agnostic orchestration layer. Implemented via phased approach (working wrappers first, extract abstraction second).
2. **Language**: Python for the orchestrator core. Use `uv` for dependency management.
3. **Backends for v0**: Claude Code (`claude -p`) and Codex (`codex exec`). No third backend until both work.
4. **Isolation**: Git worktrees by default for all code-writing tasks. No shared-folder concurrency in v0.
5. **Spawning**: Runtime owns all agent spawning. Models produce delegation requests; runtime executes them. No agent self-spawning in v0.
6. **Workflow representation**: Markdown files with YAML frontmatter. Human-readable body, machine-parseable headers.
7. **Role taxonomy for v0**: Three active roles — **Planner** (combines planning, management, and architecture), **Worker** (implementation), **Reviewer** (verification). Researcher fully deferred. Manager and Architect are Planner sub-functions, not standalone roles.
8. **Naming**: Builder→Worker. Project Architect→folded into Planner. Tester→split between Worker (writes tests) and Reviewer (validates). Explorer/Web Searcher→deferred.
9. **Logs and state**: Active specs/tasks in `repo/.p0/`. Heavy logs, session archives, worktrees in `~/.p0/`. Logs always outside the target repo.
10. **Review policy for v0**: Deterministic checks first (lint, format, type, test), then one reviewer, human escalation for S2/S3 and calibration runs. No multi-model consensus yet.
11. **Web search**: Fully deferred from automated pipeline. Human provides research context.
12. **Security**: No agent gets both bash execution and internet access. Tool allowlists per role. Runtime enforcement, not prompt-only.
13. **Scope**: Coding orchestration only. One project at a time. No personal assistant features, no rich UI, no DSPy, no evolutionary loops.
14. **First test target**: Project0 itself, then knowledge base project.
15. **Architecture**: Synchronous orchestrator for v0. Log all events for future async transition.
16. **No silent retries**: Every retry produces an event and a failure record.
17. **Anti-drift**: No new inspiration repos unless they resolve a blocked decision. No new roles unless existing ones demonstrably fail. No shared-folder concurrency. No deep KB automation. No eval sophistication beyond run comparison.

---

## B. Open Questions (Prioritized)

### Critical (must resolve in iteration 2)

1. **Exact file contract schemas**: What are the precise YAML frontmatter fields for FEATURE_SPEC.md, TASKSET.md, TASK.md, REVIEW.md, SESSION_SUMMARY.md, DECISIONS.md, and TODO.md? These need to be specified at a level where the runtime can parse them and agents can produce them.

2. **Prompt templates for each role**: What system prompt + user prompt structure produces the best output from Claude Code and Codex for each v0 role (Planner, Worker, Reviewer)? This needs concrete drafts, not abstract descriptions.

3. **Backend integration specifics**: What are the exact CLI invocations, flags, output formats, and error handling patterns for `claude -p` and `codex exec` in orchestration contexts? What are the actual limitations?

4. **Fellowship demo scope**: What specific feature or artifact should be demoable by April 30 (Parameter Golf) and May 3 (Safety Fellowship, Astra)? What narrative ties the orchestrator to "agentic oversight"?

### High Priority

5. **Cost budget for the v0 loop**: How many tokens does one Planner→Worker→Reviewer cycle consume? Is this sustainable on current subscriptions?

6. **Resume/compaction algorithm**: Under what specific conditions should a session be resumed vs restarted? What signals should the runtime check? Draft the algorithm.

7. **Error handling for the first loop**: When the Worker fails, when the Reviewer rejects, when the backend errors — what is the exact runtime behavior in each case?

### Medium Priority (can wait for iteration 3)

8. **Comprehensive deferred-ideas document**: The current parking lot is too thin. Need a thorough inventory of all ideas from all source documents.

9. **Structured principles and rules**: Organize all principles/rules into categories (agent-generated project principles, universal coding agent principles, iterative process principles, model-specific guidelines).

10. **Knowledge base implementation plan**: Outline including the comparative analysis idea (install 3-4 orchestrator projects, adapt KB project to each, compare results).

### New Questions from This Analysis

11. **Justfile/Makefile vs Python CLI for v0**: Should the v0 "orchestrator" be a Justfile with targets (simpler, faster to build) or a Python script (more flexible, harder to start)? Could be both — Justfile calls Python scripts.

12. **How to handle prompt iteration**: When a role's prompt doesn't produce good output, what's the process for iterating? Version-controlled prompt templates? A/B testing?

13. **What's the testing strategy for the orchestrator itself**: How do you validate that `p0-run` works correctly? Integration tests? A tiny synthetic task suite?

14. **Graceful degradation**: What happens when a backend is unavailable or rate-limited?

---

## C. Current Repo State

### What exists
- **Project0 repository**: All research, analyses, skills, planning documents, and source material.
- **12 analyzed reference projects**: Reports in `Research/<project>/output/`.
- **Skills library**: 90+ skills organized by origin in `skills/`.
- **Orchestrator scaffolding**: Basic directory structure and headless session scripts in `orchestrator/`.
- **Headless session infrastructure**: `claude -p` invocation via tmux + shell scripts (`Research/launch_all.sh`).
- **Iteration 1 documents**: Oracle's 4 output files + Claude's 7 analysis files (this iteration).
- **Knowledge condenser skill**: At `skills/general/knowledge-condenser/SKILL.md`.

### What's ready
- Decision record content (frozen decisions above — just needs formatting into a file).
- Role taxonomy (decided — needs formalization).
- General filesystem layout direction (decided — needs exact specification).
- Reference patterns identified (Symphony, adaf, CAR, OpenCode).

### What's NOT ready
- **No running code**: No Python package, no CLI, no backend adapters, no file parsers.
- **No prompt templates**: The actual prompts for Planner, Worker, Reviewer don't exist yet.
- **No file contract schemas**: The YAML frontmatter for each file type is described in prose but not specified precisely.
- **No backend testing**: Neither `claude -p` nor `codex exec` has been tested in an orchestration context.
- **No test suite**: No way to validate the orchestrator itself.
- **No DECISIONS.md**: The frozen decisions from this iteration haven't been committed to a durable file.

### Key files for the Oracle to reference
- `Iterations/Claude/analysis_foundation_recommendation.md` — challenges sequencing, proposes phased A→C
- `Iterations/Claude/analysis_backlog_and_next_steps.md` — challenges A→F serial sequence, proposes compression
- `Iterations/Claude/analysis_parking_lot.md` — comprehensive inventory of 30+ lost ideas
- `Iterations/Claude/iteration1_decisions.md` — decisions on all open questions with reasoning

---

## D. Target Artifacts for Iteration 2

The Oracle should produce these specific deliverables:

### D.1 — Exact YAML frontmatter schemas (PRIMARY TARGET)
Draft the precise YAML frontmatter schemas for all 7 file contracts:
- `FEATURE_SPEC.md` — including priority, effort estimate, cost budget fields
- `TASKSET.md` — including per-task cost budget, time budget, context requirements, retry policy
- `TASK.md` — including context files to inject, backend preference with fallback
- `REVIEW.md` — with S0-S3 severity classification
- `SESSION_SUMMARY.md` — including tokens consumed, cache metrics if available
- `DECISIONS.md` — decision_id, date, decided_by, scope, status
- `TODO.md` — immutable core section, mutable task section, feedback section

For each: full YAML frontmatter with field names, types, required/optional, and a complete example.

### D.2 — Draft prompt templates for v0 roles
Three concrete prompt templates:
- **Planner prompt**: Given a feature description + project context, produce a FEATURE_SPEC.md and TASKSET.md
- **Worker prompt**: Given a TASK.md + workspace, implement the task and run verification
- **Reviewer prompt**: Given a TASK.md + diff + test results, produce a REVIEW.md

Each template should include: system prompt, user prompt structure, expected output format, and notes on what to inject from the orchestrator vs what the agent discovers.

### D.3 — Comprehensive deferred-ideas document
Extract ALL ideas not in v0 scope from every source document (`prompt_iteration1.md`, `ORCHESTRATOR_PLANNING_PROMPT.md`, `Inspirations_and_Early_Ideas.md`). Each idea preserved at full fidelity — not over-summarized. Organized in the three-tier structure (soon after v0 / v1 / v2+). Cross-reference my parking lot analysis (`analysis_parking_lot.md`) which identifies 30+ specific ideas that were lost.

### D.4 — Structured principles and rules document
Organize all principles/rules from all source documents into categories:
- **Universal coding agent principles** (apply to all agents in all projects)
- **Agent-generated project principles** (apply to code produced by agents)
- **Orchestration process principles** (apply to the iterative development process)
- **Model-specific guidelines** (per-model behavioral notes, when available)
- **Security principles** (tool separation, permission boundaries)

### D.5 — Knowledge base implementation outline
Initial plan for the KB project including:
- Minimum viable feature set
- Recommended tech stack (within the Python ecosystem)
- The comparative analysis plan (install 3-4 orchestrator projects, adapt KB project to each, compare)
- How the KB project serves as a test for the orchestrator
- Alignment with fellowship application narratives
