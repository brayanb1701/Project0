# Project0 — Oracle Iteration 1: Foundation Recommendation

Date: 2026-04-09
Status: starting point, intentionally revisable

## Executive recommendation

Choose **Option C** for v0: build a **thin runtime-agnostic orchestration layer** now, with **official backend adapters** underneath it.

Initial backend set:

1. **Claude Code** via official `claude -p` / Agent SDK
2. **Codex** via official `codex exec`
3. **Optional experimental backend**: Cursor CLI or OpenCode, but **do not block v0 on either**

This is the best fit for your actual constraints:

- You want **Claude in the stack**, but Anthropic's current rules make third-party subscription routing strategically brittle.
- You need to iterate **fast**, which argues against deep adaptation of pi internals before you even validate the core workflow.
- You want the system to survive shifts in model availability, pricing, and provider policy, which argues for a stable orchestrator contract above the backend layer.
- Your system is fundamentally about **coordination, policy, artifacts, review loops, and logging** more than about one specific agent runtime.

## Why not make pi-mono the foundation?

pi-mono remains one of the strongest reference projects and should stay in the design space, but not as the v0 foundation.

### What pi gives you
- unified multi-provider API
- an agent runtime with tool calling and state management
- a strong philosophy around extensibility
- a fertile ecosystem for future self-improvement and skill evolution

### Why I would not anchor v0 on it
- The most strategically important provider for you right now is **Claude**, and the safest way to keep Claude in the stack is through **official Anthropic surfaces**, not third-party subscription routing.
- A deep pi-based adaptation would shift your time into **runtime surgery** before you have validated your own orchestration contract.
- Your current problem is not “how do I get one powerful agent runtime?” but “how do I coordinate heterogeneous coding agents safely, observably, and cheaply?”

### Final stance on pi
Treat pi-mono as:
- a **reference**
- a **future experimental backend**
- a **source of good patterns**
- possibly a **later API-native backend path**

…but not the first hard dependency.

## Why not just do Option A with ad-hoc wrappers?

Because your problem is already bigger than wrappers.

If you only script Claude Code and Codex directly without defining a stable orchestration contract, you will quickly recreate the same ambiguity in a messier form:

- inconsistent task formats
- inconsistent logs
- model-specific handoff behavior
- hard-coded workflow assumptions
- poor comparability across backends
- weak control over retries, escalation, and evaluation

The abstraction should stay **thin**, but it should exist from day one.

## v0 architecture thesis

The orchestrator should own:

- task lifecycle
- role policy
- session artifacts
- retries / escalation
- workspace creation
- logging and evaluation data
- skill resolution policy
- review policy
- security policy

Backends should own:

- model interaction
- local context handling
- tool loop execution
- native resumability features
- native sandbox / permission features

That separation is the key.

## Immediate v0 scope

v0 should be **coding orchestration only**.

### In scope
- one project at a time
- one user-facing planner loop
- feature/task decomposition
- dedicated worktree per implementation task
- structured markdown specs and handoffs
- builder -> verify -> reviewer -> fix loop
- logs outside target repo
- deterministic style/test gates
- backend adapters for Claude Code and Codex
- project-local `.p0/` state + global `~/.p0/` archive/logs

### Explicitly out of scope
- multi-channel personal assistant features
- 24/7 daemonized global autonomy
- rich dashboard/web UI
- DSPy/GEPA optimization loops
- evolutionary self-improvement loops
- full personal wiki / Obsidian ecosystem
- shared-folder concurrent editing mode
- automatic web search in the main coding workflow
- large-scale multi-project scheduler

## Successful first demo

A successful first demo is:

1. You describe a small feature or bugfix for a small repo.
2. A **Planner** produces an approval-ready spec.
3. A **Manager** converts the approved spec into a small task graph.
4. The runtime creates a worktree and launches a **Worker** in Codex or Claude Code.
5. The Worker implements, runs deterministic checks, and updates docs.
6. A **Reviewer** checks the diff, reruns verification, and either approves or returns structured feedback.
7. All logs, transcripts, diffs, test outputs, and final summary are stored outside the target repo.
8. The system leaves a PR-ready or patch-ready result.

If it can do that reliably on one small project, you have the right v0.

## Canonical role taxonomy for v0

Use these names and freeze them now:

### 1. Planner
Purpose:
- refine ambiguous ideas with the user
- produce approval-ready project/feature specs
- ask clarifying questions
- not implement code

Authority:
- may request research
- may not directly ship code

### 2. Manager
Purpose:
- turn an approved spec into executable tasks
- assign workers and reviewers
- own retries, escalation, and completion state

Authority:
- can spawn workers/reviewers
- can escalate upward
- can close a taskset

### 3. Architect
Purpose:
- one-time project or major subsystem setup
- choose repo structure, toolchain, CI, lint/test stack, conventions

Authority:
- acts before normal feature flow starts
- may be folded into Manager for very small projects, but keep the name distinct

### 4. Worker
Purpose:
- implement a bounded task completely
- write/update tests
- update docs touched by the task
- run local verification

