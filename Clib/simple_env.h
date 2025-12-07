/*
 * simple_env.h - Environment variable access for Eiffel
 * Copyright (c) 2025 Larry Rix - MIT License
 */

#ifndef SIMPLE_ENV_H
#define SIMPLE_ENV_H

#include <windows.h>

/* Get environment variable value. Returns allocated string or NULL. Caller must free. */
char* se_get_env(const char* name);

/* Set environment variable. Returns 1 on success, 0 on failure. */
int se_set_env(const char* name, const char* value);

/* Unset (delete) environment variable. Returns 1 on success, 0 on failure. */
int se_unset_env(const char* name);

/* Expand environment strings (e.g., "%PATH%" -> actual path). Caller must free result. */
char* se_expand_env(const char* input);

/* Check if environment variable exists. Returns 1 if exists, 0 if not. */
int se_env_exists(const char* name);

#endif /* SIMPLE_ENV_H */
