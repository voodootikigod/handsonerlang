-module(ex07).
-include_lib("eunit/include/eunit.hrl").

add_value_test()  ->
  [{setup, fun() -> ex06:start_link() end,
            fun({ok, Pid}) ->exit(Pid, shutdown) end,
            [?_assertEqual(success, ex06:add_value("k","z"))]
  }].


find_value()  ->
  ?assertEqual(success, ex06:add_value("Z", "K")),
  ?assertEqual("K", ex06:find_value("Z")).
  

find_value_test()  ->
  [{setup, fun() -> ex06:start_link() end,
            fun({ok, Pid}) ->exit(Pid, shutdown) end,
            [find_value()]
  }].
  

rem_value()  ->
  ?assertEqual(success, ex06:add_value("Z", "K")),
  ?assertEqual("K", ex06:find_value("Z")),
  ?assertEqual(success, ex06:remove_value("Z")),
  ?assertEqual(undefined, ex06:find_value("Z")).


remove_value_test()  ->
  [{setup, fun() -> ex06:start_link() end,
            fun({ok, Pid}) ->exit(Pid, shutdown) end,
            [rem_value()]
  }].