Authority:
- no spawning in v0
- can raise questions / blockers
- can request missing context

### 5. Reviewer
Purpose:
- verify diff, tests, docs, architecture fit, and policy compliance
- classify failures by severity/root cause
- send structured feedback back to the originating worker

Authority:
- no spawning in v0
- no direct implementation unless explicitly escalated into a new worker task

### 6. Researcher
Purpose:
- gather information safely
- split into two subtypes later:
  - local/docs researcher
  - web researcher

Authority:
- no code execution in v0
- outputs documents, not code changes

### 7. Gardener
Defer to later, but keep the name reserved.
Purpose:
- entropy cleanup, doc freshness, pattern drift reduction

## Naming reconciliation

Freeze this terminology mapping now:

- **Builder** (old term) -> **Worker**
- **Project Architect** -> **Architect**
- **Planner** stays **Planner**
- **Manager** stays **Manager**
- **Tester** is not a standalone v0 role; testing is split between Worker and Reviewer
- **Explorer / Web Searcher** collapse into **Researcher** for now, with tool policy distinguishing them

This removes a major source of prompt and config ambiguity.

## Workflow representation recommendation

Use **annotated Markdown with YAML frontmatter**, not raw YAML and not a graph database.

### Why
- human-editable
- agent-readable
- versionable in git
- parseable by the runtime
- easy to review in diffs
- keeps machine-readable contract and human rationale together

### Core files
- `PROJECT_INTENT.md` — early idea refinement
- `PROJECT_PLAN.md` — approved high-level plan
- `FEATURE_SPEC.md` — one feature or task-group spec
- `TASKSET.md` — machine-readable + human-readable task graph
- `TASK.md` — leaf task handoff for a single Worker
- `REVIEW.md` — structured review result
- `DECISIONS.md` — append-only decision/rationale log
- `TODO.md` — role + task checklist
- `SESSION_SUMMARY.md` — restart/handoff artifact

### Suggested `TASKSET.md` shape
- YAML frontmatter for:
  - taskset id
  - owner role
  - review rigor
  - nodes
  - dependencies
  - concurrency hints
  - backend/model hints
  - escalation rules
- Markdown body for:
  - rationale
  - notes for humans
  - links to deeper specs

This is the right compromise.

## Spawn policy for v0

Do **not** let models own spawning yet.

The runtime should own spawning.

### v0 rule
Only **Manager** (or root orchestrator acting as Manager) can request new sessions.

### Hard limits
- max depth: 2 below the root task
- max active workers per project: 2 initially
- max retries before escalation: 3 soft / 5 hard
- reviewer and worker self-spawn: disabled
- planner self-spawn: disabled
- researcher self-spawn: disabled

This is one of the highest-leverage design simplifications you can make.

## Workspace and storage recommendation

### Project-local state: `repo/.p0/`
Use this for active project-facing artifacts only.

Suggested structure:

```text
.p0/
  project/
    PROJECT_INTENT.md
    PROJECT_PLAN.md
    DECISIONS.md
    RULES.md
  specs/
  tasksets/
  tasks/
  reviews/
  todos/
  handoffs/
  knowledge/
  coordination/
```

### Global state: `~/.p0/`
Use this for heavy logs, session archives, reusable assets, and worktrees.

Suggested structure:

```text
~/.p0/
  backends/
  agents/
  skills/
  projects/
    <project-slug>/
      worktrees/
      sessions/
      events/
      summaries/
      evals/
      archives/
```

### Important policy
Keep **heavy session logs outside the repo**.
Keep **active specs and task artifacts inside the repo**.

That matches your goals and also follows the strongest adaf-like pattern.

## Worktrees: use them immediately

I recommend **worktrees by default** for any code-writing task in v0.

Do not spend v0 engineering time on shared-folder concurrency.

### Why
- better isolation
- lower conflict risk
- cleaner logs
- clearer task ownership
- easier rollback
- easier replay/evaluation
- aligns with proven patterns from Codex, Symphony, GitHub Copilot cloud agent, and other orchestrators

You can still keep coordination artifacts in the main repo `.p0/`, while each Worker acts in its own worktree.

## Resume and compaction policy

Your prompt-caching notes are right: this needs to become structural.

Use this initial algorithm:

### Resume same session if
- same backend
- same model
- same role
- last activity is recent enough to preserve useful cache behavior
- context usage is still comfortably below threshold

### Compact same session if
- same backend/model/role
- continuity matters
- context usage is approaching threshold
- backend-native compaction or safe summarization is available

### Restart from summary if
- model/backend changes
- session is too long
- cache is likely cold
- review loop drift is accumulating
- you need a cleaner prompt path

### Mandatory durable artifacts per session
- `SESSION_SUMMARY.md`
- `DECISIONS.md`
- `TODO.md`
- latest diff/test summary

That makes restarts cheap and safe.

## Prompt/instruction layering recommendation

Do not build giant `AGENTS.md` files.

Assemble instructions from layers:

1. **Global invariants**
2. **Backend/model-specific rules**
3. **Project rules/map**
4. **Role instructions**
5. **Task handoff**
6. **Dynamic reminders in messages, not in the stable prefix whenever possible**

