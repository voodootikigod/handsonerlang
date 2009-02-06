-module(lab4).

-compile(export_all).

start() ->
  simple_server:start(?MODULE).

on_init() ->
  global:register_name(boorad@boorad_recv, self()),
  {ok, []}.

on_message({chat_msg, Message}, State) ->
  io:format("~p~n", [Message]),
  {reply, ok, State};

on_message(stop, _State) ->
  stop.

on_terminate() ->
  toast.


send_message(Server, Message) ->
  ServerPid = global:whereis_name(Server),
  simple_server:call(ServerPid, {chat_msg, Message}).

stop(Server) ->
  send_message(Server, stop).
