# S05: CONSTRAINTS - simple_env

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_env

## Technical Constraints

### Platform Constraints

| Constraint | Impact | Rationale |
|------------|--------|-----------|
| Windows only | No Linux/macOS | Direct Win32 API |
| ANSI API | ASCII names | Simpler C interop |

### API Constraints

| Constraint | Value | Rationale |
|------------|-------|-----------|
| Max name length | 32767 | Windows limit |
| Max value length | 32767 | Windows limit |
| Case-insensitive | Names | Windows behavior |

## Business Rules

### Variable Name Rules
1. Cannot be empty
2. Case-insensitive matching
3. Any characters allowed (Windows handles validation)

### Value Rules
1. Can be empty string
2. Can contain any characters
3. Null terminates value

### Expansion Rules
1. %NAME% syntax recognized
2. Unknown variables remain unexpanded
3. Recursive expansion not performed

## State Constraints

### Process Scope
- Variables visible to current process
- Set variables visible to child processes
- Changes don't affect parent process

### Thread Safety
- Windows handles concurrent access
- SCOOP-safe design

## Error Conditions

| Condition | Result | last_operation_succeeded |
|-----------|--------|--------------------------|
| Get missing variable | Void | N/A |
| Set succeeds | Value set | True |
| Set fails | No change | False |
| Unset missing | No change | True |
| Invalid name | No change | False |
