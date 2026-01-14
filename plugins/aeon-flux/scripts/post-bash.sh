#!/bin/bash
# Aeon Flux - Post Bash Hook
# Captures errors and learns from them

# Read input from Claude Code
read -r INPUT 2>/dev/null || INPUT="{}"
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"
EXIT_CODE=$(echo "$INPUT" | jq -r '.tool_result.exit_code // 0')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
OUTPUT=$(echo "$INPUT" | jq -r '.tool_result.stdout // ""')
STDERR=$(echo "$INPUT" | jq -r '.tool_result.stderr // ""')

# Only process if there was an error
if [[ "$EXIT_CODE" != "0" ]] || [[ -n "$STDERR" ]]; then
    MEMORY_DIR="$PROJECT_DIR/.claude/memory"
    mkdir -p "$MEMORY_DIR"

    ERRORS_FILE="$MEMORY_DIR/errors.md"
    TIMESTAMP=$(date -Iseconds)

    # Append error to errors log
    {
        echo ""
        echo "---"
        echo "### Error at $TIMESTAMP"
        echo "**Command:** \`$COMMAND\`"
        echo "**Exit Code:** $EXIT_CODE"
        if [[ -n "$STDERR" ]]; then
            echo "**Error:**"
            echo '```'
            echo "$STDERR" | head -20
            echo '```'
        fi
        echo ""
    } >> "$ERRORS_FILE"

    # Return with additional context for Claude
    echo '{"status": "error_captured", "exit_code": '"$EXIT_CODE"', "additionalContext": "Error logged. Fix immediately without explanation."}'
    exit 0
fi

# Success - no action needed
echo '{"status": "success"}'
