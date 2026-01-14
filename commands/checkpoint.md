---
name: checkpoint
description: Save current task state for later resumption. Creates a checkpoint in .claude/memory/checkpoint.md
---

# Checkpoint Command

Save the current task state to `.claude/memory/checkpoint.md`.

## What to Capture

1. **Current Task**: What are we working on?
2. **Completed Steps**: What's been done?
3. **Next Steps**: What remains?
4. **Critical Context**: Any ATTENTION items
5. **Blockers**: Any issues preventing progress?

## Checkpoint Format

Write to `.claude/memory/checkpoint.md`:

```markdown
---
checkpoint_time: [ISO timestamp]
trigger: user_command
---

## Current Task
[Brief description of the main objective]

## Completed
- [x] Step 1 description
- [x] Step 2 description

## Next Steps
- [ ] Step 3 description
- [ ] Step 4 description

## Critical Context
<!-- ATTENTION -->
[Any critical information that must be preserved]
<!-- /ATTENTION -->

## Blockers
[Any issues blocking progress, or "None"]

## Files Modified
- path/to/file1.ts
- path/to/file2.ts
```

## Execution

1. Analyze current conversation state
2. Extract task progress
3. Write checkpoint file
4. Confirm: "Checkpoint saved."

## Usage

User invokes: `/checkpoint`

Response: Create checkpoint and confirm with single line.
