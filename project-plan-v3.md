# Multi-Agent Orchestration Platform — Master Plan v3

## 0. Meta-Principle: Everything Is Optimizable

Every process, workflow, configuration, and interaction pattern described in this document must be:
- **Designed as a replaceable module**, not hardcoded logic
- **Measurable** (logged with enough detail to evaluate performance)
- **Configurable** (changeable without rewriting core code)
- **Improvable** by agents themselves based on accumulated data

This is not aspirational — it is a constraint on every design decision. If a workflow cannot be swapped, measured, or refined, it is not ready for implementation.

---

## 1. Vision

Build a **secure, modular, fully configurable control plane** for fleets of AI coding agents working in parallel, inspired by the **pi-agent architecture** (fully customizable, modular, extensible via skills/extensions).

The platform is:
- An **orchestrator** that decomposes work into leaf tasks executable with high certainty
- A **session manager** that runs each agent in an isolated workspace (git worktree + optional container)
- A **coordination layer** where agents announce their presence, share status, and ask each other questions
- A **permission enforcer** with configurable tool-access policies per role
- A **review pipeline** with automated feedback loops back to the original agent session
- A **structured logger** capturing every interaction as RL-ready training data
- A **self-improvement engine** that accumulates per-model failure notes and refines agent behavior over time

The platform will be **built by agents, verified by agents, and improved by agents**.

---

## 2. Scope Boundaries

### v0 — Coding Orchestration Core (Build This First)
- Multi-agent execution across isolated worktrees/branches
- Role-based tool access enforcement with configurable policies
- **Agent coordination space** (shared ephemeral chat for presence/status/questions)
- Structured logging suitable for RL datasets
- Review → feedback → retry loop with severity-based escalation
- LLM provider abstraction layer (OAuth-based subscription access as primary path)
- Basic task decomposition (orchestrator → cell agents)

### v1+ — Expand Later (Don't Block v0 on These)
- Rich UIs (dashboard, web app, Mac-native experience)
- Multi-channel messaging bridges (Telegram, Slack, Discord)
- Tracker integrations (GitHub Issues, Linear) beyond basic PR creation
- Persistent assistant behaviors (always-on, multi-channel)
- Advanced per-model self-improvement distillation from reviewer feedback
- Cost optimization and model routing refinements

---

## 3. Foundation Choice: pi-agent Architecture

The platform is built on the **pi-agent/pi-mono approach**: fully customizable, modular, extensible through skills and extensions.

### Why pi-agent as foundation
- Unified LLM API with multi-provider support
- Skills/extensions model allows adding capabilities without modifying core
- "Code that builds itself" philosophy aligns directly with our goals
- Already supports PTY-based agent sessions

### LLM Provider Strategy

**Primary path: OAuth-based subscription access** (as pi-agent already does), using existing subscriptions (Claude, ChatGPT, Kimi, etc.) where this does not violate TOS.

**Alternative paths to keep available:**
- **Non-interactive CLI modes**: Codex CLI (confirmed non-interactive mode), Claude Code (needs investigation — subscription vs. API requirement unclear)
- **tmux-based invocation**: Wrap CLI agents (e.g., Claude Code) in tmux sessions as a fallback
- **Direct API access**: For providers where OAuth isn't viable or when full customization is needed

**Decision still needed:** TOS review for each subscription provider to confirm OAuth usage is permitted. This is a Phase 0 research task.

**Preference order:** OAuth subscriptions (most flexible, cheapest) → Direct API → CLI via tmux (least customizable, but useful for experimentation)

---

## 4. Non-Negotiable Requirements

### 4.1 Security & Isolation — Role Separation

**Core rule: no single agent gets both "bash" and "internet search" by default.**

| Role | Access | Purpose |
|---|---|---|
| **Searcher** | Web search only, no filesystem, no bash | Gathers external information safely |
| **Builder** | Scoped filesystem + bash (project folder only), no internet | Writes code based on provided context |
| **Reviewer** | Read-only filesystem + diff access + test runner, no write, no internet | Verifies work, classifies failures, provides structured feedback |
| **Orchestrator** | Agent spawning + task routing + plan management only | Decomposes tasks, assigns work, escalates, logs decisions |
| **Scaffolder** | Scoped filesystem + bash + project template skills, no internet | Creates new project foundations (language-specific boilerplate, build configs, CI setup) — activated only after planning is complete |

