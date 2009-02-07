%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the lab9 application.

-module(lab9_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for lab9.
start(_Type, _StartArgs) ->
    lab9_deps:ensure(),
    lab9_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for lab9.
stop(_State) ->
    ok.
