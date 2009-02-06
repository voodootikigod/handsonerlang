-module(time_server_test).

-include_lib("eunit/include/eunit.hrl").

teardown_test_() ->
  [{setup, fun() -> time_server:start_link() end,
    fun({ok, Pid}) -> exit(Pid, shutdown) end,
    [?_assertMatch({{_, _, _}, {_, _, _}}, time_server:current_time())]}].