**Enforcement rules:**
- Each agent only accesses tools defined for its role
- System raises a **warning/flag** when any agent attempts unauthorized tool use → potential prompt injection detection
- Default: agent scoped to its assigned folder only
- Configurable opt-in policies for broader access (per-repo, per-session)
- **Tool gating via extensions**: For certain sensitive commands, an extension prompts for confirmation before execution (not full YOLO, not full lockdown — configurable per command class)
- The enforcement mechanism itself must be configurable and swappable

### 4.2 Agent Coordination Space

Agents working in the same codebase simultaneously need a way to avoid conflicts and collaborate:

- **Ephemeral shared chat/registry**: agents register their presence with a structured template:
  ```
  agent_id: [id]
  role: [builder/reviewer/searcher]
  working_on: [task_id / description]
  files_touched: [list of files being modified]
  branch: [worktree/branch name]
  started_at: [timestamp]
  ```
- The space is **ephemeral** — reset after N tokens or after a configurable time window
- Agents can **ask questions to other active agents** through this space (coordination, not just announcement)
- Any agent can use this space, not just orchestrators
- This coordination space is itself a module that can be replaced with a more sophisticated mechanism later

### 4.3 Logging — Every Interaction as Training Data

**What to capture (minimum event types for RL readiness):**

| Event Category | Events |
|---|---|
| **Planning** | `task_created`, `task_assigned`, `plan_created`, `task_decomposed` |
| **Tool usage** | `tool_invoked`, `tool_denied`, `tool_violation_warning` |
| **Execution** | `command_ran`, `command_output`, `diff_created` |
| **Testing** | `tests_ran`, `tests_passed`, `tests_failed` |
| **Review** | `review_started`, `review_passed`, `review_failed`, `review_feedback_sent` |
| **Escalation** | `retry_scheduled`, `escalation_triggered`, `question_raised`, `handoff_completed` |
| **Conversation** | Full agent↔agent and agent↔user transcripts |
| **Coordination** | `presence_registered`, `presence_cleared`, `inter_agent_question`, `inter_agent_answer` |
| **Self-improvement** | `model_failure_note_created`, `model_failure_note_updated` |

**Critical logging rules:**
- Preserve **multiple versions/iterations** that improve a solution (failures and recoveries are valuable)
- Capture **plans and planning traces** (not just final outputs)
- Record the full iteration chain so you can learn from the improvement trajectory
- Keep orchestration/logging state **outside the target repo** (adaf pattern)

### 4.4 Task Decomposition — The "Cell" Principle

Decompose until the leaf agent ("cell") has **all information and details necessary** to complete the task. Each cell-level task must:
- Follow all project rules
- Be documented properly
- Pass all existing tests
- Pass new tests written for the feature
- Pass deterministic style/format checks (linters, formatters — not left to agent judgment)
- Meet the Definition of Done checklist (Appendix A2)

### 4.5 The Review → Feedback → Retry Loop

This is the core quality mechanism. The flow is **configurable** but the default is:

```
Builder completes task
    → Builder creates a PR / fills a structured output template (md file or PR)
    → System automatically triggers Reviewer
    → Reviewer receives: files modified, previous versions, current versions, diff, test results
        (via git diff / GitHub CLI / a skill that provides this — mechanism is configurable)
    → Reviewer evaluates against acceptance criteria
    
    IF PASS → task marked complete, merge allowed
    
    IF FAIL →
        Reviewer writes structured feedback (what failed, severity, how to fix)
        → System sends feedback as a message to the ORIGINAL BUILDER SESSION
            (same agent, same conversation history, preserving full context)
        → Builder fixes based on feedback
        → Builder re-submits to the SAME REVIEWER
        
        CONTEXT MANAGEMENT:
        - Track what percentage of the model's context window is consumed
        - If approaching a configurable threshold (e.g., 80% of max):
            Option A: Compact the conversation (summarize history, keep key context)
            Option B: Start a clean review session without chat history
        - Must track retry count regardless of context management approach
        
        RETRY LIMITS:
        - After N retries (configurable, default 3) at same severity → escalate
        - Escalation: better model, different agent, or flag for human review
        - Hard maximum before mandatory human review (configurable, default 5 total attempts)
```

