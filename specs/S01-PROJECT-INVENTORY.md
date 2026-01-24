# S01: PROJECT INVENTORY - simple_env

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_env

## Project Structure

```
simple_env/
    +-- src/
    |   +-- simple_env.e          # Main class
    |   +-- simple_env.h          # C header for Win32 wrappers
    |
    +-- testing/
    |   +-- test_app.e
    |   +-- lib_tests.e
    |
    +-- research/
    |   +-- 7S-01 through 7S-07
    |
    +-- specs/
    |   +-- S01 through S08
    |
    +-- simple_env.ecf
    +-- README.md
```

## File Inventory

| File | Lines | Purpose |
|------|-------|---------|
| simple_env.e | 280 | Environment variable access |
| simple_env.h | 100 | Win32 API wrappers |

## Dependencies

### Internal
- None (foundational library)

### External
- EiffelBase
- Windows API

## Build Targets

| Target | Purpose |
|--------|---------|
| simple_env | Library |
| simple_env_tests | Test suite |
