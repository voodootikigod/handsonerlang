-module(time_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
  TimeServer = {time_server,{time_server,start_link,[]},
                permanent,2000,worker,[time_server]},
  {ok,{{one_for_one,10,60}, [TimeServer]}}.