**How the Reviewer gets file context:**
The reviewer must have access to: the list of files modified, their previous versions, and their current versions. The mechanism for providing this is configurable (options to evaluate: git diff, GitHub CLI, a custom skill that packages this information, a PR-based workflow). This is a Phase 1 architecture decision.

### 4.6 Escalation & Question-Raising (Corrected)

**Clarification: asking questions upward is available to ANY agent**, not only reviewers. Any agent that lacks information to proceed can raise a question to:
- The agent that assigned its task
- The user (if at the top of the chain)
- Other active agents (via the coordination space)

**Self-spawning (starting a new session with refined context):**
- This capability **must be studied per agent type** before being enabled
- Not all roles should be allowed to self-spawn — the risk of loops and cost varies
- Phase 1 must define: which roles can self-spawn, under what conditions, with what limits
- Until studied: only the orchestrator can spawn new agent sessions

### 4.7 Formatting & Style: Deterministic, Not Agent-Judged

Code formatting and style checks must use **deterministic tools** (linters, formatters, static analysis), never agent judgment:
- Language-specific formatters (prettier, black, rustfmt, gofmt, etc.)
- Linters (eslint, ruff, clippy, etc.)
- Style rules defined in config files that are part of the repo
- These run as part of the automated check pipeline, before the reviewer even sees the code
- The reviewer focuses on **logic, correctness, architecture, and documentation** — not style

### 4.8 Per-Model Self-Improvement Notes

The system accumulates **per-model failure profiles** to improve agent behavior over time:

- When a reviewer identifies a recurring failure pattern for a specific model, a structured note is created/updated
- These notes live in a `MODEL_NOTES/` directory (e.g., `MODEL_NOTES/claude-sonnet-4.md`, `MODEL_NOTES/gpt-4o.md`)
- Format: pattern observed, frequency, severity, recommended mitigation (prompt adjustments, task constraints, etc.)
- These notes are fed as context to the orchestrator when it assigns tasks to that model
- **Distillation**: periodically, a dedicated agent reviews accumulated failure notes and proposes refined default prompts/constraints per model

**Priority:** This is a v1 feature (can wait), but the logging infrastructure in v0 must capture enough data to enable it later. Specifically, every review failure event must include: the model that produced the failing output, the failure category, and the reviewer's assessment.

---

## 5. New Project Scaffolding

When creating a new project from zero, a specialized **Scaffolder agent** (a builder with project-template skills) sets up the foundations:

- Triggered **only after planning is complete** (architecture decisions are made, tech stack is chosen)
- Determines scaffolding based on: language(s), whether it's frontend/backend/fullstack, framework choices, build system, CI/CD needs
- Creates: directory structure, build configuration, dependency manifests, linter/formatter configs, CI pipeline stubs, test framework setup, README template, contributing guidelines
- This is a **one-time setup task** per project, not part of the ongoing orchestration loop
- The scaffolder's template library is itself extensible (new project types can be added as skills)

---

## 6. Reference Projects — Prioritized and Classified

### Tier A — Direct Foundations / Core Patterns (Deep-Dive Required)

| # | Project | Role | Why It Matters | Key Question |
|---|---------|------|----------------|--------------|
| 1 | **pi-mono + agent-stuff** | **Primary foundation** | Unified LLM API, modular skills/extensions, PTY sessions, "code that builds itself." Aligns with our customizability and multi-provider goals. | Which skills/extensions are directly reusable? What's the effort to add our role-enforcement and coordination layers? |
| 2 | **Agent of Empires (AoE)** | Foundation (sessions) | Rust TUI, tmux + git worktrees, multi-CLI support. Most mature session manager. | Can we use this as our session/isolation layer, or does pi-mono's PTY approach make it redundant? |
| 3 | **adaf** | Foundation (state/logs) | Meta-orchestrator with plans, issues, wiki, deep recordings outside the target repo. Structured relay handoffs. | Is this our orchestration state + logging layer? How does its recording schema map to our RL needs? |
| 4 | **Composio Agent Orchestrator** | Foundation (CI/review) | Agent-agnostic, auto CI-fix, runtime-agnostic, tracker-agnostic. End-to-end PR lifecycle. | Does its review/CI loop complement our review pipeline, or is it better to build our own? |

