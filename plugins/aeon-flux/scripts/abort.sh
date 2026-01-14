#!/bin/bash
# Aeon Flux - Abort Signal Manager
# Creates or clears the abort signal file

set -e

ACTION="${1:-set}"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
PROJECT_HASH=$(echo "$PROJECT_DIR" | md5sum | cut -c1-8)
SIGNAL_FILE="/tmp/aeon-flux-abort-$PROJECT_HASH"

case "$ACTION" in
    set)
        REASON="${2:-User requested abort}"
        echo "$REASON" > "$SIGNAL_FILE"
        echo "Abort signal SET. All tool uses will be blocked."
        echo "Signal file: $SIGNAL_FILE"
        echo "Run '/abort clear' to resume."
        ;;
    clear)
        if [[ -f "$SIGNAL_FILE" ]]; then
            rm -f "$SIGNAL_FILE"
            echo "Abort signal CLEARED. Normal operation resumed."
        else
            echo "No abort signal was active."
        fi
        ;;
    status)
        if [[ -f "$SIGNAL_FILE" ]]; then
            echo "Abort signal is ACTIVE"
            echo "Reason: $(cat "$SIGNAL_FILE")"
            echo "Signal file: $SIGNAL_FILE"
        else
            echo "No abort signal active. Normal operation."
        fi
        ;;
    *)
        echo "Usage: abort.sh [set|clear|status] [reason]"
        echo ""
        echo "Commands:"
        echo "  set [reason]  - Create abort signal (blocks all tool use)"
        echo "  clear         - Clear abort signal (resume operation)"
        echo "  status        - Check if abort signal is active"
        exit 1
        ;;
esac
