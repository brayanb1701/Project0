# Research Project Reference Guide

This document is the reusable reference for analyzing candidate base projects, harnesses, and orchestrators for the **Agent Swarm Orchestrator**. It condenses the project requirements from `ORCHESTRATOR_PLANNING_PROMPT.md` and the research intent from `Projects_to_analyze.md` into a single guide that can be copied into each project folder under `Research`.

Its purpose is simple: when studying any external project, evaluate it against the target system described here and capture what can be reused, adapted, or rejected.

## 1. Target System Summary

We want to build an **Agent Swarm Orchestrator**: a custom harness and orchestration layer for fleets of AI coding agents.

Primary goal:
- Manage many coding agents across different providers and backends.
- Prefer **OAuth/subscription-based access** to models when possible.
- Support CLI backends like **Codex**, **Claude Code**, **Kimi CLI**, and similar tools as secondary or fallback runtimes.
- Treat the orchestrator as the **foundation layer** for a larger personal AI assistant ecosystem.

Long-term direction:
- Persistent 24/7 assistant behavior.
- Multi-channel input/output.
- Obsidian or second-brain integration.
- Reminder and escalation systems.
- OCR intake for handwritten notes.
- Encryption and access control for sensitive information.
- Idea-to-product / idea-to-research lifecycle support.
- Agent-to-agent experiments, specialization, personality, and evolution tracking.
- A personal “company” of specialized agents.

This long-term vision matters during research, but it must **not** block the initial coding-orchestration core.

## 2. Core Principles

All design and implementation decisions must follow these priorities:

1. **Functionality**
2. **Optimization**
3. **Modularity / granularity**
4. **Simplification**

Project-wide standards:
- Code must be maintainable, reusable, well documented, and fully tested.
- New changes must add tests and keep the entire suite passing.
- Formatting and style enforcement must be **deterministic** through tooling.
- A hybrid linting model is desirable: deterministic linters/formatters as the authority, optional LLM analysis as advisory only.
- Reimplement a narrow subset instead of taking a large dependency when that improves control, inspectability, and agent comprehensibility.

Meta-principle:
- **Everything is optimizable.**
- Every workflow, policy, configuration, and coordination mechanism must be modular, measurable, configurable, and improvable.
- No process is “final”; every process is treated as v1.

## 3. What v0 Must Be

The initial build is a **coding orchestration core**, not the full assistant platform.

### v0 scope
- Multi-agent coding execution.
- Isolated work across shared-space coordination or worktrees.
- Role-based tool access with configurable policies.
- Shared coordination space for status/questions.
- Structured logging suitable for future RL datasets.
- Review -> feedback -> retry loop with escalation.
- LLM provider abstraction layer.
- Basic orchestrator-driven task decomposition.
- Deterministic formatting/linting pipeline.

### Explicitly deferred to v1+
- Rich dashboards and polished UIs.
- Messaging bridges like Telegram/Slack/Discord.
- Deep tracker integrations beyond the basics.
- Persistent cross-channel assistant behavior.
- Sophisticated self-improvement distillation.
- Mature dynamic model routing and cost optimization.
- DSPy / RLM experimentation infrastructure beyond initial hooks.
- Plugin marketplace.

## 4. Architectural Decisions Every Research Project Must Be Judged Against

### 4.1 Base project selection
The chosen foundation project will strongly influence:
- Language.
- Runtime architecture.
- Extensibility model.
- How agent invocation is implemented.
- How easy it is for agents to maintain and extend the system later.

Each project should be evaluated for whether it can serve as:
- **Base**
- **Inspiration**
- **Tool**
- **Reference**
- **Skip**

### 4.2 Language criteria
Judge language choices by:
- Performance and concurrency characteristics.
- CLI/process/PTY integration support.
- Async I/O and IPC maturity.
- Logging, metrics, git, parsing, encryption, and file-watching ecosystem quality.
- Linux-first practicality with future portability.
- **Agent comprehensibility**: how well current LLMs can reason about the language, libraries, and debugging surface.

Languages already present in the candidate ecosystem:
- Rust (Agent of Empires, ZeroClaw)
- TypeScript (OpenClaw, pi-mono, oh-my-pi)
- Python (ypi, hermes-agent)
- Zig (NullClaw)
- Elixir (Symphony reference implementation)
- Go (codex-autorunner)

