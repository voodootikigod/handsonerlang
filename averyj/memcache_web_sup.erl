-module(memcache_web_sup).

-behaviour(supervisor).

-export([init/1, start_link/0]).

-define(SERVER, ?MODULE).

start_link() ->
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).
	
init([]) ->
  MemCacheServer = {memcache,{memcache,start_link,[]},
                permanent,2000,worker,[memcache]},
  WebServer = {web_server,{mochiweb_http,start,[[{port, 8000},
			  {loop, fun memcache_web:dispatch/1}]]},
               permanent,2000,worker,[mochiweb_http]},
  {ok,{{one_for_one,10,60}, [MemCacheServer, WebServer]}}.