# Creating Skills

Use this guide when building a new skill from scratch or extracting one from repeated ad hoc work.

## Goal

Create a skill that is:

- easy to trigger correctly
- small enough to load cheaply
- specific enough to help
- general enough to survive outside one example
- structured so future refinement is easy

## Start from examples, not abstraction

Before writing the skill, inspect:

- existing skills that already solve similar problems
- the most concrete examples of the user task
- the current workflow the skill is supposed to replace

Do not start from taxonomy. Start from repeated work.

## Creation process

1. Identify the recurring job.
2. Gather 2-5 concrete examples of tasks the skill should handle.
3. Define the skill boundary:
   what it should do
   what it should not do
4. Decide the minimum trigger description that will fire on the right tasks.
5. Write a short `SKILL.md` that explains:
   when to use it
   the default workflow
   where to look for deeper references
6. Split detailed material into separate reference files.
7. Prefer examples and operational rules over long conceptual explanation.
8. Validate on a real task.

## What to reuse

Build the initial version from:

- available example skills already present in the repo
- the principles from the platform's skill-creation guidance
- existing task artifacts, prompts, outputs, and diffs

Do not invent complexity the examples do not justify.

## Design choices

Choose the simplest design that still works:

- single-file skill if the workflow is narrow
- `SKILL.md` + references if the workflow has multiple phases or variants
- scripts only when deterministic behavior is clearly better than prose instructions

## Good defaults

- one clear default workflow
- optional branches only when common and distinct
- explicit references instead of embedding all detail
- minimal metadata, high-signal description

## Anti-patterns

- creating a skill before you have real examples
- stuffing everything into `SKILL.md`
- documenting every possibility instead of the normal path
- solving one anecdotal failure by hardcoding a brittle rule
- creating extra docs that do not directly help execution
