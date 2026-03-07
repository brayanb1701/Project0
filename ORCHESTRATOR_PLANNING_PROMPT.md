# Agent Swarm Orchestrator — Master Planning Document

> **Purpose of this document**: This is the complete specification and context for planning the development of an **Agent Swarm Orchestrator** — a system for managing fleets of AI coding agents using multiple model providers (via OAuth/subscription tokens, CLI tools like Claude Code and Codex, or direct API access). An agent receiving this document should produce a detailed, phased implementation plan covering architecture, workflows, security, monitoring, and all subsystems described below. **Nothing in this document is optional** — every item must appear in the plan, assigned to an appropriate phase (immediate, near-term, or future).

---

## 1. PROJECT VISION

### 1.1 Core Objective
Build a custom harness and orchestrator for a swarm of AI coding agents, leveraging multiple model providers through existing subscriptions (OAuth-based, as in pi-agent) as the primary invocation method, with CLI tools (Claude Code, Codex, Kimi CLI, etc.) as secondary backends. This is the **foundation layer** — the "coder building blocks" — for a much larger system.

### 1.2 Long-Term Vision (Context — Not for Immediate Implementation)
The orchestrator is the base for a personal AI assistant ecosystem (inspired by OpenClaw) that will eventually:
- Receive messages, images, and arbitrary input across channels.
- Integrate with Obsidian (or similar) as a second brain for ideas, plans, notes — with graph-based visualization and cross-topic relation discovery.
- Run 24/7, working on projects by priority (auto-restarting on token limits or failures).
- Consult the user for important decisions, with periodic reminders scaled by urgency and idle-time.
- Recommend topics of interest (papers, videos, etc.) proactively.
- Accept handwritten notes via local OCR → classify → file into the knowledge system (with image-type detection to route only notes to OCR).
- Support an "important information" mode with encryption and access authorization.
- Take ideas from inception through iterative refinement to shipped products/research.
- Evolve into a platform for agent-to-agent interaction experiments — personality, evolution tracking, community dynamics.
- Function as a "personal company" of specialized agents.

### 1.3 Design Philosophy
All code produced by this system (and for this system) must follow these principles **in priority order**:
1. **Functionality** — it works correctly and completely.
2. **Optimization** — it performs well.
3. **Modularity / Granularity** — reusable from fundamental units to composed parts.
4. **Simplification** — no unnecessary complexity.

All four are important. Code must be:
- Fully documented (for both humans and agents), always up to date.
- Thoroughly tested — all tests must pass, new tests added for every change.
- Maintainable as the codebase grows over time.
- Reusable — designed as composable building blocks.
- **Deterministically formatted and style-checked** — use linters, formatters, and static analysis tools (language-appropriate: e.g., `rustfmt`/`clippy`, `prettier`/`eslint`, `gofmt`, `black`/`ruff`). Style must never depend on agent judgment — it must be enforced by tooling. A **hybrid approach** should be evaluated: deterministic linters as the baseline, potentially augmented by LLM-based analysis layers that provide richer remediation context (e.g., explaining *why* a pattern is wrong and *how* to fix it, beyond what static rules can express). The deterministic layer remains the authority; the LLM layer is advisory and must never override it.
- **Prefer reimplementation over dependency when appropriate** — when only a small subset of a library's functionality is needed, consider reimplementing that subset rather than taking the full dependency. A tight, fully-tested internal implementation that agents can inspect, understand, and modify is often preferable to a black-box external library. This decision should be evaluated case by case during planning.

### 1.4 Meta-Principle: Everything Is Optimizable
Every process, workflow, configuration, and interaction pattern in this system must be:
- **Designed as a replaceable module**, not hardcoded logic.
- **Measurable** — logged with enough detail to evaluate performance.
- **Configurable** — changeable without rewriting core code.
- **Improvable** by agents themselves based on accumulated data.

This is not aspirational — it is a **constraint on every design decision**. If a workflow cannot be swapped, measured, or refined, it is not ready for implementation. No process is "final" — all are v1 by default.

---

## 2. ARCHITECTURE DECISIONS REQUIRED — VIA BASE PROJECT SELECTION

> **Key clarification**: The language, system structure, and many architectural decisions below will largely be **determined by which reference project is chosen as the base** (see Section 7.2). These criteria should be evaluated **as part of selecting that base project** — not in isolation. The analysis should compare the reference projects against these criteria to arrive at a recommendation for which project to build upon (fork, extend, or use as primary reference).

### 2.1 Language Selection
The language will follow from the base project choice, but the analysis should evaluate each candidate base project's language against:
- Performance and resource efficiency (this will run many concurrent agents).
- Ecosystem maturity for CLI process management, async I/O, IPC.
- Ease of integrating with external CLIs (spawning, PTY management, streaming output).
- Developer ergonomics, maintainability at scale.
- Community and library support for: git operations, markdown parsing, file watching, logging, metrics, encryption.
- Cross-platform considerations (Linux-first, but future portability).
- **Agent comprehensibility** — can current LLMs reason well about this language and its ecosystem? Languages with strong representation in training data, stable APIs, and comprehensive documentation are an asset. This is a first-class selection criterion since agents will build and maintain the system.

**Languages represented in reference projects**: Rust (Agent of Empires, ZeroClaw), TypeScript (OpenClaw, pi-mono, oh-my-pi), Python (ypi, hermes-agent), Zig (NullClaw), Elixir (Symphony reference implementation), Go (codex-autorunner). The base project recommendation must justify why its language is the best fit.

### 2.2 System Structure
Evaluate each candidate base project's architecture against:
- Does it support easy experimentation with different organizational structures/hierarchies?
- Is it extensible without rewriting core logic?
- Can it handle both synchronous and asynchronous agent coordination?
- Monolith vs. modular services vs. plugin architecture — which does it use, and is that the right fit?

### 2.3 Agent Invocation Strategy (Critical Decision)
The system needs to decide **how** it talks to each model provider. This is an open decision with multiple approaches to evaluate:

#### Approach A: OAuth / Subscription-Based (Preferred Starting Point)
Use OAuth tokens from existing subscriptions (Claude Pro, ChatGPT Plus, Kimi, etc.) to call models directly via their APIs, as done in **pi-agent**. This is the **user's preferred initial approach** because:
- Maximizes value from existing subscriptions (Claude, ChatGPT, Kimi, etc.).
- Fully customizable — no CLI constraints on prompt structure, tool definitions, or session management.
- The system controls the entire interaction loop.


#### Approach B: CLI Non-Interactive Modes
Invoke CLIs like Codex or Claude Code in non-interactive/headless mode. Research required:
- Does Claude Code support non-interactive mode with a subscription, or does it require API access?
- Codex non-interactive mode capabilities and limitations.
- What control is lost vs. direct API access?

#### Approach C: CLI via tmux/PTY Wrapping
Spawn CLIs inside tmux sessions and interact via PTY (terminal I/O). This is the most "hack-y" approach but provides a fallback for CLIs that don't offer non-interactive modes.

#### Strategy
- **Start with OAuth/subscription-based** (Approach A) for maximum customization.
- **Add CLI invocation** (Approaches B/C) as additional backends later — both for experimentation and as fallbacks.
- The Agent Runtime Manager must abstract over invocation method so that the rest of the system doesn't care how an agent is spawned.
- pi-agent's architecture is a strong reference for the OAuth approach — study it closely as a potential foundation.

