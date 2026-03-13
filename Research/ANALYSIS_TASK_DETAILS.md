# Analysis Task Details

This file defines the **methodology, decomposition model, report schema, child prompt templates, and acceptance criteria** for every project analysis in this research phase. It is project-agnostic — project-specific focus areas and questions are provided separately in each analysis prompt.

The companion file `RESEARCH_PROJECT_REFERENCE_GUIDE.md` (present in this folder) describes **what we are building** and **what to evaluate against**. This file describes **how to conduct the analysis**.

---

## 1. Recommended Decomposition Model

Every project analysis follows three stages.

### Stage 0 — Sizing and planning

The root agent should:

1. Size up the repo (file count, directory structure, major subsystems).
2. Identify docs URLs, `llms.txt`, blog/spec links, README.
3. Decide the minimum number of child investigations based on repo size (see scaling rules below).
4. Launch sub-agents.

This stage should be quick — it is planning, not analysis.

### Stage 1 — Mandatory child investigations

Create at least these focused sub-agents. Each child has a **narrow scope** and must return **structured findings with evidence**.

#### A. External docs / public-facing behavior
Scope: README, docs site, `llms.txt`, blog/spec pages, installation/CLI usage docs.

Output:
- What the project claims to do.
- Non-interactive/programmatic capabilities.
- Model access expectations.
- Documented workflows.
- Discrepancies to verify in source.

#### B. Internal architecture / module boundaries
Scope: Top-level structure, main packages/modules, entrypoints, data/control flow, extension/plugin systems.

Output:
- Architecture map.
- Main modules and responsibilities.
- How the system is composed.
- Key files worth studying further.

#### C. Provider/model invocation layer
Scope: API clients, provider abstraction, auth configuration, model-specific features, streaming/tool use/MCP/thinking support.

Output:
- How the project talks to models.
- Invocation style (OpenAI-style, Anthropic-style, unified, etc.).
- Provider-specific capabilities.
- Integration implications for our orchestrator.

#### D. Security / isolation / execution controls
Scope: Worktrees, sandboxes, Docker/containers, filesystem scoping, tool allowlists, policy enforcement, privilege separation.

Output:
- Current safety model.
- Gaps and trade-offs.
- What would need to be added or hardened for our goals.

#### E. Orchestration / multi-agent / workflow logic
Scope: Task decomposition, agent roles, workflow definitions, message passing, coordination storage, queue/ticket/worktree/session handling.

Output:
- How agents are organized.
- How they coordinate.
- What is centralized vs distributed.
- What maps well to our desired system.

#### F. Tests / maintenance / maturity
Scope: Tests, CI, release process, docs quality, code quality indicators, community/maintenance signals.

Output:
- Maturity assessment.
- Confidence level for reuse.
- Practical reuse risk.

#### G. Project-specific focus investigation(s)
Use one or more child agents dedicated to the specific questions provided in the analysis prompt. These vary per project.

### Stage 2 — Synthesis

After child reports return, the root agent must validate child findings against the repository, then produce a synthesis that answers:

1. What is this project *really* optimized for?
2. Which components are reusable as-is?
3. Which are adaptable with moderate effort?
4. Which are inspiration only?
5. Which conflict with our orchestrator goals?
6. What are the most important implementation ideas to carry forward?
7. What open questions remain after analysis?

---

## 2. Scaling Rules — Minimum Sub-Agent Count

To ensure recursive decomposition is actually used, the prompt must enforce minimum child counts based on repo size.

### Small repo (< 100 files, few subsystems)
- At least **3 child investigations** + final synthesis.

### Medium repo (100-500 files or several subsystems)
- At least **5 child investigations**, preferably parallel via the Agent tool with `run_in_background: true`.
- Plus final synthesis.

### Large repo (> 500 files, many packages, or multiple apps/services)
- At least **7 child investigations**.
- Plus **extra subsystem-specific children** for the largest areas.
- Plus final synthesis.

### Very large / sprawling repo
- The standard thematic children.
- Plus **one child per major subsystem**.
- Plus a **cross-check child** for contradictions or missing coverage.

**Default assumption**: Treat projects as medium or large unless proven otherwise after sizing.

---

## 3. Standard Final Report Schema

Every project analysis must produce these sections:

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

Additional requirements:
- Distinguish between **confirmed** (backed by source/docs) vs **inferred** claims.
- Reference **source files**, **tests**, and **external docs** as evidence.
- Compare findings against our goals from `RESEARCH_PROJECT_REFERENCE_GUIDE.md`.

---

## 4. Standard Comparison Axes

The analysis must explicitly compare findings against these areas from `RESEARCH_PROJECT_REFERENCE_GUIDE.md`:

- **Section 4** — Architecture decisions / base selection implications (language, structure, invocation strategy, centralization model).
- **Section 5** — Core capabilities (runtime manager, orchestrator, workflow engine, review system, communication, task management).
- **Section 6** — Security model (role separation, filesystem isolation, tool gating).
- **Section 7** — Monitoring, logging, and data collection.
- **Section 8** — Git and version control strategy.
- **Section 9** — Reuse and research philosophy (reuse vs reimplement decisions).
- **Section 10** — Experimentation requirements.
- **Section 11** — Additional system requirements (fault tolerance, config, plugins, testing, observability).
- **Section 17** — Phased roadmap (which phase does this project help with?).

This prevents reports that are "interesting" but not decision-useful.

---

## 5. Child Prompt Templates

The parent agent should give each child a **narrow mission**. Use these templates as starting points.

### Child: docs / public behavior

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

### Child: internal architecture

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

### Child: provider / invocation layer

```text
Analyze only the model/provider access layer of <PROJECT_NAME>.
Focus on API clients, provider abstraction, auth config, model-specific features (streaming, tool use, thinking modes, MCP).
Return:
- how the project connects to models,
- invocation style and abstraction level,
- provider-specific capabilities supported,
- integration implications for our orchestrator,
- evidence references.
```

### Child: security / isolation

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

### Child: orchestration / agent roles

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

### Child: maintenance / maturity

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

## 6. Evidence Requirements

- Use **both source code and online docs** where available.
- Every major claim must be backed by evidence: file paths, code locations, tests, docs sections, or observed commands.
- **Distinguish clearly** between confirmed facts and inferences.
- The root agent must **validate child outputs** against the repository before merging them into the final report. Do not blindly merge sub-agent output.

---

## 7. Acceptance Criteria

The analysis is complete only when:

- Recursive decomposition was actually used for multiple focused investigation tracks.
- Source code and online docs were both incorporated where available.
- Project-specific questions (from the analysis prompt) were answered.
- The report follows the standard schema (Section 3 above).
- The report is decision-useful for Phase 0 foundation selection.
- Major claims are evidence-backed.
- Confirmed facts are separated from inferences.
- Reuse/adapt/inspiration/skip recommendations are explicit.
- Findings are compared against `RESEARCH_PROJECT_REFERENCE_GUIDE.md`.

---

## 8. Extra Artifact Rules

If a project requires extra deliverables (e.g., a skills inventory, a feature priority matrix, workflow reuse notes), these must be **stated explicitly in the analysis prompt**. Do not assume the agent will infer extra outputs.
