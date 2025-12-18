/*
 * simple_env.c - Environment variable functions implementation
 * Compile this file and link with your Eiffel project
 *
 * Cross-platform: Windows and POSIX (Linux/macOS)
 * Copyright (c) 2025 Larry Rix - MIT License
 */

#include <stdlib.h>
#include <string.h>

#if defined(_WIN32) || defined(EIF_WINDOWS)
#include <windows.h>
#else
#include <unistd.h>
extern char **environ;
#endif

/* Get all environment variable names as null-separated string block.
 * Format: "NAME1\0NAME2\0NAME3\0\0" (double null at end)
 * Caller must free result with free().
 * Returns NULL on failure. */
void* se_get_all_names(void) {
#if defined(_WIN32) || defined(EIF_WINDOWS)
    char* env_block;
    char* result;
    char* p;
    char* out;
    size_t total_len = 0;
    size_t name_len;

    env_block = GetEnvironmentStringsA();
    if (!env_block) return NULL;

    /* First pass: calculate total length needed for names only */
    p = env_block;
    while (*p) {
        /* Skip entries starting with '=' (Windows internal vars) */
        if (*p != '=') {
            /* Find '=' to get name length */
            char* eq = strchr(p, '=');
            if (eq) {
                name_len = eq - p;
                total_len += name_len + 1; /* +1 for null separator */
            }
        }
        /* Move to next entry */
        p += strlen(p) + 1;
    }

    if (total_len == 0) {
        FreeEnvironmentStringsA(env_block);
        return NULL;
    }

    /* Allocate result (+1 for final double-null) */
    result = (char*)malloc(total_len + 1);
    if (!result) {
        FreeEnvironmentStringsA(env_block);
        return NULL;
    }

    /* Second pass: copy names */
    p = env_block;
    out = result;
    while (*p) {
        if (*p != '=') {
            char* eq = strchr(p, '=');
            if (eq) {
                name_len = eq - p;
                memcpy(out, p, name_len);
                out[name_len] = '\0';
                out += name_len + 1;
            }
        }
        p += strlen(p) + 1;
    }
    *out = '\0'; /* Double null terminator */

    FreeEnvironmentStringsA(env_block);
    return result;
#else
    /* POSIX implementation using environ */
    char** env;
    char* result;
    char* out;
    size_t total_len = 0;
    size_t name_len;

    if (!environ) return NULL;

    /* First pass: calculate total length needed */
    for (env = environ; *env; env++) {
        char* eq = strchr(*env, '=');
        if (eq) {
            name_len = eq - *env;
            total_len += name_len + 1;
        }
    }

    if (total_len == 0) return NULL;

    result = (char*)malloc(total_len + 1);
    if (!result) return NULL;

    /* Second pass: copy names */
    out = result;
    for (env = environ; *env; env++) {
        char* eq = strchr(*env, '=');
        if (eq) {
            name_len = eq - *env;
            memcpy(out, *env, name_len);
            out[name_len] = '\0';
            out += name_len + 1;
        }
    }
    *out = '\0'; /* Double null terminator */

    return result;
#endif
}

/* Case-insensitive string compare helper for POSIX */
#if !defined(_WIN32) && !defined(EIF_WINDOWS)
#include <strings.h>
#define strnicmp_compat strncasecmp
#else
#define strnicmp_compat _strnicmp
#endif

/* Get names matching a prefix as null-separated string block.
 * Format: "NAME1\0NAME2\0\0" (double null at end)
 * Caller must free result with free().
 * Returns NULL on failure or no matches. */
void* se_get_names_with_prefix(void* prefix) {
#if defined(_WIN32) || defined(EIF_WINDOWS)
    char* env_block;
    char* result;
    char* p;
    char* out;
    size_t total_len = 0;
    size_t name_len;
    size_t prefix_len;

    if (!prefix) return NULL;
    prefix_len = strlen((const char*)prefix);

    env_block = GetEnvironmentStringsA();
    if (!env_block) return NULL;

    /* First pass: calculate total length needed */
    p = env_block;
    while (*p) {
        if (*p != '=' && _strnicmp(p, (const char*)prefix, prefix_len) == 0) {
            char* eq = strchr(p, '=');
            if (eq) {
                name_len = eq - p;
                total_len += name_len + 1;
            }
        }
        p += strlen(p) + 1;
    }

    if (total_len == 0) {
        FreeEnvironmentStringsA(env_block);
        return NULL;
    }

    result = (char*)malloc(total_len + 1);
    if (!result) {
        FreeEnvironmentStringsA(env_block);
        return NULL;
    }

    /* Second pass: copy matching names */
    p = env_block;
    out = result;
    while (*p) {
        if (*p != '=' && _strnicmp(p, (const char*)prefix, prefix_len) == 0) {
            char* eq = strchr(p, '=');
            if (eq) {
                name_len = eq - p;
                memcpy(out, p, name_len);
                out[name_len] = '\0';
                out += name_len + 1;
            }
        }
        p += strlen(p) + 1;
    }
    *out = '\0';

    FreeEnvironmentStringsA(env_block);
    return result;
#else
    /* POSIX implementation using environ */
    char** env;
    char* result;
    char* out;
    size_t total_len = 0;
    size_t name_len;
    size_t prefix_len;

    if (!prefix) return NULL;
    prefix_len = strlen((const char*)prefix);

    if (!environ) return NULL;

    /* First pass: calculate total length needed */
    for (env = environ; *env; env++) {
        if (strncasecmp(*env, (const char*)prefix, prefix_len) == 0) {
            char* eq = strchr(*env, '=');
            if (eq) {
                name_len = eq - *env;
                total_len += name_len + 1;
            }
        }
    }

    if (total_len == 0) return NULL;

    result = (char*)malloc(total_len + 1);
    if (!result) return NULL;

    /* Second pass: copy matching names */
    out = result;
    for (env = environ; *env; env++) {
        if (strncasecmp(*env, (const char*)prefix, prefix_len) == 0) {
            char* eq = strchr(*env, '=');
            if (eq) {
                name_len = eq - *env;
                memcpy(out, *env, name_len);
                out[name_len] = '\0';
                out += name_len + 1;
            }
        }
    }
    *out = '\0';

    return result;
#endif
}