### 2.4 Decentralization vs. Pragmatism
The user desires maximum decentralization but acknowledges that current model capabilities favor assigning models to their strengths. The architecture must support both:
- A centralized oracle/orchestrator mode.
- A more distributed mode where agents negotiate and self-organize.
- Experimentation with hybrid approaches (e.g., multi-opinion orchestrator, consensus reviews).

### 2.5 Scope Boundaries (v0 vs. v1+)

To prevent over-engineering before the core loop is validated, the plan must distinguish between what is built immediately and what is deferred:

#### v0 — Coding Orchestration Core (Build First)
- Multi-agent execution across isolated worktrees/branches.
- Role-based tool access enforcement with configurable policies.
- Agent coordination space (shared ephemeral chat for presence/status/questions).
- Structured logging suitable for RL datasets.
- Review → feedback → retry loop with severity-based escalation.
- LLM provider abstraction layer (OAuth-based subscription access as primary path).
- Basic task decomposition (orchestrator → cell agents).
- Deterministic style enforcement pipeline.

#### v1+ — Expand Later (Don't Block v0 on These)
- Rich UIs (dashboard, web app, Mac-native experience).
- Multi-channel messaging bridges (Telegram, Slack, Discord).
- Tracker integrations (GitHub Issues, Linear) beyond basic PR creation.
- Persistent assistant behaviors (always-on, multi-channel).
- Advanced per-model self-improvement distillation from reviewer feedback.
- Cost optimization and dynamic model routing refinements.
- RLM integration and DSPy exploration.
- Experimentation framework (A/B testing infrastructure).
- Plugin/skill marketplace.

---

## 3. CORE COMPONENTS

### 3.1 Agent Runtime Manager
Responsible for the lifecycle of individual agent instances:
- **Spawn** agents via multiple backends: primarily **OAuth/subscription-based** direct API calls (pi-agent style), secondarily via **CLI non-interactive modes** (Codex, Claude Code), and as fallback via **tmux/PTY wrapping** of interactive CLIs. The runtime manager abstracts over these backends so the rest of the system is invocation-agnostic.
- **Isolate** agents either via shared-space coordination (for ≤4 concurrent agents per project) or git worktrees (for larger parallelism). Research what each CLI/API supports natively and verify no conflicts arise.
- **Monitor** agent state: running, waiting, errored, completed, token-limited.
- **Stop / Restart / Resume** agents dynamically.
- **Configure** per-agent: model, invocation backend (OAuth/CLI/PTY), resource limits, allowed tools, filesystem scope.
- **Identify** each agent instance with a random traceable name (only the user knows the underlying model mapping).

#### Application-Level Observability for Agents
Agents building frontend/backend code need to observe the **running application**, not just source code and test results. This is critical for validating runtime behavior:
- **Browser automation and DevTools integration** — agents working on frontend code should be able to launch the application, interact with it, and inspect DOM/network/console output.
- **Per-worktree ephemeral observability stacks** — each agent's isolated environment should include lightweight logging, metrics, and tracing for the application under development.
- **Runtime validation** — agents can verify their changes by observing actual application behavior, not just by running tests.
- **Project-type-dependent tooling** — the specific tools and skills for application observability will vary by project type (web frontend, CLI, API service, etc.). An initial recommended set should be defined during Phase 1, with the expectation that it will be extended per project.

#### Key Research Required
- How each CLI handles git worktrees and parallel instances. Document per-CLI.
- Whether native multi-agent/subagent features of each CLI can be leveraged (e.g., Claude Code's `--worktree` flag, Codex's non-interactive mode).
- Whether Claude Code can be used in non-interactive mode with a subscription or requires separate API access.
- Conflict prevention strategies when multiple agents work on related code in the same repo.
- pi-agent's OAuth/session management implementation — study as primary reference for Approach A.

### 3.2 Orchestrator / Oracle
The brain of the system. Responsible for:
- **Task decomposition**: Breaking high-level objectives into granular, self-contained tasks. Each task given to a "cell" agent must contain **all information and details necessary** to complete it — regarding the code, the rules, the documentation standards, and the testing requirements.
- **Task assignment**: Routing tasks to the best-suited model/CLI based on task type and historical performance data.
- **Hierarchy management**: Supporting multi-level delegation (orchestrator → team leads → workers).
- **Escalation**: When a task fails or an agent has a question, the orchestrator decides whether to refine the prompt and retry with the same model, escalate to a better model, or escalate to the user.
- **Planning iteration**: The planning process itself should use the best available model (e.g., Opus 4.6, GPT 5.2-xhigh). Plans must be generated with the understanding that **other agents will execute them**. The plan must await user approval before execution begins, with the option to iterate.

#### Model Specialization (Initial Mapping — To Be Refined by Data)
- **Claude (Sonnet/Opus)**: Frontend design, UI/UX work; can use Claude for Chrome to self-test frontends.
- **Codex**: Backend development, systems code.
- **Kimi CLI**: Granular tasks with very clear, specific outcomes.
- **Grok**: Information search, research, finding resources.
- **Opus 4.6 / GPT 5.2-xhigh**: Planning iteration, high-stakes reviews, architectural decisions.
- **Free models via OpenRouter + Claude Code**: Ultra-granular, highly specific tasks to reduce costs.

This mapping must be continuously refined based on collected performance data.

#### Open Design Questions (To Be Explored)
- Single orchestrator model vs. multi-opinion/multi-perspective orchestrator (ensemble decision-making)?
- How to implement RLM — as a skill within each CLI? As an external wrapper agnostic to CLIs? As a composable unit/node in the system? Or all of the above?
- Can DSPy's philosophy of programmatic prompt optimization be incorporated into workflow definitions?

### 3.3 Workflow Engine
Defines and executes structured workflows. The base workflow for programming:

```
PLAN → IMPLEMENT → TEST → REVIEW (logic + implementation) → CORRECT → REPEAT
```

This cycle applies **at every level of the hierarchy** — from the orchestrator's master plan down to individual function implementations.

#### Workflow Characteristics
- Workflows are **iterative by nature** — either cycling with user feedback or in autonomous optimization loops (e.g., code quality improvement loops).
- Different workflow templates for different project types and states (new project, maintenance, research, exploration).
- Start with the **basic programming workflow**, then expand to: exploration, research, prototyping, experimentation.
- Workflows must be inspectable, modifiable, and composable.
- **Every workflow and process must be designed as optimizable** — treat optimization as a meta-principle. Each step, each handoff, each decision point should be measurable and improvable over time. The system should be built with the assumption that current workflows are v1 and will be iteratively refined based on data.

#### New Project Scaffolding Workflow
When creating a **new project from scratch**, a dedicated workflow kicks in **after** the planning phase is complete and approved:
- A **builder agent** (specialized via skills) sets up the project's foundational structure based on: the chosen language(s), framework(s), whether it involves frontend, backend, or both, deployment targets, etc.
- This includes: directory structure, build system configuration, linter/formatter setup, CI config, test framework, documentation templates, the inter-agent communication markdown standards, and any language-specific boilerplate.
- This happens **only once the plan is finalized** — the builder needs a clear vision of the implementation approach.
- The builder agent can be a general-purpose agent with **project-type-specific skills** (e.g., a "Rust CLI project" skill, a "React + Node fullstack" skill, etc.).

