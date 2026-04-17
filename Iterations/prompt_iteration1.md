Hey, you're the most potent accessible LLM model in the world, so based on that I expect you to give me a response at the height of the best of your capacities. Also, you're not cheap to run, so we need to extract the most from our conversations.

I'm working on creating and personalizing my own harness+swarm of coding agents. I've been iterating a lot on how it should be done, sometimes even going in circles between ideas; I've also learnt about harnesses, agents, etc. so my vision and how I conceive could be the best way to do this for my purposes has evolved in some aspects and I have new ideas. Now I think it's the time to start iterating faster and that's where you enter, you'll help me start an iterative process with you so that we decide some things and create the most comprehensive plan possible through an iterative process between the two of us. You'll act as an oracle for this system we're creating and I'll review and refine through the whole process. Based on that, what we're going to do is that I will give you all the docs I've been creating in this exploratory phase as well as an explanation of the whole process and my current ideas and questions to resolve. With all this information and whatever you want to search additionally, we'll start the iterative process, maybe the first thing is that you outline clear next steps; for example, I won't pass you all the LLM generated files in the exploration phase, I will pass you the essential ones that allow you to understand what I've done, and a description of the files I haven't passed you so that you decide in which order you want to treat them, like to separate correctly well scoped areas of this big project. Besides our conversation itself should evolve through iterations, you'll always give me feedback on what part of the request isn't clear enough or what you would change and why, so that I can learn and refine a better way to communicate with you on the process. The idea is that in the whole process we all benefit, I'm more of a thinker than a builder, so I need to close this gap to improve myself.

It's important to note that all of this is subject to review and can change throughout this iterative process, this should serve as a starting point rather than be taken as definitive. You should approach everything from a critic and rational view, always thinking how to improve this to a better solution in the process.

In the following text I'll be using links for you to check relevant things, as well as references to the files I pass along with this prompt. I need you to tell me if you couldn't access a certain link and if you found a way to see the information or not.

You should create md files (if you can create files, if not, simply the text or artifact), one or the number you consider so that we can continue, either with tasks for me or for other models. Also, create a summary (if possible an individual file/artifact) of all the things we've done in this session in case we need to continue in another one. It's very important that none of the ideas are left behind, as these files need to preserve everything, even if it's not for doing from the start.

