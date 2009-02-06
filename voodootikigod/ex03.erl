-module(ex03).
-define(RECV, 'porn@idmbp_recv').
-compile(export_all).



register_client() ->
  Me = node(),
  global:trans({?RECV, ?RECV}, 
  	fun() ->
  		case global:whereis_name(?RECV) of 
  			undefined ->
  				Pid = spawn(Me, ex03, chatter,[]),
  				global:register_name(?RECV, Pid);
  			_ ->
  				ok	
  		end
  	end).


chatter() ->
  receive
    {chat_msg, From, Msg} ->
      io:format("Message from ~p: ~p~n",[From,string:strip(Msg, both, $\n)]),
      chatter();
    Fail  ->
      io:format("STFU: ~p~n", [Fail])
  end.


start()	->
  register_client(),
  NodeName = string:strip(io:get_line("Enter the node to contact> "), both, $\n),
  connect_to_node(NodeName).
  
  
connect_to_node(NodeName) ->
  NodeAtom = list_to_atom(NodeName),
  io:format(NodeAtom),
  case net_adm:ping(NodeAtom) of
    pong  ->
      send_messages_to(NodeName);
    pang  ->
      io:format("Could not contact ~p~n", [NodeName]),
      start()
  end.
  
send_messages_to(NodeName) ->
  NodeLookup = list_to_atom(NodeName++"_recv"),
  Message = string:strip(io:get_line(NodeName++" > "), both, $\n),
  case Message of
    "quit"  ->
      global:send(?RECV, die),
      io:format("Quitting~n");
    "switch"->
      NewNodeName = string:strip(io:get_line("Enter the node to contact> "), both, $\n),
      connect_to_node(NewNodeName);      
    Msg ->
      case global:whereis_name(NodeLookup) of 
    		undefined ->
    			io:format("~p is not registered yet.~n",[node]),
    			send_messages_to(NodeName);
    		Node ->
    		  
    			global:send(NodeLookup, {chat_msg, node(), Msg} ),
    			send_messages_to(NodeName)
    	end
	end.
