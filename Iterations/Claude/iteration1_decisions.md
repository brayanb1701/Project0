# Iteration 1 — Independent Decision Recommendations

**Analyst**: Claude (Opus 4.6)
**Date**: 2026-04-09
**Context**: These are MY recommended answers to the Oracle's open questions and other decisions that need to be made. These are informed recommendations from an independent analyst, not guesses about what Brayan would choose.

---

## Decision 1: Accept Option C?

**Decision**: Yes, but via phased implementation (A→C), not clean-room design.

**Reasoning**: Option C (thin runtime-agnostic orchestration layer) is the right architectural target. But building it from scratch before having a working end-to-end loop is risky for a solo developer with 3 weeks. The pragmatic path:
- **Phase 1 (days 1-3)**: Build Option A — shell scripts wrapping `claude -p` and `codex exec` directly. Hard-code one workflow. Get one task through the pipeline.
- **Phase 2 (days 4-7)**: Refactor toward Option C — extract the backend adapter interface from what you actually built. Define file contracts based on what you actually needed.
- **Phase 3 (days 8-14)**: Polish into the thin orchestrator layer. Add the second backend properly. This is now Option C, but grounded in real experience.

**Caveats**: If Phase 1 reveals that the backends behave very differently from expectations, the Phase 2 abstraction may need to be simpler than the Oracle proposed. Let reality shape the interface.

---

## Decision 2: Python for the orchestrator core?

**Decision**: Yes, Python.

**Reasoning**:
1. **Ecosystem**: Python has the best libraries for subprocess management, JSON/YAML parsing, markdown processing, and CLI construction (click, typer, argparse).
2. **Reference projects**: hermes-agent (Python), ypi (Python), and the Anthropic Agent SDK has a Python SDK. Codex's tooling is also Python-friendly.
3. **LLM comprehension**: Python is the language models reason about most reliably. Since agents will eventually help maintain the orchestrator itself, this matters.
4. **Iteration speed**: For a solo developer prototyping, Python is hard to beat. TypeScript would add a compilation step and a more complex dependency story for no meaningful v0 benefit.
5. **Not TypeScript because**: While OpenClaw and pi-mono use TypeScript, those are larger projects with different concerns (UI, real-time, browser integration). An orchestration layer that mostly calls subprocesses and manipulates files doesn't benefit from TypeScript's type system enough to justify the overhead.

**Caveats**: Use `uv` for dependency management (fast, modern). Consider a single-file script for v0 — no package scaffolding until there's enough code to justify it. If the orchestrator later needs high-performance concurrent execution, Rust could be evaluated for specific components, but that's v2+ thinking.

---

## Decision 3: First demo — worktree manager, dispatcher, or reviewer runner?

**Decision**: Dispatcher (Option 1), which subsumes the worktree manager.

**Reasoning**:
- The **dispatcher** is where all the real risk and learning lives: Can you format a prompt that produces a useful taskset? Does `claude -p` return structured output you can parse? Does `codex exec` actually implement the task correctly? Do logs capture what you need?
- The **worktree manager** (Option 3) is mechanically simple — `git worktree add` is one command. Building it as a standalone tool first delays the moment of truth (does the full loop work?) without reducing risk.
- The **reviewer runner** (Option 2) depends on having implementation output to review, so it naturally comes after the dispatcher.
- Implementing the dispatcher inherently requires creating worktrees (you need a workspace for the worker), so Option 1 implicitly includes Option 3.

**Concrete first demo**: `p0-run spec.md` that:
1. Reads a FEATURE_SPEC.md
2. Calls `claude -p` to generate a TASKSET
3. Creates a worktree for the first task
4. Calls `codex exec` (or `claude -p`) to implement the task in the worktree
5. Stores all logs in `~/.p0/projects/<project>/sessions/`
6. Outputs a summary

**Caveats**: The first run WILL fail. Budget 2-3 iterations of prompt refinement before it produces useful output. Success criteria for v0 is "the loop runs without crashing and produces interpretable output," not "the code it writes is correct."

---

## Decision 4: Architect as separate role or fold into Manager for v0?

**Decision**: Fold into Planner for v0.

**Reasoning**: In v0, you're working on one small project (Project0 itself or a tiny CLI). There are no architecture decisions complex enough to justify a separate role with its own prompt template, checklist, and skill set. The Planner can handle "choose repo structure, toolchain, CI" as part of the planning phase.

More broadly, I'd actually collapse the v0 role taxonomy further:
- **Planner** (= Planner + Manager + Architect): One frontier-model session that refines intent, decomposes tasks, and makes architectural decisions.
- **Worker**: Implements bounded tasks.
- **Reviewer**: Verifies work.

That's 3 roles, not 6. Each role that exists needs a prompt template, a checklist, testing, and iteration. Fewer roles = faster to v0. The Manager/Planner split and the standalone Architect can be introduced when the workload justifies them.

**Caveats**: If Project0 itself turns out to need significant architecture decisions (e.g., choosing between event-driven and synchronous design), a dedicated Architect session might be warranted. But that's a one-time session, not a standing role.