### 4.3 System structure criteria
Research whether the project supports:
- Easy experimentation with different hierarchies and org structures.
- Extensibility without rewrites.
- Both synchronous and asynchronous coordination.
- The right balance of monolith vs modular services vs plugin architecture.

### 4.4 Agent invocation strategy
The runtime must abstract over multiple backend types.

Required paths to evaluate:
- **OAuth/subscription-based direct access** as the preferred starting path.
- **CLI non-interactive/headless mode** where available.
- **tmux/PTY wrapping** as a fallback for interactive-only CLIs.

The rest of the system must remain invocation-agnostic.

### 4.5 Centralization vs decentralization
The architecture should support:
- A centralized orchestrator/oracle mode.
- A more distributed self-organizing mode.
- Hybrid/experimental coordination models such as ensemble orchestration or negotiation.

## 5. Core Capabilities the Final System Must Have

### 5.1 Agent Runtime Manager
The runtime manager must:
- Spawn agents through OAuth/API, non-interactive CLI, or PTY-wrapped CLI backends.
- Abstract backend differences away from higher layers.
- Isolate agents through shared-space coordination for small teams and git worktrees for larger parallelism.
- Track agent state: running, waiting, errored, completed, token-limited.
- Support stop, restart, and resume.
- Configure per-agent backend, model, limits, allowed tools, and filesystem scope.
- Give every agent a random traceable identity.

Research questions to answer for each candidate project:
- Does it support worktrees cleanly?
- Can it run parallel sessions safely?
- Does it expose native subagent support?
- Can it operate non-interactively?
- Can it preserve session state and replay context?

### 5.2 Runtime/application observability for coding agents
Agents must observe the running software they are building.

Expected capabilities:
- Browser automation and DevTools access for frontend work.
- Per-worktree ephemeral logs/metrics/traces when useful.
- Validation based on actual runtime behavior, not only tests.
- Observability tool selection adapted by project type.

### 5.3 Orchestrator / Oracle
The orchestrator must handle:
- Task decomposition into self-contained units.
- Task assignment based on model strengths and later on real data.
- Multi-level delegation.
- Escalation when tasks fail or information is missing.
- Planning with strong models, with user approval before execution.

Initial specialization hypotheses to compare against real data:
- Claude: frontend and UI work.
- Codex: backend and systems work.
- Kimi CLI: narrow, explicit tasks.
- Grok: search and research.
- Strongest available models: planning, review, architecture.
- Cheap/free models: ultra-granular low-risk work.

Open design questions to keep in mind during analysis:
- Single orchestrator vs ensemble orchestrator.
- Where RLM lives: inside tools, outside tools, or both.
- Whether DSPy concepts should shape workflows.

### 5.4 Workflow engine
Baseline programming loop:

`PLAN -> IMPLEMENT -> TEST -> REVIEW -> CORRECT -> REPEAT`

Requirements:
- Workflows must be inspectable, editable, composable, and measurable.
- Different templates should exist for coding, exploration, research, maintenance, and project creation.
- Optimization is part of workflow design from day one.

### 5.5 New project scaffolding workflow
After planning is approved, a scaffolder/builder should be able to generate:
- Project structure.
- Build system.
- Linter/formatter configuration.
- CI configuration.
- Test framework.
- Documentation templates.
- Inter-agent communication markdown files.
- Language/framework-specific boilerplate.

### 5.6 Review system
Review rigor must be configurable by task risk.

Required levels:
- **Lightweight** for cosmetic/docs/boilerplate.
- **Standard** for normal implementation work.
- **Full consensus** for high-risk, architectural, security-sensitive, or cross-cutting changes.

Full consensus means:
- Multiple independent reviews.
- Final synthesis/consensus review by the strongest available model.
- Tunable reviewer count and model mix.

### 5.7 Clarification and escalation
Any agent must be able to:
- Ask the assigning agent for clarification.
- Escalate to the user when at the top of the chain.
- Ask other active agents through the coordination space.

### 5.8 Self-spawning policy
This is not allowed broadly by default.

