-module(time_server).

-behaviour(gen_server).

%% API
-export([start_link/0, current_time/0, crash/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {}).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

current_time() ->
  gen_server:call(?MODULE, current_time).

crash() ->
  gen_server:call(?MODULE, crash).

init([]) ->
  io:format("Starting ~p~n", [?MODULE]),
  {ok, #state{}}.

handle_call(crash, _From, _State) ->
  exit({error, crashing});

handle_call(current_time, _From, State) ->
  {reply, calendar:now_to_local_time(erlang:now()), State};

handle_call(_Request, _From, State) ->
  {reply, ignored, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
