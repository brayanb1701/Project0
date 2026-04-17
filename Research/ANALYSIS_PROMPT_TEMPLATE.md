# Analysis Prompt Template

This document contains the **generic template** for invoking a headless Codex multi-agent analysis session to analyze a project, followed by a **fully worked example** using ypi as the target project.

Each invocation should be run **from inside the project's folder** under `Research/`, where `ANALYSIS_TASK_DETAILS.md` and `RESEARCH_PROJECT_REFERENCE_GUIDE.md` are already present.

---

## Generic Template

Copy the block below, fill in the placeholders, and use it as the `codex exec` prompt.

````text
You are performing a Phase 0 foundation analysis for our Agent Swarm Orchestrator project.

## Reference files (in this folder)

Before doing anything else, read the following two files IN FULL — do not skim, do not read partial sections, do not stop early. Read each file completely from beginning to end so you have the complete picture before proceeding:

1. RESEARCH_PROJECT_REFERENCE_GUIDE.md — describes the system we intend to build and the criteria for judging each project. IMPORTANT: this document represents our initial vision and design direction, not final decisions. The features, architecture, and implementation details listed there are starting points that may change based on what we learn during this research phase. Use it as a reference for what we care about, not as a locked specification.
2. ANALYSIS_TASK_DETAILS.md — defines the decomposition model, child prompt templates, report schema, comparison axes, scaling rules, and acceptance criteria you must follow.

These two files are your primary instructions. Everything below adds project-specific context.

## Target project

- Name: <PROJECT_NAME>
- Upstream URL: <REPO_URL>
- Online docs / llms.txt / blog / spec URLs: <DOCS_URLS or None identified>

## Category

<SOTA Agent Harness | Agent Orchestrator & Harness | OpenClaw Variant (AI Assistant) | Particular Case | Skills/Extensions Reference>

## Project description

<SHORT_DESCRIPTION — what the project is and why we are studying it>

## Mandatory working method

- This task MUST use Codex's built-in multi-agent workflow as described in ANALYSIS_TASK_DETAILS.md. Do not do the entire analysis in a single pass.
- After sizing up the repository, create a task tree and explicitly delegate independent investigation tracks to focused sub-agents.
- Prefer built-in roles as follows:
  - `explorer` for read-heavy source/docs investigation,
  - `default` for fallback or synthesis/cross-check work,
  - `worker` only when a delegated task must produce or update structured artifacts,
  - `monitor` only for long waits or polling if needed.
- Run independent tracks in parallel where sensible.
- The root agent should orchestrate, validate, and synthesize. It should not do most of the substantive exploration itself.
- The final report is incomplete unless it clearly reflects multiple validated sub-agent investigations.
- Follow the Stage 0 → Stage 1 → Stage 2 process from ANALYSIS_TASK_DETAILS.md.
- Follow the scaling rules from ANALYSIS_TASK_DETAILS.md to determine minimum child count after sizing the repo.

## Project-specific focus

<PASTE PROJECT-SPECIFIC QUESTIONS AND FOCUS AREAS HERE — these become the Stage 1.G child investigation(s)>

## Special deliverables

<LIST ANY EXTRA FILES THIS ANALYSIS MUST PRODUCE, e.g.:>
<- '<project>_candidate_skills.md'>
<- '<project>_workflow_reuse_notes.md'>
<Or: None beyond the standard report.>

## Output

- Create a folder called 'output' inside this project folder.
- Write the final report to 'output/report.md'.
- Write any special deliverables as separate files inside 'output/'.
- Place any intermediate files created during exploration and child agent sessions inside 'output/session_artifacts/'.
- Follow the standard final report schema (16 sections) from ANALYSIS_TASK_DETAILS.md.
- Compare findings against the standard comparison axes from ANALYSIS_TASK_DETAILS.md, referencing specific sections of RESEARCH_PROJECT_REFERENCE_GUIDE.md.
- End with an explicit foundation recommendation: base, integration candidate, inspiration, reference, partial reimplementation target, or skip.

## Acceptance criteria