This directly matches the caching and agent-legibility principles you collected.

## Skills architecture recommendation

Follow the Agent Skills standard.
Add optional metadata, but do not fork the standard.

### Keep
- folder-based skills
- `SKILL.md`
- progressive disclosure
- scripts/assets/references
- role-based activation

### Add optional metadata under your own namespace
Examples:
- `p0.category`
- `p0.role_targets`
- `p0.model_hints`
- `p0.project_types`
- `p0.risk_level`
- `p0.cache_tier`

### Important v0 choice
Prefer **runtime-side skill resolution** over agent-side free navigation.

That means:
- the runtime decides which skills/resources to inject for a role/task
- the agent can still read linked resources when instructed
- but you avoid open-ended wandering across subskills in the prompt path

This is the simplest reliable starting point.

## ToDo/checklist model recommendation

Use one runtime-generated `TODO.md` per session with two sections:

1. **Core checklist** — immutable template for the role
2. **Task-derived checklist** — mutable items the agent adds and completes

Also include:
- blockers/questions
- skill/tool feedback notes
- final verification record

### Worker core checklist
- read task handoff
- read required project/rule docs
- derive missing substeps
- implement
- run format/lint/tests
- update docs touched
- record blockers
- prepare handoff summary

### Reviewer core checklist
- read task + diff
- rerun relevant verification
- inspect docs/tests
- classify severity/root cause
- return structured feedback or approval

This is enough for v0.

## Review/testing policy for v0

### Worker must always
- run deterministic format/lint/type/test checks
- update touched docs
- summarize changed files and verification results
- stop after task completion, not keep “improving”

### Reviewer must always
- inspect diff + changed files
- rerun targeted checks
- validate docs and task acceptance criteria
- classify failures as:
  - S0 cosmetic
  - S1 local correctness
  - S2 systemic/policy/architecture
  - S3 blocked / missing info

### Human review
Required initially for:
- architecture changes
- security-sensitive changes
- workflow/runtime changes
- first several end-to-end runs while you calibrate prompts and policies

## Knowledge base / wiki recommendation

Do **not** let the full LLM wiki vision block v0.

### Minimum useful v0
Make the wiki **project-scoped** first.

Use the Karpathy three-layer pattern in miniature:

```text
knowledge/
  raw/
  pages/
  log.md
  SCHEMA.md
```

Where:
- `raw/` = immutable source material
- `pages/` = synthesized markdown
- `SCHEMA.md` = wiki rules for ingest/query/lint
- `log.md` = append-only change record

### What to defer
- life-wide second brain
- multi-domain personal memory
- OCR pipeline
- deep Obsidian automation
- generalized cross-project federation

Keep the v0 wiki tied to Project0 and to one or two small pilot repos.

## Evaluation system recommendation

For v0, optimize for **observability**, not benchmark sophistication.

Log enough to answer:
- what was the task?
- which backend/model handled it?
- what artifacts were injected?
- what tools were used?
- what changed?
- what tests ran?
- why did review fail or pass?
- how many retries happened?
- what did the human correct afterward?

### First eval set
Build a tiny internal benchmark of real tasks:
- 2 planning tasks
- 2 scaffolding tasks
- 3 bugfix tasks
- 3 small feature tasks
- 2 review-only tasks

That is enough to start learning.

## First real project target

The first real target should be **Project0 itself**, but narrowed to one thin vertical slice:

### Candidate slice
A small CLI that can:
- load a `FEATURE_SPEC.md`
- create a `TASKSET.md`
- create a worktree
- dispatch one Worker backend
- store logs outside the repo
- collect a structured review result

This is both:
- useful immediately
- demoable
- aligned with your system goal
- strong input material for applications/fellowships

## Strongest critique of your current direction

The main problem is **not** that you changed focus too often.
The main problem is that you did not yet freeze a **v0 contract**.

You already have enough research to start.
What you need now is a **decision freeze** on:
- roles
- workflow files
- backend contract
- storage layout
- review loop
- first demo

Until those are frozen, more research will keep feeling productive while still delaying the build.

## Decision summary

### Final choice
- **Foundation**: Option C, thin orchestration layer
- **Backends first**: Claude Code + Codex
- **Optional experiments**: Cursor CLI, OpenCode, later pi
- **Isolation**: worktrees from day one for code-writing tasks
- **Workflow representation**: Markdown + YAML frontmatter
- **Canonical implementation role**: Worker
- **Logs**: outside repo
- **Spawn authority**: Manager only
- **Wiki**: project-scoped minimum version only
- **No blocker**: full personal assistant vision, DSPy, evolutionary loops, rich UI

## What I would do next immediately

1. Freeze terminology and v0 scope in a single decision record.
2. Define the backend adapter contract.
3. Define file contracts (`FEATURE_SPEC.md`, `TASKSET.md`, `TASK.md`, `REVIEW.md`, `SESSION_SUMMARY.md`).
4. Implement worktree + session archive layout.
5. Implement one Claude planner path and one Codex worker path.
6. Run one end-to-end demo on a tiny task.
