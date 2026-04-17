1. I've advanced in organizing a little the structure to save all the documents created through this iterative process. We have a folder Iterations, inside we have three folders: Brayan, Claude, Oracle (you), and there will live the prompt_iteration#_#.md files. This is the first one because this is like a draft made by me, but then we will refine and even finish with a couple different prompts for a certain iteration to parallelize work from the oracle. Inside the Oracle folder we have the files you gave me as response and the response itself. With this, I will use Claude to have another opinion on their thoughts and responses to continue the process as if it were the user; at the same time I will review each document and add a section a the end of each one with my feedback, and then I'll cross this with what Claude did to complement this. After this, I create the prompt for the next iteration (like this file), and refine it with the help of Claude to make sure it follows your suggestions and is clear enough.  

  You can also give suggestions on how could we improve the structure of the files for the iteration process.

I'm documenting all my process here, so that the next session with the Oracle has a report of everything we've considered in this process to have a full picture.



## Tasks I want the oracle to do

1. I want to extract in a document the whole set of ideas that won't be considered on v0 so that we can easily come back later to them. I know the p0_iteration1_parking_lot.md file aims that, but I think it fell too short, there are many ideas that were left behind because you summarized them to much, for example, the idea of linking ToDos and skills (I know it's a very vage idea but I want to preserve all of them until I decide to prune them selectively), the multi-purpose CLI tool for agents to access context like task descriptions, todos, and rules (prompt_iteration1.md "Multi-Purpose CLI Tool" section), agents leaving structured feedback/reports about skill and tool failures after each session (prompt_iteration1.md "Skills" section), and the "desloppifier/code cleaner" agent concept (prompt_iteration1.md "Agents" section) **(TODO:  I think we can do this with Claude)**



