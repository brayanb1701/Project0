# Agent-Managed Project Principles
> Condensed from: "Harness Engineering: Leveraging Codex in an Agent-First World" (OpenAI)

**Legend:** `P` = Core Principle · `E` = Implementation Example

---

## Philosophy

`P` **Humans steer. Agents execute.** The engineer's job is designing environments, specifying intent, and building feedback loops — not writing code.

`P` **Corrections are cheap. Waiting is expensive.** High agent throughput inverts the cost model. Blocking on perfection is worse than shipping and fixing fast. **However**, this must be balanced with quality — especially in early iterations where workflows and processes are still being refined. The path is: start with human-in-the-loop review, refine workflows through experience, and gradually increase autonomy as mechanical guardrails mature. Speed without quality is not the goal; the system should evolve toward fast *and* reliable.

`P` **When something fails, fix the environment — not the agent.** Always ask first: "what capability or context is missing?" **However**, this is the default diagnostic mindset, not the only response. Model escalation is a valid complementary strategy — different models have different strengths, failure modes, and context management capabilities. The right approach is **root-cause analysis first**: diagnose whether the failure stems from missing context, a skill/workflow gap, an environment issue, or a genuine model limitation — then route the fix accordingly. Sometimes the answer *is* a more capable model; the principle guards against making that the *default* answer.

---

## 1. Knowledge Architecture

`P` **AGENTS.md is a map, not a manual.** A monolithic instruction file rots, crowds out context, and makes everything equally important (which means nothing is). Keep it short with pointers to deeper sources.

`P` **The repository is the only source of truth.** Anything not in the repo doesn't exist for the agent — Slack discussions, Google Docs, and tacit knowledge are invisible. Encode everything as versioned artifacts.

`P` **Progressive disclosure.** Agents start from a small stable entry point and are taught where to look next, never overwhelmed upfront. Architecture documents should follow a "short summary + pointers" structure — each with a concise entry section (~100 lines) and deeper sections navigated on demand.

`P` **Enforce freshness mechanically.** Don't trust docs to stay current. Lint and CI should validate that the knowledge base is up to date, cross-linked, and correctly structured. A doc-gardening agent should run on a cadence to detect and fix staleness automatically.

> `E` They kept AGENTS.md to ~100 lines. A structured `docs/` directory held design docs, execution plans, product specs, generated schemas, and external reference files (in `llms.txt` format). A recurring "doc-gardening" agent scanned for stale docs and opened fix PRs automatically.

---

## 2. Architecture Enforcement

`P` **Enforce invariants, not implementations.** Define what the code must be (boundaries, correctness, dependency directions) — not how it's expressed. Give agents freedom within strict structural constraints.

`P` **Architectural rigor is an early prerequisite, not a later optimization.** Rigid structure is what allows speed without drift. Deferring it is how codebases decay.

`P` **Encode taste as linting rules.** Human preferences that live in review comments get amplified once and enforced everywhere automatically. When documentation isn't enough, promote the rule into code.

`P` **Lint error messages are agent instructions.** Write error messages that inject remediation steps directly into agent context — not just what's wrong, but exactly how to fix it. **Note**: Achieving this fully may require a **hybrid approach** — deterministic linters as the authoritative baseline (pass/fail enforcement), augmented by an LLM-based advisory layer that can provide richer, context-aware remediation guidance beyond what static rules can express. The deterministic layer remains the authority; the LLM layer is advisory only.

> `E` They defined a fixed layer model per business domain: `Types → Config → Repo → Service → Runtime → UI`. Cross-cutting concerns (auth, telemetry, feature flags) entered only through a `Providers` interface. Violations were caught by custom Codex-generated linters. Taste invariants included: structured logging, naming conventions for schemas/types, file size limits, parse-don't-validate at boundaries (they used Zod, though the library wasn't prescribed).

---

## 3. Application Legibility

`P` **Make the running application observable to agents.** Agents need to reproduce bugs, validate fixes, and reason about behavior — not just read code. Wire the app's UI, logs, and metrics into the agent runtime. The specific observability tools will vary by project type (web frontend, CLI, API service, etc.) — define an initial recommended set per project type and extend as needed.

