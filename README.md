# Aeon Flux

A Claude Code plugin that makes Claude **faster, smarter, and more reliable** by implementing the Bash Loop architecture.

> Inspired by Geoffrey Huntley's "Ralphy Loop" - enhanced with solutions for its known limitations.

---

## What Does This Do?

Aeon Flux changes how Claude Code behaves:

| Before (Default Claude) | After (Aeon Flux) |
|------------------------|-------------------|
| "Let me explain what I'm going to do..." | *Just does it* |
| "I apologize for the error..." | *Fixes it silently* |
| "Here's a summary of the output..." | *Shows actual output* |
| Forgets important context | Preserves critical info |
| Can't reliably stop subagents | `/abort` command works |

**In short:** Claude talks less and does more.

---

## Installation (Easy Mode)

### Step 1: Open your terminal

### Step 2: Run these two commands

```bash
claude /plugin add github.com/TheGlitchKing/aeon-flux
```

```bash
claude /plugin install aeon-flux
```

### Step 3: Done!

The plugin is now active. Start a new Claude Code session to use it.

---

## Installation (Manual/Local)

If you want to modify the plugin or install from a local copy:

```bash
# Clone the repo
git clone https://github.com/TheGlitchKing/aeon-flux.git

# Go into the folder
cd aeon-flux

# Install locally
claude /plugin install ./
```

---

## The Bash Loop Philosophy

The "Bash Loop" (aka "Ralphy Loop") is an agent architecture created by Geoffrey Huntley. The core idea:

```
See → Act → Observe → Repeat
```

> "The more you can get the model to just shut up and do the thing, the better off you are."

### Core Principles

1. **Action over explanation** - Execute commands, don't describe them
2. **Bash first** - Use raw shell commands, not abstractions
3. **Self-correction** - Fix errors immediately without apologies
4. **Tight feedback loop** - See output, decide next action, repeat

---

## Improvements Over the Original Ralphy Loop

The original Bash Loop has known limitations. Aeon Flux fixes them:

| Limitation | Problem | Aeon Flux Solution |
|------------|---------|-------------------|
| **Context Exhaustion** | Loop runs out of memory on long tasks | Checkpointing system + attention preservation |
| **No Hierarchical Planning** | Flat loops can't handle complex tasks | Orchestrator agent for task decomposition |
| **Memory Loss** | Knowledge lost between sessions | Persistent memory files + PreCompact hooks |
| **Single-Agent Bottleneck** | One agent doing everything | 4 specialized agents (executor, verifier, learner, orchestrator) |
| **Error Spirals** | Repeats same mistakes | Error capture + pattern learning |
| **Can't Stop Subagents** | Ctrl+C/Escape don't work reliably | Signal file abort system (`/abort` command) |
| **No Self-Assessment** | No way to detect when stuck | `/reflect` command for self-evaluation |

### New Features

- **Attention Tags**: Mark critical info with `<!-- ATTENTION -->` tags - survives context compaction
- **Checkpointing**: Save and resume task state across sessions
- **Abort System**: Reliable way to stop all subagents when Ctrl+C fails
- **Verification Loop**: Auto-suggests tests after code changes
- **Pattern Learning**: Extracts lessons from errors to avoid repeating them

---

## Commands

| Command | What It Does |
|---------|--------------|
| `/checkpoint` | Save your current task state |
| `/resume` | Load the last checkpoint and continue |
| `/reflect` | Make Claude assess if it's stuck or making progress |
| `/focus <item>` | Mark something important to remember |
| `/abort` | Stop all running subagents immediately |
| `/abort clear` | Resume normal operation after abort |
| `/abort status` | Check if abort is active |

---

## Agents

Aeon Flux includes 4 specialized agents:

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| **executor** | Pure action, no explanation | Any bash/file task |
| **verifier** | Runs tests, checks code | After making changes |
| **learner** | Extracts patterns from errors | After repeated mistakes |
| **orchestrator** | Breaks big tasks into steps | Complex multi-step work |

---

## Skills

Skills activate automatically when relevant:

| Skill | Triggers When |
|-------|---------------|
| **bash-loop** | Any task needing shell commands |
| **error-recovery** | An error occurs |
| **context-preservation** | Long session or before compaction |
| **verification** | After code edits |

---

## The Abort System

Claude Code has a bug where Ctrl+C and Escape don't reliably stop subagents ([Issue #3455](https://github.com/anthropics/claude-code/issues/3455)).

Aeon Flux works around this with a **signal file pattern**:

1. Run `/abort` - creates a signal file
2. Every tool use checks for the signal file first
3. If found, the tool is blocked
4. Run `/abort clear` to resume

```bash
# Emergency stop
/abort

# Check status
/abort status

# Resume work
/abort clear
```

---

## How Context Preservation Works

### The Problem
When conversations get long, Claude Code "compacts" (summarizes) old messages. Important details can get lost.

### The Solution
Mark critical information with attention tags:

```markdown
<!-- ATTENTION -->
Database connection string is in .env.local
Tests require REDIS_URL environment variable
User prefers pnpm over npm
<!-- /ATTENTION -->
```

The `PreCompact` hook automatically saves these to `.claude/memory/attention.md` before compaction.

---

## File Structure

```
aeon-flux/
├── CLAUDE.md              # Philosophy injection
├── commands/              # 5 slash commands
├── agents/                # 4 specialized agents
├── skills/                # 4 auto-activating skills
├── hooks/hooks.json       # Event automation
└── scripts/               # Shell scripts for hooks
```

Runtime state (gitignored):
```
.claude/memory/
├── attention.md           # Preserved critical info
├── checkpoint.md          # Task state
├── errors.md              # Error history
└── patterns.md            # Learned behaviors
```

---

## Requirements

- Claude Code 2.0.13 or newer
- Bash shell
- md5sum (pre-installed on most systems)

---

## Credits

- **Bash Loop / Ralphy Loop concept**: Geoffrey Huntley
- **Aeon Flux implementation**: Built with Claude Opus 4.5

---

## License

MIT

---

## Links

- [Original Bash Loop Video](https://www.youtube.com/watch?v=O2bBWDoxO4s)
- [Bash Loop Limitations Discussion](https://www.youtube.com/watch?v=yAE3ONleUas)
- [Claude Code Interrupt Bug #3455](https://github.com/anthropics/claude-code/issues/3455)
