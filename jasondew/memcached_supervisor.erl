-module(memcached_supervisor).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  Memcached = {memcached, {memcached, start_link, []},
               permanent, 2000, worker, [memcached]},
  {ok,{{one_for_one,10,60}, [Memcached]}}.
