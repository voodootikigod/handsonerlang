-module(user_resource).

-export([init/1, allowed_methods/2, content_types_provided/2]).
-export([resource_exists/2, to_json/2, to_text/2]).

-include_lib("eunit/include/eunit.hrl").
-include_lib("webmachine/include/webmachine.hrl").
-include("user.hrl").


init(_) ->
  {ok, []}.

allowed_methods(_ReqProps, Context) ->
  {['GET'], Context}.

content_types_provided(_ReqProps, Context) ->
  {[{"application/json", to_json},
    {"text/plain", to_text}], Context}.

resource_exists(ReqProps, Context) ->
  UserId = ?PATH(ReqProps),
  io:format("UserId: ~p~n", [UserId]),
  case user_manager:fetch_user(UserId) of
    not_found ->
      {false, Context};
    User ->
      {true, User}
  end.

to_json(_ReqProps, User) ->
  Attr1 = dict:store("id", User#user.id, dict:new()),
  Attr2 = dict:store("name", User#user.name, Attr1),
  Attr3 = dict:store("password", User#user.password, Attr2),
  Json = mochijson:encode({struct, dict:to_list(Attr3)}),
  {Json, User}.

to_text(_ReqProps, User) ->
  Text = io_lib:format("Id: ~s~nName: ~s~nPassword: ~s~n", [User#user.id,
                                                            User#user.name,
                                                            User#user.password]),
  {Text, User}.
