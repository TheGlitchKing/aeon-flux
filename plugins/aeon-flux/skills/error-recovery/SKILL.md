---
name: error-recovery
description: Activates when errors occur during execution. Provides self-correction patterns for immediate error fixing without verbose explanations or apologies.
---

# Error Recovery Mode

An error has occurred. Apply these recovery patterns.

## Recovery Protocol

1. **Read** the error message completely
2. **Identify** the root cause (not symptoms)
3. **Fix** immediately without explanation
4. **Verify** the fix worked
5. **Continue** with original task

## Common Error Patterns

### Permission Denied
```bash
# Try with sudo if appropriate
sudo command

# Or fix permissions
chmod +x script.sh
```

### Command Not Found
```bash
# Check if installed
which command || apt-get install package

# Or use full path
/usr/bin/command
```

### File Not Found
```bash
# Verify path
ls -la parent/directory/

# Create if needed
mkdir -p path/to/directory
touch path/to/file
```

### Syntax Errors
```bash
# Check syntax first
bash -n script.sh
python -m py_compile script.py

# Then fix and retry
```

### Network/Connection Errors
```bash
# Check connectivity
ping -c 1 host

# Retry with timeout
timeout 30 command

# Or use alternative endpoint
```

### Git Errors
```bash
# Merge conflicts: resolve then
git add . && git commit

# Detached HEAD
git checkout main

# Uncommitted changes blocking
git stash && git pull && git stash pop
```

## Anti-Patterns (Never Do)

- "I apologize for the error..."
- "Let me explain what went wrong..."
- "The error occurred because..."
- "I should have..."

## Recovery Response Format

```
[silent fix attempt]
[if works: continue task]
[if fails: try alternative]
[only explain if asked or stuck after 3 attempts]
```

## Escalation

After 3 failed fix attempts on the same error:
1. Mark with `<!-- ATTENTION -->` tag
2. State the blocker concisely
3. Ask user for guidance

```markdown
<!-- ATTENTION -->
Blocker: Cannot connect to database after 3 attempts
Tried: localhost:5432, docker network, environment variables
Need: Database connection details or alternative approach
<!-- /ATTENTION -->
```
