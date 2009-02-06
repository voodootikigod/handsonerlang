-module(ex04).
-define(RECV, 'porn@idmbp_recv').
-compile(export_all)



% API Functions
on_init()       ->
  register_client().
  
on_message(Message, State)    ->
  process_message(Message,State).
  
on_terminate()  ->
  io:format("Quitting~n").
  
start() ->
  simple_server:start(ex04).
  
% local functions
register_client() ->
  Me = node(),
  global:trans({?RECV, ?RECV}, 
  	fun() ->
  		case global:whereis_name(?RECV) of 
  			undefined ->
  				Pid = self(),
  				global:register_name(?RECV, Pid);
  				{ok, []}
  			_ ->
  				{error, "Already registered"}
  		end
  	end).
  
process_message(Message, State) ->
  {chat_msg, From, Msg} ->
    io:format("Message from ~p: ~p~n",[From,string:strip(Msg, both, $\n)]),
  Fail  ->
    io:format("STFU: ~p~n", [Fail]).