Safe default:
- Only the orchestrator may spawn new sessions in v0.

Research target:
- Study which roles can safely self-spawn.
- Define depth, budget, and retry limits.

### 5.9 Review-fix loop details
The build/review loop must include:
- Pre-submission cleanup before review.
- Automatic review triggering after submission.
- Reviewer access to task context, diffs, and changed files.
- Structured feedback with severity.
- Return of feedback to the original execution session.
- Context-window management through compaction or clean-session restart.
- Retry tracking with escalation thresholds.

Severity routing:
- **S0**: cosmetic/style.
- **S1**: local correctness issues.
- **S2**: systemic/architectural/security issues.
- **S3**: blocked due to missing or ambiguous information.

Before deciding remediation, failures should go through root-cause analysis:
- Insufficient context.
- Context management failure.
- Skill/workflow gap.
- Model limitation.
- Ambiguous requirements.
- Environment issue.

### 5.10 Constructive feedback and institutional learning
Reviewer feedback should:
- Teach executing agents.
- Accumulate project and model-specific lessons.
- Feed future RL/fine-tuning/self-improvement loops.

### 5.11 RLM and DSPy hooks
The system should be built so it can later support:
- Recursive Language Models with configurable recursion parameters.
- DSPy-inspired flow/module optimization.
- Ralph-like loop patterns where useful.

These are important, but deep integration is not a v0 blocker.

### 5.12 Communication system
Primary inter-agent communication should use markdown files inside the project.

Expected properties:
- Standardized files such as `DECISIONS.md`, `QUESTIONS.md`, `STATUS.md`, `ARCHITECTURE.md`.
- File-watch triggers.
- Synchronous coordination for concurrent agents.
- Asynchronous handoff/history for sequential agents.
- Optional future email-like agent messaging.

### 5.13 Shared-space coordination
When multiple agents share one folder instead of worktrees:
- Agents must register presence and touched files.
- They must announce status, scope, and questions.
- The coordination space should reset after a configurable time or size threshold.
- Shared-space mode should be capped at roughly 4 concurrent agents by default.
- Larger parallelism should shift naturally to worktrees.

Presence records should capture:
- Agent id
- Role
- Task id
- Human-readable work summary
- Files touched
- Branch/worktree
- Start time
- Status
- Optional question and target

### 5.14 Task management
Tasks must carry:
- Full context needed to execute.
- Constraints, standards, and documentation rules.
- Test expectations.
- Linked architectural decisions.
- Assignment, status, attempts, escalation history, time, and token usage.
- Dependencies and priority.

## 6. Security Model

Security is a first-class requirement, not a later hardening pass.

### 6.1 Role-based separation
Core rule:
- No single agent should have both unrestricted bash/code execution and unrestricted web search by default.

Minimum role set:
- **Searcher**: web only, no filesystem, no bash.
- **Builder**: scoped filesystem + bash, no internet.
- **Reviewer**: read-only filesystem + diffs + tests, no write, no internet.
- **Orchestrator**: spawning/routing/planning only.
- **Scaffolder**: project setup and template generation.
- **Gardener**: ongoing cleanup, entropy control, stale-doc detection, refactoring PRs.

### 6.2 Filesystem and sandbox boundaries
The default should be:
- Access only to the folder where the agent is invoked.
- Explicit broader access by policy, not by assumption.
- Optional YOLO mode.
- Optional container/sandbox isolation.

### 6.3 Tool gating and anomaly detection
The system must:
- Define tool allowlists per role.
- Flag attempted tool use outside the allowlist.
- Treat violations as both security and prompt-injection signals.
- Log all such events.
- Support configurable confirmation gates for destructive or high-risk actions.

### 6.4 Additional security requirements
- Secure secret/token handling.
- Optional container isolation.
- Output sanitization between agents.
- Rate limiting and budget controls.
- Immutable audit trail of agent actions.

## 7. Monitoring, Logging, and Data Collection

All logs are future training data.

The system must capture:
- Full conversations and session transcripts.
- Deep session recordings, not just final outputs.
- Plans, drafts, retries, failures, diffs, and final accepted results.
- User edits to agent-generated outputs.
- Final accepted state for each task.

