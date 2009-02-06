-module(chat).
-compile(export_all).

%%prompt for the other node
start() ->
  Receiver = string:strip(io:get_line("Send to Who?"), both, $\n),
  pong = ping(list_to_atom(Receiver)),
  Listener = spawn(fun() -> listener() end),
  global:register_name('chef@Clever-Computer-Name_recv', Listener),
  console(Receiver).

%%ping the other node
ping(Receiver) ->
	net_adm:ping(Receiver).

%%process to receive messages

listener() ->
	receive({chat_msg, Sender, Message}) ->
		io:format("** ~p - ~p", [Sender, Message]),
		listener()
	end.

console(Receiver) ->
  case readLine() of
	"quit" -> x;
	Message ->	
	send(Receiver, Message),
	console(Receiver)
  end.
	
readLine() ->
  string:strip(io:get_line("Speak!:"), both, $\n).

%%processes to send messages
send(Target, Message) ->
   global:send(list_to_atom(string:concat(Target, "_recv")), {chat_msg, node(), Message}).


