#!/bin/bash
# Aeon Flux - Stop Gate Hook
# Quality gate and auto-checkpoint on session stop

# Read input from Claude Code
read -r INPUT 2>/dev/null || INPUT="{}"
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"

# Memory files
MEMORY_DIR="$PROJECT_DIR/.claude/memory"
mkdir -p "$MEMORY_DIR"

CHECKPOINT_FILE="$MEMORY_DIR/checkpoint.md"
TIMESTAMP=$(date -Iseconds)

# Auto-checkpoint on stop
{
    echo "---"
    echo "checkpoint_time: $TIMESTAMP"
    echo "trigger: session_stop"
    echo "---"
    echo ""
    echo "## Session Checkpoint"
    echo ""
    echo "Session ended normally. Review CLAUDE.md for current focus items."
} > "$CHECKPOINT_FILE"

# Allow stop (don't block)
echo '{"status": "checkpointed"}'