Metrics required:
- Tokens in/out.
- Wall-clock time.
- Rate/token/account limit hits.
- Files reviewed and modified.
- Tests run and results.
- Completion status.
- Per-model task success rates, cost, error patterns, and strengths.
- Coordination failures and communication patterns.

The system must also support:
- Dynamic model evaluation by task type.
- A/B testing of assignments/configurations.
- Cost tracking per agent/model/project.
- Future per-model self-improvement notes distilled from failures and reviews.

Minimum failure metadata should preserve:
- Model used.
- Failure category.
- Severity.
- Reviewer assessment.

## 8. Git and Version Control Requirements

The system needs a clear scaling path:
- Shared-space collaboration for small teams.
- Git worktrees for larger parallel work.

Expected git features:
- Clean worktree support.
- Branch naming tied to task and agent identity.
- PR or review-branch based workflows.
- Automated conflict detection and resolution attempts.
- Reversible operations and rollback checkpoints before risky steps.

## 9. Reuse and Research Philosophy

Every research project must be judged on whether it should be:
- Reused directly.
- Used as a foundation.
- Studied for ideas only.
- Treated as something to partially reimplement.

Guiding rule:
- If only a small useful subset is needed, reimplementing that subset may be better than importing a large opaque dependency.

Important sources and families to keep in mind during research:
- SOTA coding harnesses like Codex and Claude Code.
- Orchestrators/harnesses like pi-mono, oh-my-pi, adaf, codex-autorunner, Agent of Empires, hermes-agent, ypi, symphony.
- Assistant systems like OpenClaw and variants.
- Skill/extension ecosystems like `agent-stuff`, agentskills, and Anthropic skills.
- Research/theory sources around RLMs, DSPy, and architectural patterns.
- Useful tool ideas like MCP wrappers, evaluation tools, evolutionary frameworks, docs extractors, and CI/CD building blocks.

## 10. Experimentation Requirements

The orchestrator must be easy to experiment with.

Expected experimentation axes:
- Hierarchy structure.
- Centralized vs distributed coordination.
- Model-to-role assignment.
- Single-orchestrator vs ensemble orchestration.
- RLM depth/width/parameter tuning.
- Review reviewer-count/model-mix/consensus strategies.
- Cost-vs-quality tradeoffs using cheaper models for narrow work.

Experimentation infrastructure requirements:
- Reproducible runs with full config capture.
- Integration with logging/metrics.
- A/B testing support.

## 11. Additional System Requirements

The final system must also address:
- Crash recovery and persistent state.
- Hung/looping agent detection.
- Graceful failover on rate limits/provider outages.
- Centralized but overridable configuration.
- Config versioning and hot-reload where safe.
- CPU/memory/concurrency limits.
- Queueing and priority scheduling.
- Task dependency graphs.
- Conflict detection and deadlock prevention.
- CI/CD integration.
- User notification and approval flows.
- Plugin/skill architecture.
- Unit, integration, simulation, and chaos testing for the orchestrator itself.
- Living documentation, ADRs, and auto-generated docs where useful.
- Doc freshness enforcement in CI.
- Persistent data storage choices and retention/export policies.
- TUI-first observability with possible future web UI.
- Multi-project management with isolation and optional cross-project knowledge sharing.
- Backward compatibility and migration/versioning of coordination protocols.
- Active entropy management through cleanup before review and gardener passes over time.

## 12. Documents and Standards the System Must Eventually Define

Phase 1 of the project should produce explicit documents that agents can follow directly:
- `ARCHITECTURE.md`
- `SECURITY.md`
- `AGENTS.md`
- `LOGGING.md`
- `TASKS.md`
- `REVIEW_PIPELINE.md`
- `CONFIGURATION.md`
- `TESTING.md`
- `SCAFFOLDING.md`
- `OBSERVABILITY.md`

These documents should follow a progressive-disclosure structure:
- Short stable summary first.
- Deeper sections navigated by need.
- Clear cross-references instead of a single monolithic wall of text.

## 13. Operational Standards and Schemas

These details matter when evaluating whether a research project already has compatible primitives.

