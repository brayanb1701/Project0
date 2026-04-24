# v1 -> v2 Migration Note

## Why v2 exists

v1 was useful, but it still mixed together three different jobs:

1. source-local condensation
2. cross-source invariant synthesis
3. evolving workflow guidance

v2 separates those jobs more clearly.

---

## Replacements / successors

| v1 file | v2 successor |
|---|---|
| `methodology_assessment_and_structure.md` | `methodology/source_weighting_and_output_contract.md` + `methodology/traceability_best_effort_note.md` + `methodology/source_register.md` |
| `reviews/existing_condensed_files_review.md` | `reviews/derived_and_condensed_files_review_v2.md` |
| `principles/01_agent_foundations.md` | `principles/01_agent_operating_invariants.md` |
| `principles/02_workflow_research_planning_and_review.md` | `playbooks/01_workflow_research_planning_and_review.md` |
| `principles/03_harness_context_and_verification.md` + `principles/05_skill_design_and_distribution.md` | `principles/03_harness_context_skills_and_verification.md` |
| `principles/04_repository_architecture_and_legibility.md` | `principles/02_repository_architecture_modularity_and_control.md` |
| `principles/06_prompt_caching_and_prefix_stability.md` | `principles/04_prompt_caching_and_prefix_stability.md` |

---

## Main conceptual changes

- `principles/` now means “current invariant layer”
- `playbooks/` now means “current best-known evolving workflow”
- source weighting is explicit
- user-refined synthesis files are treated differently from plain condensations
- modularity, layered complexity, and autonomy/control are now much more explicit
- throughput is treated as a signal, not as the goal
