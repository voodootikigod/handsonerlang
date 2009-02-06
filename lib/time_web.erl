-module(time_web).

-export([dispatch/1]).

dispatch(Req) ->
  {{Year, Month, Day}, {Hour, Min, Sec}} = time_server:current_time(),
  Response = io_lib:format("The time is: ~p/~p/~p ~p:~p:~p", [Month, Day, Year, Hour, Min, Sec]),
  Req:respond({200, [{"Content-Type", "text/plain"}], Response}).
