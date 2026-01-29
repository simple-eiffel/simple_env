<p align="center">
  <img src="docs/images/logo.svg" alt="simple_env logo" width="400">
</p>

# simple_env

**[Documentation](https://simple-eiffel.github.io/simple_env/)** | **[GitHub](https://github.com/simple-eiffel/simple_env)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Eiffel](https://img.shields.io/badge/Eiffel-25.02-blue.svg)](https://www.eiffel.org/)
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()
[![SCOOP](https://img.shields.io/badge/SCOOP-compatible-orange.svg)]()

SCOOP-compatible environment variable access for Eiffel.

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

**Production**

## Overview

SIMPLE_ENV provides direct Win32 API calls with inline C for reliable, thread-safe environment manipulation. Unlike EXECUTION_ENVIRONMENT, it has no shared state issues.

```eiffel
local
    env: SIMPLE_ENV
do
    create env
    if attached env.get ("PATH") as path then
        print (path)
    end
    env.set ("MY_VAR", "my_value")
    print (env.expand ("%USERPROFILE%\Documents"))
end
```

## Features

- **Get & Set** - Read, write, delete environment variables
- **String Expansion** - Expand %VAR% references in paths
- **Enumeration** - List all variables or filter by prefix
- **SCOOP Safe** - No shared state, concurrent-ready
- **Array Access** - Use `env["PATH"]` notation

## Installation

1. Set environment variable (one-time setup for all simple_* libraries):
```bash
export SIMPLE_EIFFEL=D:\prod
```

2. Add to ECF:
```xml
<library name="simple_env" location="$SIMPLE_EIFFEL/simple_env/simple_env.ecf"/>
```

## Platform

Windows (uses Win32 API)

## License

MIT License
