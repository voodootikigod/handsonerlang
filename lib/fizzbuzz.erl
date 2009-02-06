-module(fizzbuzz).

-export([do_it/1]).

do_it(UpTo) when is_integer(UpTo),
                 UpTo > 0 ->
  Values = lists:seq(1, UpTo),
  lists:foldr(fun(V, Accum) ->
                  [analyze(V)|Accum] end, [], Values).

%% Internal functions
analyze(V) when V rem 3 == 0,
                V rem 5 == 0 ->
  "fizzbuzz";
analyze(V) when V rem 3 == 0 ->
  "fizz";
analyze(V) when V rem 5 == 0 ->
  "buzz";
analyze(V) ->
  integer_to_list(V).
