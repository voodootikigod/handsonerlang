-module(memcache_test).

-include_lib("eunit/include/eunit.hrl").

add_value_test() ->
  [{setup, fun() -> memcache:start_link() end,
    fun({ok, Pid}) -> exit(Pid, shutdown) end,
    [?assertMatch(ok, memcache:add_value(name, value))]}].

find_value_test_() ->
  [{setup, fun() -> memcache:start_link() end,
    fun({ok, Pid}) -> exit(Pid, shutdown) end,
    fun() ->
			?assertMatch(ok, memcache:add_value(name, value)),
			?assertMatch(value, memcache:find_value(name))
		end}].

remove_value_test_() ->
  [{setup, fun() -> memcache:start_link() end,
    fun({ok, Pid}) -> exit(Pid, shutdown) end,
    fun() ->
			?assertMatch(ok, memcache:add_value(name, value)),
			?assertMatch(value, memcache:find_value(name)),
			?assertMatch(ok, memcache:remove_value(name)),
			?assertMatch(undefined, memcache:find_value(name))
		end}].
