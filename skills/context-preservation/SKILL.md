---
name: context-preservation
description: Activates during long sessions or before context compaction. Manages attention markers and ensures critical information survives memory compression.
---

# Context Preservation System

Long session detected or compaction imminent. Preserve critical context.

## Attention Marker System

### Marking Critical Information

Wrap important information that MUST survive compaction:

```markdown
<!-- ATTENTION -->
[Critical information here]
<!-- /ATTENTION -->
```

### What to Mark

**Always Mark:**
- Key architectural decisions
- Blocking issues and their workarounds
- Environment-specific configurations
- User preferences discovered during session
- Critical file paths or endpoints
- Authentication/connection details (sanitized)

**Never Mark:**
- Verbose explanations
- Intermediate debugging output
- Temporary state
- Information easily re-discovered

### Example Attention Blocks

```markdown
<!-- ATTENTION -->
Decision: Using PostgreSQL over SQLite for production
Reason: Need concurrent connections for API
Config: DATABASE_URL in .env.production
<!-- /ATTENTION -->
```

```markdown
<!-- ATTENTION -->
Blocker: Tests require REDIS_URL environment variable
Workaround: export REDIS_URL=redis://localhost:6379
File: .env.test needs this added
<!-- /ATTENTION -->
```

## Pre-Compaction Checklist

Before context is compressed, ensure:

1. [ ] All blocking issues are marked with ATTENTION
2. [ ] Key decisions are documented
3. [ ] Current task state is checkpointed
4. [ ] Critical paths/files are noted
5. [ ] Any user preferences are preserved

## Checkpoint Format

Use `/checkpoint` command or the hook will auto-checkpoint:

```markdown
## Current Task
[What we're working on]

## Completed
- [x] Step 1
- [x] Step 2

## Next Steps
- [ ] Step 3
- [ ] Step 4

## Critical Context
[ATTENTION blocks here]
```

## Recovery After Compaction

When resuming after compaction:

1. Check `.claude/memory/attention.md` for preserved items
2. Check `.claude/memory/checkpoint.md` for task state
3. Review CLAUDE.md for current focus
4. Continue from checkpoint

## Memory File Locations

| File | Purpose |
|------|---------|
| `.claude/memory/attention.md` | Preserved critical info |
| `.claude/memory/checkpoint.md` | Task state |
| `.claude/memory/errors.md` | Error patterns learned |
| `.claude/memory/patterns.md` | Behavioral patterns |
