# Recursive Project Analysis Prompting Guide

## Purpose

This document explains how to prompt **ypi** (or another recursive analysis agent built on the same pattern) so that recursion is **actually used**, not merely available.

It is specifically designed for the project-analysis workflow described in:

- `Projects_to_analyze.md`
- `ORCHESTRATOR_PLANNING_PROMPT.md`

The goal is to ensure that each project analysis is:

1. **deep enough** to be useful for Phase 0 foundation research,
2. **broad enough** to cover the checklist and project-specific focus areas,
3. **evidence-based** across code + docs + tests + online docs,
4. **explicitly decomposed** into recursive sub-investigations,
5. **synthesized** into a final report that can feed the foundation-selection step.

---

## Why a normal prompt does *not* reliably trigger recursion

ypi is designed to recurse **when the task is too large for one context window**, not just because recursion exists.

That means prompts like:

- “Summarize the architecture of this repo”
- “Analyze this project thoroughly”
- “Give me a complete report”

are **not enough** to guarantee recursive decomposition.

Why?

1. **The agent may decide the task is manageable directly** after reading the README and a few central files.
2. **Architecture may appear centralized**, so the agent may choose shell inspection instead of sub-agents.
3. **The prompt may ask for completeness without forcing a task tree**, so the model still treats it as a single investigation.
4. **No explicit acceptance criteria for recursion** means the agent can satisfy the wording without delegating.
5. **No separate deliverables per investigation axis** means sub-agents are optional rather than necessary.

If recursion is required, the prompt must make the task structurally impossible to satisfy well without decomposition.

---

## Core principle

Do **not** merely say “use recursion.”

Instead, make the prompt require:

- **multiple independent investigation tracks**,
- **parallel evidence gathering**,
- **explicit sub-agent outputs**,
- **validation and synthesis**,
- **coverage of both code and online docs**,
- **project-specific focus sections**,
- **a final structured report plus any extra artifacts**.

The root agent should act primarily as:

1. **planner**,
2. **dispatcher**,
3. **validator**,
4. **synthesizer**.

It should **not** behave as the sole analyst except for a small repo.

---

## Non-negotiable instructions that should appear in the prompt

When prompting ypi for these analyses, include all of the following constraints.

### 1. State that recursive decomposition is mandatory

Use explicit wording such as:

> This task must be completed using recursive decomposition. Do not do the entire analysis in a single pass. After sizing up the repo, create a task tree and delegate independent investigation tracks to sub-agents using `rlm_query`. Use `--async` where possible.

### 2. Make the root agent responsible for orchestration, not full manual reading

Use wording such as:

> The root agent should only inspect enough material to plan, dispatch, validate, and synthesize. Most substantive investigation must be delegated to focused child agents.

### 3. Require multiple investigation tracks

At minimum, require separate child investigations for:

1. docs / README / `llms.txt` / external docs,
2. runtime architecture and module structure,
3. model/provider access and invocation API,
4. security/isolation/tool restrictions,
5. orchestration / workflow / agent roles,
6. tests / maintenance / maturity,
7. project-specific focus areas,
8. final synthesis against our orchestrator goals.

### 4. Require online docs when available

Use wording such as:

> If a docs URL or `llms.txt` URL is provided, it must be fetched and incorporated. Source code alone is not sufficient.

### 5. Require evidence and citations

Use wording such as:

> Every major claim must cite concrete evidence: file paths, relevant sections, tests, docs URLs, or command observations. Distinguish “confirmed by source/docs” from “inferred.”

### 6. Require validation of child outputs

Use wording such as:

> The root agent must validate child findings against the repository before finalizing the report. Do not blindly merge sub-agent output.

### 7. Require a structured final deliverable

Use wording such as:

> The final output is not just a narrative summary. It must follow the standardized report schema defined in this prompt.

---

## Recommended decomposition model for project analysis

For the projects in `Projects_to_analyze.md`, use this default task tree.

## Stage 0 — Sizing and planning

