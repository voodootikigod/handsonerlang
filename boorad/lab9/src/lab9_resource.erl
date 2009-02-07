%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(lab9_resource).
-export([init/1, to_html/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

to_html(ReqProps, State) ->
  Path = ?PATH(ReqProps),
  Value = lab5:find_value(Path),
  Value1 = case is_list(Value) of
	     true ->
	       Value;
	     _ ->
	       "not found"
	   end,
  {"<html><body>Value: " ++ Value1 ++ "</body></html>", State}.
