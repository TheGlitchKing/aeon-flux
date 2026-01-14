#!/bin/bash
# Aeon Flux - Pre Tool Use Hook
# Checks for abort signal before every tool execution

# Default to allow if anything fails
set +e

# Read input from Claude Code (may be empty)
read -r INPUT 2>/dev/null || INPUT=""

# Get project directory - try multiple sources
if command -v jq &>/dev/null && [[ -n "$INPUT" ]]; then
    CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null)
fi
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-${CWD:-$(pwd)}}"

# Generate project hash for abort signal file
if command -v md5sum &>/dev/null; then
    PROJECT_HASH=$(echo "$PROJECT_DIR" | md5sum 2>/dev/null | cut -c1-8)
else
    # Fallback if md5sum not available
    PROJECT_HASH=$(echo "$PROJECT_DIR" | cksum 2>/dev/null | cut -d' ' -f1)
fi

SIGNAL_FILE="/tmp/aeon-flux-abort-${PROJECT_HASH:-default}"

# Check if abort signal exists
if [[ -f "$SIGNAL_FILE" ]]; then
    REASON=$(cat "$SIGNAL_FILE" 2>/dev/null || echo "User abort signal active")
    echo "{\"decision\": \"deny\", \"reason\": \"$REASON Run /abort clear to resume.\"}"
    exit 0
fi

# Allow the tool use (default)
echo '{"decision": "allow"}'
exit 0