### Tier B — Integration Components (Evaluate for Inclusion)

| # | Project | Role | What to Extract |
|---|---------|------|-----------------|
| 5 | **oomp** | Integration | Web dashboard patterns for monitoring CLI agents |
| 6 | **takopi** | Integration | Telegram bridge for remote session management, progress streaming |
| 7 | **ai-data-extraction** | Direct tool | Extract conversation data from existing tools for bootstrapping RL datasets |
| 8 | **BuildSpace** | Integration | Reusable CI/CD blocks (release notes, version bumping, publishing) |
| 9 | **Zellij / tmux / `claude --worktree`** | Integration | Session/worktree management ergonomics |

### Tier C — Inspiration / Competitive Benchmarks

| # | Project | What to Learn |
|---|---------|---------------|
| 10 | **Agentastic.dev** | Isolated worktrees/containers per agent, multi-agent code review before merge |
| 11 | **Conductor** | Dashboard UX, "who's working on what", Linear + GitHub integration |
| 12 | **Codex.app** | Multi-agent command center, project-based context switching |
| 13 | **OpenClaw + variants** | Channel systems, skill architecture, container-per-agent isolation (NanoClaw), minimal binary security (ZeroClaw) |
| 14 | **hermes-agent** | Persistent agent that learns/builds skills over time |
| 15 | **ypi** | Recursive agent architecture built on RLMs |

---

## 7. Decisions — Now vs. Later

### Must Decide Before Building

| # | Decision | Options | Current Leaning |
|---|----------|---------|-----------------|
| 1 | **v0 scope** | Coding-orchestration only vs. also multi-channel | Coding-only. No channel expansion for v0. |
| 2 | **Foundation project** | pi-mono as base vs. build from scratch vs. hybrid | pi-mono as primary foundation, extended with our layers. |
| 3 | **LLM access method** | OAuth subscriptions vs. API vs. CLI wrappers | OAuth first (cheapest, most flexible). API as fallback. CLI/tmux for experimentation. **TOS review needed per provider.** |
| 4 | **Isolation baseline** | Worktrees only vs. container-per-agent | Worktrees as default. Optional Docker for untrusted tasks. |
| 5 | **Coordination mechanism** | Ephemeral shared chat vs. file-based registry vs. message queue | Ephemeral shared chat (simplest, aligns with pi-agent patterns). |
| 6 | **Role model + permissions** | Minimum role set, tool allowlists | 5 roles: searcher, builder, reviewer, orchestrator, scaffolder. |
| 7 | **Review pipeline mechanism** | PR-based vs. template/md-file-based vs. git-diff skill | Needs Phase 1 evaluation. PR-based preferred if GitHub CLI integration is straightforward. |
| 8 | **Log storage** | Inside repo vs. separate (adaf pattern) | Outside target repo. |
| 9 | **Self-spawn policy** | Which agent types can self-spawn | Only orchestrator for v0. Study others in Phase 1. |
| 10 | **Style enforcement** | Agent-judged vs. deterministic tools | Deterministic only. Linters/formatters, never agent opinion. |

### Can Wait

- UI choice (TUI vs. web vs. native app)
- Multi-channel control (Telegram, Slack, Discord)
- Tracker integrations beyond basic PR flow
- Per-model self-improvement distillation (but log the data now)
- Cost optimization and dynamic model routing
- Advanced coordination (beyond ephemeral chat)

---

## 8. Execution Roadmap

### Phase 0: Research & Project Reports (~2 days with agents)

**Goal:** Structured reports for Tier A + Tier B projects, plus TOS review for subscription providers.

**Process:**
1. Spawn one agent per project (Tier A first, parallel if possible)
2. Each agent explores the repo: README, docs, source code, issues, examples
3. Produces a standardized report (template below)
4. **Additional research task:** TOS review for Claude, ChatGPT, Kimi, and other subscription providers regarding OAuth-based programmatic access
5. A **synthesis agent** reads all reports + this master plan and:
   - Confirms or adjusts pi-mono as foundation choice
   - Maps which components come from which projects
   - Identifies gaps requiring custom development
   - Recommends how AoE, adaf, and Composio complement or overlap with pi-mono

