-module(memcache_web).

-export([dispatch/1]).

dispatch(Req) ->
	Args = string:tokens(Req:get(path), "/"),
	[Command|Values] = Args,
	case Command of
		"add_value" ->
			[A|B] = Values,
			memcache:add_value(A, B),
			Response = "Value Added";
		"find_value" ->
			[A|_] = Values,
			{ok, Response} = memcache:find_value(A);
		_ ->
			Response = "Ask me to do something already"
	end,
	Req:respond({200, [{"Content-Type", "text/plain"}], mochijson:encode(Response)}).

