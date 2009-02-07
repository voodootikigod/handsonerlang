%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the memcache_rest application.

-module(memcache_rest_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for memcache_rest.
start(_Type, _StartArgs) ->
    memcache_rest_deps:ensure(),
    memcache_rest_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for memcache_rest.
stop(_State) ->
    ok.