### 13.1 Minimum task payload
Tasks should include at least:
- Unique task id.
- One-sentence goal.
- Complete execution context.
- Explicit role, allowed tools, and scope path.
- Preferred model if relevant.
- Required style/lint commands.
- Input files and task dependencies.
- Acceptance criteria.
- Existing tests that must keep passing.
- New tests required.
- Documentation required.
- Done checklist.

### 13.2 Definition of done
A task is only done when:
- Deterministic style checks pass.
- Existing tests pass.
- New tests exist and pass.
- Code follows project rules.
- Documentation is updated.
- No tool-policy violations occurred.
- Review approved the result.
- Changes are committed in the task branch/worktree.

### 13.3 Minimum log event structure
Logging should preserve at least:
- Event id and timestamp.
- Event type.
- Task id.
- Agent id, role, model, and session/worktree id.
- Payload with input/output/tool/severity/decision/diff/version/context-usage/failure-category as needed.
- Parent event link for chains.
- Cost metadata with token counts and estimated cost.

### 13.4 Minimum event categories for RL readiness
The logging model should support at least:
- Planning events.
- Tool invocation/denial/violation events.
- Execution and command events.
- Test events.
- Review events.
- Escalation and retry events.
- Full conversation transcripts.
- Coordination events.
- Model self-improvement note events.

### 13.5 Review feedback structure
Review records should capture:
- Task id and reviewer id.
- Pass/fail verdict.
- Severity.
- Retry number.
- Context usage estimate.
- Structured failures with type, description, location, and suggested fix.
- Files reviewed and status.
- Recommendation: retry, escalate model, escalate human, or blocked.

## 14. Architecture Implications of Agents Building the System

Because agents will build and maintain this orchestrator, the architecture should respect these rules:
- Separate doer and checker roles.
- Send review feedback back into the original execution session when possible.
- Keep orchestration state outside the code repository.
- Write architecture and workflow docs so they double as agent instructions.
- Run deterministic checks before agent review.
- Treat the test suite as the ground truth for correctness.
- Accept that an initial bootstrap skeleton must exist before the system can self-build.
- Make workflow changes configurable rather than code-heavy.
- Instrument every workflow so it can later be optimized.

## 15. Fixed Leanings and Open Decisions

Current strong leanings:
- v0 should stay coding-only.
- `pi-mono` is the current likely foundation unless research proves otherwise.
- OAuth/subscription access is preferred first, API/CLI/tmux as additional modes.
- Worktrees are the default isolation model, with optional Docker for riskier cases.
- Coordination starts with an ephemeral shared registry/chat approach.
- The baseline role model is the six-role set listed above.
- Logs should live outside the target repository.
- Only the orchestrator should self-spawn in v0.
- Deterministic style enforcement is mandatory; LLM linting is advisory only.

Open decisions that research should clarify:
- Best base project and language.
- Whether review should be PR-driven, template-driven, or both.
- Which CLIs really support non-interactive use, worktrees, subagents, and parallel use cleanly.
- Which roles, if any, can safely self-spawn later.
- How much of DSPy/RLM philosophy should be embedded into workflow design.

## 16. Major Risks to Keep In Mind During Analysis

Key risks:
- Over-engineering before the core loop is validated.
- Terms-of-service or access issues with subscription/OAuth usage.
- Excessively broad permissions creating security holes.
- Shared coordination becoming noisy or unsafe.
- Review/retry loops consuming too much context.
- Infinite recursion or self-spawning loops.
- Picking the wrong foundation project.
- Log storage growing without limits.
- Cost blowups from escalation chains.
- Bootstrapping problem: the system cannot self-build before a minimal core exists.
- Inconsistent support for deterministic tooling across languages.

When analyzing a project, note whether it reduces or increases any of these risks.

## 17. Phased Roadmap Reference

Use this roadmap to judge whether a project helps with immediate needs or only later stages.

### Phase 0: Foundation and research
- Comparative analysis of candidate projects.
- Base project recommendation.
- Structured reports per important project.
- Synthesis of what to reuse vs build.
- Worktree/CLI/provider research.

### Phase 1: Architecture definition
- Agent-facing architecture/security/logging/task/review/testing/config/scaffolding docs.
- Initial observability recommendations.

