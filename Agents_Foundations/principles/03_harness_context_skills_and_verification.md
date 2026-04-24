# Harness, Context, Skills, and Verification
> Purpose: current invariant layer
> Scope: runtime design for coding agents
> Status markers: `Core` / `Default` / `Conditional` / `Experimental`

**Legend:** `P` = Principle · `E` = Example / Fact · `A` = Agent-specific

---

## Harness Engineering

`[HC-01][Core]` `P` **Many agent failures are harness failures before they are model failures.** The runtime surface — tools, context, skills, hooks, subagents, verification, and control flow — often determines whether today's models succeed.

`[HC-02][Default]` `P` **Start simple and add harness complexity in response to real repeated failures.** Do not try to design the perfect harness upfront.

`[HC-03][Core]` `P` **Harness engineering is context engineering in operational form.** The runtime should shape what the model sees, what it can do, and how it verifies itself.

---

## Context Control

`[HC-04][Core]` `P` **Subagents are primarily for context isolation, not roleplay.** Their main value is to keep search noise, tool chatter, and investigative detours out of the parent thread.

`[HC-05][Default]` `P` **Long context is slack, not the strategy.** Larger windows help, but they do not replace better isolation, compaction, and progressive disclosure.

`[HC-06][Default]` `P` **Offload noisy investigation into durable distilled artifacts.** Use separate sessions or tools to search, verify, and explore, then return only the signal and store it in a file when it is likely to matter again.

`[HC-06.A]` `A` Persistent distilled artifacts turn ephemeral context spending into reusable repo knowledge.

---

## Tools, Skills, and Capability Surfaces

`[HC-07][Core]` `P` **Every tool is also prompt surface area.** Tool descriptions, schemas, and available actions shape the model's behavior and consume instruction budget.

`[HC-08][Default]` `P` **Too many tools degrade performance.** Keep only the tools that matter, progressively disclose large inventories, and prefer thin wrappers when you use only a small subset.

`[HC-09][Core]` `P` **Treat MCP servers and skill bundles as trust boundaries.** They can inject behavior and may execute code. Connect and install only what you would trust on your machine.

`[HC-10][Core]` `P` **Skills are reusable knowledge-and-capability bundles, not just markdown.** A strong skill can include files, scripts, templates, references, examples, state, and hooks.

`[HC-11][Default]` `P` **Use skills for progressive disclosure.** Put detailed references, examples, templates, and scripts behind a concise entry file so the agent loads them only when needed.

`[HC-12][Default]` `P` **The highest-signal part of a skill is its non-obvious local guidance.** Focus skills on gotchas, local conventions, verification paths, and helper assets the model would not infer reliably on its own.

---

## Hooks and Deterministic Control Flow

`[HC-13][Core]` `P` **Do not use prompts for control flow when the harness can enforce it deterministically.** Use hooks, lifecycle events, permissions, and structured runtime transitions for actual control flow.

`[HC-14][Default]` `P` **Hooks should be silent on success and loud only on actionable failure.** Passing checks should not flood context; failing checks should re-engage the agent with just enough error detail to continue.

`[HC-15][Default]` `P` **Use hooks to encode local guardrails and integrations.** Approvals, notifications, preview creation, dangerous-command denial, and automatic verification are good hook territory.

---

## Verification and Back-Pressure

`[HC-16][Core]` `P` **Closed-loop verification is one of the highest-leverage investments.** The more directly the agent can test, inspect, and validate its own work, the more reliable the whole loop becomes.

`[HC-17][Core]` `P` **Verification must be context-efficient.** Swallow success, surface failures, and prefer the smallest validation slice that still gives real signal.

`[HC-18][Conditional]` `P` **Review rigor should scale with risk.** Non-critical code can move with lighter review when feedback loops are strong. Critical or cross-cutting code needs deeper review and stronger deterministic enforcement.

`[HC-19][Default]` `P` **Persistent verification skills are worth deep investment.** Strong verification assets often compound more than clever prompting does.

---

## Anti-Patterns

- Blaming the model before checking the runtime surface and feedback loops.
- Installing many tools and skills “just in case”.
- Using anthropomorphic subagent roles instead of scoped isolation tasks.
- Treating huge context windows as the main answer to complexity.
- Flooding the parent session with passing logs, grep output, or verbose tool chatter.
- Encoding real control flow only in prose instructions when the harness could enforce it.
