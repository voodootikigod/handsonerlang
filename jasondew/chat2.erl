-module(chat2).

-compile(export_all).

init(Node) ->
  net_adm:ping(Node),
  Listener = simple_server:start(chat2_listener),
  global:register_name(jason@hera_recv, Listener),
  chatWith(list_to_atom(atom_to_list(Node) ++ "_recv"), Listener).

chatWith(Node, Listener) ->
  case string:strip(io:get_line("> "), both, $\n) of
    "quit" ->
      simple_server:call(jason@hera_recv, stop),
      ok;
    Message ->
      simple_server:call(Node, {chat_msg, jason@hera_recv, Message}),
      chatWith(Node, Listener)
  end.
