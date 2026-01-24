# 7S-03: SOLUTIONS - simple_env


**Date**: 2026-01-23

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_env

## Existing Solutions Comparison

### Eiffel EXECUTION_ENVIRONMENT
- **Pros:** Built-in, cross-platform
- **Cons:** Not SCOOP-safe, limited API
- **Approach:** Global singleton

### Python os.environ
- **Pros:** Dict-like interface, cross-platform
- **Cons:** Python-specific
- **Approach:** Mapping object

### Java System.getenv()
- **Pros:** Standardized, cross-platform
- **Cons:** Read-only, verbose
- **Approach:** Static methods

### Node.js process.env
- **Pros:** Simple object access
- **Cons:** JavaScript-specific
- **Approach:** Property access

## simple_env Approach

### Design Philosophy
- Direct Win32 API calls for reliability
- Multiple aliases for API flexibility
- SCOOP-compatible (no shared state)
- Clean memory management

### Key Differentiators

1. **SCOOP-Safe:** Can be used in concurrent code
2. **Alias-Rich API:** get/value/read/fetch/lookup all do the same
3. **Expansion Support:** %VAR% expansion built-in
4. **Prefix Filtering:** Easy to get namespaced variables

### Architecture

```
SIMPLE_ENV
    |
    +-- simple_env.h (C header with Win32 wrappers)
    |
    +-- Win32 API
        +-- GetEnvironmentVariableA
        +-- SetEnvironmentVariableA
        +-- ExpandEnvironmentStringsA
        +-- GetEnvironmentStringsA
```

### Trade-offs Made

| Decision | Benefit | Cost |
|----------|---------|------|
| ANSI API | Simpler strings | No full Unicode |
| Multiple aliases | Flexible API | Larger interface |
| Direct Win32 | No dependencies | Windows-only |
| Inline C | Self-contained | C code in Eiffel |
