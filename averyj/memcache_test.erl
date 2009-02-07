-module(memcache_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

add_value_test() ->
	[{setup, fun() -> memcache:start_link() end,
	  fun({ok, Pid}) -> exit(Pid, shutdown), memcache:remove_value(a) end,
	  [[?_assert(memcache:add_value(a, 1))],
	  [?_assert(memcache:find_value(a) =:= 1)]]
	}].

find_value_test() ->
	[{setup, fun() -> memcache:start_link(), memcache:add_value(a, 1) end,
	  fun({ok, Pid}) -> exit(Pid, shutdown), memcache:remove_value(a)  end,
	  [?_assert(memcache:find_value(a) =:= 1)]
	}].
	
remove_value_test() ->
	[{setup, fun() -> memcache:start_link(), memcache:add_value(a, 1) end,
	  fun({ok, Pid}) -> exit(Pid, shutdown) end,
      [?_assert(memcache:remove_value(a))],
      [?_assert(memcache:find_value(a) =:= undefined)]
	}].