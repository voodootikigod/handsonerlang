-module(memcache_web_sup).
-behavior(supervisor).
-compile([export_all]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	MemcacheServer = {memcache,{memcache,start_link,[]}, permanent,2000,worker,[memcache]},
	WebServer = {web_server,{mochiweb_http,start,[[{port, 8000},
                                                {loop, fun memcache_web:dispatch/1}]]},
               permanent,2000,worker,[mochiweb_http]},
  {ok,{{one_for_one,10,60}, [MemcacheServer, WebServer]}}.