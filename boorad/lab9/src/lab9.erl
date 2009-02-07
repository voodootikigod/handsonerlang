%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc TEMPLATE.

-module(lab9).
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
%% @doc Start the lab9 server.
start() ->
    lab9_deps:ensure(),
    ensure_started(crypto),
    ensure_started(webmachine),
    application:start(lab9).

%% @spec stop() -> ok
%% @doc Stop the lab9 server.
stop() ->
    Res = application:stop(lab9),
    application:stop(webmachine),
    application:stop(crypto),
    Res.
