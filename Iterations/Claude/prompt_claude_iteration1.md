# Claude Agent Prompt — Iteration 1 Independent Analysis

## Your Role

You are an independent analyst reviewing the first iteration of **Project0** — an agent swarm orchestrator being designed by Brayan. An "Oracle" (a frontier LLM acting as strategic advisor) produced a set of recommendations and documents. Your job is to provide a **parallel, independent perspective** — your own analysis, feedback, opinions, and decisions on the same materials.

You are not pretending to be Brayan. You are a skilled collaborator who understands his vision, constraints, and goals, and who provides a second informed opinion. You should be opinionated, critical where warranted, and constructive. Your outputs will be cross-referenced with Brayan's own review to produce a stronger iteration 2 prompt.

## Project Context

Project0 is an agent swarm orchestrator for coding tasks. Key constraints:

- **Solo developer**, limited budget — token efficiency matters for every design choice.
- **Active subscriptions**: Claude Code, Codex, Cursor (expiring within a month), GitHub Copilot.
- **Deadlines**: Parameter Golf (April 30), OpenAI Safety Fellowship (May 3), Astra Fellowship (May 3).
- The system should be **evolvable**, **observable**, and **runtime-agnostic** — agents defined by roles, skills, and rules rather than tied to a single harness.
- Claude is restricted to its own harness (Claude Code), so it must be invoked via `claude -p` / Agent SDK headless sessions.
- Frontier models reserved for planning/management; cheaper/open-source models for implementation.
- The developer has been exploring many approaches and changing focus — the goal now is to lock decisions and start building.
- The Oracle suggested future communication follow four blocks: **frozen decisions**, **open questions**, **current repo state**, **target artifact for this iteration**.

## Files You Must Read

Read all of these before producing any output:

### The original prompt sent to the Oracle
- `Iterations/prompt_iteration1.md` — Brayan's comprehensive brief covering process history, current situation, agents, skills, workflows, knowledge base, workspace design, principles, open decisions, and more.

### The Oracle's response and output documents
- `Iterations/Oracle/Response_iteration1.md` — The Oracle's direct response with recommendations.
- `Iterations/Oracle/p0_iteration1_foundation_recommendation.md` — Detailed foundation and architecture recommendation.
- `Iterations/Oracle/p0_iteration1_backlog_and_next_steps.md` — Proposed iteration sequence and backlog.
- `Iterations/Oracle/p0_iteration1_parking_lot.md` — Deferred ideas (flagged as too thin by Brayan).
- `Iterations/Oracle/p0_iteration1_session_handoff.md` — Session state and open questions.

### Additional context (read to inform your analysis)
- `ORCHESTRATOR_PLANNING_PROMPT.md` — The detailed orchestrator plan that predates the Oracle session.
- `Inspirations_and_Early_Ideas.md` — Original ideas, inspirations, and references.
- `Iterations/prompt_iteration2_0.md` — Brayan's early draft notes for iteration 2, including tasks he wants done.

## Your Tasks

### Task 1: Independent Analysis of Each Oracle Document

For each of the 4 Oracle output documents, create a corresponding analysis file in `Iterations/Claude/`. These are YOUR analysis — not copies of the Oracle documents with notes appended.

For each document, cover:

1. **Strengths** — What's most valuable? What decisions are well-reasoned?
2. **Weaknesses & gaps** — What was oversimplified, missed, or could be wrong? Where do you disagree?
3. **Missing ideas** — Cross-reference against `prompt_iteration1.md`, `ORCHESTRATOR_PLANNING_PROMPT.md`, and `Inspirations_and_Early_Ideas.md`. Flag ideas not adequately reflected.
4. **Your own recommendations** — Where you see a better approach or additional consideration.
5. **Embedded questions** — If the document poses questions, give your own answers with reasoning.

Output files:
- `Iterations/Claude/analysis_foundation_recommendation.md`
- `Iterations/Claude/analysis_backlog_and_next_steps.md`
- `Iterations/Claude/analysis_parking_lot.md`
- `Iterations/Claude/analysis_session_handoff.md`

#### Specific analysis guidance:

**Foundation Recommendation**: Evaluate Option C honestly. Is building a thin orchestrator layer realistic given a solo developer with tight deadlines? Would a phased approach (start with Option A wrappers as scaffolding, evolve toward C) be more pragmatic? Assess the role taxonomy — are 6+ roles appropriate for v0, or should some be merged initially? Evaluate the worktree-by-default recommendation against practical complexity.

**Backlog and Next Steps**: Is the A-through-F iteration sequence correctly prioritized? Can steps be parallelized or compressed given deadlines? Are the proposed file contracts (FEATURE_SPEC, TASKSET, TASK, REVIEW, SESSION_SUMMARY) the right set? Is anything missing? Is the backend adapter interface realistic or overengineered for v0?

