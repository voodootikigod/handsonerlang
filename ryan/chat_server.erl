-module(chat_server).
-compile([export_all]).

start() ->
	simple_server:start(chat_server).

% Listening
on_init() ->
	MyName = 'daigle@Palermo_recv',
	global:register_name(MyName, self()),
	{ok, [{my_name, MyName}]}.
	
on_message({chat_msg, From, Message}, State) ->
	io:format("~p: ~p~n", [From, Message]),
	{reply, ok, [Message|State]};
	
on_message({chat_quit}, _State) -> stop.
	
on_terminate() ->
	global:unregister_name('daigle@Palermo_recv').
	
% Sending
send(Message) ->
	Pid = global:whereis_name('daigle@Palermo_recv'),
	simple_server:call(Pid, Message).
	
stop() ->
	send({chat_quit}).