#### Review Workflow (Multi-Model Consensus with Configurable Rigor)
Review rigor is **configurable based on task complexity and risk level**, not uniform for all changes:

| Rigor Level | Applies To | Process |
|---|---|---|
| **Lightweight** | S0 fixes (cosmetic), minor documentation updates, auto-generated boilerplate | Single reviewer, fast-track. Auto-merge candidates with strong deterministic checks. |
| **Standard** | Most implementation tasks (S1 scope), routine feature work | Single reviewer from a capable model. Standard review-fix cycle. |
| **Full Consensus** | Critical changes (S2+), architectural decisions, security-sensitive code, cross-cutting modifications | Multiple independent reviews from different models, followed by a final consensus review by the best available model. |

This graduated approach balances throughput with quality:
- Low-risk changes move fast with strong mechanical guardrails (linters, tests, deterministic checks).
- High-risk changes get the full multi-model consensus treatment.
- The rigor level is assigned by the orchestrator based on task metadata (severity, scope, files affected) and is configurable per project.

For full consensus reviews specifically:
1. Multiple independent reviews from different models.
2. A final consensus review by the best available model, considering all individual reviews.
3. The number of reviewers and which models contribute most should be configurable and experimentally tunable.

#### Escalation & Clarification (All Agents)
**Any agent** (not only reviewers) can raise a question or ask for clarification to the agent or user that assigned its task. This is a universal capability across the hierarchy. Specifically, any agent that lacks information to proceed can raise a question to:
- The agent that assigned its task.
- The user (if at the top of the chain).
- Other active agents (via the coordination space).

#### Self-Spawning Policy
The capability for an agent to start a new session of itself with refined context **must be studied per agent type** before being enabled:
- Not all roles should be allowed to self-spawn — the risk of infinite loops and cost varies by role.
- Phase 1 must define: which roles can self-spawn, under what conditions, with what limits (max depth, budget caps).
- **Until studied: only the orchestrator can spawn new agent sessions** — this is the safe default.

#### Review Escalation Logic
When a reviewer identifies failures:
1. **Root-cause analysis first** — before deciding the escalation path, invoke a diagnostic process (a dedicated agent role, subagent, or skill) that analyzes the full session of the agent that failed: tools/skills used, context provided, intermediate outputs, and the nature of the failure. This diagnostic should classify the failure cause into categories such as:
   - **Insufficient context**: The agent lacked information needed to complete the task correctly.
   - **Context management failure**: The agent had the information but lost or mismanaged it (e.g., context window overflow).
   - **Skill/workflow gap**: The task required a capability (tool, skill, workflow step) that wasn't available or was misconfigured.
   - **Model limitation**: The task exceeded the model's reasoning capability for that task type.
   - **Ambiguous requirements**: The task specification was unclear or contradictory.
   - **Environment issue**: Missing dependencies, broken tooling, flaky tests, or infrastructure problems.
2. **Route the fix based on root cause** — the diagnostic determines the appropriate remediation:
   - *Context issues*: Refine the task prompt, improve context management, retry with same model.
   - *Skill/workflow gaps*: Fix the skill, update the workflow, or add the missing capability before retrying.
   - *Model limitations*: Escalate to a more capable model.
   - *Ambiguous requirements*: Escalate to the assigning agent or user for clarification (S3 — Blocked).
   - *Environment issues*: Fix the environment, then retry.
3. **Minor failures** (after root-cause analysis): Send task back to the same model with refined context.
4. **Significant failures**: Escalate to a better model.
5. **Self-refinement** (requires study): The possibility of an agent starting a new session of itself with refined context must be carefully evaluated — determine **which agent types/roles** should be allowed this capability and under what constraints (to prevent infinite self-spawning loops, resource waste, etc.). This is a design question to resolve during implementation.

#### Constructive Feedback System
Reviewers must provide "constructive criticism" to the executing agents/subagents. This feedback:
- Enforces best practices and avoids repeated mistakes.
- Is accumulated as institutional knowledge for current and future projects.
- Is logged and structured for future RL training.

#### Review-Fix Workflow (Detailed)
The review-fix cycle should be as automated as possible:

0. **Pre-submission cleanup** — before creating a PR or submitting for review, a cleanup subagent (or cleanup skill) runs on the agent's output to simplify, deduplicate, and remove sloppiness. This is part of the build workflow, not the review workflow — the goal is to raise baseline quality before any reviewer sees the code. The cleanup step checks for: unnecessary complexity, dead code, inconsistent patterns relative to the project's established conventions, and deviations from the golden principles.
1. **Agent completes task** → creates a PR or fills a structured review template (markdown file).
2. **System triggers reviewer** — automatically, by detecting the PR/template completion (file-watch or git hook).
3. **Reviewer inspects the work** — the reviewer **must have access to**: the list of modified files, the diff (previous version vs. current), and the full task context. This can be achieved via GitHub CLI (`gh`), git diff tooling, or a dedicated skill that presents diffs in a structured format.
4. **If failures found** → The reviewer writes its feedback into the PR/review template with structured details: what failed, why, how to fix it.
5. **System sends the review back to the original agent's session** (preserving conversation history so the agent has full context of what it did and what's wrong). This message is triggered automatically when the reviewer fills the response template.
6. **Agent fixes and resubmits** → returns the PR/template to the **same reviewer** for re-review.
7. **Context window management**: Before sending back to the same reviewer or builder, track what percentage of the model's context window is consumed. If approaching a configurable threshold (e.g., 80% of max):
   - **Option A**: Apply **context compaction** — summarize prior exchanges while keeping key context (task requirements, latest diff, most recent feedback).
   - **Option B**: Start a clean review session without chat history (but with full task context and diff).
   - The context management strategy itself is configurable per role and per model.
8. **Reattempt tracking**: The system must track the number of review-fix cycles per task. After a configurable limit (default: 3 retries at same severity), escalate. Hard maximum before mandatory human review (configurable, default: 5 total attempts). After the hard limit, the task is **flagged for user revision** rather than continuing the loop.
9. **Severity-based routing**: The reviewer's failure analysis determines next steps using a structured severity rubric:
   - **S0 (Cosmetic)**: Linter/formatter issues, minor naming — auto-fix with deterministic tools if possible, otherwise retry with specific instructions.
   - **S1 (Local correctness)**: Failing tests, missing docs, minor logic bug — feedback to original builder session. Escalate if 2+ retries fail.
   - **S2 (Systemic)**: Architecture mismatch, widespread failures, security/tool-policy violation — escalate to better model/agent. May require human review.
   - **S3 (Blocked)**: Missing information, ambiguous requirements, depends on incomplete task — raise question upward (any agent can do this). Do not retry — wait for answer.

### 3.4 RLM (Recursive Language Models) Integration
RLMs should be used for tasks requiring **high context and deep reasoning**. Implementation must support:
- Configurable **max depth and width** for recursion.
- All other recursion parameters tunable for experimentation.
- A future project: automating optimal parameter selection based on task characteristics.
- Investigation of DSPy's RLM implementation specifically — per published experiments, it achieves better results than standard implementations. Since RLM and DSPy share the same research lineage, find ways to exploit their combined approach.
- Ralph method (loops) as a complementary pattern.

#### DSPy Considerations
- Evaluate whether DSPy's philosophy of flows, roles, and programmatic optimization is useful for defining agent workflows.
- Consider incorporating DSPy's approach to module composition and optimization into the workflow engine.
- Research the specific advantages documented in their blog/papers.

