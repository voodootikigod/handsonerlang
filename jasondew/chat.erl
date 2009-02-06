-module(chat).

-compile(export_all).

init(Node) ->
  net_adm:ping(Node),

  Listener = spawn(fun() -> listen() end),
  global:register_name(jason@hera_recv, Listener),
  chatWith(list_to_atom(atom_to_list(Node) ++ "_recv"), Listener).

chatWith(Node, Listener) ->
  case string:strip(io:get_line("> "), both, $\n) of
    "quit" ->
      Listener ! stop,
      ok;
    Message ->
      global:send(Node, {chat_msg, jason@hera, Message}),
      chatWith(Node, Listener)
  end.

listen() ->
  receive
    {chat_msg, From, Message} ->
      io:format("~p says: ~p~n", [From, Message]),
      listen();
    stop ->
      ok;
    Unknown ->
      io:format("unknown message received: ~p~n", Unknown),
      listen()
  end.