The root agent should:

1. size up the repo,
2. identify major directories/subsystems,
3. note docs URLs / `llms.txt` / blog/spec links,
4. decide the minimum number of child investigations,
5. launch sub-agents.

This stage should be quick.

---

## Stage 1 — Mandatory child investigations

Create at least these focused sub-agents.

### A. External docs / public-facing behavior
Scope:
- README
- docs site
- `llms.txt`
- blog/spec pages
- installation / CLI usage docs

Output:
- what the project claims to do,
- non-interactive/programmatic capabilities,
- model access expectations,
- documented workflows,
- any discrepancies to verify in source.

### B. Internal architecture / module boundaries
Scope:
- top-level structure,
- main packages/modules,
- entrypoints,
- data/control flow,
- extension/plugin systems.

Output:
- architecture map,
- main modules and responsibilities,
- how the system is composed,
- where to study further.

### C. Provider/model invocation layer
Scope:
- API clients,
- provider abstraction,
- auth configuration,
- model-specific features,
- streaming / tool use / MCP / thinking support.

Output:
- how the project talks to models,
- invocation style,
- provider-specific capabilities,
- integration implications for our orchestrator.

### D. Security / isolation / execution controls
Scope:
- worktrees,
- sandboxes,
- Docker/containers,
- filesystem scoping,
- tool allowlists,
- policy enforcement,
- privilege separation.

Output:
- current safety model,
- gaps and trade-offs,
- what would need to be added or hardened.

### E. Orchestration / multi-agent / workflow logic
Scope:
- task decomposition,
- agent roles,
- workflow definitions,
- message passing,
- coordination storage,
- queue/ticket/worktree/session handling.

Output:
- how agents are organized,
- how they coordinate,
- what is centralized vs distributed,
- what maps well to our desired system.

### F. Tests / maintenance / maturity
Scope:
- tests,
- CI,
- release process,
- docs quality,
- code quality indicators,
- community/maintenance signs.

Output:
- maturity assessment,
- confidence level,
- practical reuse risk.

### G. Project-specific focus investigation(s)
Use one or more child agents dedicated to the specific questions from `Projects_to_analyze.md`.

Examples:
- Claude Code: subscription vs API key, MCP, skills/extensions, useful skills list
- Codex: non-interactive mode, worktree support, programmatic driving
- Pi: philosophy, extensibility, preserving core ideas, security additions needed
- oh-my-pi: which enhancements fit Pi philosophy vs diverge from it
- adaf: agent profiles/roles and loop implementation
- Hermes: unique persistent-agent capabilities, Tinker/RL/SFT integration
- CAR: ticket system advantages/limits and how to adapt it
- Agent of Empires: tmux orchestration advantages/disadvantages
- Symphony: workflow implementation, SPEC.md implications, project-vs-general workflow model
- OpenClaw: high-value features to categorize by priority and future usefulness
- agent-stuff: useful skills/extensions to extract
- ypi: relationship to Pi, fidelity to Pi philosophy, differences from original RLM implementation

---

## Stage 2 — Synthesis

After child reports return, the root agent should produce a synthesis that answers:

1. What is this project *really* optimized for?
2. Which components are reusable as-is?
3. Which are adaptable with moderate effort?
4. Which are inspiration only?
5. Which conflict with our orchestrator goals?
6. What are the most important implementation ideas to carry forward?
7. What open questions remain after analysis?

---

## Scaling rules: how many sub-agents to require

To ensure recursion is used consistently, the prompt should include a **minimum decomposition rule**.

Use this guidance.

### Small repo (< 100 files, few subsystems)
Require at least:
- **3 child investigations**
- plus final synthesis

### Medium repo (100–500 files or several subsystems)
Require at least:
- **5 child investigations**
- preferably parallel via `rlm_query --async`
- plus final synthesis

### Large repo (> 500 files, many packages, or multiple apps/services)
Require at least:
- **7 child investigations**
- plus **extra subsystem-specific children** for the largest areas
- plus final synthesis

