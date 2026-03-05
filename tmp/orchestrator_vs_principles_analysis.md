# Comparative Analysis: Orchestrator Planning Prompt vs. Agent Project Principles

---

## I. DIFFERENCES IN PERSPECTIVE

**1. Blame model: Environment vs. Agent**
- **Principles**: "When something fails, fix the environment — not the agent. The answer is never 'try harder.'" Failures are always a missing capability or context problem.
- **Orchestrator**: Focuses on retry/escalation chains (send back to same model, escalate to better model, escalate to user). Has per-model self-improvement notes (§5.6, §9.15) that accumulate failure profiles per model — this is closer to "fix the agent's prompt" thinking rather than "fix the environment."

**2. Speed vs. Deliberation**
- **Principles**: "Corrections are cheap. Waiting is expensive." High throughput inverts the cost model. Blocking on perfection is worse than shipping and fixing fast.
- **Orchestrator**: Heavy on approval gates — plans require user sign-off (§13.7), daily priority reviews (§13.8), user approval before execution. More cautious, more deliberate. The review-fix cycle has hard retry limits and mandatory human review.

**3. Merge philosophy**
- **Principles**: Conventional norms (block on flakes, require human review, long-lived PRs) become counterproductive at agent throughput levels. Fast merging is safe *with strong mechanical guardrails*.
- **Orchestrator**: "All tests must pass at all times. No merging broken code" (§13.2). Every PR goes through multi-model review consensus (§3.3). More conservative — doesn't contemplate automerging or reduced human review even with guardrails in place.

**4. Knowledge architecture approach**
- **Principles**: Explicitly warns against monolithic AGENTS.md. Advocates short (~100 lines) map with pointers to structured `docs/`. Progressive disclosure — agents start from a small stable entry point.
- **Orchestrator**: Phase 1 produces 9+ dense architecture documents (ARCHITECTURE.md, SECURITY.md, AGENTS.md, LOGGING.md, etc.) — but never discusses their size, navigability, or how agents should consume them. Risks creating the exact "monolithic manual" the Principles doc warns against.

**5. What "observability" means**
- **Principles**: Making the *managed application* observable *to the agents working on it* — browser automation, DevTools, per-worktree ephemeral observability stacks (logs, metrics, traces). Agents validate their own work by observing runtime behavior.
- **Orchestrator**: Observability means monitoring the *orchestrator itself* — agent status, token consumption, task progress, cost tracking (§5, §9.11). Doesn't address how agents observe the applications they're building.

**6. Technology selection criteria**
- **Principles**: "Prefer technologies the agent can fully reason about." Boring tech with stable APIs and strong training-data representation is an asset. Agent comprehensibility is a first-class selection criterion.
- **Orchestrator**: Tech selection criteria (§2.1) focus on performance, ecosystem maturity, async I/O, CLI process management, developer ergonomics. Never mentions "can agents reason about this?" as a factor.

**7. Dependency philosophy**
- **Principles**: "Reimplementing a small subset is sometimes better than depending on a library." A tight, fully-tested internal implementation beats working around a black box.
- **Orchestrator**: Leans toward integration and reuse — extensive reference project analysis (§7.2), base project selection, fork/extend/integrate philosophy. Doesn't discuss when reimplementation is preferable.

**8. Entropy management**
- **Principles**: Dedicated concern. Agents replicate existing patterns *including bad ones*. Without active cleanup, drift is inevitable. Solution: background "cleanup agents" that scan for violations of golden principles and open targeted refactoring PRs on a cadence.
- **Orchestrator**: No mention of code entropy, pattern drift, or cleanup agents. Assumes the review cycle catches everything, but doesn't account for gradual drift across many tasks.

**9. Lint messages as agent instructions**
- **Principles**: "Lint error messages are agent instructions." Write error messages that inject remediation steps directly into agent context — not just what's wrong, but exactly how to fix it.
- **Orchestrator**: Mentions deterministic style enforcement (linters/formatters) but treats them as binary pass/fail gates. Doesn't address the *quality* of lint output as agent context.

**10. Scope of concern**
- **Principles**: Focused on *how to run projects managed by agents* — the engineering practices and infrastructure needed. Tool-agnostic, agent-agnostic.
- **Orchestrator**: Focused on *building the orchestration system itself* — architecture, components, invocation strategies, security, phasing. The managed projects are secondary.

---

## II. POINTS IN COMMON

**1. Deterministic style enforcement**
- Orchestrator §2.5/§10: "Deterministic only. Linters/formatters, never agent opinion."
- Principles §2: "Encode taste as linting rules." Human preferences amplified once, enforced everywhere.

**2. Repository as source of truth**
- Orchestrator §9.14: "The test suite is the ground truth."
- Principles §1: "The repository is the only source of truth."

**3. Architecture enforcement as early prerequisite**
- Orchestrator: Architecture docs in Phase 1, before any code.
- Principles: "Architectural rigor is an early prerequisite, not a later optimization."

**4. Role separation (doer vs. checker)**
- Orchestrator §3.1/§4.1: Explicit Builder/Reviewer separation with tool allowlists.
- Principles §7: Implied in the full autonomy loop (implement → validate → review as distinct steps).

**5. Per-task/per-change isolation**
- Orchestrator §3.1/§6.1: Worktrees, filesystem scoping, agent isolation.
- Principles §3: "Isolate each change's environment."

**6. Closed feedback loops**
- Orchestrator §3.3: Review → feedback → retry loop, escalation logic.
- Principles §7: Full autonomy loop from problem to merged fix.

