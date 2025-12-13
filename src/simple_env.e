note
	description: "[
		SCOOP-compatible environment variable access.
		Uses direct Win32 API calls with inline C.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ENV

feature -- Access

	get,
	value,
	read,
	fetch,
	lookup (a_name: READABLE_STRING_GENERAL): detachable STRING_32
			-- Get value of environment variable `a_name'.
			-- Returns Void if variable doesn't exist.
		require
			name_not_empty: not a_name.is_empty
		local
			l_name: C_STRING
			l_result: POINTER
		do
			create l_name.make (a_name.to_string_8)
			l_result := c_se_get_env (l_name.item)
			if l_result /= default_pointer then
				Result := pointer_to_string (l_result)
				c_free (l_result)
			end
		end

	item alias "[]" (a_name: READABLE_STRING_GENERAL): detachable STRING_32
			-- Shortcut for `get'.
		require
			name_not_empty: not a_name.is_empty
		do
			Result := get (a_name)
		end

feature -- Status Report

	has,
	exists,
	is_defined,
	contains (a_name: READABLE_STRING_GENERAL): BOOLEAN
			-- Does environment variable `a_name' exist?
		require
			name_not_empty: not a_name.is_empty
		local
			l_name: C_STRING
		do
			create l_name.make (a_name.to_string_8)
			Result := c_se_env_exists (l_name.item) /= 0
		end

feature -- Modification

	set,
	put_value,
	store,
	define (a_name: READABLE_STRING_GENERAL; a_value: READABLE_STRING_GENERAL)
			-- Set environment variable `a_name' to `a_value'.
		require
			name_not_empty: not a_name.is_empty
		local
			l_name, l_value: C_STRING
		do
			create l_name.make (a_name.to_string_8)
			create l_value.make (a_value.to_string_8)
			last_operation_succeeded := c_se_set_env (l_name.item, l_value.item) /= 0
		ensure
			variable_set: last_operation_succeeded implies attached get (a_name)
		end

	put (a_value: READABLE_STRING_GENERAL; a_name: READABLE_STRING_GENERAL)
			-- Set environment variable `a_name' to `a_value'.
			-- (Alternative signature matching HASH_TABLE convention)
		require
			name_not_empty: not a_name.is_empty
		do
			set (a_name, a_value)
		end

	unset,
	remove,
	delete_var,
	clear_var (a_name: READABLE_STRING_GENERAL)
			-- Remove environment variable `a_name'.
		require
			name_not_empty: not a_name.is_empty
		local
			l_name: C_STRING
		do
			create l_name.make (a_name.to_string_8)
			last_operation_succeeded := c_se_unset_env (l_name.item) /= 0
		ensure
			variable_removed: last_operation_succeeded implies not has (a_name)
		end

feature -- Expansion

	expand,
	expand_variables,
	substitute,
	resolve (a_string: READABLE_STRING_GENERAL): STRING_32
			-- Expand environment variables in `a_string'.
			-- E.g., "%USERPROFILE%\Documents" -> "C:\Users\John\Documents"
		require
			string_not_empty: not a_string.is_empty
		local
			l_input: C_STRING
			l_result: POINTER
		do
			create l_input.make (a_string.to_string_8)
			l_result := c_se_expand_env (l_input.item)
			if l_result /= default_pointer then
				Result := pointer_to_string (l_result)
				c_free (l_result)
			else
				create Result.make_from_string_general (a_string)
			end
		end

