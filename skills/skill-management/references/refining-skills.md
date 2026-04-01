# Refining Skills

Use this guide after a skill has been exercised on real tasks and you have concrete evidence that it is too vague, too specific, too noisy, or structurally wrong.

This document is based on a first real refinement cycle where a knowledge-condensation skill was iterated through multiple artifact versions and compared against the original source. The lessons below are generalized so they can apply to other skills.

## Objective

Refinement is not "make the skill longer" or "make the skill smarter."

Refinement means:

- identify repeated failure modes
- locate the skill instruction that allowed that failure
- change the smallest useful part of the skill
- validate that the new default improves the result without overfitting

## Core process

1. Collect evidence from actual use.
2. Separate artifact defects from skill defects.
3. Identify the failure class.
4. Decide whether the fix should change:
   trigger rules
   defaults
   workflow steps
   metadata schema
   eval criteria
   reference examples
5. Make the smallest coherent change.
6. Re-run the task or compare against prior outputs.
7. Keep the improvement if it generalizes; revert or narrow it if it overfits.

## Step 1: Collect evidence

Use concrete artifacts:

- original source or user task
- outputs from multiple versions
- diffs between versions
- notes about what became better or worse
- direct questions from the user

Do not refine from vibes alone.

## Step 2: Separate artifact defects from skill defects

Ask:

- is this a one-off bad output, or a predictable pattern?
- did the model misunderstand the task, or did the skill encourage the misunderstanding?
- is the issue in the body output, the metadata, the routing logic, or the evaluation method?

Typical split:

- artifact defect: one phrasing choice, one missing detail, one awkward section title
- skill defect: repeated omissions, misleading defaults, unreliable metadata, forced taxonomy, missing comparison method

## Step 3: Identify the failure class

Most refinement work falls into one of these buckets:

- **missing signal**: important information keeps being dropped
- **false precision**: metadata or metrics look exact but are unreliable
- **overfitting**: a rule is written around one document or one example
- **under-specification**: the skill leaves too much ambiguity in a fragile step
- **over-structuring**: the skill forces outputs into a taxonomy that the source does not naturally fit
- **eval gap**: the skill has no clear way to tell whether the change helped
- **routing problem**: the skill triggers correctly but chooses the wrong internal path

## Step 4: Choose the right level of fix

### Fix the default before adding complexity

If the problem is common, improve the default behavior first.

Only add optional branches when:

- the tasks are genuinely different
- the branch reduces ambiguity
- the branch is likely to recur

### Prefer simplification over exception handling

Good refinements often remove things:

- noisy metadata
- misleading taxonomies
- unnecessary mandatory sections
- weakly useful labels

If a field, category, or step is not reliably helping, it is probably hurting.

### Convert rigid classification into optional guidance

A common failure pattern is forcing every task into a predefined structure. A better pattern is:

- simple universal default
- optional specialized presets
- explicit instruction to stay with the default when unsure

This preserves generality while keeping domain-specific optimization available.

## Refinement lessons from the first iteration

These are generalized lessons that should transfer beyond one skill:

### 1. Preserve the things that change meaning, not just the headline

When condensing or structuring work, the most damaging loss is often not the main idea but the thing that bounds it:

- assumptions
- caveats
- scope limits
- support structure
- evidence role

General rule:
if removing a detail changes applicability, confidence, or reconstructability, it is not secondary detail.

### 2. Beware of false-precision metadata

Fields like ratios, scores, or density measures are attractive because they look rigorous. They become harmful when:

- they are not computed consistently
- they are only approximate
- they distract from the artifact
- they encourage optimizing a number instead of the real goal

General rule:
if a metric is useful mainly for evaluation, keep it in evaluation artifacts, not in the default deliverable.

### 3. Defaults should generalize; specialization should be optional

A refinement often begins by adding more rules. That can help once, then hurt everywhere else.

General rule:

- universal structure should be the default
- domain-specific shaping should be optional
- when unsure, stay with the simpler default

### 4. Mixed inputs punish forced taxonomies

Many real tasks are hybrids. If a skill forces every task into one archetype, category, or workflow, the output starts distorting the source instead of representing it.

General rule:
use semantic roles or small universal structures when the input is mixed. Use named modes only when they clearly improve the result.

### 5. Compare versions directly

One of the highest-signal refinement methods is version-to-version comparison:

- compare v1 vs v2 vs v3
- compare each against the source
- separate what improved from what regressed

General rule:
refinement should produce an explicit tradeoff statement, not just "this feels better."

## Criteria definition

Every refinement pass should define criteria before editing. Use a small set that fits the skill.

Useful criteria families:

- fidelity: did the output preserve what matters?
- efficiency: did the output stay compact enough?
- clarity: is the structure easy to scan and use?
- generality: does the change apply beyond the triggering example?
- operational fit: does the workflow remain executable?
- evalability: can future runs tell whether this got better?

Do not use too many criteria. Three to five is usually enough.

## A practical iteration loop

1. Run the skill on a real task.
2. Mark what failed.
3. Write the failure as a general statement, not just a complaint.
4. Change the skill.
5. Re-run or compare against previous outputs.
6. Record:
   what changed
   what improved
   what regressed
   whether the new behavior should become the default

## When to broaden vs narrow

Broaden a rule when:

- the same issue appears across different tasks
- the abstraction improves multiple skills
- the new default reduces ambiguity without adding much overhead

Narrow a rule when:

- it only helps one document family
- it introduces token cost or complexity everywhere else
- it distorts mixed tasks

## What to document after refinement

After every meaningful refinement, record:

- the triggering failure mode
- the new default behavior
- what remains unresolved
- what future evaluation should test

This matters because even the refinement skill itself must evolve. If you do not leave behind the reasoning for the change, the next iteration will relearn the same lesson.

## Anti-patterns

- refining from intuition with no artifacts
- adding complexity before fixing the default
- preserving bad metadata because it looks rigorous
- overfitting to a single document or user complaint
- forcing every task into a labeled taxonomy
- changing multiple things at once and then claiming success
- failing to record why the refinement was made
