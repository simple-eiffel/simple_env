/*
 * simple_env.h - Windows Environment variable helper functions for Eiffel
 */

#ifndef SIMPLE_ENV_H
#define SIMPLE_ENV_H

#include <windows.h>
#include <stdlib.h>

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

#endif /* SIMPLE_ENV_H */