**7. Documentation requirements**
- Orchestrator §13.3: "Complete documentation — every function, every module, every decision."
- Principles §1: Structured `docs/` directory, freshness enforcement.

**8. Configurable/modular design**
- Orchestrator §1.4: "Everything is optimizable." Replaceable modules, configurable workflows.
- Principles §2: "Enforce invariants, not implementations." Freedom within structural constraints.

**9. Invariants and constraints over prescriptive rules**
- Orchestrator §4.1: Role-based tool allowlists as hard constraints.
- Principles §2: Enforce what the code *must be*, not how it's expressed.

**10. Humans as decision-makers, agents as executors**
- Orchestrator §3.2: User approval gates, escalation to user for important decisions.
- Principles: "Humans steer. Agents execute."

---

## III. WHAT FROM PRINCIPLES CAN COMPLEMENT THE ORCHESTRATOR DOC

**1. "Fix the environment, not the agent" as an explicit design principle**
- Add to §1.3 (Design Philosophy) or §3.3 (Workflow Engine). When a task fails repeatedly, the system should prompt investigation of *what context, tooling, or capability is missing* — not just escalate to a better model. This reframes the escalation logic: before escalating, ask "was the environment sufficient?"

**2. Progressive disclosure for agent-facing documentation**
- Add to Phase 1 (§12, Architecture Definition). The 9+ architecture docs should follow the "short map + pointers" pattern. Each doc should have a concise summary section (~100 lines) that agents read first, with deeper sections they navigate to as needed. Without this, agents will either be overwhelmed or miss critical info.

**3. Lint error messages as agent instructions**
- Add to §2.5 (Scope Boundaries, deterministic style enforcement) and §9.14.5 (deterministic checks as first gate). The custom linters and formatters should be designed so their error output contains remediation steps — not just "line 42: error" but "line 42: error — do X to fix this." This directly improves the automated fix cycle.

**4. Application legibility / runtime observability for agents**
- Add as a new subsection under §3.1 (Agent Runtime Manager) or §9.5 (CI/CD Integration). Agents building frontend/backend code need to observe the running application — browser automation, DevTools integration, per-worktree ephemeral observability (logs, metrics, traces). Without this, agents can only validate via tests, not runtime behavior. This is a significant gap.

**5. Entropy management / cleanup agents**
- Add as a new agent role or background process in §3.2 or §4.1. A "Gardener" or "Janitor" agent role that runs on a cadence, scans for violations of project golden principles, and opens targeted cleanup PRs. This addresses the inevitable pattern drift that the review cycle alone won't catch.

**6. Doc-gardening agent**
- Add to §3.2 or §9.9 (Documentation System). A recurring background agent that scans for stale docs, broken cross-references, and outdated information — then opens fix PRs automatically. The Orchestrator doc says docs must stay current (§13.3) but has no mechanism to enforce it.

**7. "Agent reasonability" as a technology selection criterion**
- Add to §2.1 (Language Selection). "Can current LLMs reason well about this language/framework?" should be an explicit criterion alongside performance, ecosystem maturity, etc. This is especially relevant since agents will build the system.

**8. Reimplement-over-depend guideline**
- Add to §1.3 (Design Philosophy) or §7.3 (Project Reuse Philosophy). When evaluating reference projects for integration, add a decision criterion: if only a small subset of functionality is needed, consider reimplementing rather than taking the dependency. A tight, tested internal implementation the agents can inspect and modify may be better than a black-box library.

**9. Mechanical freshness enforcement for documentation**
- Add to §9.9 (Documentation System) and §9.5 (CI/CD Integration). CI should validate that docs are current, cross-linked, and correctly structured — not just that they exist. Lint rules for documentation staleness.

**10. Explicit anti-patterns list**
- Add as a new section or appendix. The Orchestrator doc has a Risk Register (§11) but no anti-patterns list. Adopting the Principles doc's anti-patterns — and adding orchestrator-specific ones — would serve as a quick reference for what to avoid:
  - Monolithic agent instruction files
  - Knowledge outside the repo
  - Retrying instead of fixing the environment
  - Manual cleanup sprints
  - Opaque dependencies when reimplementation is clearer
  - Deferring architectural constraints
  - Blocking indefinitely on flakes

**11. Throughput-aware review design**
- Add as a consideration in §3.3 (Review Workflow). The current design is conservative (multi-model consensus, mandatory human review after N retries). The Principles doc's insight — that high throughput changes what "responsible" means — should at least be acknowledged as a configurable dimension. Perhaps: configurable review rigor levels (full consensus for critical changes, lightweight/auto-merge for low-risk changes like S0 fixes).

**12. "Enforce invariants, not implementations" as a principle for workflow definitions**
- Add to §1.4 (Meta-Principle) or §3.3 (Workflow Engine). Workflow definitions should specify *what must be true* (invariants, acceptance criteria) rather than *how to do it* (step-by-step instructions). This gives agents more freedom to find optimal paths while maintaining correctness.

---

## Summary

| Category | Count |
|---|---|
| Differences in perspective | 10 |
| Points in common | 10 |
| Complementary additions | 12 |

The biggest gaps the Principles doc fills are: **environment-first debugging** (vs. model escalation), **entropy management** (cleanup agents), **application legibility for agents** (runtime observability), and **progressive disclosure in documentation** (avoiding overwhelming agents). These are practical, battle-tested insights that would make the Orchestrator's design more robust.
