-module(memcache_sup).

-export([init/1, start_link/0]).

-define(SERVER, ?MODULE).

start_link() ->
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).
	
init([]) ->
  MemCacheServer = {memcache,{memcache,start_link,[]},
                permanent,2000,worker,[memcache]},
  {ok,{{one_for_one,10,60}, [MemCacheServer]}}.