---

## Decision 5: Web research — fully deferred or document-only role?

**Decision**: Fully deferred from the automated pipeline. Human provides research context.

**Reasoning**:
- In v0, the human (Brayan) is the research layer. He's already done extensive research and has the context.
- Adding web search to the pipeline introduces the highest-risk security concern (bash + internet on the same agent) for the lowest v0 value.
- The Researcher role adds another prompt template, another skill set, another set of integration tests. For v0, this is pure overhead.
- When research IS needed, Brayan can do it interactively or spin up a manual Claude Code session.

**Caveats**: If the first real project after the internal demo requires web research (e.g., the KB project needing to fetch and process web content), re-evaluate. But even then, it should be a separate manual step, not integrated into the automated loop.

---

## Decision 6: Third experimental backend — Cursor or OpenCode?

**Decision**: Neither for now. If forced, OpenCode, but don't invest time until backends 1 and 2 work.

**Reasoning**:
- The Cursor subscription is expiring within a month. Investing engineering time into a Cursor adapter that will soon become unusable is poor allocation.
- OpenCode is a stronger long-term candidate because it's open-source, has good permission controls, and supports multiple providers. But the Oracle noted that "the older Claude Pro/Max plugin path was removed and Anthropic explicitly prohibits that usage." This limits OpenCode's value as a Claude backend.
- **The real third backend should be direct API access** (Anthropic API, OpenAI API) when budget allows. This gives you the most control and is the path to using cheaper models (OpenRouter, Kimi, etc.).
- Adding a third backend before the first two work is premature optimization. The backend adapter interface should stabilize on two implementations before adding a third.

**Regarding the expiring Cursor subscription**: Use the remaining Cursor time for **manual experimentation and comparison**, not for building an adapter. Run the same tasks manually in Cursor and compare results with Claude Code/Codex. This generates useful data about model capabilities without investing engineering time in integration code that expires.

**Caveats**: If Brayan renews the Cursor subscription or Cursor offers a CLI that's significantly better for specific task types, revisit. Also, if OpenCode resolves the Claude access issue, it becomes a stronger candidate.

---

## Additional Decisions Not Explicitly Asked by the Oracle

### Decision 7: Knowledge base as first real test project?

**Decision**: Yes, after the internal demo works.

**Reasoning**: Brayan explicitly proposed this in `prompt_iteration2_0.md`, and it's an excellent choice:
- It's a real project that the system itself benefits from.
- It's well-scoped (CRUD-like operations on markdown files with metadata).
- It tests the orchestrator on a project that isn't the orchestrator itself (important for validating generality).
- The "install 3-4 orchestrator projects and compare" idea generates valuable competitive intelligence.
- It aligns with fellowship application narratives about agentic oversight and knowledge management.

**Sequence**: Internal demo (days 1-7) → KB project as first real test (days 8-14) → fellowship-relevant refinement (days 15-21).

### Decision 8: Event-driven vs synchronous orchestrator?

**Decision**: Synchronous for v0, with event logging that enables later transition to event-driven.

**Reasoning**: A synchronous orchestrator (`run plan → wait → run worker → wait → run reviewer → wait`) is dramatically simpler to implement, debug, and reason about. Event-driven architecture is correct for production (agents finish asynchronously, multiple projects in flight), but for v0 with one project and sequential tasks, it's over-engineering.

**However**: Log every state transition as a structured event (start_task, task_complete, review_start, review_complete, etc.) so the event stream exists even if the orchestrator doesn't consume it asynchronously. This makes the transition to event-driven architecture a UI change, not a data model change.

### Decision 9: What constitutes a fellowship-demoable artifact?

**Decision**: A working CLI that takes a feature description and produces a reviewed PR, with full session logs and a narrative about the design decisions.

**Reasoning**: The fellowships care about:
- **OpenAI Safety Fellowship**: "Agentic oversight" — your review loop, safety policy enforcement, runtime-owned spawning, and escalation logic are directly relevant.
- **Astra Fellowship**: Demonstrated ability to build and reason about complex AI systems.
- **Parameter Golf**: Specific coding challenge — the orchestrator itself may not be directly relevant, but being able to quickly build a solution using your system would be.

A working demo with a clear writeup is more compelling than a sophisticated architecture without running code.

---

## Decision Summary Table

| # | Decision | Choice | Confidence |
|---|----------|--------|------------|
| 1 | Foundation approach | Option C via phased A→C | High |
| 2 | Language | Python | High |
| 3 | First demo | Dispatcher (Option 1) | High |
| 4 | Architect role | Fold into Planner for v0 | High |
| 5 | Web research | Fully deferred | High |
| 6 | Third backend | Neither for now; OpenCode if forced | Medium |
| 7 | KB as first real test | Yes, after internal demo | Medium |
| 8 | Orchestrator architecture | Synchronous for v0 | High |
| 9 | Fellowship artifact | Working CLI + writeup | Medium |
