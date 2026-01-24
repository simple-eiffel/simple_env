# S04: FEATURE SPECS - simple_env

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_env

## SIMPLE_ENV Features

### Access Features (Aliases)

| Feature | Signature | Description |
|---------|-----------|-------------|
| get | `(name: STRING): detachable STRING_32` | Get variable value |
| value | `(name: STRING): detachable STRING_32` | Alias for get |
| read | `(name: STRING): detachable STRING_32` | Alias for get |
| fetch | `(name: STRING): detachable STRING_32` | Alias for get |
| lookup | `(name: STRING): detachable STRING_32` | Alias for get |
| item alias "[]" | `(name: STRING): detachable STRING_32` | Bracket access |

### Status Features (Aliases)

| Feature | Signature | Description |
|---------|-----------|-------------|
| has | `(name: STRING): BOOLEAN` | Variable exists |
| exists | `(name: STRING): BOOLEAN` | Alias for has |
| is_defined | `(name: STRING): BOOLEAN` | Alias for has |
| contains | `(name: STRING): BOOLEAN` | Alias for has |

### Modification Features (Aliases)

| Feature | Signature | Description |
|---------|-----------|-------------|
| set | `(name, value: STRING)` | Set variable |
| put_value | `(name, value: STRING)` | Alias for set |
| store | `(name, value: STRING)` | Alias for set |
| define | `(name, value: STRING)` | Alias for set |
| put | `(value, name: STRING)` | HASH_TABLE style |
| unset | `(name: STRING)` | Remove variable |
| remove | `(name: STRING)` | Alias for unset |
| delete_var | `(name: STRING)` | Alias for unset |
| clear_var | `(name: STRING)` | Alias for unset |

### Expansion Features (Aliases)

| Feature | Signature | Description |
|---------|-----------|-------------|
| expand | `(str: STRING): STRING_32` | Expand %VAR% |
| expand_variables | `(str: STRING): STRING_32` | Alias |
| substitute | `(str: STRING): STRING_32` | Alias |
| resolve | `(str: STRING): STRING_32` | Alias |

### Enumeration Features (Aliases)

| Feature | Signature | Description |
|---------|-----------|-------------|
| all_names | `: ARRAYED_LIST [STRING_32]` | All variable names |
| list | `: ARRAYED_LIST [STRING_32]` | Alias |
| keys | `: ARRAYED_LIST [STRING_32]` | Alias |
| variables | `: ARRAYED_LIST [STRING_32]` | Alias |
| names_with_prefix | `(prefix: STRING): ARRAYED_LIST [STRING_32]` | Filtered names |

### Status Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| last_operation_succeeded | `: BOOLEAN` | Last set/unset result |
