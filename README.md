<p align="center">
  <img src="https://raw.githubusercontent.com/ljr1981/claude_eiffel_op_docs/main/artwork/LOGO.png" alt="simple_ library logo" width="400">
</p>

# SIMPLE_ENV

**[Documentation](https://simple-eiffel.github.io/simple_env/)**

### Environment Variable Library for Eiffel

[![Language](https://img.shields.io/badge/language-Eiffel-blue.svg)](https://www.eiffel.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows-blue.svg)]()
[![SCOOP](https://img.shields.io/badge/SCOOP-compatible-orange.svg)]()
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()

---

## Overview

SIMPLE_ENV provides SCOOP-compatible environment variable access for Eiffel applications. It wraps Win32 environment APIs through a clean C interface, enabling reading, writing, and expansion of environment variables without threading complications.

**Developed using AI-assisted methodology:** Built interactively with Claude Opus 4.5 following rigorous Design by Contract principles.

---

## Features

### Environment Operations

- **Get** - Read environment variable values
- **Set** - Create or update environment variables
- **Unset** - Remove environment variables
- **Has** - Check if a variable exists
- **Expand** - Expand `%VAR%` references in strings

---

## Quick Start

### Installation

1. Clone the repository:
```bash
git clone https://github.com/simple-eiffel/simple_env.git
```

2. Compile the C library:
```bash
cd simple_env/Clib
compile.bat
```

3. Set the environment variable:
```bash
set SIMPLE_ENV=D:\path\to\simple_env
```

4. Add to your ECF file:
```xml
<library name="simple_env" location="$SIMPLE_ENV\simple_env.ecf"/>
```

### Basic Usage

```eiffel
class
    MY_APPLICATION

feature

    env_example
        local
            env: SIMPLE_ENV
        do
            create env

            -- Get an environment variable
            if attached env.get ("PATH") as path then
                print ("PATH = " + path + "%N")
            end

            -- Shortcut using bracket notation
            if attached env ["USERPROFILE"] as profile then
                print ("Profile: " + profile + "%N")
            end

            -- Set an environment variable
            env.set ("MY_VAR", "my_value")
            if env.last_operation_succeeded then
                print ("Variable set successfully%N")
            end

            -- Check if variable exists
            if env.has ("MY_VAR") then
                print ("MY_VAR exists%N")
            end

            -- Expand environment strings
            print (env.expand ("%USERPROFILE%\Documents") + "%N")
            -- Output: C:\Users\John\Documents

            -- Remove a variable
            env.unset ("MY_VAR")
        end

end
```

---

## API Reference

### SIMPLE_ENV Class

#### Access

```eiffel
get (a_name: READABLE_STRING_GENERAL): detachable STRING_32
    -- Get value of environment variable `a_name'.
    -- Returns Void if variable doesn't exist.

item alias "[]" (a_name: READABLE_STRING_GENERAL): detachable STRING_32
    -- Shortcut for `get'.
```

#### Status Report

```eiffel
has (a_name: READABLE_STRING_GENERAL): BOOLEAN
    -- Does environment variable `a_name' exist?

last_operation_succeeded: BOOLEAN
    -- Did the last set/unset operation succeed?
```

#### Modification

```eiffel
set (a_name: READABLE_STRING_GENERAL; a_value: READABLE_STRING_GENERAL)
    -- Set environment variable `a_name' to `a_value'.

put (a_value: READABLE_STRING_GENERAL; a_name: READABLE_STRING_GENERAL)
    -- Alternative signature matching HASH_TABLE convention.

unset (a_name: READABLE_STRING_GENERAL)
    -- Remove environment variable `a_name'.
```

#### Expansion

```eiffel
expand (a_string: READABLE_STRING_GENERAL): STRING_32
    -- Expand environment variables in `a_string'.
    -- E.g., "%USERPROFILE%\Documents" -> "C:\Users\John\Documents"
```

---

## Building & Testing

### Build Library

```bash
cd simple_env
ec -config simple_env.ecf -target simple_env -c_compile
```

### Run Tests

```bash
ec -config simple_env.ecf -target simple_env_tests -c_compile
./EIFGENs/simple_env_tests/W_code/simple_env.exe
```

---

## Project Structure

```
simple_env/
├── Clib/                       # C wrapper library
│   ├── simple_env.h            # C header file
│   ├── simple_env.c            # C implementation
│   └── compile.bat             # Build script
├── src/                        # Eiffel source
│   └── simple_env.e            # Main wrapper class
├── testing/                    # Test suite
│   ├── application.e           # Test runner
│   └── test_simple_env.e       # Test cases
├── simple_env.ecf              # Library configuration
├── README.md                   # This file
└── LICENSE                     # MIT License
```

---

## Dependencies

- **Windows OS** - Environment APIs are Windows-specific
- **EiffelStudio 23.09+** - Development environment
- **Visual Studio C++ Build Tools** - For compiling C wrapper

---

## SCOOP Compatibility

SIMPLE_ENV is fully SCOOP-compatible. The C wrapper handles all Win32 API calls synchronously without threading dependencies, making it safe for use in concurrent Eiffel applications.

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

---

## Contact

- **Author:** Larry Rix
- **Repository:** https://github.com/simple-eiffel/simple_env
- **Issues:** https://github.com/simple-eiffel/simple_env/issues

---

## Acknowledgments

- Built with Claude Opus 4.5 (Anthropic)
- Uses Win32 Environment APIs (Microsoft)
- Part of the simple_ library collection for Eiffel
