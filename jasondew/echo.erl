-module(echo).

-compile(export_all).

start() ->
  register(echo, spawn(echo, echo, [])).

stop() ->
  echo ! stop.

echo() ->
  receive
    {Pid, Message} ->
      Pid ! Message,
      echo();
    stop -> ok
  end.
