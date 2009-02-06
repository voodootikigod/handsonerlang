%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc TEMPLATE.

-module(user_management).
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
%% @doc Start the user_management server.
start() ->
    user_management_deps:ensure(),
    ensure_started(crypto),
    ensure_started(webmachine),
    application:start(user_management).

%% @spec stop() -> ok
%% @doc Stop the user_management server.
stop() ->
    Res = application:stop(user_management),
    application:stop(webmachine),
    application:stop(crypto),
    Res.
