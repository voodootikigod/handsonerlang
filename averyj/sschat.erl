-module(sschat).
-compile(export_all).

start() ->
	simple_server:start(sschat).

on_init() ->
  global:register_name('chef@Clever-Computer-Name_recv', self()),
  {ok, []}.
	
on_terminate() ->
  global:unregister_name('chef@Clever-Computer-Name_recv').
	
on_message(Message, State) ->
  	{chat_msg, Sender, Text} = Message,
    case Text of
	 "stop" -> stop;
	 _ ->     
	  io:format("** ~p - ~p", [Sender, Text]),
      {reply, ok, State}
	end.

send_message(Message) ->
	simple_server:call("chef@Clever-Computer-Name_recv", Message).
	
stop() ->
	send_message("stop").