**Report Template:**
```
Project: [name]
URL: [github link]
License: [license type]
Tech Stack: [languages, frameworks, key dependencies]
Core Features: [what it does]
Multi-Agent Approach: [parallelism — worktrees, containers, sessions]
Security Model: [sandboxing, isolation, permissions, tool restrictions]
Integration Points: [APIs, OAuth, MCP, CLI flags]
LLM Provider Support: [which providers, how connected — OAuth, API, CLI]
Logging / Observability: [what it logs, format, storage]
Maturity: [stars, contributors, last commit, issue activity]
Advantages for Our Platform: [specific features/patterns we'd use]
Limitations / Gaps: [what's missing for our needs]
Recommendation: [foundation / integration / inspiration / skip]
Key Code to Study: [specific files/modules worth reading]
```

### Phase 1: Architecture Definition (~2 days with agents)

**Goal:** Definitive architecture documents that agents can build from.

**Deliverables:**

| Document | Purpose |
|---|---|
| `ARCHITECTURE.md` | System overview, component diagram, data flow, module boundaries, configuration points |
| `SECURITY.md` | Role definitions, tool allowlists, isolation strategy, tool-gating extensions, threat model |
| `AGENTS.md` | Agent types, capabilities, escalation rules, self-spawn policy, coordination protocol |
| `LOGGING.md` | Log schema, event types, storage strategy, RL pipeline design |
| `TASKS.md` | Task template, decomposition rules, Definition of Done, severity rubric |
| `REVIEW_PIPELINE.md` | Reviewer workflow, feedback format, retry mechanics, context management, PR/template mechanism |
| `CONFIGURATION.md` | What is configurable, where configs live, how to change workflows without code changes |
| `PHASES.md` | Build plan with milestones and acceptance criteria per phase |
| `TESTING.md` | How agents verify each other, test requirements, linter/formatter setup per language |
| `SCAFFOLDING.md` | Project template system, supported languages/frameworks, how to add new templates |

**Process:**
1. Architecture agent reads all Phase 0 reports + this master plan
2. Proposes architecture with explicit module boundaries and configuration points
3. Review agent evaluates against non-negotiable requirements (Section 4)
4. Iterate until review passes
5. Final documents become the authoritative spec

### Phase 2: Skeleton Build — Minimum Safe Orchestration Loop (~3-5 days)

**Goal:** Working system that runs the core loop on a real task.

**The MVP loop:**
1. Orchestrator decomposes a task into 2-3 subtasks
2. Orchestrator creates **isolated worktrees** per subtask
3. Agents register in the **coordination space** (presence + status)
4. **Searcher** gathers needed external context (web search only)
5. **Builder** produces changes, runs deterministic style checks (linters/formatters), runs tests
6. Builder submits output (PR or structured template)
7. System triggers **Reviewer** with full diff context (files modified, before/after, test results)
8. **If pass** → merge allowed
9. **If fail** → Reviewer sends structured feedback to **original builder session** (same history)
10. Builder fixes → re-submits to **same reviewer**
11. Context window tracked; compact or clean-start if threshold exceeded
12. Retry count enforced; escalate after limit
13. Everything **logged as structured events** outside the target repo

**What "done" looks like for Phase 2:**
- Can decompose a real task into subtasks
- Can spawn isolated agent sessions with enforced role permissions
- Can detect and flag unauthorized tool use
- Coordination space works (agents register presence, can query each other)
- Review → feedback → retry loop works end-to-end at least once
- Deterministic style checks run before review
- Produces structured logs for every step
- All workflows are configurable (not hardcoded)

### Phase 3: Deep Recording + Dataset Readiness (~1-2 days)

**Goal:** Ensure logs are genuinely useful for RL before adding more features.

- Full capture: prompt/context → plan → tool calls → command outputs → diffs → tests → review feedback → retries/escalations → final resolution
- Iteration chains preserved (version N → version N+1 with what changed and why)
- Per-model failure data captured with enough detail to enable future self-improvement notes
- Validate: can you reconstruct any task's full trajectory from logs alone?
- Define retention policy and storage limits

### Phase 4: Expand Integrations (ongoing, after core loop is reliable)

