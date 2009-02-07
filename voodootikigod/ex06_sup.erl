-module(ex06_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
  Ex06Server = {ex06,{ex06,start_link,[]},
                permanent,2000,worker,[ex06]},
  {ok,{{one_for_one,10,60}, [Ex06Server]}}.
