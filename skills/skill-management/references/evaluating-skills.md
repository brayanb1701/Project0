# Evaluating Skills

Use this guide when designing a more rigorous evaluation process for a skill.

This document is intentionally incomplete. It should evolve as the repo accumulates better fixtures, more models, and more automated comparison methods.

## Goal

Evaluation should answer:

- does the skill work on real tasks?
- does it generalize?
- is it better than the previous version?
- which model or workflow uses it best?

## Evaluation layers

### 1. Sanity checks

Fast manual checks after a change:

- did the skill trigger correctly?
- did it follow the intended path?
- did the output format stay valid?
- did it become noisier or less clear?

### 2. Regression fixtures

Build a small set of stable tasks for each skill:

- easy case
- normal case
- edge case
- failure-inducing case

These should be reusable across versions.

### 3. Comparative runs

Run:

- old skill vs new skill
- default path vs optional path
- model A vs model B
- minimal instructions vs enriched instructions

The point is not just absolute quality. The point is comparative learning.

### 4. Structured scoring

Pick a few metrics appropriate to the skill, for example:

- correctness
- completeness
- compression
- clarity
- format validity
- latency or token cost
- generalization across cases

Some skills need task-specific metrics. That is fine.

## Comparison dimensions

When comparing skill versions or models, inspect:

- output quality
- failure type
- stability across repeated runs
- sensitivity to prompt variation
- token overhead
- need for manual correction

## Model comparison

Different models may interact with the same skill differently. Evaluate:

- whether the skill is too brittle for weaker models
- whether stronger models ignore unnecessary scaffolding
- whether the skill's structure helps or hinders model reasoning

Do not assume the best-performing skill text for one model is optimal for all models.

## Future direction

This section is deliberately exploratory.

Potential future directions:

- automatic fixture runners for skills
- side-by-side diff viewers for skill outputs
- learned or optimizer-driven refinement loops
- DSPy-style optimization workflows
- GEPA-like methods for iteratively improving prompts/skill structure against a test suite

The important constraint is that any optimization loop must still preserve interpretability. A skill should remain understandable and editable by humans.

## Minimum evaluation design for now

Until stronger tooling exists, every serious skill should have:

- at least 3 reusable test tasks
- one previous version or baseline for comparison
- explicit evaluation criteria
- a short note on what changed and what result improved

## Open design questions

- how to store fixtures and expected outputs consistently across skills
- how to compare models fairly when they differ in latency, cost, and output style
- how to avoid optimizing to a narrow eval set
- when to promote a local skill-specific eval into a reusable framework
