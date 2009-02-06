-module(memcached).

-behaviour(gen_server).

%% API
-export([start_link/0, add_value/2, find_value/1, remove_value/1, crash/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add_value(Name, Value) ->
  gen_server:cast(?MODULE, {add, Name, Value}).

find_value(Name) ->
  gen_server:call(?MODULE, {lookup, Name}).

remove_value(Name) ->
  gen_server:cast(?MODULE, {remove, Name}).

crash() ->
  gen_server:call(?MODULE, crash).

init([]) ->
  io:format("Starting ~p~n", [?MODULE]),
  {ok, dict:new()}.

handle_call({lookup, Name}, _From, State) ->
  {reply, dict:find(Name, State), State};

handle_call(crash, _From, _State) ->
  exit({error, crashing});

handle_call(_Request, _From, State) ->
  {reply, ignored, State}.

handle_cast({add, Name, Value}, State) ->
  {noreply, dict:store(Name, Value, State)};

handle_cast({remove, Name}, State) ->
  {noreply, dict:erase(Name, State)};

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
