#!/bin/bash
# Aeon Flux - Pre Compact Hook
# Preserves attention-marked content before context compaction

set -e

# Read input from Claude Code
read -r INPUT 2>/dev/null || INPUT="{}"
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"

# Memory files
MEMORY_DIR="$PROJECT_DIR/.claude/memory"
mkdir -p "$MEMORY_DIR"

ATTENTION_FILE="$MEMORY_DIR/attention.md"
CHECKPOINT_FILE="$MEMORY_DIR/checkpoint.md"

# Get current timestamp
TIMESTAMP=$(date -Iseconds)

# Extract conversation context if provided
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript // ""')

# If we have transcript, try to extract ATTENTION blocks
if [[ -n "$TRANSCRIPT" ]]; then
    # Extract content between <!-- ATTENTION --> and <!-- /ATTENTION --> tags
    ATTENTION_CONTENT=$(echo "$TRANSCRIPT" | grep -Pzo '(?s)<!-- ATTENTION -->.*?<!-- /ATTENTION -->' 2>/dev/null | tr '\0' '\n' || echo "")

    if [[ -n "$ATTENTION_CONTENT" ]]; then
        # Append to attention file with timestamp
        echo "" >> "$ATTENTION_FILE"
        echo "---" >> "$ATTENTION_FILE"
        echo "### Preserved at $TIMESTAMP" >> "$ATTENTION_FILE"
        echo "$ATTENTION_CONTENT" >> "$ATTENTION_FILE"
    fi
fi

# Auto-checkpoint current state
if [[ -n "$TRANSCRIPT" ]]; then
    # Extract last few significant actions/decisions
    echo "---" > "$CHECKPOINT_FILE"
    echo "checkpoint_time: $TIMESTAMP" >> "$CHECKPOINT_FILE"
    echo "trigger: pre_compact" >> "$CHECKPOINT_FILE"
    echo "---" >> "$CHECKPOINT_FILE"
    echo "" >> "$CHECKPOINT_FILE"
    echo "## Auto-Checkpoint (Pre-Compaction)" >> "$CHECKPOINT_FILE"
    echo "" >> "$CHECKPOINT_FILE"
    echo "Context was compacted at this point. Review attention items above for critical information." >> "$CHECKPOINT_FILE"
fi

# Return success
echo '{"status": "preserved", "timestamp": "'"$TIMESTAMP"'"}'
