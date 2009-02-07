-module(chat).
-compile([export_all]).

get_node() ->
	list_to_atom(string:strip(io:get_line("Enter the node name to connect to: "), both, $\n)).
	
register() ->
	Node = get_node(),
	Result = net_adm:ping(Node),
	case Result of
		pong -> Node;
		_ -> fail
	end.

receive_chat() ->
	receive
		{chat_msg, From, Message} ->
			io:format("~p: ~p~n", [From, Message]),
			receive_chat();
		_Oops -> fail
	end.	
	
start_chatting(Partner) ->
	Chat = string:strip(io:get_line("> "), both, $\n),
	case Chat of
		"quit" -> ok;
		_ ->
			global:send(Partner, {chat_msg, "ryan", Chat}),
			start_chatting(Partner)
	end.
	
chat() ->
	Partner = register(),
	start_chatting(list_to_atom(atom_to_list(Partner) ++ "_recv")).
	
start() ->
	Receiver = spawn(fun() -> receive_chat() end),
	global:register_name('daigle@Palermo_recv', Receiver),
	chat().