feature -- Enumeration

	all_names,
	list,
	keys,
	variables: ARRAYED_LIST [STRING_32]
			-- All environment variable names.
		local
			l_ptr: POINTER
			l_pos: INTEGER
			l_name: STRING_8
			l_char: CHARACTER
		do
			create Result.make (100)
			l_ptr := c_se_get_all_names
			if l_ptr /= default_pointer then
				from
					l_pos := 0
					create l_name.make_empty
				until
					c_char_at (l_ptr, l_pos) = '%U' and c_char_at (l_ptr, l_pos + 1) = '%U'
				loop
					l_char := c_char_at (l_ptr, l_pos)
					if l_char = '%U' then
						if not l_name.is_empty then
							Result.extend (l_name.to_string_32)
							create l_name.make_empty
						end
					else
						l_name.append_character (l_char)
					end
					l_pos := l_pos + 1
				end
				c_free (l_ptr)
			end
		ensure
			result_attached: Result /= Void
		end

	names_with_prefix (a_prefix: READABLE_STRING_GENERAL): ARRAYED_LIST [STRING_32]
			-- All environment variable names starting with `a_prefix'.
			-- Case-insensitive matching.
		require
			prefix_not_empty: not a_prefix.is_empty
		local
			l_prefix: C_STRING
			l_ptr: POINTER
			l_pos: INTEGER
			l_name: STRING_8
			l_char: CHARACTER
		do
			create Result.make (50)
			create l_prefix.make (a_prefix.to_string_8)
			l_ptr := c_se_get_names_with_prefix (l_prefix.item)
			if l_ptr /= default_pointer then
				from
					l_pos := 0
					create l_name.make_empty
				until
					c_char_at (l_ptr, l_pos) = '%U' and c_char_at (l_ptr, l_pos + 1) = '%U'
				loop
					l_char := c_char_at (l_ptr, l_pos)
					if l_char = '%U' then
						if not l_name.is_empty then
							Result.extend (l_name.to_string_32)
							create l_name.make_empty
						end
					else
						l_name.append_character (l_char)
					end
					l_pos := l_pos + 1
				end
				c_free (l_ptr)
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Status

	last_operation_succeeded: BOOLEAN
			-- Did the last set/unset operation succeed?

feature {NONE} -- Implementation

	pointer_to_string (a_ptr: POINTER): STRING_32
			-- Convert C string pointer to STRING_32.
		local
			l_c_string: C_STRING
		do
			create l_c_string.make_by_pointer (a_ptr)
			Result := l_c_string.string.to_string_32
		end

feature {NONE} -- C externals (using simple_env.h)

	c_se_get_env (a_name: POINTER): POINTER
			-- Get environment variable value. Caller must free result.
		external "C inline use %"simple_env.h%""
		alias "return se_get_env((const char*)$a_name);"
		end

	c_se_set_env (a_name, a_value: POINTER): INTEGER
			-- Set environment variable. Returns 1 on success, 0 on failure.
		external "C inline use %"simple_env.h%""
		alias "return se_set_env((const char*)$a_name, (const char*)$a_value);"
		end

	c_se_unset_env (a_name: POINTER): INTEGER
			-- Unset environment variable. Returns 1 on success, 0 on failure.
		external "C inline use %"simple_env.h%""
		alias "return se_unset_env((const char*)$a_name);"
		end

	c_se_expand_env (a_input: POINTER): POINTER
			-- Expand environment strings. Caller must free result.
		external "C inline use %"simple_env.h%""
		alias "return se_expand_env((const char*)$a_input);"
		end

	c_se_env_exists (a_name: POINTER): INTEGER
			-- Check if variable exists. Returns 1 if exists, 0 otherwise.
		external "C inline use %"simple_env.h%""
		alias "return se_env_exists((const char*)$a_name);"
		end

	c_free (a_ptr: POINTER)
			-- Free allocated memory.
		external "C inline use <stdlib.h>"
		alias "free($a_ptr);"
		end

	c_se_get_all_names: POINTER
			-- Get all env var names as null-separated string block.
			-- Format: "NAME1\0NAME2\0\0" (double null at end).
			-- Caller must free result.
		external "C"
		alias "se_get_all_names"
		end

	c_se_get_names_with_prefix (a_prefix: POINTER): POINTER
			-- Get env var names matching prefix as null-separated string block.
			-- Format: "NAME1\0NAME2\0\0" (double null at end).
			-- Caller must free result.
		external "C"
		alias "se_get_names_with_prefix"
		end

	c_char_at (a_ptr: POINTER; a_index: INTEGER): CHARACTER
			-- Character at position in C string.
		external "C inline"
		alias "return ((char*)$a_ptr)[$a_index];"
		end

end