The task is complete only when:
- Recursive decomposition was actually used for multiple focused investigation tracks.
- Source code and online docs were both incorporated where available.
- The project-specific focus questions above were answered.
- The report follows the standard 16-section schema.
- The report is decision-useful for Phase 0 foundation selection.
- Major claims are evidence-backed with file paths, code locations, or docs references.
- Confirmed facts are separated from inferences.
- Reuse / adapt / inspiration / skip recommendations are explicit.
````

---

## Per-Project Specifics

Quick reference for filling the template. Each entry lists the category, description, focus areas, and special deliverables.

### Codex
- **Category**: SOTA Agent Harness
- **URL**: https://github.com/openai/codex
- **Docs**: https://developers.openai.com/codex/llms.txt
- **Focus**: Non-interactive mode capabilities and how to drive it programmatically. Worktree support. Skills/extensions system. Multi-agent features. How it handles parallel sessions.
- **Deliverables**: None beyond the standard report.

### Claude Code
- **Category**: SOTA Agent Harness
- **URL**: https://github.com/anthropics/claude-code
- **Docs**: https://code.claude.com/docs/llms.txt
- **Focus**: Non-interactive mode — check if usable with a subscription plan or requires an API key. Worktree support. Skills/extensions system. Multi-agent features. MCP integration. How it handles parallel sessions.
- **Deliverables**: `claude_code_candidate_skills.md` — a separate file listing skills that might be useful for our project and needs.

### pi-mono
- **Category**: Agent Orchestrator & Harness
- **URL**: https://github.com/badlogic/pi-mono
- **Focus**: Concentrate on `packages/coding-agent`. Understand the Pi philosophy (check Pi-blog.md). Analyze extensibility — can our desired features be added without breaking Pi's core model? How could security be layered on top (currently runs in yolo mode)? Evaluate as a potential base that can self-evolve. Study the `agent-stuff` repo for examples of how extensions and skills are implemented on top of Pi.
- **Deliverables**: None beyond the standard report.

### oh-my-pi
- **Category**: Agent Orchestrator & Harness
- **URL**: https://github.com/can1357/oh-my-pi
- **Focus**: This is Pi with many additions (hash-anchored edits, LSP, browser tool, subagents, etc.). Analyze which changes preserve Pi philosophy and which diverge. Identify which enhancements are strong candidates for adaptation vs which we'd implement differently. Compare directly against pi-mono to map what was added, what was modified, and what was removed.
- **Deliverables**: None beyond the standard report.

### adaf
- **Category**: Agent Orchestrator & Harness
- **URL**: https://github.com/agusx1211/adaf
- **Focus**: Agent profiles/roles and how they are implemented. Workflow loops (plan/implement/review cycles). How collaboration state lives outside the target repository. Session recording and relay handoff mechanisms.
- **Deliverables**: None beyond the standard report.

### hermes-agent
- **Category**: Agent Orchestrator & Harness
- **URL**: https://github.com/NousResearch/hermes-agent
- **Focus**: Distinctive persistent-agent features — what makes this agent unique. Scheduled/background task behavior. Memory and learning patterns. Tinker / RL / SFT workflow integration — how is the framework for running RL and SFT experiments structured? Skill-building and self-improvement mechanisms.
- **Deliverables**: None beyond the standard report.

### codex-autorunner (CAR)
- **Category**: Agent Orchestrator & Harness
- **URL**: https://github.com/Git-on-my-level/codex-autorunner
- **Focus**: The ticket system — dig deep into the ticket/control-plane design. Advantages and limitations of this approach. How tickets flow through the system. How a similar ticket system could be incorporated into our orchestrator. Multi-model support and interface options (Web UI, CLI, chat apps).
- **Deliverables**: None beyond the standard report.

### agent-of-empires
- **Category**: Agent Orchestrator & Harness
- **URL**: https://github.com/njbrake/agent-of-empires
- **Focus**: tmux-based orchestration model — how sessions are managed, spawned, and monitored. Worktree/session isolation mechanisms. Logging and traceability — can full agent trajectories be reconstructed? Docker sandboxing integration. Operational pros and cons of terminal-session-based orchestration.
- **Deliverables**: None beyond the standard report.

