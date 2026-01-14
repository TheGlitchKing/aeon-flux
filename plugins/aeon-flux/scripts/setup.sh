#!/bin/bash
# Aeon Flux - Setup Script
# Run after plugin installation to initialize everything

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get project directory
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
cd "$PROJECT_DIR"

echo "Setting up Aeon Flux..."
echo ""

# Step 1: Create memory directory
echo -n "Creating memory directory... "
mkdir -p .claude/memory
touch .claude/memory/.gitkeep
echo -e "${GREEN}done${NC}"

# Step 2: Initialize memory files
echo -n "Initializing memory files... "
touch .claude/memory/attention.md
touch .claude/memory/checkpoint.md
touch .claude/memory/errors.md
touch .claude/memory/patterns.md
echo -e "${GREEN}done${NC}"

# Step 3: Clear stale abort signals
echo -n "Clearing stale abort signals... "
rm -f /tmp/aeon-flux-abort-* 2>/dev/null || true
echo -e "${GREEN}done${NC}"

# Step 4: Verify scripts are executable
echo -n "Verifying scripts... "
if [ -n "$CLAUDE_PLUGIN_ROOT" ]; then
    chmod +x "${CLAUDE_PLUGIN_ROOT}/scripts/"*.sh 2>/dev/null || true
fi
echo -e "${GREEN}done${NC}"

# Step 5: Update .gitignore if needed
echo -n "Updating .gitignore... "
if [ -f .gitignore ]; then
    if ! grep -q "\.claude/memory/" .gitignore 2>/dev/null; then
        echo "" >> .gitignore
        echo "# Aeon Flux runtime state" >> .gitignore
        echo ".claude/memory/*.md" >> .gitignore
        echo "!.claude/memory/.gitkeep" >> .gitignore
        echo -e "${GREEN}updated${NC}"
    else
        echo -e "${YELLOW}already configured${NC}"
    fi
else
    echo -e "${YELLOW}no .gitignore found${NC}"
fi

echo ""
echo "========================================"
echo -e "${GREEN}Aeon Flux Setup Complete!${NC}"
echo "========================================"
echo ""
echo "Memory directory: .claude/memory/"
echo "Abort signals:    cleared"
echo "Scripts:          ready"
echo ""
echo "Available commands:"
echo "  /checkpoint  - Save task state"
echo "  /resume      - Load last checkpoint"
echo "  /reflect     - Self-assessment"
echo "  /focus       - Mark attention items"
echo "  /abort       - Stop all subagents"
echo ""
echo "Bash Loop mode active. Claude will now:"
echo "  - Act without explaining"
echo "  - Fix errors silently"
echo "  - Show real output"
echo "  - Preserve critical context"
echo ""
echo "Start working!"
