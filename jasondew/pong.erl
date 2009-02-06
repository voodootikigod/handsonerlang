-module(pong).

-compile(export_all).

start() ->
  A = spawn(pong, play, []),
  B = spawn(pong, play, []),
  A ! {ping, B, 0},
  ok.

ping(Caller, N) ->
  Caller ! {ping, self(), N}.

pong(Caller, N) ->
  Caller ! {pong, self(), N}.

play() ->
  receive
    {ping, Caller, N} ->
      io:format("ping: ~p~n", [N]),
      pong(Caller, N + 1),
      play();
    {pong, Caller, N} when N =< 50 ->
      io:format("pong: ~p~n", [N]),
      pong(Caller, N + 1),
      play();
    {pong, Caller, _} ->
      Caller ! stop,
      io:format("done!~n");
    stop ->
      ok;
    Unknown ->
      io:format("unknown message: ~p~n", Unknown)
  end.
