## Mario Zechner's (creator of Pi coding agent) views and ideas:

- Large Context Windows are a hack and agentic search fail **(HYPOTHESIS: agentic search still only works when it's guided by a human)**

- Agents patch locally, break things globally. For example: 

  ​    // Fixes race condition

  ​    setTimeout(()=>{ ... }, 100)

- Can't trust your 400k LOC code nor 600k LOC tests anymore

- Cap generated code to what the user can actually review.

- Non-critical code? Go nuts. Critical code? Review every line.

### Properties of good agent tasks:

- Scoped such that agent doesn't need to gobble up tons of code
- Closed loop: agent can evaluate its own work
- Not mission critical (dashboards, debugging tools, ...)
- Boring stuff or things you'd never have time to try
- Reproduction cases from user issues
- Rubber duck to bounce ideas against in lieu of human
- You evaluate, take what's reasonable, finalize

## Earendil talk

- Goal: Small PRs.
- Your codebase is infrastructure for the agent, design it that way.

### Why Agent Code Drifts: 

- Agents are optimized to produce code that runs
- They over-protect locally: catching exceptions broadly, falling back to defaults
- This is the opposite of good design: failures should propagate up, not be swallowed
- A service silently running with wrong config is worse than a service that refuses to start
- Multiply across a codebase and failure modes become invisible

**(COMMENT: The harness/orchestrator layer should aim to reduce the effects of this)**

Messier codebase -> worse agent recall -> more duplication -> more mess (Entropy is self-reinforcing)

### Where agents excel:

Clearly defined problem, compact API surface, tight constraints, a legible and stable core to plug into

### Where agents struggle: 

Interacting concerns (flags, permissions, billing), no single file owns a feature, context window can't hold the full picture, locally reasonable but globally incoherent

### Agent-Legible Codebase:

- Modularization with clear boundaries: agents work in one area without corrupting another.
- Known patterns and conventions: agents pattern-match; give them patterns worth matching.
- Simple core, complexity pushed to layers above.
- No hidden magic: if the agent can't see it, it can't respect it

### Example Mechanical Enforcement:

- No bare catch-alls: forces the agent to think about error handling.
- No raw SQL outside the abstraction layer: preserves the query interface.
- No raw input boxes in the UI: forces use of the component library
- No dynamic imports
- Unique function names enforced: nudges toward discovery over duplication
- erasableSyntaxOnly TypeScript mode

### Where Speed actually helps

High leverage: exploring product directions, shipping prototypes and onboarding experiments quickly, debugging concrete failures, fixing CI and regressions, creating reproduction cases, reducing time to first draft.

Low leverage: reliability, consistency, shared understanding, long-lived systems with many interacting states, code you have not specified clearly yourself, anything where cleanup cost arrives later.