### 3.5 Communication System
The primary communication mechanism between agents is **markdown files** in the project directory, inspired by OpenClaw but expanded.

#### Markdown-Based Communication
- Define a **standard for inter-agent communication via .md files** in every project.
- Use purpose-specific markdown files (e.g., `DECISIONS.md`, `QUESTIONS.md`, `STATUS.md`, `ARCHITECTURE.md`).
- **File-watch triggers**: Editing a specific markdown file can trigger actions — e.g., a review request, a question escalation, a status update.
- These files serve double duty as human-readable project documentation and machine-readable coordination signals.

#### Communication Channels
- **Synchronous**: Between concurrent agents on the same project (shared markdown files, file-watch triggers).
- **Asynchronous**: Between sequential agents (persistent logs of architectural decisions, question queues, handoff notes).
- **Escalation to upper management**: Agents must have a clear path to raise questions or blockers to the agent or user that assigned the task.
- **Experimental: Agent email system** — agents communicate via an email-like mechanism. Each agent has a random (but traceable) name; only the user knows the model-to-name mapping.

#### Shared-Space Coordination (Presence Registry)
When multiple agents work in the **same folder/project simultaneously** (without worktree isolation), they need a lightweight coordination mechanism:
- A **temporal coordination chat/file** where agents register their presence — announcing what they're currently working on, which files they're touching, and their status.
- Uses a structured template: agent name, task, target files/modules, start time, estimated scope.
- This file can also serve as a place for agents to **ask quick coordination questions** to each other (e.g., "I need to modify `utils.ts` — are you using it?").
- The file resets after N tokens or after a configurable time window to prevent unbounded growth.
- Consider requiring **confirmation/approval extensions** for certain high-risk commands when in shared-space mode (e.g., deleting files, modifying shared configs).

**Scalability Constraint**: This shared-space approach has a practical limit of approximately **~4 concurrent agents per folder/project**. Beyond that, contention and coordination overhead become problematic. The system must:
- Enforce this limit as a configurable cap.
- For larger parallelism, **scale via git worktrees** (see Section 6) where each agent gets its own isolated copy.
- The transition from shared-space to worktree-based isolation should be a natural scaling path, not a rewrite.

#### Agent Identity
- Each agent instance has a unique, randomly generated name.
- The name-to-model mapping is known only to the user.
- Each "clone" of the same agent (if the same agent is instantiated for two simultaneous operations) must have a specific description of its unique purpose/role for that instance.

#### Coordination Space Presence Template
Agents registering in the coordination space must use a structured template:
```yaml
agent_id: [unique id]
role: [builder | searcher | reviewer | orchestrator | scaffolder | gardener]
task_id: [what task is being worked on]
working_on: [human-readable description]
files_touched: [list of files being modified — for conflict avoidance]
branch: [worktree/branch name]
started_at: [timestamp]
status: [active | waiting_for_answer | completed]
question: [optional — if the agent needs input from another agent]
question_to: [optional — target agent_id or "any"]
```

### 3.6 Task Management
- Tasks must be decomposed until the executing agent has **complete, self-contained context**.
- Each task carries: requirements, constraints, relevant code context, documentation standards, test expectations, and links to architectural decisions.
- Tasks track: assigned agent, status, attempts, escalation history, time spent, tokens consumed.
- Dependency management between tasks (blocking, parallel, sequential).
- Priority system with at least daily user review.

---

## 4. SECURITY MODEL

### 4.1 Filesystem Isolation & Role-Based Access

**Core rule: no single agent gets both "bash" and "internet search" by default.**

The system enforces a minimum role set with explicit tool allowlists:

| Role | Access | Purpose |
|---|---|---|
| **Searcher** | Web search only, no filesystem, no bash | Gathers external information safely |
| **Builder** | Scoped filesystem + bash (project folder only), no internet | Writes code based on provided context |
| **Reviewer** | Read-only filesystem + diff access + test runner, no write, no internet | Verifies work, classifies failures, provides structured feedback |
| **Orchestrator** | Agent spawning + task routing + plan management only | Decomposes tasks, assigns work, escalates, logs decisions |
| **Scaffolder** | Scoped filesystem + bash + project template skills, no internet | Creates new project foundations (language-specific boilerplate, build configs, CI setup) — activated only after planning is complete |
| **Gardener** | Scoped filesystem + read access to project golden principles + PR creation, no internet | Scans for code entropy, pattern drift, stale documentation, and violations of project conventions — opens targeted cleanup/refactoring PRs on a cadence |