2. I'll give the oracle all the basic files that talk about different important topics associated to agents, harnesses, prompt caching, context engineering, etc. There are some of them that have already been condensed and I pass them as a example so that the oracle evaluates them and determine if they're good enough or even if they facilitate in some way the understanding of what I pretend. I need the oracle to guide from the knowledge_extraction_prompt.md to understand what I mean by extracting principles/rules/facts about all these documents so that we can have them as core base for everything LLM agents related, including the coding projects we aim to build, as it's essential that they facilitate the use of agents inside the own project.

   I want to structure the set of principles and rules present in the files I passed. Maybe it could be something basic like a file with all the principles and rules related to projects generated with agents, another one for the principles and rules all agents (particularly coding agents) should consider always, and another set for the iterative process itself for example. But the oracle is in charge of deciding the structure, following the same principles it extracts from the documents I give

   ---

   ### Prompt for the Oracle: Structured Principles Extraction from Agents_Foundations

   You are given a set of files, which includes articles, notes, condensed documents, and guides covering topics like harness engineering, agent-oriented thinking, prompt caching, context engineering, skills design, prompting practices, and architecture principles — all related to building software with and for LLM coding agents.

   Some of these documents have already been individually condensed using the methodology in `knowledge_extraction_prompt.md` (files ending in `.condensed.md`), or another version of it (maybe more general). These condensed versions serve as examples of the extraction style (P/E/A tagging, theme grouping, anti-patterns). Evaluate them: are they good enough? Do they capture everything? Would you restructure them?

   **Your objectives:**

   #### 1. Understand the extraction methodology
   Read `knowledge_extraction_prompt.md` carefully. This defines an initial idea on how we extract principles (`P`), implementation examples (`E`), and agent-specific considerations (`A`) from source material. Analyze this methodology to serve as a base for you to decide your own.

   #### 2. Extract and structure ALL principles, rules, and facts across every file
   Process every file (not just the ones that already have condensed versions). Extract every distinct principle, rule, fact, and actionable insight. Remember: condensing means fewer words, not fewer ideas — nothing should be silently dropped.

   #### 3. Decide the best structure for organizing the extracted knowledge
   Don't just produce one flat file. Decide the optimal way to organize the extracted principles into separate files (and folders/subfolders if warranted). Group by domain/purpose, not by source document. For example, you might end up with something like:

   - Principles that apply to **all agent-built projects** (repo structure, legibility, documentation, entropy management, etc.)
   - Principles that **coding agents should always follow** (context management, progressive disclosure, tool use, error handling, prompt design, etc.)
   - Principles for **the iterative design/research process itself** (how to run experiments, evaluate, refine, etc.)
   - Principles for **harness/orchestrator design** (agent coordination, feedback loops, autonomy escalation, etc.)
   - Principles for **prompt engineering and caching** (token efficiency, cache-aware design, system prompt structure, etc.)

   These are suggestions — you decide the actual structure based on what emerges from the material. Follow the same principles you extract (e.g., if the documents say "group by theme not by source," do that). Explain your reasoning for the structure you chose.

   #### 4. Evaluate existing condensed files
   For files that already have a `.condensed.md` version, compare your extraction against the existing condensed version. Note what was missed, what was over-summarized, and whether the condensed version is sufficient or needs to be replaced by your version.

   #### 5. Produce a traceability mapping
   This is critical. In a separate file (e.g., `principles_traceability.md`), produce a mapping that shows:
   - Each principle/rule/fact you extracted
   - Which source file(s) it came from (with enough specificity to locate it — section name or a short quote if needed)
   - Which output file you placed it in

   This mapping lets us verify that every idea from every source file was considered and nothing was lost. Format it as a table or structured list — whatever is most scannable.

   #### 6. Report on coverage gaps and cross-cutting themes
   In your response (not in the output files), include:
   - A list of any source files where content felt thin, redundant, or contradictory with other sources
   
   - Cross-cutting themes that appeared in 3+ source files (these are likely the most important principles)
   
   - Any principles that conflicted between sources, and how you resolved the conflict
   
   - Your assessment of the existing condensed files — keep, replace, or merge?
   
     **Files you will receive:**
   
     All files inside `Agents_Foundations/`:
   
   - `knowledge_extraction_prompt.md` — the extraction methodology itself (as an example)
   
   - `Harness_Engineering.md` + `Harness_Engineering.condensed.md`
   
   - `Harness_Eng_HumanLayer.md`
   
   - `Agent_Oriented_Thinking.md`
   
   - `Agent_Project_Principles.md`
   
   - `Architecture_Doc_Principles.md`
   
   - `Prompt Caching is Everything.md` + `Prompt Caching is Everything.condensed.md`
   
   - `Skills_Use_Anthropic_engineer.md` + `Skills_Use_Anthropic_engineer.condensed.md`
   
   - `ace-fca.md`
   
   - `AI-Engineer-Conference-EU-0426.md`
   
   - `Dex Process on coding with agents.md`
   
   - `Manage_Context_Window_DanielGriesser.md`
   
   **Output:** The structured principle files (following the P/E/A format), the traceability mapping file, and your analysis/recommendations in your response text.
   
   ---

​	



3. Related to the previous task, I think we really need to advance parallel with an initial version of the knowledge base. I think this is the perfect kind of project to take as test, besides it's something that can improve our system by a lot if implemented correctly. And I had another idea, I will take 3-4 of the original orchestrator projects (the ones that use codex, claude code or their subscriptions like agent-orchestrator) I explored initially, I'll install them and adapt the knowledge base project with each one adapting our requirements to how each one treats tasks (handling gh issues, using linear/jira, etc.). We will use like the default configuration for each one, let them build the knowledge base system, and then compare the results between them, which will allow us to detect common issues on using this type of software, to be aware of them while building our own system. We'll do this right after we have the initial version of contracts, formats, etc. Particularly, using the format and instructions for the project level planner.



## New rules I come up

- We shouldn't talk in plans/documents for projects in terms of days, it's not useful when we're talking about agents mainly. We should only talk in terms of phases/tasks/etc. Time of each one will be eventually relative to amount of tokens available at a time.