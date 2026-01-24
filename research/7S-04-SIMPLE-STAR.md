# 7S-04: SIMPLE-STAR - simple_env


**Date**: 2026-01-23

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_env

## Ecosystem Integration

### Used By

| Library | Purpose |
|---------|---------|
| simple_oracle | Database path configuration |
| simple_http | Proxy settings |
| simple_email | SMTP credentials |
| Application configs | General configuration |

### Dependencies

| Library | Purpose |
|---------|---------|
| EiffelBase | C_STRING, ARRAYED_LIST |

## API Consistency

### Naming Conventions
- Multiple aliases per feature (get/value/read/fetch/lookup)
- Boolean queries: has/exists/is_defined/contains
- Modification: set/put_value/store/define

### Error Handling Pattern
```eiffel
-- Success flag for modifications
last_operation_succeeded: BOOLEAN

-- Void result for missing variables
value := env.get ("UNDEFINED")  -- Returns Void
```

### Creation Pattern
```eiffel
-- Simple creation, no arguments
env: SIMPLE_ENV
create env
value := env.get ("PATH")
```

## Ecosystem Patterns Applied

### Multiple Aliases
Different naming conventions for same operation:
- Ruby style: `get`
- Python style: `lookup`
- Eiffel style: `item`

### SCOOP Compatibility
No shared mutable state - safe for concurrent access.

### Inline C Pattern
Uses simple_env.h for Win32 API wrappers.
