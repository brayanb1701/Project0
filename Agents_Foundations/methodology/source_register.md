# Provisional Source Register

This reflects both the corpus itself and your clarifications.

| Source | Role | Weight | Notes |
|---|---|---:|---|
| `knowledge_extraction_prompt.md` | methodology seed | high | useful for source-local extraction style, not sufficient alone for invariant synthesis |
| `Harness_Engineering.md` | primary | high | major first-order source for repo-as-system-of-record, legibility, boundaries, autonomy |
| `Harness_Eng_HumanLayer.md` | primary | high | major first-order source for harness engineering, tools, subagents, hooks, back-pressure |
| `Prompt Caching is Everything.md` | primary | high | provider-specific but highly actionable |
| `Skills_Use_Anthropic_engineer.md` | primary | high | strong first-order source for skill design |
| `ace-fca.md` | primary | high | major first-order workflow source |
| `Manage_Context_Window_DanielGriesser.md` | primary | medium-high | narrower than ace-fca, but strong for subagent distillation and persistent artifacts |
| `Agent_Oriented_Thinking(2).md` | user-refined synthesis | high | should be treated as an intentional distilled foundation, not a casual derived file |
| `Agent_Project_Principles(2).md` | user-refined synthesis | high | policy-oriented synthesis; useful for operating defaults and tradeoff framing |
| `Architecture_Doc_Principles(2).md` | user-refined synthesis | high | strong canonical starting point for architecture docs |
| `AI-Engineer-Conference-EU-0426.md` | notes / fragment | medium | useful and high-signal, but hypothesis-heavy and not always fully argued |
| `Dex Process on coding with agents.md` | notes / fragment | medium | important workflow clues, but thin and apparently truncated |
| `Harness_Engineering.condensed(2).md` | source-local condensation | medium | good fidelity aid, but secondary to the primary source |
| `Prompt Caching is Everything.condensed(2).md` | source-local condensation | medium | strong summary, still secondary to the primary source |
| `Skills_Use_Anthropic_engineer.condensed(2).md` | source-local condensation | medium | useful support file, not final authority |

## Practical interpretation

- The three user-refined synthesis files should influence the final invariant layer more than generic condensed summaries.
- The two note-like workflow sources should influence playbooks strongly, but core principles only when corroborated or clearly marked as default / experimental.
- The OpenAI/HumanLayer/Anthropic primary sources remain the strongest anchors for repo, harness, caching, and skill-system claims.