I'll first describe all the process I've done, with my thoughts and observations, referencing some key documents (the ones I'll be giving you). You must incorporate all those learnings.

## Description of my process

I started reading about harness engineering and all related topics, to understand what I needed to know and comprehend before starting, at the same time, I started seeing a lot of different tries of implementation but I think none of them fully satisfy my vision. Based on that, I started collecting my thoughts in the "Inspirations_and_Early_Ideas.md" file. This file mentions like the inspirations, sources, useful tools, etc. Having this file, I also noted that I needed to condense the useful information from the articles I've read about the topic, that's why I created "knowledge_extraction_prompt.md" as a very initial version, this allowed me to separate principles (which are what matters most) from other context information. Then, I already started an iterative process with different agents refining my ideas from "Inspirations_and_Early_Ideas.md" and considering the learnings from other documents (I will pass those ones to you so that you have them as reference).

Based on that, we created and refined "ORCHESTRATOR_PLANNING_PROMPT.md" or ORCHESTRATOR_PLAN as I reference later in this text, where we give more structure to these loose ideas I had previously. From that, we started a phase where models would analyze the selected projects as stated in "Projects_to_analyze.md" (opencode was added and analyzed), based on "RESEARCH_PROJECT_REFERENCE_GUIDE.md" (reports for hermes-agent, openclaw, pi-mono, and codex were updated with new features as of April 2026). 

I tried using ypi itself to do this exploration for each project, however, it seemed to be poorly optimized and burnt tokens very fast without finishing (I think there might be some prompt cache optimizations to do). Then, I switched to a more common way by using codex/claude code each invoking subagents.

After this, we have a report for each of these projects, the recommendation shouldn't be taken literally and we should again analyze each of the results.

After having all of this information, I was still very doubtful and not clear how to continue, so I started a more pragmatic approach and redirected my attention to collect and organize all the skills we have as examples, I grouped them in the skills folder, organized by origin: coding/agent-related skills are under their source project folders (`anthropic/`, `codex/`, `gstack/`, `hermes/`, `openclaw/`, `pi/`), general-purpose skills we created are under `general/`, Addy Osmani's agent-skills collection is under `addy_skills/`, and miscellaneous skills from other sources are under `Others/` — each preserving their original provenance. Then, I started thinking how we should create the skills, following the standards present in https://agentskills.io/llms.txt but also personalizing them (more on that later). In this moment I was already thinking on creating a very early version  of the system only based on skills, headless-sessions (async comms between agents via md files mainly) and workflows implemented within the skills and their accompanying scripts. In this point I also started to refine the headless-sessions skills. 

After that, I thought it'd be a good idea then to change focus again to something else, the knowledge base/wiki system, as I thought it could be really convenient for managing accessibility of information for agents and for me, that's where I started refining the knowledge-condenser skill (more on this later). Related to that, I thought it would be a good idea to define the structure for how we should store principles/rules, skills, and any useful information for the agents and the system. That's what I have inside the orchestrator folder, my attempt to reflect these ideas, although in a very early stage.

As you can notice I've changed so many times of focus, that's a problem to advance; but that also have helped me to shape my ideas and understand better what we need. But now it's time to put some order for the next steps and accelerate the iterations.

This is the repo in case you want to check it yourself: https://github.com/brayanb1701/Project0 here are all the files plus some others I used along the way but I didn't consider relevant to mention.

## Current Situation + Summary of available files

Here are some facts that could change how we approach from now on:

- Claude subscription has restricted the use of its models outside its own harness (claude code). I want to have Claude inside the stack (at least in the beginning) as I've seen that Claude is much better at understanding my intent and producing structured outputs that other models (like GPT) can then work from effectively, so we could reserve Claude for the initial phase of intent clarification and structuring; based on that, we have no choice but calling claude code as headless sessions.
- This prior point makes me think maybe we should start with a runtime agnostic to where the models are run. Although we can think about leaving Claude just as a skill being called headless, and that could be enough for our purposes, for the system to work. 
- Currently, I think the best approach could be to handle this system based on events (as the communication layer will be async). Maybe we should have at least one interactive agent I can talk to directly for ad-hoc tasks within a project when I want to be more hands-on; but we need to consider this carefully as this implies other changes in logging and other things.
- I currently have a subscription with Cursor that finishes in less than a month I think, and I consider we should use it as much as we can (this one has access to different models so we can use it to try); Cursor has its own CLI. Also, I have a subscription for Github Copilot which has some other models (this one expires in more time but still we need to make sure we optimize the use of everything we have available); with this one I'm not sure how can we use it. Based on that optimization of current resources, I'd think the best way to do this is to leave the frontier models only in definition, planning, decomposition, and distribution of tasks, while chinese/open_source/etc models to act as builders with very clear and defined instructions. Basically frontier models (paid) for manager, planners, etc. and the others to act as builders.

Now, here you have a summary of files/skills I haven't showed you. Besides this, we have the full report for each of the projects, which I also won't give you this time so that I don't saturate your context.

### Skills folder structure (`skills/`)

- **`general/`** — Skills we created: `headless-claude`, `headless-codex`, `knowledge-condenser`. Also contains a README.
- **`anthropic/`** — Skills from Anthropic's public repo: `claude-api`, `frontend-design`, `mcp-builder`, `skill-creator`, `web-artifacts-builder`, `webapp-testing`.
- **`codex/`** — Skills from OpenAI's Codex: `openai-docs`, `plugin-creator`, `skill-creator`, `skill-installer`.
- **`gstack/`** — Skills from gstack (20 skills): workflow-oriented skills like `browse`, `careful`, `design-consultation`, `design-review`, `investigate`, `qa`, `review`, `ship`, plan reviews, etc.
- **`hermes/`** — Skills from Hermes Agent (8 categories): `autonomous-ai-agents`, `dogfood`, `github`, `mcp`, `migration`, `mlops`, `research`, `software-development`.
- **`openclaw/`** — Skills from OpenClaw (12 skills): `acp-router`, `clawhub`, `coding-agent`, `diffs`, `gh-issues`, `github`, `healthcheck`, `mcporter`, `model-usage`, `session-logs`, `skill-creator`, `tmux`.
- **`pi/`** — Skills from pi-agent (11 skills): `commit`, `frontend-design`, `ghidra`, `github`, `librarian`, `mermaid`, `pi-share`, `sentry`, `tmux`, `update-changelog`, `uv`.
- **`Others/`** — Miscellaneous skills preserving origin in their prefix (90+ skills): `anthropic--*`, `codex--*`, `gstack--*`, `hermes--*`, `openclaw--*`, `pi--*` covering channels, integrations, media, productivity, research, etc.
- **`addy_skills/`** — Addy Osmani's agent-skills collection (20 skills): `api-and-interface-design`, `browser-testing-with-devtools`, `ci-cd-and-automation`, `code-review-and-quality`, `code-simplification`, `context-engineering`, `debugging-and-error-recovery`, `deprecation-and-migration`, `documentation-and-adrs`, `frontend-ui-engineering`, `git-workflow-and-versioning`, `idea-refine`, `incremental-implementation`, `performance-optimization`, `planning-and-task-breakdown`, `security-and-hardening`, `shipping-and-launch`, `spec-driven-development`, `test-driven-development`, `using-agent-skills`.
- **`skill-management/`** — Skill management utilities with references.

### Orchestrator folder structure (`orchestrator/`)

- `README.md` — Orchestrator overview.
- `install.md` — Installation instructions.
- **`headless/`** — Headless session management:
  - `README.md` — Headless session docs.
  - `launcher-template.md` — Template for launching headless sessions.
  - `project-codes.md` — Project code registry.
  - `session-naming.md` — Session naming conventions.
  - **`scripts/`** — `p0-headless-lib.sh`, `p0-headless-session.sh`, `p0-session-name.sh`.
  - **`templates/`** — `headless-launch-response.md`, `headless-mission-context.md`.

### Root-level files

- `prompt.md` — This document (main project brief and vision).
- `ORCHESTRATOR_PLANNING_PROMPT.md` — Detailed orchestrator plan (ORCHESTRATOR_PLAN).
- `Inspirations_and_Early_Ideas.md` — Early inspirations, project references, and rules.
- `Projects_to_analyze.md` — Master list of projects to analyze with focus areas.
- `RESEARCH_PROJECT_REFERENCE_GUIDE.md` — Guide for analyzing research projects.
- `knowledge_extraction_prompt.md` — Initial prompt for extracting principles from articles.
- `Harness_Engineering.md` — Full harness engineering article.
- `Harness_Engineering.condensed.md` / `.v2` / `.v3` / `.v4` — Iterative condensed versions.
- `Karpathys_takes.md` / `.condensed.md` — Karpathy's ideas and condensed version.
- `Prompt Caching is Everything.md` / `.condensed.md` — Prompt caching article and condensed version.
- `Prompting_gpt5.4.md` / `.condensed.md` — Prompting guide for GPT 5.4 and condensed version.
- `Skills_Use_Anthropic_engineer.md` / `.condensed.md` — Anthropic engineer's skills usage notes and condensed version.
- `Architecture_Doc.md` / `.condensed.md` — Architecture document and condensed version.
- `Architecture_Doc_Principles.md` — Architecture principles extracted.
- `Agent_Oriented_Thinking.md` — Agent-oriented thinking notes.
- `Agent_Project_Principles.md` — Agent project principles.
- `Repos for inspo and some rules.txt` — Original inspiration file (predecessor to Inspirations_and_Early_Ideas.md).
- `install.sh` — Installation script (a very initial version).
- **`Research/`** — Per-project analysis folders with prompts and output reports.

## Defining the basis of the system

Aiming for simplicity, I'm currently inclined to start with an initial idea of getting an initial version functional enough to iterate from that, like create something simple where you can add and refine iteratively. This basis should be flexible and adaptable (that's why I like pi-agent, its concept itself).

