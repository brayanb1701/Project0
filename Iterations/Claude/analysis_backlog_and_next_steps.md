# Independent Analysis: Backlog and Next Steps

**Analyst**: Claude (Opus 4.6)
**Date**: 2026-04-09
**Source document**: `Iterations/Oracle/p0_iteration1_backlog_and_next_steps.md`

---

## 1. Strengths

### Clean iteration structure
The A-through-F sequence is logically ordered: freeze contracts → define files → implement backend → implement storage → implement loop → run demo. Each iteration has a clear goal and deliverables. This is good project management.

### Anti-drift rules are excellent
"No new major inspiration repo unless it resolves a currently blocked decision" and "No new role unless an existing role demonstrably fails" are exactly the discipline needed. These should be frozen as principles for the next 3 weeks.

### File contract proposals are well-structured
The `FEATURE_SPEC.md`, `TASKSET.md`, `TASK.md`, `REVIEW.md`, and `SESSION_SUMMARY.md` set covers the essential artifacts. The YAML frontmatter + markdown body approach is the right format — machine-parseable headers with human-readable rationale.

### Correct first-project targeting
Internal CLI tools + Project0 itself + tiny throwaway test repos. Explicitly excluding webapps from v0 is right — simpler verification, faster feedback loops.

### "No silent retries" rule
Every retry producing an event and a failure record is correct. This is how you build the data flywheel for later optimization.

---

## 2. Weaknesses & Gaps

### The A→F sequence is too sequential for a 3-week timeline
As written, iterations A through F are serial. At the estimated pace:
- A (freeze contracts): 1-2 days
- B (file contracts): 1-2 days
- C (backend abstraction): 2-3 days
- D (session/archive layout): 1-2 days
- E (deterministic loop): 2-3 days
- F (first demo): 1-2 days

That's 8-14 days, which is reasonable — but only if nothing goes wrong. More critically, A and B are pure documentation with zero running code. By the time you finish B, you've spent 2-4 days without testing any assumptions.

**My proposed compression**:
- **Days 1-2**: Merge A+B+D. Write the decision record, file contracts, AND the storage layout simultaneously — these are all documentation and inform each other. Use a single focused session.
- **Days 3-5**: Merge C+E. Implement the backend abstraction AND the deterministic loop together — you can't meaningfully test the backend adapter without running it in a loop, and you can't run the loop without a backend.
- **Days 6-7**: F — Run and debug the demo.
- **Days 8-14**: Iterate on real tasks, fix issues, refine contracts based on actual usage.

This cuts the design-only phase from 4 days to 2 and puts running code on day 5 instead of day 10.

### Missing: parallelizable work streams
The Oracle doesn't identify what can be done simultaneously. For example:
- While Claude works on contracts (A+B), Brayan could manually test `claude -p` and `codex exec` wrappers to surface integration surprises early.
- File contract definitions (B) and storage layout (D) can absolutely happen in parallel — they're independent concerns.
- The backend adapters for Claude Code and Codex can be developed in parallel.

### The TASKSET.md schema is underspecified in important ways
The proposed frontmatter is a good start but misses:
- **Cost budget**: estimated and actual token cost per task. This is critical for a budget-constrained developer.
- **Time budget**: estimated and actual wall-clock time. Needed for deadline management.
- **Retry policy per task**: the document mentions global retry limits but not per-task overrides (some tasks are cheap to retry, others expensive).
- **Context requirements**: what documents/files the worker needs injected. This is crucial for prompt-cache optimization — if you know what context a task needs, you can batch tasks with similar context.
- **Success criteria type**: "tests pass" vs "diff looks correct" vs "human review needed." Different tasks have different acceptance mechanisms.

### Missing file: DECISIONS.md contract
The Oracle mentions `DECISIONS.md` in the foundation doc and in `SESSION_SUMMARY.md` but never defines its contract in the backlog. This is a significant oversight — DECISIONS.md is arguably the most important file because it prevents re-litigation and provides restart context. It needs:
- YAML frontmatter: decision_id, date, decided_by (role), scope, status (final/provisional)
- Body: question, options considered, chosen option, reasoning, caveats

### Missing file: TODO.md contract
Referenced in the foundation doc's checklist model but not defined as a file contract in iteration B. Needs:
- Immutable core checklist (per role template)
- Mutable task-derived items
- Feedback/report section for skill/tool issues
- Completion tracking

### The backend adapter interface is premature
The Python class with `capabilities()`, `launch()`, `resume()`, `cancel()`, `collect_events()`, `collect_artifacts()` looks clean but:
- `resume()` assumes you know how resumption works for each backend before you've tried it. Claude Code and Codex handle resume very differently.
- `collect_events()` assumes a common event schema before you've seen what each backend actually emits.
- `cancel()` may not even be meaningful for `codex exec` which runs to completion.

**Better approach for v0**: Define the interface AFTER implementing both adapters. Start with concrete wrapper functions, then extract the common interface from what they actually share.

### No mention of error handling for the demo
Iteration F says "run the first demo" but doesn't address what to do when it fails (and it will fail). There should be explicit guidance on:
- What constitutes a successful demo vs a useful failure?
- How much debugging time should be budgeted?
- When should you declare the demo "good enough" and move to real tasks?

