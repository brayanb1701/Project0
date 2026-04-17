You’ve already done the hard part: your notes converge on the right invariants. The strongest ones are that agents start cold, context is scarce, repo-local artifacts must be the source of truth, progressive disclosure beats monolithic manuals, and important rules should be mechanically enforced rather than left in prose.

My current judgment is:

**Build v0 as a thin runtime-agnostic orchestration layer, not as a deep fork of pi or any single harness.**
Under that layer, use **official backends first**:

- **Claude Code** for planning / intent clarification / some review
- **Codex** for implementation / verification / review
- **Cursor or OpenCode** only as optional third experimental backends, not as blockers for v0

That recommendation is mostly driven by the live tool situation. Claude Code now has an official programmatic path via `claude -p` and the Agent SDK, including Python/TypeScript SDKs, structured output, continuation, and a `--bare` mode that Anthropic explicitly recommends for scripted runs. Anthropic’s own compliance docs also say OAuth subscription auth is for ordinary native Claude Code / Anthropic app use, and that third parties should use API keys rather than routing user Pro/Max credentials. ([Claude](https://code.claude.com/docs/en/headless))

That means your instinct to keep Claude in the stack is good, but the safe way to do it is **through official Claude Code surfaces**, not by making a third-party runtime the primary foundation. On the Codex side, OpenAI’s official docs already give you `codex exec`, default read-only sandboxing, JSONL event output, resume support, and ChatGPT-plan access, which is exactly the kind of official automation surface you want under an orchestrator. ([OpenAI Developers](https://developers.openai.com/codex/noninteractive))

For inspiration and selective reuse, I would borrow patterns, not foundations. Symphony is especially useful as a reference for separating **policy** from **runtime**: repo-owned workflow files, isolated per-issue workspaces, structured logs, and a scheduler that does not hardcode business logic into the core. adaf remains valuable for the “logs/state outside target repo” pattern. OpenCode is a strong reference for permission grammar, headless modes, and agent/subagent configuration, but not the safest primary base if Claude subscription access matters, since OpenCode’s docs now say the older Claude Pro/Max plugin path was removed and Anthropic explicitly prohibits that usage. ([GitHub](https://github.com/openai/symphony/blob/main/SPEC.md))

So my current answers to your highest-priority open decisions are:

1. **Immediate foundation choice:** Option C. Thin orchestrator layer now. Official Claude Code + Codex adapters first. pi stays in the design space as a future backend/reference, not the v0 anchor.
2. **Exact v0 scope:** coding orchestration only, one project at a time, one small end-to-end loop, no broad assistant features yet.
3. **Workflow representation:** markdown files with YAML frontmatter. I would start with `FEATURE_SPEC.md`, `TASKSET.md`, `TASK.md`, `REVIEW.md`, and `SESSION_SUMMARY.md`.
4. **Role taxonomy:** freeze on `Planner`, `Manager`, `Architect`, `Worker`, `Reviewer`, `Researcher`. Retire the overloaded “Builder” naming by mapping implementation to `Worker` and keeping `Architect` distinct.
5. **Spawn policy:** runtime-owned spawning only; `Manager` can spawn, `Worker` and `Reviewer` cannot in v0.
6. **Workspace/storage:** active project-facing artifacts in `repo/.p0/`; heavy logs, archives, evals, and worktrees in `~/.p0/`.
7. **Resume/caching policy:** never switch model/backend mid-session; resume only when backend/model/role stay the same, otherwise restart from `SESSION_SUMMARY.md` + `DECISIONS.md` + `TODO.md`. This follows the caching lessons you collected.
8. **Security:** no agent gets both general bash/code execution and web search by default; code-writing tasks use worktrees from day one; backend permission modes plus wrapper-level policies. OpenCode’s permission model is a good design reference here, and Codex/Claude already expose official automation controls. ([OpenCode](https://opencode.ai/docs/permissions/))
9. **Review/testing:** one reviewer first, deterministic checks first, human escalation for S2/S3 and the first calibration runs. Multi-model consensus later.
10. **Skills:** keep the Agent Skills standard intact, add optional `p0.*` metadata, and prefer **runtime-side skill resolution** over free agent navigation through subskills. That aligns with the spec and with the Anthropic lessons about high-signal, folderized skills with progressive disclosure and gotchas. ([Agente Habilidades](https://agentskills.io/home))
11. **ToDo/checklists:** one runtime-generated `TODO.md` per session with an immutable core checklist plus mutable task-derived items.
12. **Knowledge base/wiki:** do a **project-scoped** Karpathy-style mini-wiki now, not the full personal second brain yet. The gist itself supports this interpretation: raw sources, wiki, schema. Visible discussion on the gist also surfaced useful refinements around deterministic retrieval, confidence-tagged claims, and resolving links against known entities instead of guessing them. ([Gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f))
13. **Agents.md layering:** assemble global invariants + model/backend rules + project map + role rules + task handoff, instead of stuffing everything into one giant file.
14. **Eval system:** log first, benchmark second. Build a tiny real-task eval set only after the first loop works.
15. **Initial project target:** Project0 itself, but only one thin vertical slice. The first demo should be something like “spec → taskset → worktree → worker run → review artifact”.
16. **Longer-horizon self-evolution:** explicitly deferred, but preserved. Your ideas around DSPy/GEPA, Darwinian evolvers, and post-training data are worth keeping in the parking lot, not throwing away. ([Imbue](https://imbue.com/research/2026-02-27-darwinian-evolver/))

The single biggest correction I’d make to your current design is this: **models should not own backend invocation or agent spawning in v0; the runtime should.**
Let models produce plans, task graphs, reviews, and delegation requests. Let the runtime decide whether to launch Claude Code, Codex, or another backend, how to name the session, where to store logs, what permissions to attach, and how retries/escalations happen. That one shift simplifies control, cost accounting, safety, and reproducibility.

On your communication style: the content quality is high, but future packets will go much faster if you separate them into four blocks only:
**frozen decisions**, **open questions**, **current repo state**, and **target artifact for this iteration**.
Right now your prompt mixes stable requirements, speculative future ideas, and historical notes. That’s valuable for onboarding, but it slows decision-forcing.

I checked the critical links for this iteration. I could directly access the Project0 repo, Claude Code docs, Codex docs, OpenCode docs, Symphony repo/SPEC, Karpathy’s gist, OpenAI Safety Fellowship, Astra Fellowship, Parameter Golf repo, and GitHub Copilot docs. Cursor docs were only **partially** accessible here: I could confirm the existence of CLI/headless/ACP/skills docs from search/index results, but opening those pages did not return parsed body text in this environment. I also could not get a usable parse of Karpathy’s original X post, so I relied on the gist and the visible gist discussion instead. The Parameter Golf repo was accessible, but I did **not** verify the April 30 deadline from the repo page itself. ([GitHub](https://github.com/brayanb1701/Project0))

I also verified the fellowship timing you care about: the OpenAI Safety Fellowship application closes **May 3** and explicitly includes **agentic oversight** among its priority areas, and Astra also shows **May 3 at 11:59pm AoE** on the current program page. That makes your instinct right: the best near-term move is a small but credible orchestrator slice you can demo and explain clearly. ([OpenAI](https://openai.com/index/introducing-openai-safety-fellowship/))

I created four markdown artifacts so this session compounds instead of disappearing into chat history:

- [Foundation recommendation](sandbox:/mnt/data/p0_iteration1_foundation_recommendation.md)
- [Backlog and next steps](sandbox:/mnt/data/p0_iteration1_backlog_and_next_steps.md)
- [Parking lot for retained-but-deferred ideas](sandbox:/mnt/data/p0_iteration1_parking_lot.md)
- [Session handoff summary](sandbox:/mnt/data/p0_iteration1_session_handoff.md)

The next best move is for you to answer only three things: whether you accept **Option C**, whether **Python** is acceptable for the thin orchestrator core, and whether the first demo should be the **worktree manager** or the **dispatcher**.