/*
 * simple_env.h - Cross-platform Environment variable helper functions for Eiffel
 *
 * Windows: Uses Win32 GetEnvironmentVariable/SetEnvironmentVariable
 * Linux/macOS: Uses POSIX getenv/setenv/unsetenv
 *
 * Copyright (c) 2025 Larry Rix - MIT License
 */

#ifndef SIMPLE_ENV_H
#define SIMPLE_ENV_H

#include <stdlib.h>
#include <string.h>

#if defined(_WIN32) || defined(EIF_WINDOWS)
/* ============ WINDOWS IMPLEMENTATION ============ */

#include <windows.h>

/* Get environment variable value. Caller must free result with free(). */
static char* se_get_env(const char* name) {
    DWORD size;
    char* result;
    if (!name) return NULL;
    size = GetEnvironmentVariableA(name, NULL, 0);
    if (size == 0) return NULL;
    result = (char*)malloc(size);
    if (!result) return NULL;
    if (GetEnvironmentVariableA(name, result, size) == 0) {
        free(result);
        return NULL;
    }
    return result;
}

/* Set environment variable. Returns 1 on success, 0 on failure. */
static int se_set_env(const char* name, const char* value) {
    if (!name) return 0;
    return SetEnvironmentVariableA(name, value) ? 1 : 0;
}

/* Unset environment variable. Returns 1 on success, 0 on failure. */
static int se_unset_env(const char* name) {
    if (!name) return 0;
    return SetEnvironmentVariableA(name, NULL) ? 1 : 0;
}

/* Expand environment strings. Caller must free result with free(). */
static char* se_expand_env(const char* input) {
    DWORD size;
    char* result;
    if (!input) return NULL;
    size = ExpandEnvironmentStringsA(input, NULL, 0);
    if (size == 0) return NULL;
    result = (char*)malloc(size);
    if (!result) return NULL;
    if (ExpandEnvironmentStringsA(input, result, size) == 0) {
        free(result);
        return NULL;
    }
    return result;
}

/* Check if variable exists. Returns 1 if exists, 0 otherwise. */
static int se_env_exists(const char* name) {
    if (!name) return 0;
    return GetEnvironmentVariableA(name, NULL, 0) > 0 ? 1 : 0;
}

#else
/* ============ POSIX IMPLEMENTATION (Linux/macOS) ============ */

#include <unistd.h>

extern char **environ;

/* Get environment variable value. Caller must free result with free(). */
static char* se_get_env(const char* name) {
    const char* value;
    char* result;
    if (!name) return NULL;
    value = getenv(name);
    if (!value) return NULL;
    result = strdup(value);
    return result;
}

/* Set environment variable. Returns 1 on success, 0 on failure. */
static int se_set_env(const char* name, const char* value) {
    if (!name) return 0;
    return (setenv(name, value ? value : "", 1) == 0) ? 1 : 0;
}

/* Unset environment variable. Returns 1 on success, 0 on failure. */
static int se_unset_env(const char* name) {
    if (!name) return 0;
    return (unsetenv(name) == 0) ? 1 : 0;
}

/* Expand environment strings. Caller must free result with free().
 * On POSIX, we manually expand $VAR and ${VAR} patterns.
 */
static char* se_expand_env(const char* input) {
    char* result;
    char* out;
    const char* p;
    const char* var_start;
    const char* var_end;
    const char* value;
    char var_name[256];
    size_t var_len;
    size_t result_size = 4096;
    size_t out_pos = 0;

    if (!input) return NULL;

    result = (char*)malloc(result_size);
    if (!result) return NULL;
    out = result;

    p = input;
    while (*p) {
        if (*p == '$') {
            p++;
            if (*p == '{') {
                /* ${VAR} format */
                p++;
                var_start = p;
                while (*p && *p != '}') p++;
                var_len = p - var_start;
                if (*p == '}') p++;
            } else {
                /* $VAR format */
                var_start = p;
                while (*p && ((*p >= 'A' && *p <= 'Z') ||
                              (*p >= 'a' && *p <= 'z') ||
                              (*p >= '0' && *p <= '9') ||
                              *p == '_')) p++;
                var_len = p - var_start;
            }

            if (var_len > 0 && var_len < sizeof(var_name)) {
                memcpy(var_name, var_start, var_len);
                var_name[var_len] = '\0';
                value = getenv(var_name);
                if (value) {
                    size_t value_len = strlen(value);
                    while (out_pos + value_len >= result_size - 1) {
                        result_size *= 2;
                        char* new_result = (char*)realloc(result, result_size);
                        if (!new_result) { free(result); return NULL; }
                        result = new_result;
                        out = result + out_pos;
                    }
                    memcpy(out, value, value_len);
                    out += value_len;
                    out_pos += value_len;
                }
            }
        } else {
            if (out_pos >= result_size - 1) {
                result_size *= 2;
                char* new_result = (char*)realloc(result, result_size);
                if (!new_result) { free(result); return NULL; }
                result = new_result;
                out = result + out_pos;
            }
            *out++ = *p++;
            out_pos++;
        }
    }
    *out = '\0';
    return result;
}

/* Check if variable exists. Returns 1 if exists, 0 otherwise. */
static int se_env_exists(const char* name) {
    if (!name) return 0;
    return getenv(name) != NULL ? 1 : 0;
}

#endif /* _WIN32 */

/* Declarations for functions implemented in simple_env.c */
void* se_get_all_names(void);
void* se_get_names_with_prefix(void* prefix);

#endif /* SIMPLE_ENV_H */
