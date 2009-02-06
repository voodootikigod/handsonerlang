-module(pong).

-compile(export_all).

start() ->
  A = spawn(pong, play, []),
  B = spawn(pong, play, []),
  A ! {ping, B, 0},
  ok.

play() ->
  receive
    {ping, Caller, N} ->
      io:format("ping: ~p~n", [N]),
      Caller ! {pong, self(), N + 1},
      play();
    {pong, Caller, N} when N =< 50 ->
      io:format("pong: ~p~n", [N]),
      Caller ! {ping, self(), N + 1},
      play();
    {pong, _, _} ->
      io:format("done!~n");
    Unknown ->
      io:format("unknown message: ~p~n", Unknown)
  end.
