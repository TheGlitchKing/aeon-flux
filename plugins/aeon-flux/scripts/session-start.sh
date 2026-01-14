#!/bin/bash
# Aeon Flux - Session Start Hook
# Loads context and clears any stale abort signals

set -e

# Read input from Claude Code
read -r INPUT 2>/dev/null || INPUT="{}"
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"

# Generate project hash for abort signal file
PROJECT_HASH=$(echo "$PROJECT_DIR" | md5sum | cut -c1-8)
SIGNAL_FILE="/tmp/aeon-flux-abort-$PROJECT_HASH"

# Clear any stale abort signals from previous sessions
if [[ -f "$SIGNAL_FILE" ]]; then
    rm -f "$SIGNAL_FILE"
fi

# Initialize memory directory if needed
MEMORY_DIR="$PROJECT_DIR/.claude/memory"
mkdir -p "$MEMORY_DIR"

# Load checkpoint if exists
CHECKPOINT_FILE="$MEMORY_DIR/checkpoint.md"
ATTENTION_FILE="$MEMORY_DIR/attention.md"

OUTPUT=""

# Add checkpoint context if available
if [[ -f "$CHECKPOINT_FILE" ]] && [[ -s "$CHECKPOINT_FILE" ]]; then
    CHECKPOINT_CONTENT=$(cat "$CHECKPOINT_FILE")
    OUTPUT="$OUTPUT

## Previous Checkpoint
$CHECKPOINT_CONTENT
"
fi

# Add attention items if available
if [[ -f "$ATTENTION_FILE" ]] && [[ -s "$ATTENTION_FILE" ]]; then
    ATTENTION_CONTENT=$(cat "$ATTENTION_FILE")
    OUTPUT="$OUTPUT

## Attention Items (Preserved)
$ATTENTION_CONTENT
"
fi

# Output context for Claude (will be injected into conversation)
if [[ -n "$OUTPUT" ]]; then
    echo "$OUTPUT"
fi

# Return success
echo '{"status": "initialized", "abort_cleared": true}' >&2