**Filesystem rules:**
- By default, each agent should **only have access to the folder where it's called**.
- A configurable **YOLO mode** that relaxes restrictions when explicitly enabled.
- Explicit mount/access declarations per agent (inspired by NanoClaw's container isolation approach).
- Configurable opt-in policies for broader access (per-repo, per-session).

### 4.2 Tool Separation (Critical)
Agents with bash/code execution access **must not** simultaneously have unrestricted internet access. This prevents prompt injection attacks via fetched content influencing code execution.

**Initial Architecture for Web Search**:
- A **dedicated search agent** that only has web search capabilities (no code execution, no filesystem write).
- A **dedicated writer/coder agent** that receives search results but cannot search the web itself.
- Role separation as a security boundary.

### 4.3 Tool Authorization & Anomaly Detection
- Each agent has a **defined set of allowed tools** (see role table in 4.1).
- The system **raises a warning/flag** when any agent attempts to use a tool not in its allowed set.
- This serves as a prompt injection detection mechanism.
- All such violations are logged with full context for review.
- **Tool gating via extensions**: For certain sensitive commands (e.g., deleting files, modifying shared configs), an extension prompts for confirmation before execution — not full YOLO, not full lockdown, but configurable per command class.
- The enforcement mechanism itself must be configurable and swappable (the permission model is a module, not hardcoded logic).

### 4.4 Additional Security Considerations
- **Secrets management**: How API keys, tokens, and credentials are stored and passed to agents without exposure.
- **Sandboxing options**: Docker/container isolation per agent (optional, configurable).
- **Output sanitization**: Review agent outputs before they're used as inputs to other agents (defense against adversarial agent-to-agent influence).
- **Rate limiting**: Prevent runaway agents from exhausting API quotas or system resources.
- **Audit trail**: Every action by every agent is logged immutably.

---

## 5. MONITORING, LOGGING & DATA COLLECTION

### 5.1 Purpose
All collected data is **future training data** for RL-based personalization and model fine-tuning. Information is the key asset. The monitoring system must capture everything needed for this purpose.

### 5.2 Conversation & Session Logging
- **Complete conversation logs** for every agent session, in a clear, structured format.
- **Deep session recordings** (inspired by adaf) — not just final outputs but the full reasoning trace.
- When problems occur: record **all intermediate versions** that led to the solution, including failed attempts.
- Plans, drafts, iterations — all are valuable training data.
- **User modifications**: Log every change the user makes to agent-generated code, plans, or decisions.
- **Final accepted state**: Clearly mark the final correct solution/implementation with all requirements accepted.

### 5.3 Performance Metrics
Per-agent, per-session, per-task:
- Tokens consumed (input + output).
- Wall-clock time.
- Token limit hits / rate limit hits / account exhaustion events.
- Files reviewed and modified.
- Tests run and results (pass/fail/error details).
- Task completion status (success, partial, failed, escalated).

Per-model aggregate:
- Task type vs. completion success rate.
- Average tokens per task type.
- Error patterns and common failure modes.
- Cost per task type.

### 5.4 Coordination Metrics
- Trace when tasks were **incorrectly coordinated** — conflicts, race conditions, duplicate work, dependency violations.
- Log cross-agent communication patterns (who asked whom, what, when, resolution).
- Identify bottlenecks in the hierarchy.

### 5.5 Model Evaluation
- Continuously track per-model performance by task type.
- Use this data to **dynamically adjust** the model-to-task-type mapping.
- Support A/B testing of model assignments.

### 5.6 Per-Model Self-Improvement Notes (Can-Wait — But Design For It)
Each model should accumulate a **personalized instruction file** (analogous to a per-model `AGENTS.md`) that captures:
- Common mistakes this specific model makes, with corrective guidance.
- Patterns where it excels and should be preferred.
- Formatting/style tendencies to watch for.
- Distilled from reviewer feedback — when a reviewer identifies a recurring issue with a model's output, the system should **automatically or semi-automatically** extract that pattern into the model's self-improvement notes.
- These notes are injected into the model's system prompt / context on every invocation, creating a feedback loop where each model gets progressively better at the specific tasks assigned to it.
- This is a form of prompt-level "fine-tuning" without actual model training — valuable both as an immediate improvement and as structured data for future actual RL/fine-tuning.

### 5.7 Cost Tracking
- Per-agent, per-model, per-project cost tracking.
- Budget alerts and limits.
- ROI analysis: cost vs. task completion quality.
- Track cost savings from using free models on granular tasks via OpenRouter.

---

## 6. GIT & VERSION CONTROL STRATEGY

### 6.1 Worktree Management
- **Scaling path**: The system starts with shared-space coordination (Section 3.5, ~4 agents max per project). When more parallelism is needed, it scales to **git worktrees** where each agent operates in its own isolated copy with its own branch.
- Research and document how each supported CLI interacts with git worktrees.
- Verify: no conflicts between concurrent agents, proper lock handling, clean merge paths.
- Automated branch naming conventions tied to task IDs and agent names.
- The transition from shared-space to worktree mode should be seamless — the orchestrator decides based on agent count and task independence.

### 6.2 Merge Strategy
- Define clear merge workflows (agent → review branch → main).
- Automated conflict detection and resolution attempts before human escalation.
- PR creation per completed task with full context (task description, decisions made, tests passed).

### 6.3 Rollback
- Every agent operation must be reversible.
- Checkpoint/snapshot mechanism before risky operations.
- Clean rollback path when reviews reject work.

---

## 7. EXPLORATION & PLANNING PHASE RULES

### 7.1 Pre-Implementation Research (For Projects Built With This System)
During the planning phase for **any project that will be built using this orchestrator**, the system must:
- **Search the web** for existing implementations, libraries, patterns, or prior art that could be used, reused, adapted, or taken as reference for the task at hand.
- Evaluate whether any discovered component can be incorporated directly as a dependency, tool, or design reference.
- Document what was found and the decision to build vs. reuse.

> **Note**: This is a general rule for all future projects managed by the orchestrator. The reference projects listed in Section 7.2 below are specific to **this orchestrator project itself** — they were manually curated as inspiration and potential base projects for building the orchestrator.

### 7.2 Reference Projects & Inspiration Sources (Specific to This Project)

#### SOTA Agent Harnesses
The state-of-the-art CLI tools for AI-assisted coding. While still early in multi-agent management, they serve as a solid foundation or starting point.

| Tool | Key Characteristic |
|------|-------------------|
| Claude Code | Anthropic's official CLI for Claude — interactive and non-interactive modes, worktree support, MCP integration |
| Codex | OpenAI's CLI agent — non-interactive mode, sandboxed execution, multi-file editing |

#### Agent Orchestrators & Harnesses
Systems for coordinating and managing AI coding agents at scale.

| Project | URL | Key Takeaway |
|---------|-----|--------------|
| pi-mono | https://github.com/badlogic/pi-mono | AI agent toolkit: CLI, unified LLM API, TUI & web UI, code-that-builds-itself philosophy |
| oh-my-pi | https://github.com/can1357/oh-my-pi | Fork of pi-mono — hash-anchored edits, optimized tool harness, LSP integration, persistent Python kernels, subagents, multi-agent orchestration |
| adaf | https://github.com/agusx1211/adaf | Meta-orchestrator, plans/issues/wiki/session recordings outside repo, relay handoffs |
| codex-autorunner | https://github.com/Git-on-my-level/codex-autorunner | Ticket-based coordination framework for long-running agent tasks — tickets as control plane, multi-model support, Web UI + CLI + chat interfaces (Telegram/Discord) |
| Agent of Empires | https://github.com/njbrake/agent-of-empires | Rust TUI, tmux-based, multi-CLI support, worktree isolation, Docker sandboxing |
| hermes-agent | https://github.com/NousResearch/hermes-agent | Persistent personal agent, learns, builds skills, scheduled tasks |
| ypi | https://github.com/rawwerks/ypi | Recursive coding agent built on Pi, based on RLMs |
| symphony | https://github.com/openai/symphony/ | Orchestration system turning project management tasks into autonomous agent runs — CI-based proof of work, automated PR landing |

#### OpenClaw & Variants (AI Assistant)
Personal AI assistant ecosystem — multi-channel, persistent, extensible.

| Variant | URL | Key Characteristic |
|---------|-----|-------------------|
| OpenClaw | https://github.com/openclaw/openclaw | Personal AI assistant, multi-channel, persistent, Canvas, Gateway architecture |
| ZeroClaw | *(Rust variant)* | Tiny binary, <5MB RAM, <10ms startup, sandboxing, swappable traits |
| NanoClaw | *(container variant)* | OS-level container isolation per agent, minimal attack surface |
| NullClaw | https://github.com/nullclaw/nullclaw | Minimal AI assistant in Zig — 678KB binary, 23+ LLM providers, 18 messaging channels, hybrid vector+keyword memory, sandboxing, encryption, zero dependencies |

#### Research / Theory
| Source | URL | Relevance |
|--------|-----|-----------|
| Arcgentica (Symbolica) | https://www.symbolica.ai/blog/arcgentica | Architecture patterns |
| RLMs as Memory Systems | https://raw.works/recursive-language-models-as-memory-systems/ | Core RLM theory and implementation |
| DSPy | (library + blog) | Programmatic prompt optimization, RLM implementation with superior benchmark results |

#### Must Check for Our Own Skills
Resources to study for building our workflow skills and extensions.

| Resource | URL | Notes |
|----------|-----|-------|
| agent-stuff | https://github.com/mitsuhiko/agent-stuff/tree/main | Skills and extensions fine-tuned per project — study for workflow and feature patterns we can adapt |
| Agent Skills Directory | https://agentskills.io/llms.txt | Community directory of agent skills |
| Anthropic Skills | https://github.com/anthropics/skills | Official public repository for Agent Skills |

#### Interesting Tools to Explore (Soon)
Tools worth investigating in the near term for potential integration or reimplementation.

| Tool | URL | Notes |
|------|-----|-------|
| mcporter | https://github.com/steipete/mcporter/ | Call MCPs via TypeScript or package as CLI — relevant for using MCPs without context bloating |
| vet | https://github.com/imbue-ai/vet | Find issues worth attention — API-key-only, but analyze for potential reimplementation |
| darwinian_evolver | https://github.com/imbue-ai/darwinian_evolver/ | Framework for evolving code and prompts via Darwinian evolution — population-based optimization |

#### Potential Useful Tools

| Tool | URL | Use Case |
|------|-----|----------|
| ai-data-extraction | https://github.com/0xSero/ai-data-extraction | Extract personal data/history from Cursor, Codex, Claude Code, Windsurf, Trae |
| BuildSpace | https://github.com/photon-hq/buildspace | AI-powered CI/CD blocks (release notes, versioning, publishing) |
| Morph LLM Docs | https://docs.morphllm.com/llms.txt | LLM documentation and integration reference |

#### Commercial/Closed Tools (Study for Feature Ideas)
- **Agentastic.dev**: Native macOS multi-agent IDE, Ghostty terminals, kanban labels, diff viewer, multi-agent code review.
- **Conductor (conductor.build)**: Polished Mac UI for parallel agent teams, Linear + GitHub integration.
- **Codex.app**: Desktop command center for Codex agents, project-based context switching.

### 7.3 Project Reuse Philosophy
A reference project may serve any of these roles:
- **Base**: Fork/build upon its codebase.
- **Inspiration**: Study its architecture and adapt ideas.
- **Tool**: Integrate it directly as a component of the system.
- **Reference**: Use its patterns to inform design decisions.

**Reimplement-over-depend guideline**: When evaluating reference projects or external libraries for integration, apply this decision criterion: if only a small subset of functionality is needed, consider reimplementing that subset rather than taking the full dependency. A tight, fully-tested internal implementation that agents can inspect, understand, and modify may be preferable to a black-box library the agents cannot reason about. This should be evaluated case by case — the decision factors are: subset size, maintenance burden, agent comprehensibility, and whether the library's internals need to be understood for debugging.

The plan must specify which role each relevant project plays.

---

## 8. EXPERIMENTATION FRAMEWORK

The system must be built to support easy experimentation across multiple dimensions:

### 8.1 Organizational Experiments
- Test different hierarchy structures (flat, deep, tree, mesh).
- Test different models in each role.
- Compare centralized orchestration vs. distributed negotiation.
- Compare single-orchestrator vs. ensemble orchestrator.

### 8.2 RLM Parameter Experiments
- Vary recursion depth, width, and other parameters.
- Measure quality vs. cost vs. time tradeoffs.
- Compare DSPy's RLM implementation against alternatives.

### 8.3 Review Configuration Experiments
- Vary number of reviewing models.
- Identify which models add the most value in reviews.
- Compare review consensus strategies.

### 8.4 Cost Optimization Experiments
- Test delegation of granular tasks to free models via OpenRouter.
- Measure quality degradation vs. cost savings.
- Find the optimal cost/quality frontier per task type.

### 8.5 Experimentation Infrastructure
- All experiments must be reproducible (full configuration capture).
- Results must feed back into the monitoring/metrics system.
- A/B testing framework for comparing configurations.

---

## 9. ADDITIONAL CONSIDERATIONS

> The following were not explicitly mentioned but are critical for a system of this complexity. Each must be addressed in the plan.

### 9.1 Fault Tolerance & Recovery
- **Crash recovery**: If the orchestrator crashes, how is state recovered? Persistent state store required.
- **Agent failure handling**: Detect when an agent hangs, loops, or produces garbage. Automatic timeout + retry policies.
- **Token/rate limit exhaustion**: Automatic failover to alternative models or graceful queuing.
- **Graceful degradation**: If a model provider is down, the system continues with available models.
- **Idempotent operations**: Tasks should be safely retryable without side effects.

### 9.2 Configuration Management
- Centralized configuration for: agent profiles, model preferences, CLI paths, API keys, worktree templates, workflow definitions, security policies.
- Per-project configuration overrides.
- Configuration versioning (track what config produced what results).
- Hot-reload of non-critical configuration without restarting the system.

### 9.3 Resource Management
- CPU and memory limits per agent process.
- Maximum concurrent agents (global and per-project).
- Queue management when capacity is exceeded.
- Priority-based scheduling (urgent tasks preempt lower-priority ones).

### 9.4 Dependency & Conflict Management
- Task dependency graphs (must-complete-before relationships).
- Detection of conflicting file modifications between concurrent agents.
- Lock mechanisms for shared resources (e.g., database migrations, config files).
- Deadlock detection between agents waiting on each other.

### 9.5 CI/CD Integration
- Automated test execution after each agent's work.
- Integration with existing CI pipelines (GitHub Actions, etc.).
- Automatic PR creation with structured descriptions.
- CI failure → automatic agent assignment for fix.

### 9.6 Notification & User Interaction
- Beyond agent-to-agent communication: clear notification system to the user.
- Multiple urgency levels with appropriate notification channels.
- Daily priority review digest.
- Interactive approval workflows (plan review, merge approval, escalation responses).
- Time tracking: how long user decisions have been pending, with escalating reminders.

### 9.7 Plugin / Skill System
- Architecture for adding new capabilities without modifying core code.
- Skills can be: CLI integrations, tool wrappers, workflow templates, review strategies, communication adapters.
- Skills should be shareable across projects and potentially across users.
- Inspired by pi-mono's "code that builds itself" philosophy and agent-stuff's project-specific skill tuning.

### 9.8 Testing Strategy for the Orchestrator Itself
- Unit tests for each component.
- Integration tests for agent spawning, communication, and coordination.
- Simulation mode: test workflows with mock agents (no API calls).
- Chaos testing: randomly kill agents, corrupt state, simulate API failures.

### 9.9 Documentation System
- Auto-generated documentation from code and configuration.
- Separate documentation streams: human-facing (how to use/configure) and agent-facing (how to extend/integrate).
- Architecture Decision Records (ADRs) for every significant design choice.
- Living documentation that updates as the system evolves.
- **Doc-gardening agent**: A recurring background agent (using the **Gardener** role) that scans for stale documentation, broken cross-references, outdated information, and structural violations — then opens targeted fix PRs automatically. Documentation must stay current (§13.3), and this is the enforcement mechanism.
- **Mechanical freshness enforcement**: CI should validate that documentation is current, correctly cross-linked, and structurally sound — not just that it exists. Lint rules for documentation staleness (e.g., flagging docs that reference deleted files, outdated API signatures, or missing sections).

### 9.10 State Persistence & Data Storage
- Choose appropriate storage for: agent state, task queues, metrics, conversation logs, configuration.
- Consider: SQLite for simplicity, PostgreSQL for scale, flat files for transparency, or a combination.
- Data retention policies (what to keep, what to archive, what to purge).
- Export formats for training data (RL-ready datasets).

### 9.11 Observability Dashboard
- Real-time view of: all running agents, their status, current tasks, resource consumption.
- Historical views: project timeline, agent performance trends, cost trends.
- Alert system for anomalies (unusual token consumption, repeated failures, security violations).
- Start with TUI (terminal), plan for web UI later.

### 9.12 Multi-Project Management
- The system manages multiple projects simultaneously with independent priority levels.
- Resource allocation across projects based on priority.
- Shared knowledge base across projects (architectural patterns, learned best practices).
- Project-level isolation with optional cross-project knowledge sharing.

### 9.13 Backward Compatibility & Migration
- As the system evolves, older projects must remain manageable.
- Version the communication protocol (markdown file standards).
- Migration scripts for schema/format changes.

### 9.14 Entropy Management & Code Quality Maintenance
Agents replicate existing patterns — including bad ones. Without active countermeasures, code entropy (pattern drift, convention violations, accumulated sloppiness) is inevitable across many tasks. The system addresses this at two levels:

- **Pre-submission cleanup (inline)**: Part of the build workflow. Before any agent submits work for review, a cleanup subagent or skill runs to simplify, deduplicate, and align the output with project conventions. This catches entropy at the source.
- **Background gardening (periodic)**: The **Gardener** agent role runs on a configurable cadence, scanning the codebase for violations of project golden principles, pattern drift, dead code, and inconsistencies that accumulate over time. It opens targeted cleanup PRs — small, focused refactoring changes rather than large sweeping rewrites.
- **Review alone is insufficient**: The review cycle catches issues in individual changes but does not address gradual drift across many merged changes. The Gardener role fills this gap.

### 9.15 Architecture Implications of "Agents Build the System"

Since this system will be built by the very agents it manages, these principles apply from day one:

1. **Separate "doer" vs. "checker" roles** to reduce correlated mistakes.
2. **Reviewer feeds back to the original session**, preserving context — not a fresh start every time.
3. **Orchestration state lives outside the code repo** to prevent tampering and preserve training data (adaf pattern).
4. **Every architectural document is also an agent prompt** — specs must be written so agents follow them directly.
5. **Deterministic checks are the first gate** — linters and tests run before any agent review.
6. **The test suite is the ground truth** — if deterministic checks pass, tests pass, and docs exist, the task is done.
7. **Bootstrap problem acknowledged**: The initial skeleton (Phase 2) must be built manually or by a single agent session before the system can build itself. This is an accepted bootstrapping cost, not a design flaw.
8. **Configurability is a first-class concern** — changing a workflow (e.g., swapping the review pipeline mechanism) should require config changes, not code rewrites.
9. **Every workflow is a candidate for optimization** — the system must measure its own processes well enough to identify bottlenecks and propose improvements.

### 9.16 Per-Model Self-Improvement Notes

The system accumulates **per-model failure profiles** to improve agent behavior over time:

- When a reviewer identifies a recurring failure pattern for a specific model, a structured note is created/updated.
- These notes live in a `MODEL_NOTES/` directory (e.g., `MODEL_NOTES/claude-sonnet-4.md`, `MODEL_NOTES/gpt-4o.md`).
- Format: pattern observed, frequency, severity, recommended mitigation (prompt adjustments, task constraints, etc.).
- These notes are fed as context to the orchestrator when it assigns tasks to that model.
- **Distillation**: Periodically, a dedicated agent reviews accumulated failure notes and proposes refined default prompts/constraints per model.

**Priority:** This is a v1 feature (can wait), but the logging infrastructure in v0 must capture enough data to enable it later. Specifically, every review failure event must include: the model that produced the failing output, the failure category, and the reviewer's assessment.

---

## 10. DECISIONS — NOW VS. LATER

### 10.1 Must Decide Before Building

| # | Decision | Options | Current Leaning |
|---|----------|---------|-----------------|
| 1 | **v0 scope** | Coding-orchestration only vs. also multi-channel | Coding-only. No channel expansion for v0. |
| 2 | **Foundation project** | pi-mono as base vs. build from scratch vs. hybrid | pi-mono as primary foundation, extended with our layers. |
| 3 | **LLM access method** | OAuth subscriptions vs. API vs. CLI wrappers | OAuth first (cheapest, most flexible). API as fallback. CLI/tmux for experimentation. |
| 4 | **Isolation baseline** | Worktrees only vs. container-per-agent | Worktrees as default. Optional Docker for untrusted tasks. |
| 5 | **Coordination mechanism** | Ephemeral shared chat vs. file-based registry vs. message queue | Ephemeral shared chat (simplest, aligns with pi-agent patterns). |
| 6 | **Role model + permissions** | Minimum role set, tool allowlists | 6 roles: searcher, builder, reviewer, orchestrator, scaffolder, gardener. |
| 7 | **Review pipeline mechanism** | PR-based vs. template/md-file-based vs. git-diff skill | Needs Phase 1 evaluation. PR-based preferred if GitHub CLI integration is straightforward. |
| 8 | **Log storage** | Inside repo vs. separate (adaf pattern) | Outside target repo. |
| 9 | **Self-spawn policy** | Which agent types can self-spawn | Only orchestrator for v0. Study others in Phase 1. |
| 10 | **Style enforcement** | Agent-judged vs. deterministic vs. hybrid | Deterministic as baseline authority. Evaluate a **hybrid approach**: deterministic linters/formatters for enforcement, augmented by an LLM-based advisory layer that provides richer remediation context (explaining *why* and *how to fix*). The LLM layer is advisory only — it never overrides deterministic checks. |

### 10.2 Can Wait

- UI choice (TUI vs. web vs. native app).
- Multi-channel control (Telegram, Slack, Discord).
- Tracker integrations beyond basic PR flow.
- Per-model self-improvement distillation (but log the data now).
- Cost optimization and dynamic model routing.
- Advanced coordination (beyond ephemeral chat).
- RLM parameter optimization automation.
- DSPy integration.

---

## 11. RISK REGISTER

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

## 12. IMPLEMENTATION PHASING GUIDANCE

The plan should be structured in phases. Suggested (but the planning agent should refine):

### Phase 0: Foundation & Research
- **Base project selection** — comparative analysis of reference projects (Section 7.2) against architecture criteria (Section 2), resulting in a recommended base, which determines language and initial system structure.
- Core architecture design (adapting/extending the chosen base).
- Project scaffolding with documentation standards.
- Git worktree research per CLI.
- **Structured project reports**: Spawn one research agent per Tier A project (parallel if possible). Each produces a standardized report covering: license, tech stack, core features, multi-agent approach, security model, integration points, LLM provider support, logging/observability, maturity, advantages, limitations, recommendation (foundation/integration/inspiration/skip), and key code to study.
- **Synthesis step**: A synthesis agent reads all reports + this master plan and confirms or adjusts the foundation choice, maps which components come from which projects, and identifies gaps requiring custom development.

### Phase 1: Architecture Definition
- Produce definitive architecture documents that agents can build from:
  - `ARCHITECTURE.md` — System overview, component diagram, data flow, module boundaries, configuration points.
  - `SECURITY.md` — Role definitions, tool allowlists, isolation strategy, tool-gating extensions, threat model.
  - `AGENTS.md` — Agent types, capabilities, escalation rules, self-spawn policy, coordination protocol.
  - `LOGGING.md` — Log schema, event types, storage strategy, RL pipeline design.
  - `TASKS.md` — Task template, decomposition rules, Definition of Done, severity rubric.
  - `REVIEW_PIPELINE.md` — Reviewer workflow, feedback format, retry mechanics, context management, PR/template mechanism.
  - `CONFIGURATION.md` — What is configurable, where configs live, how to change workflows without code changes.
  - `TESTING.md` — How agents verify each other, test requirements, linter/formatter setup per language, and evaluation of the hybrid linting approach (deterministic + LLM-advisory).
  - `SCAFFOLDING.md` — Project template system, supported languages/frameworks, how to add new templates.
  - `OBSERVABILITY.md` — Initial recommended set of application-level observability tools/skills by project type (web frontend, CLI, API service, etc.), including browser automation, DevTools integration, and per-worktree ephemeral observability stacks.
- These documents serve as both human specifications and agent prompts — they must be written so agents can follow them directly.
- **Progressive disclosure principle**: Each architecture document must follow a "short map + pointers" structure to avoid overwhelming agents with monolithic walls of text. Specifically:
  - Each document should have a **concise summary section (~100 lines)** that agents read first — the stable entry point.
  - Deeper sections are navigated to as needed, with clear cross-references.
  - This prevents the "monolithic manual" problem where agents either get overwhelmed by irrelevant context or miss critical information buried deep in a long document.
  - Refer to principles from `Agent_Oriented_Thinking.md` for detailed guidance on structuring agent-facing documentation. This will be refined further when Phase 1 execution begins.

### Phase 2: Minimum Viable Orchestrator (Skeleton Build)
- OAuth/subscription-based agent invocation (pi-agent style) for at least one provider.
- Single-provider agent spawning and lifecycle management.
- Shared-space coordination (presence registry) for concurrent agents (~4 max).
- Simple task assignment (manual).
- Conversation logging as structured events outside the target repo.
- Filesystem-scoped security with role-based tool enforcement.
- Basic markdown communication standard.
- Deterministic formatting/linting pipeline.
- Review → feedback → retry loop working end-to-end at least once.
- All workflows configurable (not hardcoded).
- **Note**: This is the bootstrap phase — built manually or by a single agent session before the system can build itself.

### Phase 3: Deep Recording & Dataset Readiness
- Ensure logs are genuinely useful for RL before adding more features.
- Full capture: prompt/context → plan → tool calls → command outputs → diffs → tests → review feedback → retries/escalations → final resolution.
- Iteration chains preserved (version N → version N+1 with what changed and why).
- Per-model failure data captured with enough detail to enable future self-improvement notes.
- Validate: can you reconstruct any task's full trajectory from logs alone?
- Define retention policy and storage limits.

### Phase 3.5: Multi-Provider & Basic Orchestration
- Add support for additional providers (OAuth + CLI backends).
- Git worktree isolation for scaling beyond ~4 concurrent agents.
- Automated task decomposition and assignment.
- Basic workflow engine (plan → scaffold → implement → cleanup → test → review → correct) — note the **cleanup step** before review.
- Project scaffolding builder agent with language/framework-specific skills.
- Tool separation security model.
- Per-agent metrics collection.
- Review-fix workflow with PR/template automation.
- Root-cause analysis diagnostic for review failures (failure classification and routing).
- Configurable review rigor levels (lightweight / standard / full consensus) based on task complexity.

### Phase 4: Intelligence & Optimization
- RLM integration.
- Multi-model review consensus.
- Dynamic model-to-task routing based on performance data.
- Escalation logic (severity analysis, model upgrade, user escalation).
- Cost tracking and optimization.

### Phase 5: Advanced Features
- Experimentation framework.
- DSPy integration exploration.
- Agent email system.
- Constructive feedback accumulation.
- Per-model self-improvement notes (personalized AGENTS.md) with auto-distillation from reviewer feedback.
- Advanced anomaly detection.
- **Gardener agent role** — background entropy management: scans for code pattern drift, convention violations, and stale documentation on a configurable cadence. Opens targeted cleanup/refactoring PRs.
- **Doc-gardening and mechanical freshness enforcement** — CI validation of documentation currency, cross-linking, and structural integrity. Automated detection and fix of stale docs.

### Phase 6: Platform Evolution
- Web/TUI dashboard.
- Plugin/skill system.
- Multi-project management.
- Preparation for the broader assistant ecosystem (Obsidian integration, OCR pipeline, channel support, etc.).

---

## 13. CONSTRAINTS & NON-NEGOTIABLES

1. **Linux-first** development. Future portability is a consideration, not a blocker.
2. **All tests must pass** at all times. No merging broken code.
3. **Complete documentation** — every function, every module, every decision.
4. **All agent conversations are logged** — no data loss.
5. **Security by default** — filesystem isolation, tool separation, anomaly detection.
6. **Everything is training data** — design every log, metric, and record with future RL in mind.
7. **User approval gates** — plans require user sign-off before execution.
8. **Daily priority review** — at minimum, once per day.
9. **Projects built with this system can be in any language** — the orchestrator must be language-agnostic in what it manages.
10. **Easy reconfigurability** — changing workflows, review processes, agent assignments, hierarchy structures, and any other system behavior must be straightforward configuration changes, not code rewrites. The system is built to be experimented with.
11. **Everything is optimizable** — every process, workflow, handoff, and decision point must be designed with the assumption that it will be measured and improved. No process is "final" — all are v1 by default.

---

## 14. DELIVERABLE EXPECTED FROM THE PLANNING AGENT

Produce a comprehensive, actionable implementation plan that:

1. **Addresses every section** of this document — nothing is skipped.
2. **Recommends the base project** with full comparative analysis of reference projects against architecture criteria (language choice follows from this).
3. **Defines the architecture** with component diagrams and interaction patterns.
4. **Specifies the phased roadmap** with clear milestones, dependencies, and deliverables per phase.
5. **Details the data model** — what is stored, where, in what format.
6. **Defines the communication protocol** — the markdown file standard for inter-agent coordination.
7. **Designs the security model** with specific implementation details.
8. **Designs the monitoring system** with specific metrics, storage, and alerting.
9. **Identifies risks** and proposes mitigations.
10. **Lists open questions** that require experimentation or user decisions, with recommended approaches.
11. **Specifies what to build vs. what to reuse** from reference projects.
12. **Includes estimated effort** per phase (rough t-shirt sizing is acceptable).
13. **Defines success criteria** for each phase.

The plan itself should be structured so that it can be decomposed into tasks for the very system it describes — recursive by design.

---

## Appendix A — Starter Templates

### A1. Leaf Task Template

```yaml
task_id: [unique identifier]
goal: [one sentence — what this task must accomplish]
context: [everything the cell agent needs — no assumptions, no implied knowledge]
constraints:
  role: [builder | searcher | reviewer | scaffolder | gardener]
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
  - [ ] Pre-submission cleanup completed (simplification, deduplication, convention alignment)
  - [ ] All existing tests pass
  - [ ] New tests written and passing
  - [ ] Code follows project rules
  - [ ] Documentation updated/created
  - [ ] No unauthorized tool usage flagged
  - [ ] Review agent approved
```

### A2. Definition of Done

A task is **done** when:
1. Deterministic style/format checks pass (linters, formatters — configured per project).
2. All existing tests pass (no regressions).
3. New tests cover the added/changed functionality and pass.
4. Code follows project rules.
5. Documentation is updated or created as needed.
6. No tool-policy violations were flagged during execution.
7. Review agent has approved the output.
8. Changes are committed to the task's worktree/branch.

### A3. Log Event Schema

```json
{
  "event_id": "uuid",
  "timestamp": "ISO-8601",
  "event_type": "[see event table in Section 5.2]",
  "task_id": "parent task reference",
  "agent_id": "which agent produced this event",
  "agent_role": "searcher | builder | reviewer | orchestrator | scaffolder | gardener",
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

### A4. Review Feedback Template (Reviewer → Builder)

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

### A5. Minimum Log Event Types for RL Readiness

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
