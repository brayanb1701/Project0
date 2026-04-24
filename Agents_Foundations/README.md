# Agents Foundations v2

This package revises the earlier extraction corpus around four changes:

1. **Separate source-local condensation from cross-source invariant synthesis.**
2. **Make source weight explicit.**
3. **Separate stable principles from evolving playbooks.**
4. **Treat traceability as best-effort evidence, not perfect proof.**

## Structure

- `prompts/01_source_condensation_prompt_v2.md`
  - for condensing a single source without losing ideas
- `prompts/02_cross_source_invariant_synthesis_prompt_v2.md`
  - for extracting the current invariant layer across many sources
- `methodology/source_weighting_and_output_contract.md`
  - authority tiers, stability tiers, conflict handling, output contract
- `methodology/traceability_best_effort_note.md`
  - how to think about traceability honestly
- `methodology/source_register.md`
  - provisional weighting of this corpus after your clarifications
- `principles/01_agent_operating_invariants.md`
  - cross-cutting defaults that are currently worth treating as stable
- `principles/02_repository_architecture_modularity_and_control.md`
  - repo shape, modularity, layered architecture, control, autonomy
- `principles/03_harness_context_skills_and_verification.md`
  - runtime design, subagents, skills, MCP, hooks, back-pressure
- `principles/04_prompt_caching_and_prefix_stability.md`
  - provider-specific but high-value caching constraints
- `playbooks/01_workflow_research_planning_and_review.md`
  - current best-known workflow patterns; explicitly evolving
- `reviews/derived_and_condensed_files_review_v2.md`
  - re-evaluation of prior condensed/derived files using the updated framing

## Status markers used in principle docs

- `[Core]` — strong current invariant; useful across repos and model generations unless disproven
- `[Default]` — current strong default; usually right, but dependent on today's harness/model behavior
- `[Conditional]` — valid only under certain risk, repo, or runtime conditions
- `[Experimental]` — promising, but not mature enough to treat as invariant

## Main deltas from the previous package

- Workflow guidance moved into `playbooks/` rather than being framed as timeless principle.
- The repository/architecture file now explicitly centers **modularity, simple core + layered complexity, and autonomy/control tradeoffs**.
- Throughput is treated as a **health signal**, not the goal.
- Source weighting now distinguishes **primary sources**, **user-refined syntheses**, **source-local condensations**, and **notes/fragments**.
