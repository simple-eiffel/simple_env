note
	description: "Tests for SIMPLE_ENV library"
	testing: "covers"

class
	TEST_SIMPLE_ENV

inherit
	TEST_SET_BASE

feature -- Test routines

	test_get_path
			-- Test getting PATH variable.
		local
			l_env: SIMPLE_ENV
		do
			create l_env
			if attached l_env.get ("PATH") as l_path then
				assert_string_not_empty ("path_not_empty", l_path)
			else
				assert ("path_exists", False)
			end
		end

	test_get_nonexistent
			-- Test getting non-existent variable.
		local
			l_env: SIMPLE_ENV
		do
			create l_env
			assert ("nonexistent_is_void", l_env.get ("SIMPLE_ENV_TEST_NONEXISTENT_12345") = Void)
		end

	test_has_path
			-- Test has for PATH.
		local
			l_env: SIMPLE_ENV
		do
			create l_env
			assert_true ("has_path", l_env.has ("PATH"))
		end

	test_has_nonexistent
			-- Test has for non-existent variable.
		local
			l_env: SIMPLE_ENV
		do
			create l_env
			assert_false ("not_has_nonexistent", l_env.has ("SIMPLE_ENV_TEST_NONEXISTENT_12345"))
		end

	test_set_and_get
			-- Test setting and getting a variable.
		local
			l_env: SIMPLE_ENV
		do
			create l_env
			l_env.set ("SIMPLE_ENV_TEST_VAR", "test_value_123")
			assert_true ("set_succeeded", l_env.last_operation_succeeded)
			if attached l_env.get ("SIMPLE_ENV_TEST_VAR") as l_value then
				assert_strings_equal ("value_correct", "test_value_123", l_value.to_string_8)
			else
				assert ("value_retrieved", False)
			end
			-- Clean up
			l_env.unset ("SIMPLE_ENV_TEST_VAR")
		end

	test_unset
			-- Test unsetting a variable.
		local
			l_env: SIMPLE_ENV
		do
			create l_env
			l_env.set ("SIMPLE_ENV_TEST_UNSET", "to_be_removed")
			assert_true ("was_set", l_env.has ("SIMPLE_ENV_TEST_UNSET"))
			l_env.unset ("SIMPLE_ENV_TEST_UNSET")
			assert_true ("unset_succeeded", l_env.last_operation_succeeded)
			assert_false ("no_longer_exists", l_env.has ("SIMPLE_ENV_TEST_UNSET"))
		end

	test_expand
			-- Test expanding environment strings.
		local
			l_env: SIMPLE_ENV
			l_expanded: STRING_32
		do
			create l_env
			l_expanded := l_env.expand ("%%USERPROFILE%%")
			assert_string_not_empty ("expanded_not_empty", l_expanded)
		end

	test_item_alias
			-- Test [] alias.
		local
			l_env: SIMPLE_ENV
		do
			create l_env
			assert ("item_works", attached l_env ["PATH"])
		end

end
