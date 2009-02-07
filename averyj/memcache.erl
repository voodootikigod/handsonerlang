-module (memcache).

-behavior(gen_server).

-export([add_value/2, find_value/1, remove_value/1, start_link/0, crash/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

init([]) ->
  io:format("Starting ~p~n", [?MODULE]),
  {ok, dict:new()}.

crash() ->
	exit({error, crashing}).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
	
add_value(K, V) ->
	gen_server:call(?MODULE, {add_value, K, V}).
	
find_value(K) ->
	gen_server:call(?MODULE, {find_value, K}).

remove_value(K) ->
	gen_server:cast(?MODULE, {remove_value, K}).

handle_call({add_value, K, V}, _From, State) ->
	{reply, ok, dict:store(K, V, State)};

handle_call({find_value, K}, _From, State) ->
	{reply, dict:find(K, State), State};
	
handle_call(_Request, _From, State) ->
    {reply, ignored, State}.
	
handle_cast({remove_value, K}, State) ->
    {noreply, dict:erase(K, State)};

handle_cast(_Msg, State) ->
    {noreply, State}.
	
handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