An option would be to start as basic as possible, like using the already existing harnesses like codex, claude code, opencode, and using skills and scripts to chain the agents, although we're limited by each harness's customization capabilities, and coordinating skills across different harnesses adds complexity. This was what I started doing and that's why I started creating headless-codex, headless-claude skills as a first approach, but I'm not sure it will work as I intend because for now, the models are the ones in charge of calling the other models, and maybe that's not the best strategy, besides other concerns. I was trying to simplify these skills so that we had like a unified and more basic script to run this, however, this is an ongoing effort and isn't finished, currently it's buggy and worked better directly referencing how to call each headless session.

Another option is to use pi-agent as a base, which is completely personalizable and would allow most models by default, this would clearly require more work. Here, we have a few options regarding if the runtime will be tied to pi-agent itself or it could be an additional system in charge of managing tasks and calling pi-agent with the corresponding settings.

The last and least practical option is creating everything from scratch (this could be possible maybe later when we have a good enough version of this system that allows us to build everything)

It's very important that we define clear scopes for each part of the system we're building, based on rational and logical decisions.

**Why?** We want a harness that evolves and adapts at the same rate as new models come out, but being very aware that there may be models too expensive for us, and that in each instant of time there's a variety of models that we can use to our convenience to extract the most from our budget (currently very limited)  

## Constraints of time

There are a couple of fellowships, hackathons, internships, etc. that I would like to apply:

- https://github.com/openai/parameter-golf (April 30th deadline)
- https://openai.com/index/introducing-openai-safety-fellowship/ (May 3rd deadline)
- https://constellation.org/programs/astra (May 3rd deadline)

Based on that, I really need to start iterating faster so that we can start doing projects related to this; this could be a huge way of getting fundings, resources, compute, and much more tokens for agents so that we keep iterating and improving our system. We really need to iterate fast, but at the same time making sure we make the right choices to build something that can truly expand

## Workspace design

