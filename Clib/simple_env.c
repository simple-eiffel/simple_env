/*
 * simple_env.c - Environment variable access for Eiffel
 * Copyright (c) 2025 Larry Rix - MIT License
 */

#include "simple_env.h"
#include <stdlib.h>
#include <string.h>

char* se_get_env(const char* name) {
    DWORD size;
    char* result;

    if (!name) return NULL;

    /* Get required buffer size */
    size = GetEnvironmentVariableA(name, NULL, 0);
    if (size == 0) return NULL;  /* Variable doesn't exist */

    result = (char*)malloc(size);
    if (!result) return NULL;

    if (GetEnvironmentVariableA(name, result, size) == 0) {
        free(result);
        return NULL;
    }

    return result;
}

int se_set_env(const char* name, const char* value) {
    if (!name) return 0;
    return SetEnvironmentVariableA(name, value) ? 1 : 0;
}

int se_unset_env(const char* name) {
    if (!name) return 0;
    return SetEnvironmentVariableA(name, NULL) ? 1 : 0;
}

char* se_expand_env(const char* input) {
    DWORD size;
    char* result;

    if (!input) return NULL;

    /* Get required buffer size */
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

int se_env_exists(const char* name) {
    if (!name) return 0;
    return GetEnvironmentVariableA(name, NULL, 0) > 0 ? 1 : 0;
}
