# S03: CONTRACTS - simple_env

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_env

## SIMPLE_ENV Contracts

### Feature Contracts

#### get/value/read/fetch/lookup
```eiffel
require
    name_not_empty: not a_name.is_empty
```
Returns Void if variable doesn't exist.

#### item alias "[]"
```eiffel
require
    name_not_empty: not a_name.is_empty
```

#### has/exists/is_defined/contains
```eiffel
require
    name_not_empty: not a_name.is_empty
```

#### set/put_value/store/define
```eiffel
require
    name_not_empty: not a_name.is_empty
ensure
    variable_set: last_operation_succeeded implies attached get (a_name)
```

#### put (alternate signature)
```eiffel
require
    name_not_empty: not a_name.is_empty
```

#### unset/remove/delete_var/clear_var
```eiffel
require
    name_not_empty: not a_name.is_empty
ensure
    variable_removed: last_operation_succeeded implies not has (a_name)
```

#### expand/expand_variables/substitute/resolve
```eiffel
require
    string_not_empty: not a_string.is_empty
```

#### names_with_prefix
```eiffel
require
    prefix_not_empty: not a_prefix.is_empty
ensure
    result_attached: Result /= Void
```

#### all_names/list/keys/variables
```eiffel
ensure
    result_attached: Result /= Void
```

## State Queries

### last_operation_succeeded
Indicates if most recent set/unset operation succeeded.
- True: Operation completed successfully
- False: Operation failed (invalid name, permission denied, etc.)
