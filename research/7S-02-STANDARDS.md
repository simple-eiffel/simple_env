# 7S-02: STANDARDS - simple_env

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_env

## Applicable Standards

### Windows Environment Variables
- Win32 API: GetEnvironmentVariable, SetEnvironmentVariable
- Environment block format (null-separated, double-null terminated)
- Case-insensitive variable names
- Max variable name: 32767 characters

### POSIX Conventions (partial)
- NAME=VALUE format
- PATH variable with semicolon separator (Windows)
- Common variables: PATH, HOME, USER, TEMP

### 12-Factor App (reference)
- Configuration in environment
- Strict separation of config from code
- Environment variables for deployment-specific values

## Implementation Status

| Standard | Coverage | Notes |
|----------|----------|-------|
| Win32 GetEnvironmentVariable | Complete | Direct API call |
| Win32 SetEnvironmentVariable | Complete | Direct API call |
| Win32 ExpandEnvironmentStrings | Complete | Direct API call |
| Environment block enumeration | Complete | GetEnvironmentStrings |
| POSIX getenv/setenv | N/A | Windows-only |

## Compliance Notes

- Uses ANSI versions of Win32 API (not Unicode)
- Proper memory cleanup with free()
- Thread-safe via process-level locking (Windows handles)
