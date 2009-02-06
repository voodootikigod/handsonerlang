-module(ex05).
-behaviour(gen_server).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([add_value/2, find_value/1, remove_value/1, start_link/0]).


start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add_value(Name, Value) ->
  gen_server:call(?MODULE, {add_value, Name, Value}).
find_value(Name) ->
  gen_server:call(?MODULE, {find_value, Name}).
remove_value(Name) ->
  gen_server:call(?MODULE, {remove_value, Name}).

init([]) ->
  io:format("Starting ~p~n", [?MODULE]),
  {ok, dict:new()}.


without(Key, Dict)  ->
  dict:filter(
  		fun(K,_V) -> 
  		  K /= Key
  		end,
  	 Dict).

handle_call({add_value, Name, Value}, _From, State) ->
  {reply, success, dict:store(Name, Value, State)};
handle_call({find_value, Name}, _From, State) ->
  case dict:find(Name, State) of 
    {ok, Val} ->
      {reply, Val, State};
    _Else  ->
      {reply, undefined, State}
  end;
handle_call({remove_value, Name}, _From, State) ->
  {reply, success, without(Name, State)}.




handle_cast({add_value, Name, Value}, State) ->
  {noreply, dict:store(Name, Value, State)};
handle_cast({remove_value, Name}, State) ->
  {noreply,  without(Name, State)}.


terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
handle_info(_Request, State)  ->
  {ok, State}.