# S06: BOUNDARIES - simple_env

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_env

## System Boundaries

### External Systems

```
+-------------------+
|   Application     |
+-------------------+
         |
         | Eiffel API
         v
+-------------------+
|    simple_env     |
+-------------------+
         |
         | C API (simple_env.h)
         v
+-------------------+
|   Windows API     |
+-------------------+
         |
         | Process environment block
         v
+-------------------+
|   Process Memory  |
+-------------------+
```

## Interface Boundaries

### Public API

```eiffel
-- Read operations
get, value, read, fetch, lookup (name): STRING_32
item alias "[]" (name): STRING_32
has, exists, is_defined, contains (name): BOOLEAN

-- Write operations
set, put_value, store, define (name, value)
put (value, name)
unset, remove, delete_var, clear_var (name)

-- Enumeration
all_names, list, keys, variables: ARRAYED_LIST
names_with_prefix (prefix): ARRAYED_LIST

-- Expansion
expand, expand_variables, substitute, resolve (str): STRING_32
```

### Internal API (C functions)

```c
// simple_env.h
char* se_get_env(const char* name);
int se_set_env(const char* name, const char* value);
int se_unset_env(const char* name);
char* se_expand_env(const char* input);
int se_env_exists(const char* name);
char* se_get_all_names(void);
char* se_get_names_with_prefix(const char* prefix);
```

## Data Flow

### Read Flow
```
Application
    | name (STRING)
    v
SIMPLE_ENV.get
    | name (C_STRING)
    v
se_get_env (C)
    | name (char*)
    v
GetEnvironmentVariableA (Win32)
    | value (char*)
    v
STRING_32 result
```

### Write Flow
```
Application
    | name, value (STRING)
    v
SIMPLE_ENV.set
    | name, value (C_STRING)
    v
se_set_env (C)
    | name, value (char*)
    v
SetEnvironmentVariableA (Win32)
    | success (BOOL)
    v
last_operation_succeeded
```