- PR/CI lifecycle behaviors (Composio patterns)
- Dashboard/monitoring (oomp patterns)
- Remote session management (takopi bridge)
- GitHub/Linear tracker integration
- Dataset bootstrap from existing tools (ai-data-extraction)
- Scaffolder agent with initial project templates

### Phase 5: Self-Improvement Loop (ongoing)

- Agents use the platform to build new features for the platform
- Per-model failure notes begin accumulating (`MODEL_NOTES/`)
- Distillation agent periodically reviews failure notes → proposes prompt/constraint refinements
- Logs feed back into model routing decisions
- New skills/tools added by agents as needed
- Workflows themselves get optimized based on measured performance data

---

## 9. Architecture Implications of "Agents Build the System"

1. **Separate "doer" vs. "checker" roles** to reduce correlated mistakes
2. **Reviewer feeds back to the original session**, preserving context — not a fresh start every time
3. **Orchestration state lives outside the code repo** to prevent tampering and preserve training data
4. **Every architectural document is also an agent prompt** — specs must be written so agents follow them directly
5. **Deterministic checks are the first gate** — linters and tests before any agent review
6. **The test suite is the ground truth** — if deterministic checks pass, tests pass, and docs exist, the task is done
7. **Bootstrap problem acknowledged**: Phase 2 skeleton must be built manually or by a single agent session before the system can build itself
8. **Configurability is a first-class concern** — changing a workflow (e.g., swapping the review pipeline mechanism) should require config changes, not code rewrites
9. **Every workflow is a candidate for optimization** — the system must measure its own processes well enough to identify bottlenecks and propose improvements

---

## 10. Risk Register

| Risk | Impact | Likelihood | Mitigation |
|---|---|---|---|
| Over-engineering before validating core loop | High | High | Phase 2 is deliberately minimal. No UI, no integrations, just the loop. |
| TOS violation using OAuth for subscriptions | High | Medium | Phase 0 includes explicit TOS review per provider. Fallback to API/CLI ready. |
| Security holes from agents with too much access | High | Medium | Role separation from day 1. Tool-violation flagging. Default least-privilege. |
| Coordination space becomes a bottleneck or attack vector | Medium | Medium | Ephemeral by design (auto-reset). Structured templates only, not free-form. |
| Review→retry loops consume too much context | Medium | High | Context threshold tracking. Compaction or clean-start policies. Retry limits. |
| Infinite loops from self-spawning agents | Medium | Medium | v0: only orchestrator can spawn. Self-spawn policy studied in Phase 1. Budget limits. |
| Analysis paralysis from too many project options | Medium | Medium | pi-mono as declared foundation. Synthesis agent confirms or adjusts. |
| Foundation choice (pi-mono) turns out wrong | High | Low | Architecture designed with module boundaries — session layer, LLM layer, logging layer are swappable. |
| Log storage growing uncontrollably | Low | Medium | Retention policy in Phase 3. Separate storage from code repo. |
| Model costs spiraling from escalation chains | Medium | Medium | Cost tracking per task (in log schema). Budget caps. Prefer cheaper models for retries. |
| Bootstrap problem: can't self-build until v0 exists | Medium | Certain | Phase 2 skeleton built manually. Accepted as necessary bootstrapping cost. |
| Deterministic tools (linters) not available for all languages | Low | Medium | Scaffolder includes linter setup. Fallback: define minimum supported languages for v0. |

---

## 11. Immediate Next Steps

```
RIGHT NOW:
  1. Review this v3 plan. Flag anything that still doesn't match your thinking.
  2. Tentatively confirm the "Must Decide" items in Section 7.
  3. Specifically decide: which subscription providers to TOS-review first.

THEN:
  4. Set up the Phase 0 research pipeline.
     - Agent per Tier A project (pi-mono, AoE, adaf, Composio)
     - Parallel TOS review task for subscription providers
     - Then Tier B projects
  
  5. Run synthesis agent → confirm pi-mono as foundation → map component sources.
  
  6. Begin Phase 1: architecture documents.
     - These are the "agent contract" — once written, agents can build from them.
     - CONFIGURATION.md and REVIEW_PIPELINE.md are new critical deliverables.
  
  7. Phase 2: build the skeleton loop.
     - This is the bootstrap moment — built manually, then the system takes over.
```

---

## Appendix A — Starter Templates

### A1. Leaf Task Template

