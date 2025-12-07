note
	description: "[
		SCOOP-compatible environment variable access.
		Uses direct Win32 API calls via C wrapper.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ENV

feature -- Access

	get (a_name: READABLE_STRING_GENERAL): detachable STRING_32
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

	has (a_name: READABLE_STRING_GENERAL): BOOLEAN
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

	set (a_name: READABLE_STRING_GENERAL; a_value: READABLE_STRING_GENERAL)
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

	unset (a_name: READABLE_STRING_GENERAL)
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

	expand (a_string: READABLE_STRING_GENERAL): STRING_32
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

feature {NONE} -- C externals

	c_se_get_env (a_name: POINTER): POINTER
			-- Get environment variable.
		external
			"C inline use %"simple_env.h%""
		alias
			"return se_get_env((const char*)$a_name);"
		end

	c_se_set_env (a_name, a_value: POINTER): INTEGER
			-- Set environment variable.
		external
			"C inline use %"simple_env.h%""
		alias
			"return se_set_env((const char*)$a_name, (const char*)$a_value);"
		end

	c_se_unset_env (a_name: POINTER): INTEGER
			-- Unset environment variable.
		external
			"C inline use %"simple_env.h%""
		alias
			"return se_unset_env((const char*)$a_name);"
		end

	c_se_expand_env (a_input: POINTER): POINTER
			-- Expand environment strings.
		external
			"C inline use %"simple_env.h%""
		alias
			"return se_expand_env((const char*)$a_input);"
		end

	c_se_env_exists (a_name: POINTER): INTEGER
			-- Check if variable exists.
		external
			"C inline use %"simple_env.h%""
		alias
			"return se_env_exists((const char*)$a_name);"
		end

	c_free (a_ptr: POINTER)
			-- Free allocated memory.
		external
			"C inline"
		alias
			"free($a_ptr);"
		end

end