By default, workspace is the project folder, inside we have a hidden folder where we have personalized "settings", it could be specific workflows, skills, knowledge, rules, etc. applicable to the specific project); also, the main "settings" folder should be included, that one is located in $HOME/[what_we_call_this]. Currently the name we have is Project0 (abbreviated p0). The idea is that in this main folder we will have a collection of all different sets of skills, tools, default settings, session logs (in a tree structure or something like that, so that we preserve the relations between agents and sessions). There, we should also have an initial "memory system" (maybe something related to Karpathy's wiki LLM vision but adapted), and a way where concurrent agents can talk to each other. (maybe something like in $HOME/.p0/project_name/session(parent)/sub_comms/. The other important thing in the $HOME/.p0 folder is the principles or rules, either general for any kind of project, for particular models, for specific types of projects (web apps, mobile apps, CLIs, etc). And another thing is all the kind of agents, categorized and grouped.

## Agents
In our system, agents will be defined as an LLM that follows certain instructions to accomplish a clear well-scoped goal, given the necessary context, tools and skills. I was thinking maybe in the HOME folder, $HOME/.p0/agents/, we should have like all config files for each agent, each file should contain like a first part, like a frontmatter where there's basic info like name and short desc for discovery and quick lookup (something like we do with skills), and after that the rest of the info like skills to use, permissions, specific model, etc.. Some agents are:

- Explorer: Find and condense information locally (or using docs cli).

- Web searcher: the one that has the most risks, need to find a way to ensure it's limited so it only produces a document with the results ensuring it's not prompt injected.

- Frontend / Backend managers: take a feature request, convert them in specific actionables/tasks to distribute to F/B builders. Not sure if the same should make tests (restriction to avoid test hacking by builders who should only ensure tests pass) and review for each agent commit (apart that the basic builder workflow should ensure it tests its own code and documenting before finishing). There could be other managers too. One of the most important things to consider is that based on the complexity involved in implementing, it should determine how much detail it must specify for the builders to do it correctly; implementing a CRUD endpoint requires far less specification detail than implementing complex functional programming logic, for example.

- Planner: here we need a distinction for levels of plans, they can be for whole project, for a feature etc. It must be an iterative process where until the user approves, we keep iterating based on user feedback directly in the md file. Planner should incentivize this with questions. 
- Builder (Note: what this document calls "Builder" corresponds to "Worker" in ORCHESTRATOR_PLAN; what this document calls "Project Architect" corresponds to "Builder" in ORCHESTRATOR_PLAN): it must run on a closed loop based on having a list of things to do (1 or more) with the full context available to achieve it, and it must focus on finishing the task completely passing all the new tests associated and without breaking any other, and also documenting both for agents and humans, and finalizing committing only the files it changed. 
- Project Architect: When starting a project from "zero" or only from ideas, after having a general plan, the project architect must structure the project itself, it must decide which technologies, languages, packages, etc will use the project, anything technical not specified in the plan yet. It should make sure that the project has everything defined, like linter to use, package for tests, etc, CI/CD management, etc. But it should have like predefined options based on the type of project (CLI tool, webapp, mobile app, etc)

- Tester (Creator and or verifier)
- Reviewer (Checks Tests and docs). It could be the same manager, not defined yet.
- Desloppifier/code cleaner

- Others to see based on the workflows I've collected for you to check and analyze; we should analyze them systematically like evaluating pros, cons, weaknesses, etc. of each approach to determine our initial point to iterate from that, or maybe our own personalized approach, based on what I've iterated before in the documents.

All agents (and workflows, and everything) must be evaluated, the evals will be based on our own data collected for those purposes. 

As an initial idea, I think the evals could be saved in the main folder $HOME/.p0/agents/{particular_agent_folder}/ but I still don't have it clear how to do evals for agents and workflows. 

These ideas aren't opposite to the ones presented in the ORCHESTRATOR_PLAN, maybe there, many of them are better described, you should only take from here what are novel ideas and also analyze if there are discrepancies, which approach is better, but in case you can combine them, you should also evaluate that in order to have the best possible solution.

## Skills

Skills should always follow the standard format described in https://agentskills.io/home; however, I think we could enhance it with optional metadata to categorize them following the ideas implemented in hermes agent, I think many design choices from there can be very useful as I imagine how it should work, like grouping and categorizing skills; I have checked very broadly how skills work in Hermes Agent and I think that could be a good starting point or at least to take as reference.  The idea would be that skills can be loaded per project (to preserve prompt cache), but even when we list all of the ones for the project, it should only be able to use the ones mentioned for each agent.

For skills I have a couple of ideas of how we could modify how they work, one way is that for example we have a skill for frontend design, but for frontend design we could have a sub-skill for design, another for using certain libraries, and even particular parts that could change according to the model. Based on that, there are two options: Option A: the skill's main file acts as an index that the agent navigates to find the relevant sub-skill files in the corresponding subfolder(s). Option B: the runtime/harness resolves and injects the relevant sub-skill files before the agent sees them. The question is how much freedom we should give the agent (it could get lost navigating sub-skills for example), we need to analyze this in detail. This would also depend on the project we choose as base and what's easier to start with.

Skills should evolve continuously through our own evals and tests, for that we need to collect the traces of sessions, analyze them, organize them, and have the processed information of failures and any other relevant information.

In that sense of evolution, I think we should include a way for the agents to leave feedback/report issues in every session for whichever skill/tool/CLI it uses. For example, if an agent tries to use a skill and it doesn't work as expected, it should document what failed, why the agent thinks it failed and if it found some workaround or had to ask for help to its superior. This feedback/report should be organized and saved so that we create tasks to review this and check how can we improve (at first, me as the human in the loop will be reviewing these to include my own criteria)

## To Dos and relations to agents and skills

I have an idea that could be interesting to explore, that is that certain skills (specially those skills related to how an agent must do its role) can have a ToDo file associated with a set of steps to execute, this To Do should be flexible enough so that the agent itself must add more specific To Dos according to the particular task it's solving. 

The agent should have a To Do list (which should be a md file, something easy to modify), that could be used to make sure the agent completes everything it's supposed to complete. For example, at the beginning of every session, it should already exist this file that the model has access too (note: the agent should only be able to remove ToDos that it created itself; core ToDos are immutable), where it has the instructions on reading the task spec file, reading the corresponding skills in order, adding the corresponding ToDos based on that, and also for each skill used, to leave feedback or report any issue or error encountered during the session related to that skill; also making sure for example in the case of the builder that it always verifies, commits and documents as a To Do.

## Workflows

Agents should work based on Spec Driven development and TDD. The spec is what tells the builder agent how to achieve the task, but also it should have a set of tests associated to rely on and check everything works. The builder loop is one of the most important, as this agent should be able to verify its own work always before marking a task as completed. I visualize something like this, these are just a very basic drafts of the main workflows for coding.

- First we have the process where we start from some related ideas for making a program/app/extension/whatever coding project. From that, we need to start an iterative process between me and an agent where we refine these ideas to have a better vision on how the project should look like; in this part of the process, the agent should call another one in charge of searching for similar ideas (github, repos, products, etc) or things we could use, as well as another one for giving ideas on how this new project could relate to other projects already built or ideas that were archived in the knowledge base for projects. The main refinement agent should output an md file that will serve as the base for the project (Idk how to call this file), it must have a section of questions for me to clarify better my ideas, and also a final section where I put my feedback of the project. Then it's sent back to the agent, and we have this iterative process until I mark it as ready to start development.

  After that, from this file, it could pass to another agent (or maybe the same refinement agent could do that, that's to decide yet) that defines the first tasks to assign, obviously the first one should be the project architect that leaves the repo ready for other agents to start contributing to them. We should define a checklist for this agent to make sure the repo is ready (besides, there are many things that could be configured programatically, like the runtime/scripts/whatever could handle this automatically, for example with things like creating the folder structure and so on. After that, it should be the iterative process for each particular feature, which will be described now

- The other workflow would be the general one, like we start with a feature we want to build, this is taken by a manager, which is in charge to analyze what needs to be done to implement the whole thing, the feature has to be very clear and well defined, and it's the manager who analyzes how to implement it in the project seamlessly, following all the rules, standards, and integrating correctly with the architecture. It first starts doing an exploration to gather the information needed, it could both explore by himself (maybe here it's useful the CLI tool mentioned later on this text) or invoking an specialized agent for exploring that will answer the specific questions it could have. After that it will use all the information it has to create the plan and the full spec file(s) to implement this, which will not be implemented by it but by other agents, it should split the work accordingly in 2-4 different agents by creating an md file with the instructions and requirements of the task. This part can be tricky to do correctly as the agent must do this separation correctly so that the tasks that can be parallel are executed that way and sequential when it's necessary. This should be expressed clearly in a format readable by the agent but also parseable by the runtime so that it knows which agents to activate and in which order. The specific format is yet to be decided — we should evaluate which one best adjusts to our purposes (e.g., DAG, YAML, annotated markdown, etc.). Also, we need to have the corresponding tests (TDD) for the builder agents to check their work. Each of these builder agents will take the corresponding task, gather all the context they need, coordinate with the other agents if necessary and proceed implementing, then running the tests, checking any left detail, commit its changes based on the standards determined, and marking the task for review. Then the task passes to the manager which reviews everything (we need to determine if waiting for all the builders that are concurrent to finish to resume the manager agent or doing it as it arrives). There's more detail on the review process on the ORCHESTRATOR_PLAN file. The manager should group everything done for the feature and then send the PR for review of the whole thing by an external reviewer agent that will check carefully everything (at first, me as the user and the oracle will make these external reviews while we tune a reviewer agent for this).

When resuming after for example a builder agent finishes, or after an explorer finishes, it's important to create an algorithm or something adaptable so that it creates a strategy for resuming the conversation. We need to account for two separate concerns: (a) the prompt cache TTL (currently ~5 minutes) — if more time than that has passed since the last response, the cache is cold and re-prefilling is expensive; and (b) context length — independently of cache, we need to decide if the accumulated context is too long and whether it's worth starting a new session with the same agent but with a summary or compaction of the previous session. We need to think this carefully, as this also affects how we log and register sessions, and also how we can use this data later for post-training. In general, this applies to any agent that aims to resume later.

We might not even need a compactor per se, maybe if we make sure the same agent logs everything it has done (like checking and updating the todo). Although this could be not enough, as there are some nuances and things learnt during the session; but for example every decision should have been documented with the reasons.  

These workflows don't invalidate what was already stated in the ORCHESTRATOR_PLAN file, it should be seen as additional ideas to create the best version possible.

## Knowledge_Base/Wiki

We need to create an LLM wiki, inspired by the idea file where Karpathy describes this idea: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f. Check this file as well as the comments there to see what people have been saying looking for useful insights we should consider when designing our own version. Here's also the original X post where he initially presented this idea: https://x.com/karpathy/status/2039805659525644595

I was already thinking in doing something like this, even integrating with Obsidian so I can visualize everything. This idea can be adapted to whatever we can think of, for example, I could have a folder where I organize my life in general and hobbies, another one focused on research and academia, another one for work related projects, another one for the system itself of agents, each agent could have its own to explore its own history, a particular one for each project, etc. It can be adapted in any way we can think of so that agents /and even myself have better access to information.

Everything started when I was reading some blogs and articles about harness engineering, I thought I needed to have this information in a condensed way, specifically extract the principles or key facts useful for our project and our own system. That's what "knowledge_extraction_prompt.md" is about; then, I started defining a skill for agents, a way for agents to condense information following certain principles and templates, with a frontmatter with basic info of the documents, tags, and other useful info that could allow to link related files, I iterated some times with this skill (I pass you Harness_Engineering.condensed*.md as examples of outputs of this iterative process), the current version lives at `skills/general/knowledge-condenser/SKILL.md`; however, what I don't like is that I think the format should be adaptable to the document(s) and its particularities, I'm not sure if having that common structure for all the different types of documents will be effective. 

I'm just showing you this in case this can be useful, I'm not really even sure if that's the best way to do it, but consider everything I've described about this knowledge base and how it should work, here and in other parts, as well as the base idea of Karpathy.

## Agents.md Files

I think I already mentioned something about this in the ORCHESTRATOR_PLAN but to reinforce the idea. We should have the Agents.md files as a way to define rules for the agents but structuring them in layers. There can be principles and rules that apply to all agents, then we can have rules explicitly for each model, and then rules particular to each project. We need to find a way to construct that set of agents.md dynamically based on that. Although considering that the Agents.md are loaded directly into context,  we must be very careful on what we add there.

## Self Evolution Strategies

There are different evolution strategies we can approach, at different levels. First, things like skills, prompts, etc. can be optimized using DSPY and GEPA (a prompt optimization algorithm) through evals, I think there's already an initial implementation of this in Hermes-Agent, we can take that as reference for our own version.

Another option would be adapting interesting approaches like LLM-based Evolution as a Universal Optimizer (https://imbue.com/research/2026-02-27-darwinian-evolver/), [The Darwin Gödel Machine](https://sakana.ai/dgm/) and other similar ideas.

Another level would be more oriented to search for efficiency and cost optimization by post-training/adapting smaller models for specific tasks, via different recent techniques like Loras, RL with environments (the harness itself and the tools would be an environment), RFT, SFT, etc. 

## Types of Projects 

The idea is that the system in the future can handle any kind of project, but first we will focus on CLI tools (useful for agents themselves), the system of agents itself, simple webapps, LLM research oriented projects in different areas (this will be clearly influenced on topics I have interest in as well as projects that increase my chance on getting certain fellowships). We need to aim first for simple projects to start testing our system and keep tackling more and more complex projects.

## Multi-Purpose CLI Tool 

I think we should facilitate access to fundamental context needed to complete successfully the given task. For that, and thinking on making things simpler, I think maybe having a cli tool that encapsulates all the basic stuff for the model, like the description of the task (which is also an md file the model can read directly if the CLI is unavailable), or checking the todo list, or seeing the rules it must follow related to the task, etc. As this cli tool is very much related to knowledge/wiki, This CLI tool could share infrastructure with the knowledge base CLI (as described by Karpathy's llm-wiki concept referenced in the Knowledge Base section). Also, I was thinking all this information should be available for the agent inside the same project folder it's working on, like inside the .p0 present in the project folder, and maybe to avoid generating noise inside the project, right after finishing (maybe we can group and migrate once each manager finishes a whole task) the tasks, all these registries associated with the session should be moved to the central folder, including the full session log.

I was also thinking about including in this CLI tool a way to do commits and related  actions, but I think that would be over-engineering as all these models are already being trained a lot to use tools like git.

## General principles I've considered to add recently and other ideas

- The simpler the better, the simpler the tools for agents, the less tokens we use without compromising content, etc. will help improve the performance; then we can start trying more complex things and evaluate performance. My thesis is that simpler tool interfaces and prompts reduce ambiguity for the model, making next-token prediction more reliable — though this needs validation.
- Everything that evolves needs to have a log or historic of changes applied to track the changes and avoid repeating errors. I was debating if for example github history would be enough, but git history is hard to query programmatically and lacks the structured context agents need, a file log is much simpler and easier to query, another option would be a db but that wouldn't be wise if we're building the knowledge base.
- Prompt Caching is key to optimize tokens. We need to ensure this is preserved in the workflows and between agents as optimal as possible.
- Every time any agent needs to take a decision, it should always follow a systematic, logical and documented process on the considerations it had, how it evaluated everything that's involved. The decisions also must be based on the set of principles that apply to that decision. The system should ensure in some way that the agent truly considers the relevant principles.
- Information fed to agents should be minimal and precise, not maximal. Complex systems should be split into specialized sub-modules, not built as omniscient agents. All knowledge must live in the repo — verbal agreements don't exist. Routing and constraints must be structural, not left to the agent's judgment. Feedback loops should be as tight as possible — we currently use a logging system to record the full reasoning chain of every query, and we've started using Codex for LLM-as-a-judge verification, but we're still far from ideal. None of this is new. In traditional software engineering, these are called separation of concerns, single responsibility principle, docs-as-code, and shift-left constraints. We're just applying them to LLM work environments now, and some people feel that warrants a new name.
- There should be a way so that we take an existing project, we gather all the feedback, errors reported, and create a super detailed collection of SPEC files, these files should also highlight the current problems reported. With that, we could start a new version of the project from scratch, addressing all the current issues from the beginning. Maybe this could be another workflow.
- Files and code should always be organized properly. I think we should avoid giant code files unmanageable by agents later.

## Other ideas

- I'd like to then experiment other approaches, maybe try to implement everything using DSPY as base with all its design patterns, or any of the approaches we discard in the process, even then we can for example take other projects as the base to start from.
- One interesting idea that came up to me was maybe using something like this https://github.com/cline/kanban or symphony so that the managers assign tasks there, but not sure it would work well.

## Other (maybe) useful references

- https://simonwillison.net/2026/Feb/23/agentic-engineering-patterns/

## Current Open Decisions (ordered by urgency)

This section compiles the main pending decisions that are intentionally still open. These are not contradictions to "fix away" prematurely; they are the highest-priority questions to resolve through iteration so we can start coding the right v0 as soon as possible.

### 1. Immediate foundation choice for v0

We need to decide what the first implementation base will be:

- Option A: orchestrate existing harnesses first (`codex`, `claude code`, `opencode`, maybe Cursor) through headless sessions, skills, and scripts.
- Option B: use `pi-agent` as the base runtime and adapt it to our needs.
- Option C: create a thin runtime-agnostic orchestration layer from the beginning that can call existing harnesses as backends.

This is the most urgent decision because it determines what we can build in the next days, how fast we can iterate, and how much of the system is prompt/skill driven vs runtime driven.

### 2. Exact scope of v0

We need to define what "good enough to start iterating" actually means for the first version.

Questions:

- What is the minimum set of capabilities that v0 must support?
- Which capabilities are explicitly deferred?
- Which project types are in scope first: the orchestrator itself, small CLI tools, simple webapps, or research prototypes?
- What does a successful first demo look like?

Without this boundary, it is too easy to overbuild or keep expanding the design space.

### 3. Orchestration contract and workflow representation

We need to decide how managers/planners express work decomposition so that both agents and the runtime can consume it reliably.

Questions:

- Should the workflow/task graph be represented as DAG, YAML, annotated markdown, or another format?
- What information must be machine-readable vs only human-readable?
- How are dependencies, concurrency, retries, escalation, and approval gates represented?
- Where do task specs, checklists, and acceptance criteria live?

This is critical because it defines how the orchestrator actually coordinates work.

### 4. Agent role taxonomy and responsibility boundaries

We need a clean, stable set of roles and names for the first version.

Questions:

- What are the canonical roles for v0?
- How do `Planner`, `Manager`, `Builder/Worker`, `Reviewer`, `Tester`, `Project Architect`, `Explorer`, and `Web Searcher` differ in responsibility and authority?
- Which roles can create tasks, spawn agents, review work, merge work, or escalate to the user?
- Which role names from this prompt should be reconciled with the names in `ORCHESTRATOR_PLANNING_PROMPT.md`?

This must be clarified early so that prompts, skills, evals, and runtime config all use the same mental model.

### 5. Spawn policy and control of agent autonomy

We need to define when agents may create or delegate to other agents.

Questions:

- Is self-spawning allowed only for orchestrator-like roles in v0?
- Under what budget, depth, retry, and scope limits can spawning happen?
- Which delegations are structural/runtime-enforced vs left to prompt policy?
- How should headless sessions be resumed, monitored, and closed?

This affects cost, control, observability, and safety.

### 6. Workspace, storage, and session layout

We need to define the concrete filesystem model for project-local state vs global state.

Questions:

- What lives in project-local `.p0` vs global `$HOME/.p0`?
- Where do specs, todos, logs, summaries, evaluations, and knowledge artifacts live during execution and after task completion?
- When should local task/session artifacts be migrated to the central store?
- How should parent/child session relationships be represented on disk?

This matters for usability, prompt-cache preservation, and future automation.

### 7. Resume strategy, context management, and caching policy

We need a practical algorithm for deciding whether to resume the same session, compact it, or restart from a summary.

Questions:

- What signals should trigger compaction vs continuation vs fresh restart?
- How do we account for prompt-cache TTL, accumulated context length, and the value of preserving raw history?
- Should each agent always maintain a structured session summary or decision log?
- What information must survive a restart to avoid repeated mistakes?

This is central to long-running agent reliability and token efficiency.

### 8. Security model and permission boundaries

We need to define what safety guarantees v0 actually enforces.

Questions:

- What level of sandboxing do we require for builders, searchers, reviewers, and external-tool agents?
- How should destructive actions, network access, web search, and secret-bearing tools be constrained?
- What tasks require explicit human approval?
- Which safety rules are enforced structurally by runtime/tooling vs only by prompt/skill instructions?

This is especially urgent for any web-searching, system-writing, or deployment-related workflows.

### 9. Review, testing, and acceptance policy

We need a concrete definition of "task complete" for builders and reviewers.

Questions:

- What must a builder always do before marking work complete?
- Which tests are mandatory, and who is responsible for creating them?
- Who reviews documentation, tests, code quality, and architectural fit?
- When do we require single review vs multi-review vs human review?

This determines how much we can trust autonomous execution.

### 10. Skill system architecture

We need to decide how sophisticated the skill-loading system should be in early versions.

Questions:

- Should skills remain simple folder-based bundles with progressive disclosure, or should we introduce structured sub-skill composition early?
- If sub-skills exist, should agents navigate them directly or should the runtime resolve them before injection?
- What metadata beyond the standard should we add?
- How are skills scoped per project, per agent, and per model?

This affects context size, usability, and maintainability.

### 11. ToDo/checklist model for agents

We need to decide how much of agent execution should be driven by explicit mutable checklists.

Questions:

- Which roles require a default immutable checklist?
- What may the agent add dynamically?
- What may the agent mark complete or delete?
- How should skill-specific feedback/reporting obligations appear in the ToDo model?

This could become one of the simplest ways to enforce reliability, but it needs a clear contract.

### 12. Knowledge base / wiki design

We need to move from high-level vision to operational rules for the knowledge layer.

Questions:

- What is the minimum useful version of the LLM wiki?
- How should documents be condensed, linked, tagged, versioned, and marked for staleness?
- What belongs in the knowledge base vs in session artifacts vs in repo docs?
- How should agents retrieve and update knowledge without flooding context?

This is important, but it should probably follow the initial runtime/workflow decisions rather than block them.

### 13. Agents.md layering and instruction assembly

We need to decide how layered rules are constructed and injected.

Questions:

- How should global, model-specific, project-specific, and role-specific rules combine?
- What should always be in `Agents.md`-style files vs what should remain outside the main prompt path?
- How do we avoid overloading context while still keeping rules explicit and structural?

This should be resolved before the instruction stack grows too large.

### 14. Eval and feedback system

We need to define how we will measure whether agents, skills, and workflows are improving.

Questions:

- What traces should be stored by default?
- What is the schema for feedback on skills, prompts, tools, and workflows?
- What benchmark tasks and rubrics should we use for the first eval loop?
- Which evals are automatic vs human-reviewed?

This is essential for self-improvement, but it depends on earlier decisions about artifacts and runtime structure.

### 15. Initial project targets under time pressure

We need to decide what we are trying to build soon enough to support fellowship/hackathon applications and fast iteration.

Questions:

- Which project should be the first real test of the orchestrator?
- What can realistically be built before the upcoming deadlines?
- Should we prioritize a useful internal CLI/orchestrator feature, a small product, or a research-oriented artifact?

This should be aligned with the v0 scope so the system is tested on something real quickly.

### 16. Longer-horizon self-evolution strategy

These are important, but they should not block v0 implementation.

Questions:

- When should DSPy/GEPA-based prompt optimization enter the roadmap?
- When do we experiment with evolutionary/self-improving agent loops?
- When do we start collecting data specifically for post-training, fine-tuning, or RL-style adaptation?
- Which of these are practical near-term research tracks vs only future possibilities?

These decisions matter, but only after the first orchestration core is working.