### symphony
- **Category**: Particular Case
- **URL**: https://github.com/openai/symphony/tree/main
- **Focus**: Workflow implementation — understand deeply how workflows are defined and executed. Study SPEC.md and its implications for personal implementation. Determine whether the model is project-specific or generalizable across projects. Why Elixir was chosen as the reference implementation language — is there an architectural benefit (functional paradigm, concurrency model, etc.)? How could these workflow patterns be adapted to our orchestrator?
- **Deliverables**: `symphony_workflow_reuse_notes.md` — notes on which workflow patterns and definitions we can adapt.

### openclaw
- **Category**: Particular Case (AI Assistant)
- **URL**: https://github.com/openclaw/openclaw
- **Focus**: Feature inventory — catalog the large number of features. Categorize by priority and usefulness for our future personal-assistant evolution (high / medium / low). Understand the Gateway architecture and Canvas system. This is not a base candidate (codebase is too large), but a reference for long-term direction.
- **Deliverables**: `openclaw_feature_priority_matrix.md` — features categorized by priority for our roadmap.

### agent-stuff
- **Category**: Particular Case (Skills/Extensions Reference)
- **URL**: https://github.com/mitsuhiko/agent-stuff/tree/main
- **Focus**: Inventory all skills and extensions. For each, assess: what it does, how it's implemented, whether it could be useful for our workflows and platform, and how it would need to be adapted. This is not a project to fork — it's a catalog of patterns to study and selectively adopt.
- **Deliverables**: `agent_stuff_reusable_skills_inventory.md` — structured inventory of skills/extensions with reuse recommendations.

### ypi
- **Category**: Particular Case (RLM Reference)
- **URL**: https://github.com/rawwerks/ypi
- **Focus**: How ypi builds on Pi agent — which parts of Pi does it use, modify, or bypass? Does it respect Pi's philosophy or diverge? Detail the recursive implementation: how are rlm_query calls structured, what controls recursion depth/width, how is context managed across recursive levels? Compare the implementation against the original RLM paper to identify any relevant differences in approach.
- **Deliverables**: None beyond the standard report.

### opencode
- **Category**: SOTA Agent Harness
- **URL**: https://github.com/anomalyco/opencode
- **Docs**: https://opencode.ai/docs
- **Focus**: Client/server architecture — how does headless operation work, what is the server API, and how can multiple clients connect? Provider-agnostic model access — how is the abstraction layer structured? Agent system — how do build/plan agents work, what is the @general subagent mechanism? Skills/extensions/plugins system — how are they defined, loaded, and managed? SDK and plugin architecture — how extensible is the system programmatically? MCP and ACP support — what protocols are supported and how? LSP integration — how is it implemented? CLI non-interactive mode — how can it be driven programmatically? Permissions model — how are tool access and filesystem scope controlled? Evaluate as a potential base or integration candidate.
- **Deliverables**: None beyond the standard report.

---

## Worked Example: ypi

This is the complete, ready-to-use prompt for analyzing ypi with a headless Codex multi-agent run. Run from inside `Research/ypi/`.

````text
You are performing a Phase 0 foundation analysis for our Agent Swarm Orchestrator project.

## Reference files (in this folder)

Before doing anything else, read the following two files IN FULL — do not skim, do not read partial sections, do not stop early. Read each file completely from beginning to end so you have the complete picture before proceeding:

1. RESEARCH_PROJECT_REFERENCE_GUIDE.md — describes the system we intend to build and the criteria for judging each project. IMPORTANT: this document represents our initial vision and design direction, not final decisions. The features, architecture, and implementation details listed there are starting points that may change based on what we learn during this research phase. Use it as a reference for what we care about, not as a locked specification.
2. ANALYSIS_TASK_DETAILS.md — defines the decomposition model, child prompt templates, report schema, comparison axes, scaling rules, and acceptance criteria you must follow.

