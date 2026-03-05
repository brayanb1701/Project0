# Projects to analyze

These two are particular because it's like the SOTA of agent harnesses, the idea is to analyze them and give a detailed view on how it works, particularly according to our features.

- https://github.com/openai/codex
  Add web version through search using the llms.txt (https://developers.openai.com/codex/llms.txt). I think here we should focus on understanding how we can use non-interactive mode, if they manage any sort of worktrees, how they use skills and multiagents, etc.

- https://github.com/anthropics/claude-code
  Add web version through search using the llms.txt (https://code.claude.com/docs/llms.txt). I think here we should focus on understanding how we can use non-interactive mode (check if usable with plan or requires API key), if they manage any sort of worktrees, how they use skills and multiagents, etc. Create another file exclusively for the skills that might be useful for our project and needs.

Some things we need to check on every agent orchestrator project:

1. Access to models/providers (if API, OAUTH with suscriptions, etc)
2. API structure or way to call models (OpenAI API style, Anthropic, etc). This is important considering different features like interleaved thinking with Claude.
3. Security and Isolation (Worktrees, etc.).
4. Types of predefined agents and orchestration between them (like use of some Protocol).
5. Noticeable features that have similarities with the ones we desire.
6. Interesting features not related but that could improve the system overall.
7. Particular sections or topics highlighted for each project by us to analyze specifically, if any.
8. Limitations 
9. Maintenance, good practices in the project, etc.

The "template" or guide for the final output should be flexible enough so that it can include any other relevant information not present in the list. 

- https://github.com/badlogic/pi-mono | AI agent toolkit: coding agent CLI, unified LLM API, TUI & web UI libraries, Slack bot, vLLM pods. Most versatile, with the idea of code that builds itself (see agent-stuff repo for examples of extensions and skills that can be implemented). 
  This is the whole repo, but we will focus on packages/coding-agent. I really like the philosophy (check Pi-blog.md to read the , I think it's something that will evolve as models evolve. It's important to understand the different ways it has to expand itself and if it's possible to implement all our desired features or how can we expand it preserving the core ideas and philosophy. Here, I know we start in yolo mode so we'd need to add the security part too. I think this is a good base for something that can even self evolve.
- https://github.com/can1357/oh-my-pi | AI Coding agent for the terminal — hash-anchored edits, optimized tool harness, LSP, Python, browser, subagents, and more (Based on PI Agent).
  This one is basically Pi but already modified with a lot more features (for example I like the browser tool). My main concern or thing to analyze is if all these changes preserve the philosophy of Pi, or if there's a better way to implement. Also I know there are things that we'd need to modify as there are things that are done differently. We need to analyze what matches what we want and what's different.
- https://github.com/agusx1211/adaf | adaf is a meta-orchestrator for AI coding agents. It manages plans, issues, wiki, session logs, and deep session recordings outside the target repository, so multiple AI agents can collaborate on a codebase via structured relay handoffs.
  From what I saw quickly, the most interesting part is that it implements some similar loops as well as some agent profiles/roles. Look at those and describe how are they implemented.
- https://github.com/NousResearch/hermes-agent | The fully open-source AI agent that grows with you. Install it on a machine, give it your messaging accounts, and it becomes a persistent personal agent — learning your projects, building its own skills, running tasks on a schedule, and reaching you wherever you are. An autonomous agent that lives on your server, remembers what it learns, and gets more capable the longer it runs.
  There are a lot of features that I like about this project, specially I want you to explore features that make unique this agent, one that caughts my attention is that as I understood, it's built to help running RL and SFT experiments through their framework that connects to Tinker.
- https://github.com/Git-on-my-level/codex-autorunner | CAR provides a set of low-opinion agent coordination tools for you to run long complex implementations using the agents you already love. CAR is not a coding agent, it's a meta-harness for coding agents.
  What I like about this one is the simple ticket system. I want you to dig into this and explain advantages and possible limitations, and think about how we could incorporate it into our system.
- https://github.com/njbrake/agent-of-empires | A terminal session manager for AI coding agents on Linux and macOS. Built on tmux, written in Rust. Run multiple AI agents in parallel across different branches of your codebase, each in its own isolated session with optional Docker sandboxing. 
  I think this is an example of orchestratos based on tmux sessions to call each CLI, simple but somewhat effective. The possible limitations I see rn are that maybe it could be more difficult to trace everything and logging, but it's important to think deeply on the advantages and disadvantages this implementation has.

## Particular cases

- https://github.com/openai/symphony/tree/main | Symphony turns project work into isolated, autonomous implementation runs, allowing teams to manage work instead of supervising coding agents.
  
  ​	This is a completely new repo released by OpenAI and I think that it might be very helpful as a base for workflows definitions adjusted to our own needs, it's important to think how we could adapt this to our own project, we need to understand very well how the workflows are implemented here to understand how we can use them and expand them. This repository is very important as it even includes a SPEC.md that already has all the details for a personal implementation by an agent, I'm not sure if this system would be per project, or it could be general across different projects, we need to determine that too. Algo, I'd like to understand why they used Elixir as the official example for implementation, is there any advantage of using that language (maybe something related that it's functional? Idk)
  
- https://github.com/openclaw/openclaw | OpenClaw is a personal AI assistant you run on your own devices. It answers you on the channels you already use (WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, iMessage, Microsoft Teams, WebChat), plus extension channels like BlueBubbles, Matrix, Zalo, and Zalo Personal. It can speak and listen on macOS/iOS/Android, and can render a live Canvas you control. The Gateway is just the control plane — the product is the assistant (Based on pi-agent).
  
  ​	This is the most famous AI assistant, it has a loooot of features, we don't need them immediately but it's worth looking at them to sort them in some way based on priority and usefulness. It's also known that the codebase is huge, so I wouldn't take it as a base directly for the project. This is also more for understanding how we can evolve for the personal assistant in the future
  
- https://github.com/mitsuhiko/agent-stuff/tree/main | This repository contains skills and extensions that I use in some form with projects. Note that I usually fine-tune these for projects so they might not work without modification for you.

  ​	The idea with this repo is to check examples of skills and extensions that might be useful to create our workflows and the rest of the features we need. The idea is to select and analyze everything that could be useful for our purposes.

- https://github.com/rawwerks/ypi| ypi — a recursive coding agent built on Pi, based on RLMs.

  ​	Understand how it uses pi agent, and if it respects the philosophy of the project. Also detail how it's implemented and compare to the original implementation of the RLM paper to find any relevant differences .