`P` **Isolate each change's environment.** Each task should run against its own instance of the app, with its own observability — torn down when done.

> `E` They made the app bootable per git worktree. They wired Chrome DevTools Protocol into the agent runtime (DOM snapshots, screenshots, navigation). Each worktree had an ephemeral observability stack (logs via LogQL, metrics via PromQL, traces via TraceQL). This enabled prompts like "no span in these four user journeys exceeds 2 seconds."

---

## 4. Technology Selection

`P` **Prefer technologies the agent can fully reason about.** "Boring" tech with stable APIs and strong representation in training data is an asset. Opaque upstream behavior is a liability.

`P` **Reimplementing a small subset is sometimes better than depending on a library.** A tight, fully-tested internal implementation the agent can inspect and modify beats working around a black box.

> `E` Rather than using `p-limit`, they implemented their own map-with-concurrency helper — tightly integrated with their OpenTelemetry setup, 100% test coverage, and behaving exactly as their runtime expected.

---

## 5. Entropy Management

`P` **Agents replicate existing patterns — including bad ones.** Without active cleanup, drift is inevitable. Manual cleanup sprints don't scale.

`P` **Pay down technical debt continuously in small increments.** Encode human taste once as "golden principles," then enforce them automatically on a recurring cadence. Daily small fixes beat painful periodic rewrites.

`P` **Catch entropy at the source, not just in the background.** Pre-submission cleanup should be part of the build workflow — before any agent submits work for review, a cleanup step (subagent or skill) simplifies, deduplicates, and aligns the output with project conventions. Background gardening catches drift across many merged changes; inline cleanup prevents individual contributions from introducing it.

> `E` They encoded "golden principles" (e.g., prefer shared packages over hand-rolled helpers; never probe data on guessed shapes) and ran background agents that scanned for violations, updated quality grades, and opened targeted refactoring PRs on a regular cadence. Most were reviewable in under a minute and automerged.

---

## 6. Throughput and Merge Philosophy

`P` **High throughput changes what "responsible" means.** Conventional norms (block on flakes, require human review, long-lived PRs) become counterproductive when agent throughput far exceeds human attention.

`P` **This only works with strong mechanical guardrails.** Fast merging is safe when architecture, linting, and test enforcement are already in place. Without them, it's reckless.

`P` **Working code is the floor, not a ceiling.** All tests must pass at all times. No merging broken code, regardless of throughput. The standard never drops — throughput is achieved by moving fast *above* the quality floor, not by lowering it.

`P` **Review rigor should be graduated by risk.** Not all changes need the same scrutiny. Low-risk changes (cosmetic fixes, minor docs) can move through lightweight review with strong deterministic checks. Critical changes (architecture, security, cross-cutting) warrant full multi-model consensus review. The rigor level is a configurable dimension, not a fixed policy.

---

## 7. The Full Autonomy Loop (Maturity Target)

`P` **The goal is a closed feedback loop where agents can drive work end-to-end.** Build toward agents that can take a prompt from problem to merged fix with human escalation only when judgment is required.

> `E` Their mature loop: validate codebase → reproduce bug → record failure video → implement fix → validate fix → record resolution video → open PR → respond to feedback → remediate build failures → merge. Agents used `gh`, local scripts, and repo-embedded skills directly.

---

## Required Infrastructure (Summary)

| Layer | What it enables |
|---|---|
| Short AGENTS.md + structured `docs/` | Agent context that stays fresh and navigable |
| Rigid layer model + custom linters | Architecture without human policing |
| Per-task app isolation + observability | Agents that can validate their own work |
| Browser/UI automation | Bug reproduction and UI validation |
| Execution plans as versioned artifacts | Long-horizon tasks without losing context |
| Background cleanup agents | Continuous entropy control |

---

## Anti-Patterns

- Monolithic AGENTS.md
- Knowledge outside the repo (Slack, Docs, people's heads)
- Retrying instead of fixing the environment
- Manual cleanup sprints
- Opaque library dependencies when a small reimplementation is clearer
- Deferring architectural constraints until "later"
- Blocking indefinitely on test flakes
