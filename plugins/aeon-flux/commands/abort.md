---
name: abort
description: Create or clear abort signal to stop all subagents. Use when you need to halt all running operations immediately.
---

# Abort Command

Manage the abort signal that stops all subagent tool execution.

## Usage

```
/abort         - Set abort signal (stop all operations)
/abort set     - Same as above
/abort clear   - Clear abort signal (resume operations)
/abort status  - Check if abort signal is active
```

## How It Works

Due to Claude Code limitations with Ctrl+C/Escape not reliably stopping subagents,
this command uses a **signal file pattern**:

1. `/abort` creates a signal file at `/tmp/aeon-flux-abort-{project-hash}`
2. The `PreToolUse` hook checks for this file before every tool execution
3. If the file exists, tool use is blocked with "User abort signal active"
4. `/abort clear` removes the signal file, resuming normal operation

## Execution

### /abort (or /abort set)

```bash
#!/bin/bash
PROJECT_HASH=$(echo "$CLAUDE_PROJECT_DIR" | md5sum | cut -c1-8)
echo "User requested abort" > "/tmp/aeon-flux-abort-$PROJECT_HASH"
```

Output:
```
Abort signal SET.
All tool uses blocked until cleared.
Run /abort clear to resume.
```

### /abort clear

```bash
#!/bin/bash
PROJECT_HASH=$(echo "$CLAUDE_PROJECT_DIR" | md5sum | cut -c1-8)
rm -f "/tmp/aeon-flux-abort-$PROJECT_HASH"
```

Output:
```
Abort signal CLEARED.
Normal operation resumed.
```

### /abort status

Output (if active):
```
Abort signal: ACTIVE
Run /abort clear to resume.
```

Output (if inactive):
```
Abort signal: INACTIVE
Normal operation.
```

## Limitations

- Cannot stop in-flight API calls
- Only prevents NEXT action from starting
- Signal persists until cleared or new session

## When to Use

- Runaway subagents
- Wrong direction, need to stop and redirect
- Emergency stop when Ctrl+C/Escape doesn't work