These two files are your primary instructions. Everything below adds project-specific context.

## Target project

- Name: ypi
- Upstream URL: https://github.com/rawwerks/ypi
- Online docs / llms.txt / blog / spec URLs: None identified. Check the repo for any README, docs, or blog links during Stage 0 sizing.

## Category

Particular Case (RLM Reference)

## Project description

ypi is a recursive coding agent built on Pi (pi-agent/pi-mono), based on Recursive Language Models (RLMs). It extends Pi with recursive decomposition capabilities, allowing tasks to be broken into sub-investigations that are delegated to child agent sessions. We are studying it to understand how recursive agent patterns work in practice, how it integrates with the Pi ecosystem, and whether its RLM implementation matches or improves on the original paper's approach.

## Mandatory working method

- This task MUST use Codex's built-in multi-agent workflow as described in ANALYSIS_TASK_DETAILS.md. Do not do the entire analysis in a single pass.
- After sizing up the repository, create a task tree and explicitly delegate independent investigation tracks to focused sub-agents.
- Prefer built-in roles as follows:
  - `explorer` for read-heavy source/docs investigation,
  - `default` for fallback or synthesis/cross-check work,
  - `worker` only when a delegated task must produce or update structured artifacts,
  - `monitor` only for long waits or polling if needed.
- Run independent tracks in parallel where sensible.
- The root agent should orchestrate, validate, and synthesize. It should not do most of the substantive exploration itself.
- The final report is incomplete unless it clearly reflects multiple validated sub-agent investigations.
- Follow the Stage 0 → Stage 1 → Stage 2 process from ANALYSIS_TASK_DETAILS.md.
- Follow the scaling rules from ANALYSIS_TASK_DETAILS.md to determine minimum child count after sizing the repo.

## Project-specific focus

This is the most important investigation track for this project. Dedicate one or more child agents to these questions:

1. Relationship to Pi: Which parts of Pi does ypi use, modify, or bypass? Is ypi a thin wrapper around Pi, a fork with deep modifications, or something else? Map the dependency precisely.

2. Philosophy preservation: Does ypi respect Pi's core philosophy (code that builds itself, extensibility, simplicity)? Where does it diverge, and are those divergences improvements or trade-offs?

3. RLM implementation details: How are 'rlm_query' calls structured? What controls recursion depth and width? How is context managed across recursive levels (does the parent summarize child results, pass raw output, or use some other compaction strategy)? How does the agent decide when to recurse vs handle directly?

4. Comparison to original RLM paper: Compare ypi's recursive implementation against the approach described in the RLM paper (https://raw.works/recursive-language-models-as-memory-systems/). Identify any relevant differences in: recursion structure, context management, termination conditions, quality of decomposition, or parameter tuning.

5. Practical observations: What are the strengths and weaknesses of ypi's approach when used for real tasks? Any evidence of failure modes (infinite recursion, context loss, shallow decomposition)?

## Special deliverables

None beyond the standard report.

## Output

- Create a folder called 'output' inside this project folder.
- Write the final report to 'output/report.md'.
- Place any intermediate files created during exploration and child agent sessions inside 'output/session_artifacts/'.
- Follow the standard final report schema (16 sections) from ANALYSIS_TASK_DETAILS.md.
- Compare findings against the standard comparison axes from ANALYSIS_TASK_DETAILS.md, referencing specific sections of RESEARCH_PROJECT_REFERENCE_GUIDE.md.
- End with an explicit foundation recommendation: base, integration candidate, inspiration, reference, partial reimplementation target, or skip.

## Acceptance criteria

The task is complete only when:
- Recursive decomposition was actually used for multiple focused investigation tracks.
- Source code and online docs were both incorporated where available.
- All five project-specific focus questions above were answered with evidence.
- The report follows the standard 16-section schema.
- The report is decision-useful for Phase 0 foundation selection.
- Major claims are evidence-backed with file paths, code locations, or docs references.
- Confirmed facts are separated from inferences.
- Reuse / adapt / inspiration / skip recommendations are explicit.
````
