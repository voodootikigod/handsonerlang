-module(memcache).
-compile([export_all]).

-behavior(gen_server).

-record(state, {entries=dict:new()}).

% Client calls

add_value(Name, Value) ->
	gen_server:cast(?MODULE, {add_value, Name, Value}).
find_value(Name) ->
	gen_server:call(?MODULE, {find_value, Name}).
remove_value(Name) ->
	gen_server:cast(?MODULE, {remove_value, Name}).

% Server stuff

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

crash() ->
  gen_server:call(?MODULE, crash).

init([]) ->
  io:format("Starting ~p~n", [?MODULE]),
  {ok, #state{}}.

handle_cast({add_value, Name, Value}, State) ->
	NewEntries = dict:store(Name, Value, State#state.entries),
	{noreply, State#state{entries=NewEntries}};
	
handle_cast({remove_value, Name}, State) ->
	NewEntries = dict:erase(Name, State#state.entries),
	{noreply, State#state{entries=NewEntries}}.
	
handle_call({find_value, Name}, _From, State) ->
	case dict:find(Name, State#state.entries) of
		{ok, Value} -> {reply, Value, State};
		error -> {reply, undefined, State}
	end;

handle_call(crash, _From, _State) ->
	exit({error, crashing}).

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.