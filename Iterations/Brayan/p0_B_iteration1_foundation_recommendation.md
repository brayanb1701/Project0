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

---

## Consolidated Brayan Feedback

> **Total annotations: 20** (17 comments, 3 questions)
>
> Every `**(COMMENT:)**` and `**(QUESTION:)**` left inline throughout this document is collected here verbatim, indexed by its source section and line number for traceability.

---

### QUESTIONS (3)

**Q-1 — v0 architecture thesis / skill resolution policy (line 74)**
Section: *v0 architecture thesis → orchestrator owns*
> How the orchestrator owns this if the skills are managed by each harness?

**Q-2 — Canonical role taxonomy / Planner scope (line 138)**
Section: *Canonical role taxonomy for v0 → 1. Planner*
> So this planner would be for both refining initial ideas and refining particular features/additions/etc? If that's correct, it's fine for starting, but we must do it correctly.

**Q-3 — Canonical role taxonomy / Manager spawn semantics (line 160)**
Section: *Canonical role taxonomy for v0 → 2. Manager → Authority*
> By spawning I guess you mean just by assigning (creating) tasks, because it's really the orchestration layer that spawns them, no?

---

### COMMENTS (17)

**C-1 — Executive recommendation / Skills as a fundamental concern (line 23)**
Section: *Executive recommendation*
> In general I like the proposal but there are still some thing too relevant to not consider, one of the most important ones are how we're gonna treat skills, a fundamental part of how coding agents work right now.

**C-2 — Successful first demo / Project-from-zero support (line 128)**
Section: *Successful first demo*
> What you describe here I understand it's for a small feature or bugfix but I also want to iterate on creating the project from zero from the start because surely most of the projects will be that way. So it's important that the first demo also includes the possibility of handling a project from zero (a small one), even if I need to be part of the process in each step to make sure everything is correct.

**C-3 — Canonical role taxonomy / Manager is backend-specific (line 152)**
Section: *Canonical role taxonomy for v0 → 2. Manager*
> Okay, we can have a single manager for now, but it's important to note it's a backend manager (not sure if changing the name or simply adding some sort of label inside the role spec), we won't start doing anything with frontend for now, but eventually we'll need it.

**C-4 — Workflow representation / FEATURE_SPEC vs TASKSET boundaries (line 239)**
Section: *Workflow representation recommendation → Core files*
> I think it's important to define the boundaries clearly of what should be included here and in TASKSET, so we not include implementation details here as the manager is the one in charge of so.

**C-5 — Worktrees / Organization requirement (line 350)**
Section: *Worktrees: use them immediately*
> Okay let's try this, but then we must make sure that it's organized.

**C-6 — Worktrees / Branching strategy between agents (line 352)**
Section: *Worktrees: use them immediately*
> We still need to define how we will work to log changes on the repo between agents, even if for now we will work one feature at a time, we need to know for example if for feature/ticket we will create a new branch that then will be merged to main by the manager after grouping what workers did. This should be flexible in the design so that we can try different strategies and maybe adapt them by project.

**C-7 — Resume and compaction / 5-minute cache window (line 364)**
Section: *Resume and compaction policy → Resume same session if*
> Important 5 minute limit.

**C-8 — Resume and compaction / Simplify to two modes (line 380)**
Section: *Resume and compaction policy*
> I think we can simplify here for now. Just resume same session or restart from summary, as compaction is usually handled internally by the harnesses.

**C-9 — Skills architecture / Folder structure and metadata clarification (line 417)**
Section: *Skills architecture recommendation → Keep*
> I'm not sure if what you were trying to say is that we only keep each skill individually in its own folder, but add them additional metadata to categorize them and group them easily if necessary. Is that right? I only see one disadvantage and it's that usually the agents load the name and the description of all skills available in the particular skill folder, so the agent could really access whichever skill it's there even we only reference some specific ones; I think we still can leave it that way in the initial version, but it's something to revisit later.

**C-10 — Skills architecture / Skill design needs deeper treatment (line 419)**
Section: *Skills architecture recommendation → Keep*
> Still, I think the skill design must be done with more detail as it's such an important part of the system. We need to explore all the skills we currently have, distill them based on the roles we decide, and adjust the structure based on those skills.

**C-11 — Review/testing policy / Worker self-reflection (line 477)**
Section: *Review/testing policy for v0 → Worker must always*
> Well, maybe the agent should self-reflect at least one more time to verify everything was done correctly.

**C-12 — Review/testing policy / Severity classification as knowledge base doc (line 489)**
Section: *Review/testing policy for v0 → Reviewer must always*
> I think this is the sort of files that we should have in the knowledge base for agents, like a doc that explains what belongs to each category and the clear rules to determine.

