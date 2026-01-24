# 7S-01: SCOPE - simple_env

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_env

## Problem Domain

Environment variable access for Eiffel applications. The library provides a SCOOP-compatible interface to read, write, and enumerate environment variables on Windows.

## Target Users

- Eiffel developers needing configuration from environment
- Applications requiring 12-factor app compliance
- Systems with environment-based secrets management
- Cross-process communication via environment

## Problem Statement

Eiffel's EXECUTION_ENVIRONMENT is not SCOOP-safe. Developers need:
1. Thread-safe environment variable access
2. Simple API for get/set/exists operations
3. Variable expansion support
4. Prefix-based enumeration for namespaced configs

## Boundaries

### In Scope
- Get environment variable values
- Set environment variable values
- Check variable existence
- Expand embedded variables
- Enumerate all variables
- Prefix-filtered enumeration
- Multiple feature aliases for API flexibility

### Out of Scope
- Persistent environment changes (registry)
- Process spawning with modified environment
- Environment variable inheritance control
- Cross-platform support (Windows only)

## Success Criteria

1. SCOOP-compatible (no global state mutation)
2. Simple one-line operations
3. Proper handling of Unicode values
4. No memory leaks from C interop

## Dependencies

- Windows API (GetEnvironmentVariable, SetEnvironmentVariable)
- EiffelBase (C_STRING, ARRAYED_LIST)
