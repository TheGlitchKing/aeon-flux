# Aeon Flux

A Claude Code plugin implementing **Bash Loop** (Ralphy Loop) principles for maximum efficiency.

> Inspired by Geoffrey Huntley's Bash Loop architecture for AI agents.

## What is Bash Loop?

The Bash Loop is an agent architecture where Claude operates in a tight feedback cycle:

```
See → Act → Observe → Repeat
```

Key principles:
- **Action over explanation** - Do, don't describe
- **Bash first** - Raw shell commands over abstractions
- **Self-correction** - Fix errors immediately, no apologies
- **Context preservation** - Critical info survives compaction

## Installation

### From Marketplace
```bash
claude /plugin add github.com/yourname/aeon-flux-marketplace
claude /plugin install aeon-flux
```

### Local Development
```bash
cd /path/to/aeon-flux
claude /plugin install ./
```

## Features

### Commands
| Command | Description |
|---------|-------------|
| `/checkpoint` | Save task state for resumption |
| `/resume` | Load last checkpoint |
| `/reflect` | Trigger self-assessment loop |
| `/focus <item>` | Mark item for attention preservation |
| `/abort` | Soft-kill all running subagents |
| `/abort clear` | Resume after abort |

### Agents
| Agent | Purpose |
|-------|---------|
| `executor` | Pure bash loop execution |
| `verifier` | Test-after-action validation |
| `learner` | Extract patterns from errors |
| `orchestrator` | Task decomposition |

### Skills
| Skill | Activates When |
|-------|----------------|
| `bash-loop` | Any task requiring shell commands |
| `error-recovery` | Errors encountered during execution |
| `context-preservation` | Long sessions, pre-compaction |
| `verification` | After code changes |

### Hooks
| Event | Action |
|-------|--------|
| `SessionStart` | Load context, clear abort signals |
| `PreToolUse` | Check abort signal (soft-kill gate) |
| `PreCompact` | Preserve attention-marked content |
| `PostToolUse[Bash]` | Capture and learn from errors |
| `PostToolUse[Edit]` | Trigger verification |
| `Stop` | Auto-checkpoint, quality gate |

## Abort System

Due to Claude Code limitations with Ctrl+C/Escape ([#3455](https://github.com/anthropics/claude-code/issues/3455)),
this plugin implements a **signal file pattern** for reliable subagent termination:

```bash
# Stop all subagents
/abort

# Resume normal operation
/abort clear

# Check status
/abort status
```

This creates a signal file that blocks all subsequent tool uses until cleared.

## Philosophy

From the original Bash Loop concept:

> "The more you can get the model to just shut up and do the thing, the better off you are."

This plugin enforces:
1. Minimal narration
2. Direct action
3. Real output (not summaries)
4. Immediate error correction
5. Context-aware preservation

## Configuration

The plugin uses these files for state:
- `.claude/memory/attention.md` - Preserved context
- `.claude/memory/checkpoint.md` - Task state
- `.claude/memory/errors.md` - Error patterns
- `.claude/memory/patterns.md` - Learned behaviors

## Requirements

- Claude Code 2.0.13+
- Bash shell
- md5sum (for abort signal hashing)

## License

MIT
