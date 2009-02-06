-module(fizzbuzz2).

-compile(export_all).

start(Start, End) ->
  Formatter = spawn(fizzbuzz2, format, []),
  Answer = lists:map(fun(X) -> handle(Formatter, X) end, lists:seq(Start, End)),
  Formatter ! stop,
  io:format("~p~n", [Answer]).

handle(Formatter, X) ->
  Formatter ! {format, self(), X},
  receive
    {result, R} -> R
  end.

format() ->
  receive
    {format, Caller, N} when N rem 15 == 0 ->
      Caller ! {result, "fizzbuzz"},
      format();
    {format, Caller, N} when N rem 5 == 0 ->
      Caller ! {result, "buzz"},
      format();
    {format, Caller, N} when N rem 3 == 0 ->
      Caller ! {result, "fizz"},
      format();
    {format, Caller, N} ->
      Caller ! {result, N},
      format();
    stop ->
      ok;
    Unknown ->
      io:format("unknown message: ~p~n", Unknown)
  end.
