-module(lab9_addkey).

-export([init/1, allowed_methods/2, to_html/2, process_post/2]).

-include_lib("eunit/include/eunit.hrl").
-include_lib("webmachine/include/webmachine.hrl").

init(_) ->
  {ok, []}.

allowed_methods(_ReqProps, Context) ->
  {['GET', 'POST'], Context}.

to_html(_ReqProps, State) ->
  {"<html><body><form name=\"blah\" target=\"#\" method=\"POST\">key: <input name=\"key\" value=\"boo\"/><br />value: <input name=\"value\" value=\"rad\"/><br /><input type=\"submit\" value=\"submit\"/></form></body></html>", State}.

process_post(ReqProps, Context) ->
  Req = ?REQ(ReqProps),
  Params = parse_params(binary_to_list(Req:recv_body())),

  case store_kv(Params) of
    added ->
      Req:append_to_response_body("stored."),
      {true, Context};
    _ ->
      Req:respond({406, [{"Content-Type", "application/json"}], mochijson:encode({struct, [{"error", "Missing key/value attributes"}]})}),
      {false, Context}
  end.

%% Internal helper functions
parse_params(Body) when is_list(Body) ->
  Pairs = string:tokens(Body, "&"),
  lists:foldr(fun(NV, Acc) ->
                  [Name, Value] = string:tokens(NV, "="),
                  dict:store(Name, Value, Acc) end, dict:new(), Pairs).

store_kv(Params) ->
  Key = fetch_value("key", Params),
  Value = fetch_value("value", Params),
  lab5:add_value(Key, Value).

fetch_value(Name, Dict) ->
  case dict:find(Name, Dict) of
    {ok, Value} ->
      user_util:url_decode(Value);
    Error ->
      Error
  end.
