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

### Questions to lock now
- Are the canonical roles exactly:
  - Planner
  - Manager
  - Architect
  - Worker
  - Reviewer
  - Researcher
- Are code-writing tasks always worktree-isolated in v0?
- Is web search deferred from the main coding loop for v0?
- Is the first end-to-end demo a single feature in Project0 itself?

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
