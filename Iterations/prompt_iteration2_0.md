1. I've advanced in organizing a little the structure to save all the documents created through this iterative process. We have a folder Iterations, inside we have three folders: Brayan, Claude, Oracle (you), and there will live the prompt_iteration#_#.md files. This is the first one because this is like a draft made by me, but then we will refine and even finish with a couple different prompts for a certain iteration to parallelize work from the oracle. Inside the Oracle folder we have the files you gave me as response and the response itself. With this, I will use Claude to have another opinion on their thoughts and responses to continue the process as if it were the user; at the same time I will review each document and add a section a the end of each one with my feedback, and then I'll cross this with what Claude did to complement this. After this, I create the prompt for the next iteration (like this file), and refine it with the help of Claude to make sure it follows your suggestions and is clear enough.  

     You can also give suggestions on how could we improve the structure of the files for the iteration process.

     I'm documenting all my process here, so that the next session with the Oracle has a report of everything we've considered in this process to have a full picture.

2. When there's something I'm not sure or don't know how to do it, maybe I can mention some options, what I expect as a feedback are like pros/cons of each option, as well as present any other valid option, specially if it could be better than what I mention. With that, I can select something. This applies for any iteration process with any agent where there's clarification needed. **(TODO: we need to include this as Brayan feedback in the appropriate p0_B_iteration1_*.md file)**

## Tasks I want the oracle to do

1. I want to extract in a document the whole set of ideas that won't be considered on v0 so that we can easily come back later to them. I know the p0_iteration1_parking_lot.md file aims that, but I think it fell too short, there are many ideas that were left behind because you summarized them to much, for example, the idea of linking ToDos and skills (I know it's a very vage idea but I want to preserve all of them until I decide to prune them selectively), the multi-purpose CLI tool for agents to access context like task descriptions, todos, and rules (prompt_iteration1.md "Multi-Purpose CLI Tool" section), agents leaving structured feedback/reports about skill and tool failures after each session (prompt_iteration1.md "Skills" section), and the "desloppifier/code cleaner" agent concept (prompt_iteration1.md "Agents" section) **(TODO:  I think we can do this with Claude)**



2. I'll give the oracle all the basic files that talk about different important topics associated to agents, harnesses, prompt caching, context engineering, etc. There are some of them that have already been condensed and I pass them as a example so that the oracle evaluates them and determine if they're good enough or even if they facilitate in some way the understanding of what I pretend. I need the oracle to guide from the knowledge_extraction_prompt.md to understand what I mean by extracting principles/rules/facts about all these documents so that we can have them as core base for everything LLM agents related, including the coding projects we aim to build, as it's essential that they facilitate the use of agents inside the own project.

   I want to structure the set of principles and rules present in the files I passed. Maybe it could be something basic like a file with all the principles and rules related to projects generated with agents, another one for the principles and rules all agents (particularly coding agents) should consider always, and another set for the iterative process itself for example. But the oracle is in charge of deciding the structure, following the same principles it extracts from the documents I give

   ---

   ### Summary: What was done (completed across two iterations)

   The oracle processed all 12+ source files from `Agents_Foundations/` (articles, notes, condensed docs, and user-refined syntheses on harness engineering, agent-oriented thinking, prompt caching, context engineering, skills design, and architecture principles). The original source files were moved to `Agents_Foundations/Original/`.

   **Iteration 1** produced an initial extraction using the `knowledge_extraction_prompt.md` methodology (P/E/A tagging, theme grouping, anti-patterns). It generated principle files grouped by domain, a traceability mapping, and a review of existing condensed files.

   **Iteration 2 (corrections)** addressed structural issues from v1:
   - Separated **source-local condensation** (compressing a single doc) from **cross-source invariant synthesis** (extracting stable truths across all sources) — v1 had conflated the two.
   - Made **source weighting explicit** via a source register (`methodology/source_register.md`) with four tiers: primary sources, user-refined syntheses, source-local condensations, and notes/fragments.
   - Separated **stable principles** (invariant layer) from **evolving workflows** (playbook layer) — v1 had presented workflow habits as if they were timeless invariants.
   - Treated **traceability as best-effort** rather than claiming perfect proof of coverage.

   **Final output structure** (what we use going forward — `principles/` and `playbooks/`):

   | File | Scope |
   |---|---|
   | `principles/01_agent_operating_invariants.md` | Cross-cutting defaults for agent-oriented work: cold-start, context scarcity, explicitness, enforcement, drift, and meta-rules about invariants themselves. 14 tagged invariants. |
   | `principles/02_repository_architecture_modularity_and_control.md` | Repo as system of record, modularity, layered complexity, legibility, validation, control vs. throughput, entropy management. 19 tagged invariants. |
   | `principles/03_harness_context_skills_and_verification.md` | Runtime design: harness engineering, context control via subagents, tools/skills/MCP, hooks, deterministic control flow, verification and back-pressure. 19 tagged invariants. |
   | `principles/04_prompt_caching_and_prefix_stability.md` | Provider-specific (Anthropic prefix caching): prefix stability, session discipline, feature design around cache, monitoring. 12 tagged invariants. |
   | `playbooks/01_workflow_research_planning_and_review.md` | Evolving best-known workflow patterns: research->plan->implement flow, context handling, human leverage, task selection, risk-based supervision. 14 tagged defaults. |

   Each principle uses status markers (`[Core]`, `[Default]`, `[Conditional]`, `[Experimental]`) and the P/E/A legend. Each file ends with an anti-patterns section.

   **Supporting methodology files** (for reference, not for daily use):
   - `methodology/source_weighting_and_output_contract.md` — authority tiers and conflict handling rules
   - `methodology/source_register.md` — weight assigned to each source file
   - `methodology/traceability_best_effort_note.md` — honest framing of traceability limits
   - `prompts/` — the two-stage extraction prompts (source condensation + cross-source synthesis)
   - `reviews/derived_and_condensed_files_review_v2.md` — verdict on each existing condensed/derived file
   - `migration_v1_to_v2.md` — maps v1 files to their v2 successors

   ---



