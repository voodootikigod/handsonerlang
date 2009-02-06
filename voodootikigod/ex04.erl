-module(ex04).
-define(RECV, 'porn@idmbp_recv').
-export([on_init/0, on_message/2, on_terminate/0, start/0, send_message/2, stop/1]).



% API Functions
on_init()     ->
  find_others(),
  register_me().
  
on_message(Message, State)    ->
  process_message(Message,State).
  
on_terminate()  ->
  io:format("Quitting~n").
  
start() ->
  simple_server:start(ex04).
  
  
  
% local functions

find_others() ->
  lists:map(fun(X) -> net_adm:ping(X) end, ['chef@Clever-Computer-Name', 'boorad@boorad']).

register_me() ->
  Me = node(),
  global:trans({?RECV, ?RECV}, 
  	fun() ->
  		case global:whereis_name(?RECV) of 
  			undefined ->
  				Pid = self(),
  				global:register_name(?RECV, Pid),
  				{ok, []};
  			Oops ->
  				{error, "Already registered"}
  		end
  	end).
  
process_message(Message, State) ->
  case Message of
    {chat_msg, From, Msg} ->
      io:format("Message from ~p: ~p~n",[From,string:strip(Msg, both, $\n)]),
      {reply, ok, State};
    {chat_msg, Msg} ->
      io:format("Anonymous Message: ~p~n",[string:strip(Msg, both, $\n)]),
      {reply, ok, State};
    Fail  ->
      io:format("STFU: ~p~n", [Fail]),
      stop
  end.
  
send_message(Server, Message) ->
  Pid = global:whereis_name(Server),
  simple_server:call(Pid, {chat_msg, Message}).
  
stop(Server)  ->
  Pid = global:whereis_name(Server),
  simple_server:call(Pid, stop).
  