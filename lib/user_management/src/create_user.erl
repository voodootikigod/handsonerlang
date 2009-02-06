-module(create_user).

-export([init/1, allowed_methods/2, process_post/2]).

-include_lib("eunit/include/eunit.hrl").
-include_lib("webmachine/include/webmachine.hrl").
-include("user.hrl").

init(_) ->
  {ok, []}.

allowed_methods(_ReqProps, Context) ->
  {['POST'], Context}.

process_post(ReqProps, Context) ->
  Req = ?REQ(ReqProps),
  Params = parse_params(binary_to_list(Req:recv_body())),
  case store_user(Params) of
    {ok, _User} ->
      Req:add_response_header("Content-Type", "application/json"),
      Req:append_to_response_body(mochijson:encode("ok")),
      {true, Context};
    {error, missing_value} ->
      Req:respond({406, [{"Content-Type", "application/json"}], mochijson:encode({struct, [{"error", "Missing user attribute"}]})}),
      {false, Context}
  end.

%% Internal helper functions
parse_params(Body) when is_list(Body) ->
  Pairs = string:tokens(Body, "&"),
  lists:foldr(fun(NV, Acc) ->
                  [Name, Value] = string:tokens(NV, "="),
                  dict:store(Name, Value, Acc) end, dict:new(), Pairs).

store_user(Params) ->
  Id = fetch_value("id", Params),
  Name = fetch_value("name", Params),
  Password = fetch_value("password", Params),
  case Id =:= error orelse Name =:= error orelse Password =:= error of
    true ->
      {error, missing_value};
    false ->
      UserRec = #user{id=Id, name=Name, password=Password},
      user_manager:store_user(UserRec),
      {ok, UserRec}
  end.

fetch_value(Name, Dict) ->
  case dict:find(Name, Dict) of
    {ok, Value} ->
      user_util:url_decode(Value);
    Error ->
      Error
  end.
