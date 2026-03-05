# YPI Configuration Instructions

This guide explains how to configure `ypi` correctly, including whether you need to install Pi first.

## Short Answer

- `ypi` requires `pi` at runtime.
- If you install `ypi` from npm, Pi is installed as a dependency.
- If you run `ypi` from a raw git clone, you must ensure `pi` is already installed and on `PATH`.

## Prerequisites

Required:

- `node` >= 18
- `npm` (or `bun`)
- `git`
- `bash`

Optional (recommended):

- `jj` for child workspace isolation

Check:

```bash
node --version
npm --version
git --version
bash --version
jj --version
```

## Option A (Recommended): Global Install from npm

Install:

```bash
npm install -g ypi
```

This provides:

- `ypi`
- `rlm_query`
- `rlm_cost`
- `rlm_sessions`
- Pi runtime dependency

Verify:

```bash
pi --version
ypi -p "Reply exactly: ypi ready"
```

## Option B: Run from Cloned Repository

If you want to run from `Research/ypi` directly:

1. Install Pi globally:

```bash
npm install -g @mariozechner/pi-coding-agent
```

2. Add local `ypi` scripts to `PATH` for the current shell:

```bash
cd /home/brayan/Project0/Research/ypi
export PATH="$PWD:$PATH"
```

3. Verify:

```bash
pi --version
ypi -p "Reply exactly: local mode ok"
```

## Provider Authentication (Required Before Real Use)

Use either API keys or interactive login.

### API key method

Example with Anthropic:

```bash
export ANTHROPIC_API_KEY=sk-ant-...
```

Example with OpenAI:

```bash
export OPENAI_API_KEY=sk-...
```

Make it persistent by adding to your shell profile (`~/.bashrc` or `~/.zshrc`), then reload:

```bash
source ~/.bashrc
```

### Subscription/OAuth method (Pi interactive)

```bash
pi
/login
```

Then select provider and model.

## First Run

Interactive:

```bash
ypi
```

One-shot:

```bash
ypi "Summarize this repository architecture"
```

Choose provider/model explicitly when needed:

```bash
ypi --provider anthropic --model claude-sonnet-4-5-20250929 "What does this repo do?"
```

## Recommended Guardrails

Set these before long or recursive tasks:

```bash
export RLM_MAX_DEPTH=3
export RLM_MAX_CALLS=20
export RLM_TIMEOUT=1800
export RLM_BUDGET=1.50
export RLM_CHILD_MODEL="<cheaper-child-model>"
```

Optional:

```bash
export PI_TRACE_FILE=/tmp/ypi-trace.log
```

## Useful Runtime Commands

Current accumulated spend:

```bash
rlm_cost
rlm_cost --json
```

Inspect recursive session tree:

```bash
rlm_sessions --trace
rlm_sessions read --last
```

## Troubleshooting

`pi: command not found`

- Install Pi: `npm install -g @mariozechner/pi-coding-agent`
- Ensure npm global bin is in `PATH`

`ypi: command not found`

- Install `ypi`: `npm install -g ypi`
- Or add repo path: `export PATH="/home/brayan/Project0/Research/ypi:$PATH"`

Auth/model errors

- Confirm API key env var is exported in current shell
- Or run `pi` then `/login`

No workspace isolation

- Install `jj`
- Ensure you are inside a `jj` repo/workspace when running `ypi`

