---
title: "Anthropic's Internal Skill Design Lessons"
source: "Skills_Use_Anthropic_engineer.md"
source_type: article
tags: [agent-design, tool-use, prompt-engineering, documentation, patterns, principles]
domain: software-engineering
extracted: "2026-04-09"
summary: "Anthropic's lessons from heavy internal Claude Code skill usage: treat skills as scoped folders with code/config/hooks, design them around high-signal non-obvious guidance, and distribute them with care as org scale changes."
key_concepts: [skill-categories, gotchas, progressive-disclosure, setup-and-config, memory-and-scripts, distribution]
applicability: bounded
preset: prescriptive
---

**Schema:** Core
**Legend:** `K` = Key Claim · `S` = Support · `X` = Scope / Qualifier · `E` = Evidence / Example · `A` = Agent-Specific
**Preset:** Prescriptive

---

## Skill Model

`K` **Skills are folders, not just markdown.** A skill can include scripts, assets, data, examples, and config that the agent can inspect and use.

`K` **Claude Code skills have meaningful runtime surface area.** Frontmatter/config can define behavior beyond text, including dynamic hooks.

`S` The most effective skills use folder structure + config creatively, not just prose instructions.

`X` These lessons are from heavy Anthropic internal use of Claude Code skills; they are practical heuristics, not a formal taxonomy.

---

## Skill Categories

`K` **Useful skill inventories cluster into recurring types.** Strong skills fit one category cleanly; confusing skills often span several.

| Category | Purpose | Compressed examples |
|---|---|---|
| Library & API Reference | Teach correct use of a library/CLI/SDK, including gotchas and snippets | internal billing lib, internal platform CLI, design system |
| Product Verification | Verify behavior with tools/scripts; often browser or TTY driven | signup flow driver, checkout verifier, `tmux` CLI driver |
| Data Fetching & Analysis | Connect agents to data/monitoring stacks and known workflows | funnel query, cohort compare, Grafana lookup |
| Business Process & Team Automation | Automate repetitive org workflows into one command | standup post, ticket creation, weekly recap |
| Code Scaffolding & Templates | Generate codebase-specific boilerplate with natural-language constraints | new workflow/service, new migration, create app |
| Code Quality & Review | Enforce review/testing/style practices; can run deterministically or via hooks | adversarial review, code style, testing practices |
| CI/CD & Deployment | Help fetch, ship, deploy, and babysit changes | babysit PR, deploy service, cherry-pick to prod |
| Runbooks | Map symptoms to tools and produce structured investigations | service debugging, oncall runner, log correlator |
| Infrastructure Operations | Perform operational maintenance with guardrails around destructive steps | orphan cleanup, dependency management, cost investigation |

`E` Anthropic reports hundreds of skills in active internal use.

---

## High-Signal Authoring Rules

`K` **Do not waste tokens stating the obvious.** Focus knowledge skills on information that shifts the model away from default coding priors or generic codebase knowledge.

`E` The cited `frontend-design` skill improved Claude's design taste by encoding specific preferences and anti-defaults.

`K` **The Gotchas section is the highest-signal part of a skill.** Build it from repeated model failure points and keep updating it over time.

`K` **Use the filesystem for progressive disclosure.** Put detailed references, examples, templates, scripts, and assets in separate files/folders so the agent can load them only when needed.

`E` Good patterns: `references/api.md` for signatures/examples, `assets/` templates for final markdown outputs.

`K` **Avoid railroading.** Give enough structure to guide the agent, but not so much specificity that the skill becomes brittle across tasks.

`A` Skill text should encode the non-obvious local deltas from baseline model competence; verbose generic advice dilutes trigger quality and context efficiency.

---

## Setup, Triggering, and Metadata

`K` **Some skills need explicit setup state.** If a workflow depends on user/org-specific context, store it in a local config file and ask only when missing.

`E` Example pattern: `config.json` inside the skill for values like target Slack channel.

`K` **Structured question-asking should be explicit.** If the skill expects multiple-choice user setup, instruct the agent to use the dedicated question tool.

`K` **The description field is a trigger description for the model, not a user-facing summary.** It should maximize retrieval: when should the model invoke this skill?

`A` Bad descriptions reduce discoverability because the model scans descriptions to decide whether a matching skill exists for the current request.

---

## Memory, Scripts, and Hooks

`K` **Skills can carry memory by storing prior outputs/state.** Append-only logs, JSON, or SQLite can help the agent stay consistent across repeated runs.

`E` Example: a `standup-post` skill can keep `standups.log` so the next run computes deltas from prior posts.

`X` Skill-directory data may be deleted on skill upgrade; stable long-lived data should live in `${CLAUDE_PLUGIN_DATA}`.

`K` **Code is one of the strongest skill assets.** Scripts/libraries let the model compose existing functionality instead of regenerating boilerplate every run.

`S` This shifts model effort from reconstruction to orchestration and higher-level analysis.

`K` **On-demand hooks are useful for opinionated temporary guardrails.** Activate them only when the skill is called, for the current session.

`E` Examples: `/careful` blocks destructive shell/database actions; `/freeze` blocks edits outside an allowed directory.

`A` Scripts and hooks are leverage multipliers: they turn skills from static instruction blocks into reusable operational tools.

---

## Distribution Strategy

`K` **There are two main sharing models.** Check skills into repos for simple team use, or distribute them via plugins/marketplaces for broader optional install.

`X` Repo-local skills work well for smaller teams with fewer repos, but every checked-in skill adds some model context overhead.

`K` **As scale increases, a marketplace model becomes more attractive.** It centralizes distribution while letting teams install only what they need.

`K` **Useful skills should emerge organically, not only through central gatekeeping.** Anthropic's described approach is lightweight experimentation plus social sharing before wider adoption.

`E` Example flow: upload a skill to a sandbox GitHub folder, share it in Slack, and let usefulness determine spread.

---

## Anti-Patterns

- Treating a skill as only a markdown prompt instead of a folderized package of instructions, scripts, assets, and state
- Writing skills that mix several categories without a clear dominant job
- Filling skills with generic coding advice the model already knows
- Omitting a maintained gotchas section built from real failure cases
- Over-specifying the workflow so the agent cannot adapt to context
- Storing long-lived state inside upgrade-prone skill folders instead of a stable data path
- Using user-friendly summaries instead of model-trigger descriptions in the `description` field
- Checking every possible skill into every repo as org scale grows, increasing ambient context cost
