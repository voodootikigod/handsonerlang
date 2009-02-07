%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc TEMPLATE.

-module(memcache_rest).
-author('author <author@example.com>').
-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
	ok ->
	    ok;
	{error, {already_started, App}} ->
	    ok
    end.
	
%% @spec start() -> ok
%% @doc Start the memcache_rest server.
start() ->
    memcache_rest_deps:ensure(),
    ensure_started(crypto),
    ensure_started(webmachine),
    application:start(memcache_rest).

%% @spec stop() -> ok
%% @doc Stop the memcache_rest server.
stop() ->
    Res = application:stop(memcache_rest),
    application:stop(webmachine),
    application:stop(crypto),
    Res.