### Very large / sprawling repo
Require:
- the standard thematic children,
- plus **one child per major subsystem**,
- plus a **cross-check child** for contradictions or missing areas.

For the projects in `Projects_to_analyze.md`, assume **medium or large by default** unless proven otherwise.

---

## What to say in the prompt to force good decomposition

Use language like this:

> You must use recursion as a first-class method, not as a fallback. After an initial size-up, decompose the work into focused child investigations. The final answer will be considered incomplete unless it clearly reflects multiple validated sub-agent investigations.

> Do not let one child summarize the whole repo. Each child must have a narrow scope and return structured findings with evidence.

> Use `rlm_query --async` for independent tracks so investigation happens in parallel. Use synchronous sub-calls only when one result is needed to decide the next step.

> If the repo is large, spawn additional children for major subsystems instead of reading everything in the root context.

> The root agent should synthesize and compare, not monopolize the exploration.

---

## What *not* to do in the prompt

Avoid prompts like:

- “Analyze this project completely.”
- “Give me a thorough summary.”
- “Use recursion if helpful.”
- “Look at the repo and docs and tell me what matters.”

These leave decomposition optional.

Also avoid this mistake:

- assigning one child the entire job.

That technically uses recursion once, but does **not** create a recursive exploration tree.

---

## Standard final report schema

Require every project analysis to produce the following sections.

1. **Executive summary**
2. **What the project is optimized for**
3. **Architecture overview**
4. **Access to models/providers**
5. **API structure / invocation method**
6. **Security and isolation**
7. **Agent types and orchestration**
8. **Features aligned with our goals**
9. **Interesting unrelated features**
10. **Project-specific focus findings**
11. **Limitations and trade-offs**
12. **Maintenance and engineering practices**
13. **What to reuse vs adapt vs only take inspiration from**
14. **Key code / docs to study next**
15. **Open questions**
16. **Confidence and evidence notes**

The prompt should also require:

- distinction between **confirmed** vs **inferred** claims,
- references to **source files**, **tests**, and **external docs**,
- comparison against our goals from `ORCHESTRATOR_PLANNING_PROMPT.md`.

---

## Standard comparison axes against our orchestrator plan

Tell the agent to explicitly compare findings against these areas from `ORCHESTRATOR_PLANNING_PROMPT.md`:

- Section 2 — architecture decisions / base selection implications
- Section 3 — core components
- Section 4 — security model
- Section 5 — monitoring/logging/data collection
- Section 6 — git/worktree strategy
- Section 7 — reuse vs build guidance
- Section 9 — plugin/skill system, state persistence, testing, observability, notifications
- Section 12 — Phase 0 foundation research needs

This avoids reports that are “interesting” but not decision-useful.

---

## Prompt template for the root invocation

Use this as the base prompt for each project analysis.

