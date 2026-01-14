---
name: focus
description: Mark an item for attention preservation. Items marked with /focus survive context compaction.
---

# Focus Command

Mark information as critical for preservation across context compaction.

## Usage

```
/focus [item to preserve]
```

## Examples

```
/focus Database uses PostgreSQL on port 5433
/focus Tests require REDIS_URL environment variable
/focus User prefers pnpm over npm
```

## Execution

1. Read the focus item from command arguments
2. Append to `.claude/memory/attention.md` with timestamp
3. Confirm with single line

## Attention File Format

Write to `.claude/memory/attention.md`:

```markdown
## Focus Items

### [timestamp]
[focus item content]

### [earlier timestamp]
[earlier focus item]
```

## Output

```
Focused: "[item summary]"
```

## Without Arguments

If user runs just `/focus`:

```
Usage: /focus [item to preserve]

Example: /focus Tests require REDIS_URL set

Current focus items:
[list existing items or "None"]
```

## Clearing Focus Items

To clear all focus items:
```
/focus clear
```

This empties `.claude/memory/attention.md`.
