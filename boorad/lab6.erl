%%%-------------------------------------------------------------------
%%% File    : lab6.erl
%%% Author  : Brad Anderson <brad@sankatygroup.com>
%%% Description :
%%%
%%% Created :  6 Feb 2009 by Brad Anderson <brad@sankatygroup.com>
%%%-------------------------------------------------------------------
-module(lab6).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the supervisor
%%--------------------------------------------------------------------
start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================
%%--------------------------------------------------------------------
%% Func: init(Args) -> {ok,  {SupFlags,  [ChildSpec]}} |
%%                     ignore                          |
%%                     {error, Reason}
%% Description: Whenever a supervisor is started using
%% supervisor:start_link/[2,3], this function is called by the new process
%% to find out about restart strategy, maximum restart frequency and child
%% specifications.
%%--------------------------------------------------------------------
init([]) ->
  Memcache = {memcache,{lab5,start_link,[]},
	      permanent,2000,worker,[lab5]},
  Mochiweb = {web_server,{mochiweb_http,start,[[{port, 8000},
                                                {loop, fun lab8:dispatch/1}]]},
	      permanent,2000,worker,[mochiweb_http]},

  {ok,{{one_for_all,10,60}, [Memcache, Mochiweb]}}.

%%====================================================================
%% Internal functions
%%====================================================================