### Phase 2: Minimum viable orchestrator
- One-provider invocation.
- Agent lifecycle management.
- Shared-space coordination.
- Structured logging outside repo.
- Role-based security.
- Markdown communication.
- Deterministic style pipeline.
- One complete review-feedback-retry loop.

### Phase 3: Dataset readiness
- Deep full-trajectory logs.
- Retry/version chain reconstruction.
- Retention policy.
- Enough failure metadata for later self-improvement.

### Phase 3.5: Multi-provider and basic orchestration
- Additional providers/backends.
- Worktree scaling.
- Automated decomposition and assignment.
- Basic workflow engine.
- Scaffolder agent.
- Tool-separation security.
- Metrics collection.
- Automated review-fix routing.
- Root-cause diagnostics.
- Configurable review rigor.

### Phase 4: Intelligence and optimization
- RLM integration.
- Multi-model review consensus.
- Data-driven routing.
- Better escalation.
- Cost optimization.

### Phase 5: Advanced features
- Experimentation framework.
- DSPy exploration.
- Agent email.
- Constructive feedback accumulation.
- Per-model notes and distillation.
- Advanced anomaly detection.
- Gardener role.
- Doc gardening and mechanical freshness checks.

### Phase 6: Platform evolution
- Dashboard/UI.
- Plugin/skill system.
- Multi-project management.
- Preparation for the broader assistant ecosystem.

## 18. Non-Negotiables

These are project constraints, not preferences:
- Linux-first.
- All tests must pass.
- Documentation must stay complete and current.
- All agent conversations must be logged.
- Security by default.
- Everything collected should be useful as future training data.
- Plans require user approval before execution.
- Priorities should be reviewed at least daily.
- The orchestrator must be able to manage projects in any language.
- Workflows and policies must be easy to reconfigure without rewrites.
- Every process must be designed for measurement and optimization.

## 19. What Each Project Analysis Must Answer

Every research report should cover at least the following:

1. **Access to models/providers**
   How does the project connect to models: API keys, OAuth/subscriptions, CLI wrappers, or other methods?

2. **API structure / invocation method**
   What abstraction does it use? What provider-specific capabilities are supported, such as tools, streaming, or special reasoning modes?

3. **Security and isolation**
   Worktrees, sandboxing, containers, filesystem scoping, tool restrictions, role-based access, and any prompt-injection defenses.

4. **Agent types and orchestration**
   Defined roles, session model, hierarchy, communication protocol, task routing, review loops, subagents, and state management.

5. **Alignment with our target system**
   Which parts directly match our goals in sections 1-16 of this guide?

6. **Interesting unrelated features**
   Valuable ideas outside the current scope that may strengthen the overall platform later.

7. **Project-specific focus areas**
   Any extra questions or investigation targets specific to that project.

8. **Limitations**
   Missing features, scaling constraints, risk areas, trade-offs, or reasons it may not fit as a base.

9. **Maintenance and engineering quality**
   Code quality, documentation quality, test coverage, activity, maturity, contribution model, and how safe it is to depend on or fork.

10. **Foundation recommendation**
   Categorize the project as: `base`, `integration candidate`, `inspiration`, `reference`, `partial reimplementation target`, or `skip`.

11. **Key code or docs worth studying**
   Point to the exact files, modules, docs pages, `llms.txt`, blog posts, or examples that matter most.

## 20. Research Process Notes

When analyzing a project:
- Use source code and online docs together when available.
- If the project exposes `llms.txt`, docs pages, specs, or blogs, include them.
- Compare the project against both immediate v0 needs and long-term strategic value.
- Explicitly separate what is production-ready from what is only inspirational.
- Note whether the project preserves a philosophy we care about, especially for Pi-derived systems.
- Call out not just features, but how extensible and agent-maintainable the implementation is.

## 21. Minimal Output Shape for Each Report

Each per-project report should ideally end with:
- Short summary.
- Architecture overview.
- Provider/invocation model.
- Security/isolation review.
- Coordination/workflow/review analysis.
- Logging/observability analysis.
- Strengths.
- Limitations.
- Relevant ideas for our system.
- Final recommendation and role in our architecture.

That final recommendation should answer:
- Should we build on this?
- Should we integrate it?
- Should we copy patterns from it?
- Should we only learn from it and move on?
