%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(memcache_rest_resource).
-export([init/1, to_json/2, to_html/2, resource_exists/2]).

-include_lib("webmachine/include/webmachine.hrl").

init(_) ->
  {ok, []}.

allowed_methods(_ReqProps, Context) ->
  {['GET'], Context}.

content_types_provided(_ReqProps, _Context) ->
	[{"application/json", to_json}, {"text/html", to_html}].

resource_exists(ReqProps, Context) ->
	Key = ?PATH(ReqProps),
	case memcache:find_value(Key) of
		undefined -> {false, Context};
		V -> {true, V}
	end.
	
to_json(ReqProps, Value) ->
	{mochijson:encode(Value), Value}.
	
to_html(ReqProps, Value) ->
	{Value, Value}.