**C-13 — Review/testing policy / Human-in-the-loop for initial iterations (line 498)**
Section: *Review/testing policy for v0 → Human review*
> I think at least in the very first iterations, I will be in the loop in each step checking the outputs of every agent to make sure everything is done as expected, this way we'll also be creating like the standard to evaluate later versions.

**C-14 — Knowledge base / Fundamental context-management system vision (line 504)**
Section: *Knowledge base / wiki recommendation*
> I think I value much more the Knowledge Base system as a fundamental part for managing context and how agents access information. How I visualize it: we have a core knowledge base system that is applicable to any form of linking files and store the information in folders and md files. With this core base, we can then build on top of it a coding_projects specific layer that can be personalized also for the design of the particular orchestrator that will use it. This way, this CLI tool could directly handle which files should be presented for each agent, like a command for seeing the current task, another one for searching in project rules, etc. The idea is to compare if this really reduces or adds complexity for agents compared to for example letting it do based on routes. Maybe we can adapt this to project-scoped version, but I really think we shouldn't underestimate the things we can accomplish right now.

**C-15 — Evaluation system / Log skill usage and effectiveness (line 549)**
Section: *Evaluation system recommendation*
> We should also add which skills were used and effectiveness of them.

**C-16 — Evaluation system / Eval set construction source (line 561)**
Section: *Evaluation system recommendation → First eval set*
> The eval set will be constructed with the files we're creating for this initial version and with the ones for the knowledge_base system.

**C-17 — First real project target / Why a CLI instead of the full project? (line 576)**
Section: *First real project target → Candidate slice*
> I don't understand why a CLI, I thought the whole project but having already clearly defined the design. That's why I'm taking so much time refining the design, so that we can iterate on this with the tool itself.

---

## Claude Feedback

> Additional recommendations for the Oracle to consider in the next iteration. Items already covered by the Consolidated Brayan Feedback above are not repeated here.

---

### Directives

**CF-1 — Do not frame recommendations in terms of time**
All recommendations should be framed in terms of scope, dependencies, and sequencing — not calendar durations. Only the user can assess feasibility in time. LLMs tend to underestimate what is possible.

**CF-2 — The implementation language is Python**
The orchestrator should be built directly in Python from the start.

---

### Ideas to include in v0

**CF-3 — Event-driven architecture for the orchestrator**
The orchestrator's communication layer will be async. Whether the runtime is event-driven, polling-based, or synchronous is an important architectural decision that should be addressed in the initial version.

**CF-4 — Interactive agent for ad-hoc work**
At least one interactive agent should be available in the first iteration for ad-hoc tasks within a project. This can be as simple as a command or wrapper that invokes the interactive mode of either Claude Code or Codex.

**CF-5 — Feature refinement iterative loop as a first-class planning mechanism**
Extends Q-2 from the Consolidated Brayan Feedback (Planner scope). The workflow where user and planner iterate on an idea via markdown until it is ready for development is a key planning element and must be preserved in v0. The envisioned process: the Planner takes initial ideas, structures them, and asks clarifying questions for any parts that are not clear enough. The user reviews the resulting document and leaves feedback inline. The Planner incorporates that feedback, makes fixes, and asks additional questions if relevant. The user determines whether more iterations are needed. There should be a mechanism for the user to signal readiness (e.g., marking the document as approved), even while simultaneously suggesting minor last-pass fixes.

**CF-6 — Token tracking (lightweight, via harnesses)**
A clear way to track token usage is needed, but this largely depends on how each harness (Codex, Claude Code, etc.) already exposes that data. No custom cost accounting infrastructure required — just ensure the logging system captures what the harnesses report.

---

### Ideas to preserve for later

**CF-7 — Application-level observability (treat as a skill)**
Agents building frontend/backend code may eventually need to observe the running application — browser automation, DevTools, per-worktree ephemeral stacks. This should be treated as a skill rather than a core orchestrator concern. Map it during skill design so the idea is not lost.

**CF-8 — Output sanitization between agents**
Defense against drifted agent-to-agent influence: reviewing and sanitizing agent outputs before they are used as inputs to other agents. Not needed for v0, but track the idea for when multi-agent pipelines grow more complex.

**CF-9 — Shared-space coordination**
The idea of multiple agents working in a shared space with a coordination/presence mechanism is deferred. Worktrees-only is the v0 approach.

**CF-10 — Cost optimization as first-class concern**
Frontier models for planning, cheaper or open-source models for building, cost budgets per taskset. Deferred until the system works end-to-end and there is real usage data to optimize against.

