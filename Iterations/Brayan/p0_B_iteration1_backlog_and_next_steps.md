# Project0 — Oracle Iteration 1: Backlog and Next Steps

Date: 2026-04-09
Status: concrete next steps for the next 1-3 iterations

## The next build sequence

This sequence is intentionally narrow.
Do not expand scope until step 6 works.

## Iteration A — Freeze the contracts

### Goal
Stop design drift by freezing the minimum contracts for v0.

### Deliverables
1. `docs/v0/DECISION_RECORD.md`
2. `docs/v0/ROLE_TAXONOMY.md`
3. `docs/v0/FILESYSTEM_LAYOUT.md`
4. `docs/v0/BACKEND_CONTRACT.md`
5. `docs/v0/WORKFLOW_CONTRACT.md`

**(COMMENT: I think this might change based on other feedback)**

### Questions to lock now
- Are the canonical roles exactly:
  - Planner
  - Manager
  - Architect
  - Worker
  - Reviewer
  - Researcher
  
  **(ANSWER: I'm even thinking now that we still need to separate the planner into two based on if it's about a whole new project or adding a feature to an existing one because their scope are too different. Maybe we could just have a way to point the agent to the appropriate context/information/docs to know how to do for each one (maybe using skills?). So, it depends, we can start with these roles if there's a clear way to separate that for those two cases.)**
  
- Are code-writing tasks always worktree-isolated in v0?

  **(ANSWER: Yes, I agree with that)**

- Is web search deferred from the main coding loop for v0?

  **(ANSWER: Yes)**

- Is the first end-to-end demo a single feature in Project0 itself?

  **(ANSWER: As mentioned in other parts of feedback, the first end-to-end demos will be Knowledge Base project, and Project0 itself)**

### What not to debate in this iteration
- personal assistant features
- DSPy integration
- full wiki automation
- model fine-tuning
- multi-project scheduling
- advanced UI

## Iteration B — Define the file contracts

### Goal
Make task routing structural instead of prompt-implied.

### Files to define

**(COMMENT: It's important to keep in mind that whatever data can be filled deterministically by the orchestration layer, should be done and not left to the model, like ids.)**

#### 1. `FEATURE_SPEC.md`
Purpose:
- approved feature intent
- acceptance criteria
- constraints
- project references

Suggested sections:
- Goal
- User-visible outcome
- Technical constraints
- Affected areas
- Acceptance criteria
- Tests required
- Docs required
- Out of scope
- Open questions

#### 2. `TASKSET.md`
Purpose:
- parseable task graph for a feature

Suggested frontmatter:
```yaml
kind: taskset
taskset_id: feat-0001
owner_role: manager
review_rigor: standard
backend_preferences:
  planning: claude-code
  implementation: codex
nodes:
  - id: task-1
    role: worker
    deps: []
    backend_hint: codex
    scope: "create backend contract"
  - id: task-2
    role: reviewer
    deps: [task-1]
    backend_hint: claude-code
    scope: "review backend contract"
```

Suggested body:
- taskset overview
- sequencing rationale
- concurrency notes
- escalation notes

#### 3. `TASK.md`
Purpose:
- leaf task handoff to one Worker/Reviewer

Suggested sections:
- task id
- role
- exact goal
- required reads
- allowed tools
- target files
- acceptance criteria
- tests/docs checklist
- escalation path

#### 4. `REVIEW.md`
Purpose:
- structured reviewer response

Suggested sections:
- verdict
- severity
- failure categories
- files reviewed
- exact fixes requested
- next action

#### 5. `SESSION_SUMMARY.md`
Purpose:
- durable restart artifact

Suggested sections:
- objective
- current status
- key decisions
- files changed
- tests run
- unresolved blockers
- next best action

## Iteration C — Implement the backend abstraction

### Goal
Make backend choice a config problem, not a rewrite problem.

### Minimal backend interface

```python
class BackendAdapter:
    name: str

    def capabilities(self) -> dict: ...
    def launch(self, session_config, prompt, workspace) -> LaunchResult: ...
    def resume(self, session_ref, prompt=None) -> LaunchResult: ...
    def cancel(self, session_ref) -> None: ...
    def collect_events(self, session_ref) -> list[dict]: ...
    def collect_artifacts(self, session_ref) -> dict: ...
```

### Required capability fields
- supports_resume
- supports_json_stream
- supports_subagents
- supports_native_permissions
- supports_skills
- supports_model_selection
- supports_structured_output
- supports_worktree_friendly_execution

### Initial adapters
1. `claude_code`
2. `codex`

### Optional third adapter
- `cursor_cli` or `opencode`
- only after the first two work

**(COMMENT: As we can do the research for each adapter in parallel, I decided to include pi and opencode)**

## Iteration D — Implement the session/archive layout

### Goal
Make every run observable and restartable.

### Proposed layout

```text
~/.p0/projects/project0/
  worktrees/
    task-0001/
  sessions/
    sess-0001/
      metadata.json
      transcript.jsonl
      tool_events.jsonl
      summary.md
      todo.md
      review.md
      diff.patch
      test_results.json
  events/
    events.jsonl
```

### Minimum metadata
- session id
- task id
- role
- backend
- model
- parent session
- start/end timestamps
- exit status
- retry count
- worktree path

## Iteration E — Implement the deterministic loop

### Goal
One vertical slice from spec to approved result.

### Flow
1. read `FEATURE_SPEC.md`
2. generate `TASKSET.md`
3. create worktree
4. create session folder
5. launch Worker
6. collect summary + test results
7. launch Reviewer
8. either approve or return `REVIEW.md`
9. if fail, resume or restart Worker based on policy
10. archive everything

### Hard rule
No silent retries.
Every retry must produce an event and a review/failure record.

## Iteration F — Run the first demo

### Demo task candidates
Choose exactly one:

#### Option 1 — Best immediate fit
Implement `p0-run spec <FEATURE_SPEC.md>`
- loads spec
- creates taskset
- dispatches one worker
- stores session artifacts

#### Option 2
Implement `p0-review <session_or_diff>`
- loads diff + task
- runs reviewer
- writes `REVIEW.md`

#### Option 3
Implement `p0-worktree create <task-id>`
- creates deterministic per-task workspace
- links required `.p0` artifacts
- prepares metadata skeleton

### Recommended first demo
Start with **Option 3**, then **Option 1**, then **Option 2**.
That ordering reduces dependency pain.

## Decisions I recommend freezing now

### 1. One project type for the first month
Use:
- internal CLI tools
- Project0 itself
- maybe one tiny throwaway test repo

Do **not** target webapps first.
You need faster feedback and simpler verification.

### 2. One review policy for v0
Use:
- deterministic checks first
- one reviewer
- human escalation for S2/S3 and first calibration runs

Do **not** start with multi-model consensus.
That is a later optimization.

### 3. No automatic web search in the code path
For v0:
- research is a separate role
- outputs a document
- manager passes curated findings to worker

### 4. No model-owned spawning
The runtime owns spawning.
Agents request, runtime executes.

## Tasks for you

### Human tasks
1. Confirm the frozen role taxonomy.
2. Confirm whether Python is acceptable for the thin orchestrator layer.
3. Confirm that worktrees are the default isolation unit for code-writing tasks.
4. Decide the very first demo task from the three above.
5. Decide whether OpenCode or Cursor is the preferred third experimental backend.

### Good constraint-setting from you in future turns
When giving the next packet, separate it into:
- `frozen decisions`
- `open questions`
- `current repo state`
- `target artifact for this iteration`

That will speed us up a lot.

## Tasks for another model / agent

### Planning model
- draft the five v0 contract docs
- propose exact frontmatter schemas
- suggest a minimal event schema revision

### Builder model
- scaffold the Python CLI package
- implement filesystem layout and config loading
- add test harness for session archive creation

### Reviewer model
- check that the file contracts are parseable, minimal, and consistent
- find naming ambiguities or overengineering

## Anti-drift rules for the next 2 iterations

- No new major inspiration repo unless it resolves a currently blocked decision.
- No new role unless an existing role demonstrably fails.
- No shared-folder concurrency mode yet.
- No deep knowledge-base automation yet.
- No eval sophistication beyond what is needed to debug and compare runs.

---

## Feedback impact analysis

> Cross-reference of how the Consolidated Brayan Feedback (C-1 through C-17, Q-1 through Q-3) and Claude Feedback (CF-1 through CF-10) from the foundation recommendation affect this document. Organized by iteration.

---

### Iteration A — Freeze the contracts

| Feedback | Impact |
|----------|--------|
| C-1, C-9, C-10, Q-1 | **Skill resolution is missing from the deliverables.** Skills are identified as fundamental. The contract freeze should either include a `SKILL_CONTRACT.md` or explicitly address skill ownership (orchestrator vs harness) within `BACKEND_CONTRACT.md` or `ROLE_TAXONOMY.md`. |
| Q-2, CF-5 | **Planner scope and the feature refinement iterative loop must be defined in `ROLE_TAXONOMY.md` and `WORKFLOW_CONTRACT.md`.** The Planner handles both initial idea refinement and feature-level planning. The iterative markdown-based refinement cycle with user approval signals needs to be part of the workflow contract. |
| Q-3 | **Spawn semantics should be clarified in `ROLE_TAXONOMY.md`.** "Spawn" means the Manager assigns/creates tasks; the runtime is what actually launches sessions. |
| C-3 | **Manager should be labeled as backend-scoped in `ROLE_TAXONOMY.md`.** Frontend management is deferred but the role should note this boundary. |
| C-4 | **FEATURE_SPEC vs TASKSET boundary should be locked in `WORKFLOW_CONTRACT.md`.** FEATURE_SPEC contains no implementation details; the Manager owns that decomposition in TASKSET. |
| CF-3 | **Event-driven architecture is not addressed anywhere.** The contracts should define whether the orchestrator communicates via events, polling, or synchronous calls. Candidate location: `BACKEND_CONTRACT.md` or a new section in `WORKFLOW_CONTRACT.md`. |
| CF-4 | **Interactive agent mode is not represented.** Add it as either a role mode or a separate entry in `WORKFLOW_CONTRACT.md`. |
| C-6 | **Branching strategy between agents needs a home.** Could go in `FILESYSTEM_LAYOUT.md` or `WORKFLOW_CONTRACT.md`. How worktrees map to branches and how the Manager merges worker results should be defined, even if flexible. |

**Questions to lock now — updates needed:**
- Role taxonomy is confirmed as all 6+ roles (not reduced). Mark as answered.
- Python is confirmed (CF-2). Mark as answered.
- Add new question: How does skill resolution work across orchestrator and harness?
- Add new question: What is the branching/merge strategy for worktree-based tasks?

---

### Iteration B — File contracts

| Feedback | Impact |
|----------|--------|
| C-4 | **FEATURE_SPEC.md definition must explicitly state "no implementation details."** Add a boundary note: implementation decomposition belongs in TASKSET, owned by the Manager. |
| CF-5 | **A file for the refinement phase is missing.** The iterative loop between user and Planner (idea → structured draft → feedback → revision → approval) needs a file contract. Candidate: `PROJECT_INTENT.md` (already mentioned in the foundation doc but absent from this backlog's file list). |
| C-12 | **Severity classification needs a reference document.** The `REVIEW.md` contract uses S0–S3 categories. A knowledge base doc defining each category and its determination rules should be listed as a dependency or companion artifact. |
| C-11 | **Worker self-reflection step.** The Worker flow should include a verification/self-reflection pass before handoff. This affects `TASK.md` (add to checklist) and `SESSION_SUMMARY.md` (record self-check results). |
| C-15 | **SESSION_SUMMARY.md should include skills used.** Add "skills invoked" and "skill effectiveness notes" to the suggested sections. |
| CF-6 | **SESSION_SUMMARY.md or session metadata should include token usage.** Add a field for token counts as reported by the harness. |

---

### Iteration C — Backend abstraction

| Feedback | Impact |
|----------|--------|
| CF-3 | **The adapter interface should account for event-driven communication.** `collect_events()` exists but the broader question of whether the orchestrator polls or subscribes to events needs to be settled before finalizing the interface. |
| CF-6 | **Add token usage to the adapter return types.** `LaunchResult` or `collect_artifacts()` should expose token counts if the harness provides them. |
| Q-1 | **Skill injection needs a touchpoint in the adapter.** If the orchestrator owns skill resolution but the harness executes skills, the adapter needs a way to pass skill configurations or paths to the backend. |
| C-8 | **Resume policy simplification.** Only two modes: resume same session or restart from summary. The `resume()` method stays, but compaction logic is not needed in the adapter — harnesses handle that internally. |

---

### Iteration D — Session/archive layout

| Feedback | Impact |
|----------|--------|
| C-5, C-6 | **Worktree organization and branching strategy.** The layout should show how worktrees relate to branches (e.g., one branch per feature, one worktree per task on that branch) and how the Manager consolidates results. |
| C-15 | **Add skill usage to session metadata.** The minimum metadata list should include: skills injected, skills actually used, skill effectiveness notes. |
| CF-6 | **Add token usage to session metadata.** |
| C-7 | **The 5-minute cache window should inform the resume decision.** Session metadata should record last-activity timestamp so the orchestrator can apply the resume-vs-restart policy. |

---

### Iteration E — Deterministic loop

| Feedback | Impact |
|----------|--------|
| CF-5 | **The flow starts at step 1 with `FEATURE_SPEC.md` but skips the refinement phase.** Before step 1, there should be a Planner loop: idea → structured draft → user feedback → revision → user approval. Only after approval does the flow proceed to TASKSET generation. |
| CF-4 | **Interactive agent is absent from the loop.** It operates outside the automated pipeline, but the loop description should acknowledge that ad-hoc interactive sessions can happen in parallel. |
| C-13 | **Human-in-the-loop checkpoints.** In early iterations, the user reviews outputs at every step. The flow should mark which steps require human approval before proceeding (at minimum: after Planner output, after TASKSET generation, after Review verdict). |
| C-11 | **Add a self-reflection step after Worker implementation (between steps 5 and 6).** The Worker verifies its own work before the summary is collected. |
| C-2 | **The flow assumes an existing repo.** It should also handle project-from-zero: Architect sets up the repo/toolchain before the Worker flow begins. |

---

### Iteration F — First demo

| Feedback | Impact |
|----------|--------|
| C-2 | **The demo should include creating a project from zero**, not only adding a feature to an existing repo. Even if small and human-supervised at each step. |
| C-17 | **The user questions the CLI-tool framing.** The demo target may be better framed as "run the full orchestrator on a small task" rather than "implement a `p0-run` CLI command." Revisit whether the demo options should be reframed. |
| C-13 | **First demo should be fully human-supervised.** Every agent output is reviewed by the user to establish the quality baseline for later evaluation. |

---

### Human tasks — already answered by feedback

| Question | Answer | Source |
|----------|--------|--------|
| Is Python acceptable? | **Yes.** | CF-2 |
| Worktrees as default? | **Yes.** | C-5, C-6 |
| Role taxonomy confirmed? | **Yes, all 6+ roles.** Not merged, not reduced. | Rejection of role reduction (B_Clarifications) |
| Architect separate or folded? | **Separate.** Keep distinct even if folded for small projects in practice. | Foundation doc (unchanged) |

**Still open:**

- First demo task selection (reframe per C-2 and C-17)
- Third experimental backend (Cursor vs OpenCode)
- Skill resolution ownership (Q-1)
- Branching strategy (C-6)
- Event-driven vs polling vs synchronous (CF-3)
