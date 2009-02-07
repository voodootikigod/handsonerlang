%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the user_management application.

-module(user_management_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for user_management.
start(_Type, _StartArgs) ->
    user_management_deps:ensure(),
    user_management_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for user_management.
stop(_State) ->
    ok.
