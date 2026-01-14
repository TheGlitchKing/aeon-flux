---
name: resume
description: Load the last checkpoint and resume work from saved state. Reads from .claude/memory/checkpoint.md
---

# Resume Command

Load the last checkpoint from `.claude/memory/checkpoint.md` and continue work.

## Execution Steps

1. **Read Checkpoint**
   ```bash
   cat .claude/memory/checkpoint.md
   ```

2. **Read Attention Items**
   ```bash
   cat .claude/memory/attention.md
   ```

3. **Present State**
   Briefly show:
   - What was the task
   - What's completed
   - What's next
   - Any blockers or critical context

4. **Continue**
   Ask: "Continue with next step?" or begin immediately if clear.

## Output Format

```
## Resuming from checkpoint

**Task**: [task description]
**Progress**: X/Y steps complete
**Next**: [next step]

[Any critical context from attention.md]

Continuing...
```

## If No Checkpoint Exists

```
No checkpoint found. Start a new task or use /checkpoint to save current state.
```

## Usage

User invokes: `/resume`

Response: Load checkpoint, show state briefly, continue work.
