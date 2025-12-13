note
	description: "Test application for simple_env"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_APP

create
	make

feature -- Initialization

	make
			-- Run application.
		local
			l_env: SIMPLE_ENV
			l_all: ARRAYED_LIST [STRING_32]
			l_simple: ARRAYED_LIST [STRING_32]
		do
			create l_env

			-- Test basic get/set
			print ("=== Testing basic get/set ===%N")
			l_env.set ("TEST_VAR", "test_value")
			if attached l_env.get ("TEST_VAR") as v then
				print ("TEST_VAR = " + v + "%N")
				check v.same_string ("test_value") end
			end
			l_env.unset ("TEST_VAR")
			check not l_env.has ("TEST_VAR") end
			print ("Basic tests passed%N%N")

			-- Test enumeration
			print ("=== Testing all_names ===%N")
			l_all := l_env.all_names
			print ("Total env vars: " + l_all.count.out + "%N%N")

			-- Test prefix filtering
			print ("=== Testing names_with_prefix('SIMPLE_') ===%N")
			l_simple := l_env.names_with_prefix ("SIMPLE_")
			print ("SIMPLE_* count: " + l_simple.count.out + "%N")
			across l_simple as ic loop
				print ("  " + ic + "%N")
			end

			print ("%N=== All tests passed ===%N")
		end

end