3. Related to the previous task, I think we really need to advance parallel with an initial version of the knowledge base. I think this is the perfect kind of project to take as test, besides it's something that can improve our system by a lot if implemented correctly. And I had another idea, I will take 3-4 of the original orchestrator projects (the ones that use codex, claude code or their subscriptions like agent-orchestrator) I explored initially, I'll install them and adapt the knowledge base project with each one adapting our requirements to how each one treats tasks (handling gh issues, using linear/jira, etc.). We will use like the default configuration for each one, let them build the knowledge base system, and then compare the results between them, which will allow us to detect common issues on using this type of software, to be aware of them while building our own system. We'll do this right after we have the initial version of contracts, formats, etc. Particularly, using the format and instructions for the project level planner.

4. In general and related to the previous, I think we can use the Oracle to define all the necessary documents, plans, technical files, etc. to serve as the base for the Knowledge_Base, the first and second version of the orchestrator (the second version I decided to do it on pi to have much more fine control on context, skills, etc. more on this later) So, basically we can do this in parallel requests to the Oracle (we don't have a limit of requests) and it can create all the corresponding documents and files based on the same workflow, contracts, etc. we will already have defined. In that way, for each case I'll be reviewing and making corrections to then start with each one in an appropriate order. This way, we will also be able to maximize the benefits of the oracle to have strong foundations from the beginning. And while I test version 1, I'll save time refining version 2 documents to its final form.

   Just to clarify, even if we use the Oracle as the main planner for almost every step, in the orchestration layer we still define Claude to do this for the first version.

   The idea is also that maybe we first adapt pi as one the harnesses of the first version, so that I still can understand and learn about pi and we advance through configuring some things associated with pi, to then try to do everything with pi as the base while leaving Claude (through claude code) more and more to just only one role (if still necessary because for sure I think other models like GPT can do this with good prompting and clear instructions) of being just like a co-reviewer and refiner/clarifier of my ideas, which it's how I'm using it currently.



## New rules I come up

- We shouldn't talk in plans/documents for projects in terms of days, it's not useful when we're talking about agents mainly. We should only talk in terms of phases/tasks/etc. Time of each one will be eventually relative to amount of tokens available at a time.