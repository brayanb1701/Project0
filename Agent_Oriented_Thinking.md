# Agent-Oriented Thinking: Core Principles

Core principles to apply when designing documents, systems, processes, or architecture for LLM agent consumption and operation.

---

## Context & Memory

`P` **Agents start cold every run.** There is no accumulated intuition, no "I remember last time." Every artifact must be self-contained enough to orient a fresh agent within its context window.

`P` **Context is finite and scarce.** Every token injected into context competes with the task, the code, and other docs. Maps beat manuals. Pointers beat copies. Progressive disclosure beats exhaustive upfront loading.

`P` **If it's not in the repo, it doesn't exist.** Slack threads, Google Docs, verbal agreements, and tacit knowledge are invisible. Anything the agent needs to know must be encoded as a versioned, repository-local artifact.

---

## Trust & Staleness

`P` **Agents trust what they read — silently.** A human notices when documentation contradicts the code. An agent follows the stale doc and generates code based on a false model. Staleness is a silent corruption vector.

`P` **Make agents responsible for the docs they depend on.** Don't rely on periodic human review. When an agent's task touches something described in a document, checking and updating that document should be part of the task itself — during review, at completion, or as a triggered check.

---

## Explicitness

`P` **Explicit beats implicit — always.** Conventions, dependency directions, naming rules, placement logic, and rationale must be stated, not inferred. Agents cannot absorb convention through osmosis the way humans do over months on a team.

`P` **Answer "where does new X go?"** Agents generate new files, modules, and types constantly. Without explicit placement rules, they extrapolate from the nearest existing pattern — which may be wrong, outdated, or an exception.

`P` **Include rationale for constraints.** An unexplained rule looks like unnecessary complexity to an agent asked to modify or extend the system. It may "helpfully" optimize the constraint away. Rationale makes constraints load-bearing in the agent's reasoning.

`P` **Name the injection point, not just the concern.** Saying "auth is cross-cutting" tells the agent what exists. Saying "auth is injected via the Providers interface in `src/providers/`" tells it where to act.

---

## Enforcement

`P` **Mechanical enforcement > documented rules.** A principle that only exists in prose will eventually be violated. A principle backed by a linter, a test, or a CI check will be caught immediately.

`P` **Error messages are agent instructions.** Write lint and CI error messages to include remediation steps — not just what's wrong, but exactly how to fix it. The error message is the agent's next prompt.

`P` **Tie invariants to their enforcement.** Stating "X never depends on Y" is good. Stating "X never depends on Y — enforced by `lint:deps`" is better. The agent can then verify compliance and understand the failure mode.

---

## Pattern Replication

`P` **Agents replicate existing patterns — including bad ones.** Whatever is most common in the codebase becomes the template. If inconsistent patterns coexist, agents amplify the inconsistency.

`P` **Encode the right pattern once, enforce it everywhere.** Human taste captured as a linting rule or a golden principle applies to every line of agent-generated code. Human taste left as a review comment applies once and is forgotten.

`P` **Pay down drift continuously.** Background agents scanning for deviations and opening small fix PRs on a regular cadence prevent drift from compounding. Daily small corrections beat periodic painful rewrites.