```text
You are performing a Phase 0 foundation analysis for our orchestrator project.

Target project:
- Name: <PROJECT_NAME>
- Local repo path: <LOCAL_PATH>
- Upstream URL: <REPO_URL>
- Online docs / llms.txt / blog / spec URLs: <URLS>

Primary objective:
Produce a structured report that evaluates this project against the goals and design requirements in ORCHESTRATOR_PLANNING_PROMPT.md, using the checklist and project-specific focus areas from Projects_to_analyze.md.

Mandatory working method:
- This task must use recursive decomposition. Do not do the entire analysis in a single pass.
- First size up the repository and identify major subsystems, docs, tests, and any online sources.
- Then create a task tree and delegate independent investigation tracks to focused sub-agents using rlm_query.
- Use rlm_query --async for independent tracks whenever possible.
- The root agent should orchestrate, validate, and synthesize. It should not do most of the substantive exploration itself.
- The final report is incomplete unless it clearly reflects multiple validated sub-agent investigations.

Minimum decomposition requirements:
- Spawn separate child investigations for:
  1. external docs / llms.txt / public docs,
  2. internal architecture and module structure,
  3. model/provider access and invocation API,
  4. security / isolation / execution controls,
  5. orchestration / workflow / agent roles,
  6. tests / CI / maintenance / maturity,
  7. project-specific focus areas.
- If the repo is large or has many top-level subsystems, spawn additional children for the biggest subsystems.
- Do not assign one child to summarize the entire project.

Evidence requirements:
- Use both source code and online docs where available.
- Every major claim must be backed by evidence: file paths, code locations, tests, docs sections, or observed commands.
- Distinguish clearly between confirmed facts and inferences.
- Validate child outputs before merging them into the final report.

Required output sections:
1. Executive summary
2. What the project is optimized for
3. Architecture overview
4. Access to models/providers
5. API structure / invocation method
6. Security and isolation
7. Agent types and orchestration
8. Features aligned with our goals
9. Interesting unrelated features
10. Project-specific focus findings
11. Limitations and trade-offs
12. Maintenance and engineering practices
13. What to reuse vs adapt vs only take inspiration from
14. Key code / docs to study next
15. Open questions
16. Confidence and evidence notes

Comparison requirements:
- Compare findings explicitly against relevant sections of ORCHESTRATOR_PLANNING_PROMPT.md, especially Sections 2, 3, 4, 5, 6, 7, 9, and 12.
- The report should help us decide whether this project is best used as: foundation, integration source, design inspiration, or skip.

Project-specific focus:
<PASTE THE RELEVANT PROJECT ENTRY / QUESTIONS FROM Projects_to_analyze.md HERE>

Special deliverables:
<ADD ANY EXTRA FILES OR OUTPUTS REQUIRED FOR THIS PROJECT>
```

---

## Template for child prompts

The parent should give each child a **narrow mission**. Use prompts like these.

### Child template: docs / public behavior

```text
Analyze only the external docs and publicly documented behavior of <PROJECT_NAME>.
Focus on README, docs site, llms.txt, blog/spec pages, and documented CLI/API usage.
Return a structured note with:
- documented purpose,
- documented model/provider access,
- documented non-interactive/programmatic behavior,
- documented extension/plugin/workflow capabilities,
- important claims that need verification in source,
- evidence references.
Do not summarize the entire project.
```

### Child template: internal architecture

```text
Analyze only the internal architecture of <PROJECT_NAME> from source layout and key entrypoints.
Focus on modules, packages, control flow, extension points, and subsystem boundaries.
Return:
- architecture map,
- main modules and responsibilities,
- how data/control moves through the system,
- key files worth studying,
- evidence references.
Do not cover providers/security unless directly necessary.
```

### Child template: security / isolation

```text
Analyze only the security, isolation, and execution-control model of <PROJECT_NAME>.
Focus on sandboxes, worktrees, tool restrictions, filesystem isolation, containerization, and safety trade-offs.
Return:
- current security model,
- isolation mechanisms,
- gaps/risks,
- what would need to change for our orchestrator goals,
- evidence references.
```

### Child template: orchestration / agent roles

```text
Analyze only the orchestration model of <PROJECT_NAME>.
Focus on agent roles, task decomposition, workflow definitions, communication patterns, coordination storage, and lifecycle management.
Return:
- agent/orchestration model,
- coordination mechanisms,
- strengths,
- limitations,
- adaptation ideas for our orchestrator,
- evidence references.
```

### Child template: maintenance / maturity

```text
Analyze only the maintenance and maturity profile of <PROJECT_NAME>.
Focus on tests, CI, release process, docs quality, repo hygiene, update cadence, and practical reuse confidence.
Return:
- maturity assessment,
- quality signals,
- risk signals,
- what this means for reuse/adaptation,
- evidence references.
```

---

## Project-specific additions to include in the prompt

When constructing the root prompt, append the relevant custom focus block.

## Codex
Emphasize:
- non-interactive mode,
- worktree support,
- skills/extensions system,
- multi-agent features,
- programmatic drivability.

