# S02: CLASS CATALOG - simple_env

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_env

## Class Hierarchy

```
ANY
    +-- SIMPLE_ENV
```

## Class Details

### SIMPLE_ENV

**Purpose:** Access environment variables
**Responsibility:** Read, write, enumerate env vars

| Feature Category | Count |
|-----------------|-------|
| Access (queries) | 5 aliases |
| Status queries | 4 aliases |
| Modification | 8 aliases |
| Expansion | 4 aliases |
| Enumeration | 4 aliases |
| Internal | 10 |

**Key Feature Groups:**

#### Access (all aliases for same operation)
- `get`, `value`, `read`, `fetch`, `lookup`
- `item alias "[]"`

#### Status Queries
- `has`, `exists`, `is_defined`, `contains`

#### Modification
- `set`, `put_value`, `store`, `define`
- `put` (alternate signature)
- `unset`, `remove`, `delete_var`, `clear_var`

#### Expansion
- `expand`, `expand_variables`, `substitute`, `resolve`

#### Enumeration
- `all_names`, `list`, `keys`, `variables`
- `names_with_prefix`

## Class Dependencies

```
SIMPLE_ENV
    |
    +-- C_STRING (EiffelBase)
    +-- ARRAYED_LIST [STRING_32] (EiffelBase)
    +-- simple_env.h (Win32 wrappers)
```
