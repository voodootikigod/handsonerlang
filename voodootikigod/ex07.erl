-module(ex07).
-include_lib("eunit/include/eunit.hrl").


runner(Add,Find,Remove) ->
  if Add == true ->
    ?assertEqual(success, ex06:add_value("Z", "K"))
  end,
  if Find == true->
    ?assertEqual("K", ex06:find_value("Z"))
  end,
  if Remove == true ->
    ?assertEqual(success, ex06:remove_value("Z")),
    ?assertEqual(undefined, ex06:find_value("Z"))
  end.
  

add_value_test()  ->
  [{setup, fun() -> ex06:start_link() end,
            fun({ok, Pid}) ->exit(Pid, shutdown) end,
            [fun() -> runner(true, false, false) end]
  }].


  

find_value_test()  ->
  [{setup, fun() -> ex06:start_link() end,
            fun({ok, Pid}) ->exit(Pid, shutdown) end,
            [fun() ->runner(true, true, false) end]
  }].
  



remove_value_test()  ->
  [{setup, fun() -> ex06:start_link() end,
            fun({ok, Pid}) ->exit(Pid, shutdown) end,
            [fun() -> runner(true, true, true) end ]
  }].