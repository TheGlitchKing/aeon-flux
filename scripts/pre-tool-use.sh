#!/bin/bash
# Aeon Flux - Pre Tool Use Hook
# Checks for abort signal before every tool execution

# Read input from Claude Code
read -r INPUT 2>/dev/null || INPUT="{}"
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"

# Generate project hash for abort signal file
PROJECT_HASH=$(echo "$PROJECT_DIR" | md5sum | cut -c1-8)
SIGNAL_FILE="/tmp/aeon-flux-abort-$PROJECT_HASH"

# Check if abort signal exists
if [[ -f "$SIGNAL_FILE" ]]; then
    # Read abort reason if available
    REASON=$(cat "$SIGNAL_FILE" 2>/dev/null || echo "User abort signal active")

    # Block the tool use
    echo "{\"decision\": \"deny\", \"reason\": \"$REASON. Run /abort clear to resume.\"}"
    exit 0
fi

# Allow the tool use
echo '{"decision": "allow"}'
