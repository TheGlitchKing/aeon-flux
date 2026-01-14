---
name: setup
description: Initialize Aeon Flux plugin after installation. Creates memory directories, verifies hooks, and activates Bash Loop mode.
---

# Aeon Flux Setup

Run this command after installing the plugin to complete setup.

## Setup Steps

### 1. Create Memory Directory Structure

```bash
mkdir -p .claude/memory
touch .claude/memory/.gitkeep
```

### 2. Initialize Memory Files

Create empty memory files if they don't exist:

```bash
# Attention file for preserved context
touch .claude/memory/attention.md

# Checkpoint file for task state
touch .claude/memory/checkpoint.md

# Errors file for pattern learning
touch .claude/memory/errors.md

# Patterns file for learned behaviors
touch .claude/memory/patterns.md
```

### 3. Clear Any Stale Abort Signals

```bash
# Remove any leftover abort signals from previous sessions
rm -f /tmp/aeon-flux-abort-*
```

### 4. Verify Scripts Are Executable

```bash
chmod +x "${CLAUDE_PLUGIN_ROOT}/scripts/"*.sh 2>/dev/null || true
```

### 5. Add to .gitignore (if not already present)

Check if `.gitignore` exists and add memory files:

```bash
if [ -f .gitignore ]; then
    grep -q "\.claude/memory/" .gitignore || echo -e "\n# Aeon Flux runtime state\n.claude/memory/*.md\n!.claude/memory/.gitkeep" >> .gitignore
fi
```

### 6. Display Status

After setup, show:

```
Aeon Flux Setup Complete!

✓ Memory directory: .claude/memory/
✓ Abort signals: cleared
✓ Scripts: executable

Available commands:
  /checkpoint  - Save task state
  /resume      - Load last checkpoint
  /reflect     - Self-assessment
  /focus       - Mark attention items
  /abort       - Stop all subagents

Bash Loop mode is now active. Claude will:
- Act without explaining
- Fix errors without apologizing
- Show real output, not summaries
- Preserve critical context

Start working!
```

## Output

Return a concise confirmation that setup is complete.
