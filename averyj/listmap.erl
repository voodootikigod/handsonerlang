-module(listmap).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

map(A, F) when is_function(F) ->
	[ F(X) || X <- A].

map_test() -> ?assert([2,4] =:= map([1,2], fun(X) -> X * 2 end)).