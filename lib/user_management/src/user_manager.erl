-module(user_manager).

-behaviour(gen_server).

-include("user.hrl").

-define(SERVER, ?MODULE).

%% API
-export([start_link/0, store_user/1, fetch_user/1, dump_keys/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state,
        {users=dict:new()}).

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  {ok, #state{}}.

dump_keys() ->
  gen_server:call(?SERVER, dump_keys).

store_user(User) ->
  gen_server:call(?SERVER, {store_user, User}).

fetch_user(UserId) ->
  gen_server:call(?SERVER, {fetch_user, UserId}).

handle_call(dump_keys, _From, State) ->
  {reply, dict:fetch_keys(State#state.users), State};

handle_call({fetch_user, UserId}, _From, State) ->
  Result = case dict:find(UserId, State#state.users) of
             {ok, Value} ->
               Value;
             error ->
               not_found
           end,
  {reply, Result, State};

handle_call({store_user, User}, _From, State) ->
  {reply, ok, State#state{users=dict:store(User#user.id, User, State#state.users)}};

handle_call(_Request, _From, State) ->
  Reply = ok,
  {reply, Reply, State}.

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast(_Msg, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% Function: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
  ok.

%%--------------------------------------------------------------------
%% Func: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
