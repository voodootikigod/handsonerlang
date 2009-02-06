-module(chat2_listener).

-compile(export_all).

on_init() ->
  global:register_name(jason@hera_recv, self()),
  {ok, []}.

on_message({chat_msg, _, Message}, State) ->
  io:format("< ~s~n", [Message]),
  {reply, ok, State};

on_message(stop, _) ->
  stop.

on_terminate() ->
  ok.