### The recommended demo order (Option 3→1→2) is debatable
The Oracle recommends worktree manager first, then full dispatcher, then reviewer. My take:
- **Worktree management is not the hardest or most uncertain part.** Git worktrees are well-understood. `git worktree add` is one command.
- **The dispatcher (Option 1) is where the real risk lives** — this is where you discover if your prompt format works, if the backends behave as expected, if the log format captures what you need.
- **Start with Option 1** (dispatcher), which implicitly requires worktree creation. Don't build the worktree manager as a separate tool — just make it a function within the dispatcher.

---

## 3. Missing Ideas

### From `prompt_iteration1.md`
- **Resume strategy algorithm**: The backlog doesn't include an explicit iteration for implementing the resume/compaction policy. This is one of the hardest practical problems (when to continue vs restart a session) and deserves its own iteration item, even if small.
- **Human-in-the-loop approval gates**: The feature refinement loop where the user iterates with the planner is not represented in any iteration. How does the system pause for human approval?
- **Interactive mode**: No iteration addresses the "at least one interactive agent for ad-hoc tasks" need. Even for v0, having `p0 chat` as a way to interact with a context-loaded agent would be valuable for debugging and development.

### From `ORCHESTRATOR_PLANNING_PROMPT.md`
- **Pre-submission cleanup step**: Section 3.3 describes a "cleanup subagent" that runs before review to "simplify, deduplicate, and remove sloppiness." This is the "desloppifier" concept. Not in any iteration.
- **Coordination metrics**: Section 5.4 describes tracking incorrect coordination — conflicts, race conditions, duplicate work. Not addressed in the logging/storage iteration.
- **Cost tracking**: Section 5.7 describes per-agent, per-model, per-project cost tracking. Not in any iteration.

### Practical gaps
- **No iteration for prompt engineering**: Writing effective prompts for each role is a substantial task. The backlog assumes prompts exist but doesn't schedule their creation.
- **No iteration for testing the orchestrator itself**: How do you know the orchestrator works correctly? There should be a small test suite — even just 3-4 scripted scenarios.

---

## 4. My Own Recommendations

### A. Collapse iterations A+B into a single "Contracts Sprint"
One 1-2 day sprint that produces:
- `DECISION_RECORD.md` (already half-written from this Oracle session)
- Role taxonomy (already decided)
- File contracts (FEATURE_SPEC, TASKSET, TASK, REVIEW, SESSION_SUMMARY, DECISIONS, TODO)
- Filesystem layout
- Backend contract (as a text spec, not code yet)

### B. Make iteration C "implement the thinnest possible loop" not "implement the backend abstraction"
The goal should be: "call `claude -p` with a prompt, call `codex exec` with a prompt, capture both outputs." Not: "define a capability interface with 8 fields." The abstraction emerges from the implementation.

### C. Add a "Prompt Engineering" iteration between C and E
Before you can run the deterministic loop (E), you need working prompts for:
- Planner: "Given this feature spec, produce a taskset"
- Worker: "Given this task, implement it in this worktree"
- Reviewer: "Given this diff and task spec, produce a review"

Each of these needs 2-3 iterations of testing and refinement. This is real work that the backlog ignores.

### D. Redefine success for the first demo
Instead of "the system leaves a PR-ready result" (iteration F, from the foundation doc), I'd set the bar at:
1. A feature spec goes in
2. A taskset comes out
3. A worker produces code in a worktree
4. A reviewer produces a review document
5. All logs are captured

Whether the code is actually correct or the review catches all issues is secondary — v0 success means the loop runs end-to-end without crashing.

### E. Budget explicit time for "learning the backends"
Neither `claude -p` nor `codex exec` are well-documented for orchestration use cases. Budget 1-2 days for experimentation: what flags work, what output formats are available, how does error handling work, what are the actual token/rate limits. This knowledge is prerequisite for everything else.

---

## 5. Assessment of Proposed File Contracts

| File | Assessment | Notes |
|------|-----------|-------|
| `FEATURE_SPEC.md` | **Good** | Sections are comprehensive. Add: priority, estimated effort, cost budget |
| `TASKSET.md` | **Good but needs additions** | Add: cost budget, time budget, context requirements, retry policy per task |
| `TASK.md` | **Good** | Add: context files to inject, backend preference with fallback |
| `REVIEW.md` | **Good** | Severity classification (S0-S3) is well-designed |
| `SESSION_SUMMARY.md` | **Good** | Add: tokens consumed, cache hit rate if available |
| `DECISIONS.md` | **Missing** | Needs its own contract — critical for restart context |
| `TODO.md` | **Missing** | Needs its own contract — referenced but not defined |
| `WORKFLOW_CONTRACT.md` | **Proposed but undefined** | The meta-document describing how files relate to each other |

---

## Summary Assessment

The backlog is well-structured but **too sequential and too documentation-heavy** for the time constraints. The file contracts are mostly right but need additions (DECISIONS.md, TODO.md, cost tracking). The iteration sequence should be compressed from 6 serial phases to 3 parallel-capable phases. The backend abstraction should emerge from implementation, not precede it. And the backlog critically underestimates the prompt engineering effort required to make any of this work.

**Key risk**: If Brayan follows this backlog literally, he'll have excellent documentation and no running code by day 7. The documents are means, not ends — prioritize the working loop.
