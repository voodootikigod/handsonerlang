-module(lab3).

-compile(export_all).

start() ->
  OtherNode = string:strip(io:get_line("Who you want? "), both, $\n),
  pong = net_adm:ping(list_to_atom(OtherNode)),
  Pid = spawn(fun() -> receiver() end),
  global:register_name(boorad@boorad_recv, Pid),
  sender().


receiver() ->
  io:format("receiver started~n"),
  receive
    {chat_msg, Sender, Message} ->
      io:format("~p - ~p~n", [Sender, Message]),
      receiver();
    _ ->
      ignored
    end.


sender() ->
  Input = io:get_line("say what? "),
  [To, Message] = string:tokens(Input, "|"),
  case Message of
    "quit\n" ->
      ok;
    _ ->
      global:send(list_to_atom(string:concat(To, "_recv")), {chat_msg, node(), Message}),
      sender()
  end.