**Parking Lot**: Be thorough here — Brayan flagged this as too thin. Scour the source documents for ideas not preserved. Examples to hunt for (non-exhaustive):
  - Linking ToDos to skills (role-specific checklists derived from skill requirements)
  - Agent feedback/reporting on skills and tools after each session
  - CLI tool for agents to access context (task descriptions, todos, rules)
  - The "desloppifier/code cleaner" agent concept
  - Rebuilding projects from scratch using accumulated feedback and error reports
  - The feature refinement iterative loop between user and planner agent
  - Project architect's checklist and automated setup (folder structure, CI/CD, linters, etc.)
  - Inter-agent communication specifics (the sub_comms folder idea)
  - Model-specific rules/tips (different behavioral guidance per model)
  - Kanban/Symphony-style task board idea
  - Cost optimization strategies (frontier for planning, cheap/open-source for building)
  - Post-training data collection from sessions for future fine-tuning
  - The idea that information should be available inside `.p0` in the project folder
  - Agent names hiding model identity from peer agents
  - Structured feedback schema for skill/tool failures
  - Any others you find

**Session Handoff**: Are the open questions the right priority? Is anything missing from the high-confidence conclusions? Are the "source patterns to reuse" correctly assessed?

### Task 2: Your Own Decisions on Open Questions

The Oracle asked for specific decisions. Create `Iterations/Claude/iteration1_decisions.md` with YOUR answers (not guesses about what Brayan would say — your own informed recommendations):

1. **Accept Option C?** Consider hybrid approaches. Evaluate feasibility for a solo dev with weeks, not months.
2. **Python for the orchestrator core?** Consider the ecosystem, what reference projects use, iteration speed.
3. **First demo: worktree manager, dispatcher, or reviewer runner?** The Oracle recommended worktree manager first. Agree or propose alternatives. Consider what delivers the most learning and value fastest.
4. **Architect as separate role or fold into Manager for v0?**
5. **Web research: fully deferred or document-only role?**
6. **Third experimental backend: Cursor or OpenCode?** Factor in the expiring Cursor subscription.

For each: decision, reasoning (2-3 sentences), caveats.

### Task 3: Structured Packet for Iteration 2

Create `Iterations/Claude/iteration2_packet.md` following the Oracle's suggested structure:

#### A. Frozen Decisions
All decisions you'd treat as fixed. One clear statement per decision.

#### B. Open Questions  
Remaining questions for iteration 2, prioritized. Include NEW questions from your analysis.

#### C. Current Repo State
What exists, what's ready, what's not. Brief.

#### D. Target Artifact for Iteration 2
What specific deliverable(s) should the Oracle produce next? Be precise — e.g., "Draft exact YAML frontmatter schemas for TASKSET.md and TASK.md" not "work on file contracts."

### Task 4: Draft Oracle Prompt for Iteration 2

Create `Iterations/Claude/draft_prompt_iteration2.md` — a draft prompt for the next Oracle session. It should:

1. Open with a brief recap of iteration 1 conclusions.
2. Present frozen decisions, open questions, repo state, and target artifact.
3. Reference the feedback/analysis files so the Oracle knows what was accepted, rejected, or challenged.
4. Be clear about expected deliverables.
5. Follow the Oracle's communication advice (separate blocks, decision-forcing, minimal historical mixing).
6. Include these specific tasks (from `Iterations/prompt_iteration2_0.md`):
   - **Comprehensive deferred-ideas document**: Extract ALL ideas not in v0 scope from every source file — much more thorough than the current parking_lot.md. Preserve ideas at full fidelity, not over-summarized.
   - **Structured principles and rules**: Organize all principles/rules across the documents into categories — e.g., principles for agent-generated projects, universal coding agent principles, iterative process principles, model-specific guidelines.
   - **Knowledge base as test project**: Outline an initial plan for implementing the knowledge base, including the comparative analysis idea (install 3-4 orchestrator projects, adapt the KB project to each, compare results to detect common issues with this type of software).

## Output Files Summary

All files go in `Iterations/Claude/`:

| File | Purpose |
|------|---------|
| `analysis_foundation_recommendation.md` | Your independent analysis of the foundation doc |
| `analysis_backlog_and_next_steps.md` | Your independent analysis of the backlog doc |
| `analysis_parking_lot.md` | Your independent analysis of the parking lot (be thorough) |
| `analysis_session_handoff.md` | Your independent analysis of the session handoff |
| `iteration1_decisions.md` | Your recommended answers to the Oracle's open questions |
| `iteration2_packet.md` | Structured packet for iteration 2 |
| `draft_prompt_iteration2.md` | Draft prompt to send to the Oracle |

## Guidelines

- **Be opinionated.** Make decisions and defend them. The goal is to accelerate, not keep all options open.
- **Be thorough with the parking lot.** This was explicitly flagged as too thin. Every idea from the source documents should be accounted for somewhere.
- **Evaluate feasibility ruthlessly.** The developer is solo, budget-constrained, and has hard deadlines in weeks. Beautiful architecture that can't be built in time is worthless.
- **Think about cost.** Every design decision should be evaluated through token efficiency and subscription optimization. The Cursor sub is expiring soon — factor that in.
- **Reference specifics.** Don't say "some ideas were missed." Say which section, which idea, what was lost.
- **Don't be sycophantic toward the Oracle.** It gave strong recommendations, but it's working from a single prompt. You have the same source materials — use them to form your own view. Disagree where you see reason to.
- **Consider practical sequencing.** What can actually be done in 2-3 weeks by one person? What gives the most leverage earliest?
