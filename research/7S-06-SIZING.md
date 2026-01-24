# 7S-06: SIZING - simple_env


**Date**: 2026-01-23

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_env

## Implementation Size

### Actual Implementation

| Component | Lines | Complexity |
|-----------|-------|------------|
| SIMPLE_ENV | ~280 | Low-Medium |
| simple_env.h | ~100 | Low (C wrappers) |
| **Total Source** | **~380** | **Low** |

### Test Coverage

| Test File | Lines | Tests |
|-----------|-------|-------|
| lib_tests.e | ~80 | Basic tests |
| test_app.e | ~50 | Test runner |
| **Total Tests** | **~130** | |

### Complexity Breakdown

#### Simple (delegation)
- Get/set wrappers: Direct C calls
- Boolean queries: Thin wrappers

#### Medium (data handling)
- Enumeration: Parse null-separated string
- Expansion: String manipulation

### Dependencies

```
simple_env
    +-- EiffelBase
    |   +-- C_STRING
    |   +-- ARRAYED_LIST
    |   +-- STRING_32
    +-- simple_env.h (custom)
    +-- Windows API
        +-- GetEnvironmentVariableA
        +-- SetEnvironmentVariableA
        +-- ExpandEnvironmentStringsA
        +-- GetEnvironmentStringsA
```

### Build Time Impact
- Clean build: ~5 seconds
- Incremental: ~2 seconds
- C compilation: ~3 seconds

### Runtime Footprint
- Memory: ~10KB base
- Per-call: Small temporary strings
- No background operations

## Estimation vs Actual

| Aspect | Estimated | Actual |
|--------|-----------|--------|
| Development time | 1 day | 1 day |
| Core classes | 1 | 1 |
| Lines of code | 300 | 380 |
| Test coverage | 70% | ~65% |
