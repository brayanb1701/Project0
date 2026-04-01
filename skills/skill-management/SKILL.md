---
name: skill-management
description: Use when creating a new skill, refining an existing skill after observing failures or drift, or designing a more rigorous evaluation process for a skill. This skill routes to focused documents for creation, refinement, and evaluation design.
---

# Skill Management

Use this skill for the lifecycle of skills: creation, refinement, and evaluation. Skills are never finished artifacts. They should evolve as you observe new tasks, new failures, new environments, and better validation methods.

## How to use this skill

Pick the subdocument that matches the task:

- **Creating a new skill**: read [`references/creating-skills.md`](references/creating-skills.md)
- **Refining an existing skill** after real usage, regressions, overfitting, or noisy outputs: read [`references/refining-skills.md`](references/refining-skills.md)
- **Designing or improving evaluation** for a skill, including model comparisons and future optimizer-driven loops: read [`references/evaluating-skills.md`](references/evaluating-skills.md)

If the task spans more than one phase, use them in this order:
1. creation
2. refinement
3. evaluation

## Core principles

- Treat each skill as an evolving operational artifact, not a one-shot prompt.
- Keep `SKILL.md` lean; push deeper process and examples into reference files.
- Refine based on concrete failures and comparisons, not intuition alone.
- Prefer defaults that generalize; make specialized behavior opt-in.
- Separate artifact problems from skill problems:
  artifact problem = one bad output
  skill problem = repeated failure pattern, unclear default, missing guardrail, bad eval, or misleading abstraction
- If a field, rule, or taxonomy is not pulling its weight, simplify or remove it.

## Required output discipline

When updating a skill:

- state what changed
- state why it changed
- state what failure mode it is meant to fix
- state what future test should confirm the change

If you cannot say those four things clearly, the skill change is probably underspecified.
