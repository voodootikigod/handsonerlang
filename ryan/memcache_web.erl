-module(memcache_web).

-export([dispatch/1]).

dispatch(Req) ->
	case Req:get(path) of
		"/cached_value" ->
			Key = proplists:get_value("key", Req:parse_qs()),
			Val = memcache:find_value(Key),
			Req:respond({200, [{"Content-Type", "application/javascript"}], mochijson:encode({struct, [{Key, Val}]})});
		Other ->
			Req:respond({404, [{"Content-Type", "application/javascript"}], mochijson:encode("Unrecognized path: " ++ Other)})
	end.