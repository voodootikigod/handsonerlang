-module(lab7).

-include_lib("eunit/include/eunit.hrl").

memcache_test_() ->
  [{setup,
    fun() -> lab5:start_link() end,
    fun({ok, Pid}) -> exit(Pid, shutdown) end,
    [
     fun() ->
	 lab5:add_value(boo,rad),
	 lab5:add_value("boo","rad"),
	 ?assertMatch(rad,lab5:find_value(boo)),
	 ?assertMatch("rad",lab5:find_value("boo")),
	 lab5:remove_value(boo),
	 ?_assertMatch(not_found, lab5:find_value(boo))
     end
    ]}].