## Claude Code
Emphasize:
- non-interactive mode,
- whether subscription access works or API key is required,
- worktree support,
- skills/extensions,
- multi-agent features,
- MCP integration.

Also require:
- **a separate file listing potentially useful skills for our project**.

## pi-mono
Emphasize:
- `packages/coding-agent`,
- philosophy and extensibility,
- whether desired features can be added without breaking Pi’s core model,
- how security could be layered on.

## oh-my-pi
Emphasize:
- what it adds over Pi,
- which changes preserve Pi philosophy,
- which diverge,
- which ideas are strong candidates for adaptation.

## adaf
Emphasize:
- loops,
- profiles/roles,
- how these are implemented,
- how collaboration state lives outside the target repo.

## Hermes
Emphasize:
- distinctive persistent-agent features,
- scheduled/background behavior,
- memory/learning patterns,
- Tinker / RL / SFT workflow integration.

## CAR (codex-autorunner)
Emphasize:
- ticket/control-plane design,
- advantages,
- limitations,
- how a similar ticket system could fit our orchestrator.

## Agent of Empires
Emphasize:
- tmux-based orchestration,
- worktree/session isolation,
- logging/traceability trade-offs,
- operational pros/cons of terminal-session-based orchestration.

## Symphony
Emphasize:
- workflow implementation,
- `SPEC.md` and workflow-definition implications,
- whether the model is project-specific or generalizable,
- why Elixir was used and whether that choice has architectural benefits.

## OpenClaw
Emphasize:
- large-feature inventory,
- which capabilities are most valuable for future personal-assistant evolution,
- which should be high/medium/low priority for us.

## agent-stuff
Emphasize:
- skills and extensions worth reusing,
- how they could fit our workflows and platform.

## ypi
Emphasize:
- how it builds on Pi,
- whether it preserves Pi philosophy,
- implementation details,
- differences from the original RLM paper approach.

---

## Extra artifact rules

If a project requires extra deliverables, say so explicitly in the prompt.

Examples:

- Claude Code:
  - `claude_code_candidate_skills.md`
- agent-stuff:
  - `agent_stuff_reusable_skills_inventory.md`
- OpenClaw:
  - `openclaw_feature_priority_matrix.md`
- Symphony:
  - `symphony_workflow_reuse_notes.md`

Do not assume the agent will infer extra outputs unless they are stated.

---

## Recommended acceptance criteria to include

Add a completion block like this to the prompt:

```text
The task is complete only when:
- recursion was actually used for multiple focused investigation tracks,
- source code and online docs were both incorporated where available,
- project-specific questions from Projects_to_analyze.md were answered,
- the report is decision-useful for Phase 0 foundation selection,
- major claims are evidence-backed,
- confirmed facts are separated from inferences,
- reuse/adapt/inspiration/skip recommendations are explicit.
```

This is important: if you do not define completion this way, the agent may stop after producing a plausible but under-decomposed summary.

---

## Short “good prompt” example

```text
Analyze Research/ypi for our Phase 0 foundation research.
This task must use recursive decomposition. After sizing up the repo and docs, spawn focused child investigations for docs/public behavior, internal architecture, provider/invocation model, security/isolation, orchestration logic, tests/maturity, and the project-specific question of how ypi differs from Pi and from the original RLM paper approach. Use rlm_query --async for independent tracks. The root agent should orchestrate and synthesize, not do most of the substantive exploration itself. Every major claim must cite evidence from files, tests, or docs. Produce the standard project report and explicitly state what we should reuse, adapt, treat as inspiration, or reject.
```

---

## Final rule of thumb

If the prompt could be satisfied by:

- reading the README,
- opening a few central files,
- and writing one long summary,

then the prompt is **not yet strong enough** to force recursion.

A good prompt makes the task naturally require:

- **parallel exploration**,
- **specialized sub-analysis**,
- **validation**,
- **synthesis**.

That is the difference between “recursion is available” and “recursion is actually used.”
