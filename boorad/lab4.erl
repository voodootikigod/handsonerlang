-module(lab4).

-compile(export_all).

start() ->
  simple_server:start(?MODULE).

on_init() ->
  global:register_name(boorad@boorad_recv, self()),
  {ok, []}.

on_message(Message, State) ->
  io:format("~p~n", [Message]),
  {reply, ok, State}.

on_terminate() ->
  toast.


send_message(Server, Message) ->
  ServerPid = global:whereis_name(Server),
  simple_server:call(ServerPid, Message).

stop(Server) ->
  send_message(Server, stop).
