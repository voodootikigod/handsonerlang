-module(lab9_remkey).

-export([init/1, allowed_methods/2, to_html/2, process_post/2]).

-include_lib("eunit/include/eunit.hrl").
-include_lib("webmachine/include/webmachine.hrl").

init(_) ->
  {ok, []}.

allowed_methods(_ReqProps, Context) ->
  {['GET', 'POST'], Context}.

to_html(_ReqProps, State) ->
  {"<html><body><form name=\"blah\" target=\"#\" method=\"POST\">key: <input name=\"key\" value=\"boo\"/><br /><input type=\"submit\" value=\"zap this\"/></form></body></html>", State}.

process_post(ReqProps, Context) ->
  Req = ?REQ(ReqProps),
  Params = parse_params(binary_to_list(Req:recv_body())),

  case zap_key(Params) of
    removed ->
      Req:append_to_response_body("that shizzle is toast."),
      {true, Context};
    _ ->
      Req:respond({406, [{"Content-Type", "application/json"}], mochijson:encode({struct, [{"error", "Missing key attribute"}]})}),
      {false, Context}
  end.

%% Internal helper functions
parse_params(Body) when is_list(Body) ->
  Pairs = string:tokens(Body, "&"),
  lists:foldr(fun(NV, Acc) ->
                  [Name, Value] = string:tokens(NV, "="),
                  dict:store(Name, Value, Acc) end, dict:new(), Pairs).

zap_key(Params) ->
  Key = fetch_value("key", Params),
  lab5:remove_value(Key).

fetch_value(Name, Dict) ->
  case dict:find(Name, Dict) of
    {ok, Value} ->
      user_util:url_decode(Value);
    Error ->
      Error
  end.