```yaml
task_id: [unique identifier]
goal: [one sentence — what this task must accomplish]
context: [everything the cell agent needs — no assumptions, no implied knowledge]
constraints:
  role: [builder | searcher | reviewer | scaffolder]
  allowed_tools: [explicit list]
  scoped_to: [directory path]
  model: [default model, or "any"]
  style_checks: [linter/formatter commands to run before submission]
inputs:
  files: [list of files the agent will read]
  dependencies: [other task IDs that must complete first]
acceptance_criteria:
  - [criterion 1]
  - [criterion 2]
tests:
  existing: [test files that must still pass]
  new: [new tests to write]
docs_required: [what documentation must be produced]
done_checklist:
  - [ ] Deterministic style checks pass (linter, formatter)
  - [ ] All existing tests pass
  - [ ] New tests written and passing
  - [ ] Code follows project rules
  - [ ] Documentation updated/created
  - [ ] No unauthorized tool usage flagged
  - [ ] Review agent approved
```

### A2. Definition of Done

A task is **done** when:
1. Deterministic style/format checks pass (linters, formatters — configured per project)
2. All existing tests pass (no regressions)
3. New tests cover the added/changed functionality and pass
4. Code follows project rules
5. Documentation is updated or created as needed
6. No tool-policy violations were flagged during execution
7. Review agent has approved the output
8. Changes are committed to the task's worktree/branch

### A3. Failure Severity Rubric

| Level | Name | Description | Action |
|---|---|---|---|
| **S0** | Cosmetic | Linter/formatter issues that slipped through, minor naming | Auto-fix with deterministic tools if possible. Otherwise retry with specific instructions. |
| **S1** | Local correctness | Failing tests, missing docs, minor logic bug | Feedback to original builder session. Escalate if 2+ retries fail. |
| **S2** | Systemic | Architecture mismatch, widespread failures, security/tool-policy violation | Escalate to better model/agent. May require human review. |
| **S3** | Blocked | Missing information, ambiguous requirements, depends on incomplete task | Raise question upward (any agent can do this). Do not retry — wait for answer. |

### A4. Log Event Schema

```json
{
  "event_id": "uuid",
  "timestamp": "ISO-8601",
  "event_type": "[see event table in Section 4.3]",
  "task_id": "parent task reference",
  "agent_id": "which agent produced this event",
  "agent_role": "searcher | builder | reviewer | orchestrator | scaffolder",
  "agent_model": "model identifier (critical for future per-model analysis)",
  "session_id": "session/worktree reference",
  "payload": {
    "input": "what the agent received",
    "output": "what the agent produced",
    "tool_name": "if tool event",
    "severity": "if review/failure event",
    "decision": "if escalation event",
    "diff": "if code change event",
    "version": "iteration number within retry chain",
    "context_usage_pct": "percentage of model context window used",
    "failure_category": "if failure — for future per-model analysis"
  },
  "parent_event_id": "links to prior event in chain",
  "cost": {
    "tokens_in": 0,
    "tokens_out": 0,
    "model": "model used",
    "estimated_usd": 0.0
  }
}
```

### A5. Agent Coordination Space — Presence Template

```yaml
agent_id: [unique id]
role: [builder | searcher | reviewer | orchestrator | scaffolder]
task_id: [what task is being worked on]
working_on: [human-readable description]
files_touched: [list of files being modified — for conflict avoidance]
branch: [worktree/branch name]
started_at: [timestamp]
status: [active | waiting_for_answer | completed]
question: [optional — if the agent needs input from another agent]
question_to: [optional — target agent_id or "any"]
```

### A6. Review Feedback Template (Reviewer → Builder)

```yaml
task_id: [task being reviewed]
reviewer_id: [reviewer agent id]
verdict: [pass | fail]
severity: [S0 | S1 | S2 | S3]
retry_number: [which attempt this is]
context_usage_pct: [how much of the builder's context window is estimated used]

failures:
  - type: [test_failure | missing_docs | logic_error | style_violation | security_issue | architecture_mismatch]
    description: [what's wrong]
    location: [file:line or general area]
    suggestion: [how to fix it]

files_reviewed:
  - file: [path]
    status: [approved | needs_changes]

recommendation: [retry_same_agent | escalate_model | escalate_human | blocked_needs_info]
```
