#!/bin/bash
# Aeon Flux - Post Edit Hook
# Triggers verification suggestion after file edits

# Read input from Claude Code
read -r INPUT 2>/dev/null || INPUT="{}"
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')

# Determine file type for verification suggestion
EXTENSION="${FILE_PATH##*.}"

VERIFY_CMD=""
case "$EXTENSION" in
    js|ts|jsx|tsx)
        VERIFY_CMD="npm test or npx tsc --noEmit"
        ;;
    py)
        VERIFY_CMD="pytest or python -m py_compile"
        ;;
    go)
        VERIFY_CMD="go build or go test"
        ;;
    rs)
        VERIFY_CMD="cargo check or cargo test"
        ;;
    sh|bash)
        VERIFY_CMD="bash -n (syntax check)"
        ;;
    *)
        # No specific verification for this file type
        echo '{"status": "edited"}'
        exit 0
        ;;
esac

# Suggest verification (doesn't block, just informs)
echo "{\"status\": \"edited\", \"additionalContext\": \"File edited. Consider running: $VERIFY_CMD\"}"
