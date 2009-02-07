-module(memcached_test).

-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

teardown_test_() ->
  [{setup,
    fun() -> memcached:start_link() end,
    fun({ok, Pid}) -> exit(Pid, shutdown) end,
    [?_assertMatch(ok, memcached:add_value(foo, "bar")),
     ?_assertMatch({ok, "bar"}, memcached:find_value(foo)),
     ?_assertMatch(ok, memcached:remove_value(foo)),
     ?_assertMatch(error, memcached:find_value(foo))]
   }].
