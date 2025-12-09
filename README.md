# SIMPLE_ENV

SCOOP-compatible environment variable access using direct Win32 API calls with inline C.

## Features

- Get environment variable values
- Set and unset environment variables
- Check if variables exist
- Expand environment strings (e.g., "%USERPROFILE%\Documents")
- Array-style access with `[]` operator
- SCOOP-compatible for concurrent programming

## Installation

Add to your ECF file:

```xml
<library name="simple_env" location="$SIMPLE_ENV/simple_env.ecf"/>
```

Set the environment variable:
```
SIMPLE_ENV=/path/to/simple_env
```

## Quick Start

```eiffel
local
    env: SIMPLE_ENV
    path: detachable STRING_32
do
    create env

    -- Get a variable
    path := env.get ("PATH")

    -- Or use array notation
    path := env ["PATH"]

    -- Set a variable
    env.set ("MY_VAR", "my_value")

    -- Check existence
    if env.has ("HOME") then
        print ("HOME is set%N")
    end

    -- Expand environment strings
    print (env.expand ("%%USERPROFILE%%\Documents"))

    -- Remove a variable
    env.unset ("MY_VAR")
end
```

## API Overview

### SIMPLE_ENV

| Feature | Description |
|---------|-------------|
| `get (name)` | Get environment variable value |
| `item [name]` | Array-style access (alias for get) |
| `has (name)` | Check if variable exists |
| `set (name, value)` | Set environment variable |
| `put (value, name)` | Set variable (HASH_TABLE style) |
| `unset (name)` | Remove environment variable |
| `expand (string)` | Expand %VAR% references in string |
| `last_operation_succeeded` | Status of last set/unset |

## Documentation

- [API Documentation](https://simple-eiffel.github.io/simple_env/)

## Platform

Windows (uses Win32 API)

## License

MIT License - see LICENSE file for details.

## Author

Larry Rix
