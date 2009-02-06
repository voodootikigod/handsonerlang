-module(ex01).
-compile(export_all).

mapper(F, A) when is_function(F)  ->
  [ F(X) || X <- A].

mapper_test()  ->
  V = [1,2,3,4,5],
  F = fun(X) -> X * 2 end,
  mapper(F, V).



fb_lc() ->
  lists:foreach(fun(Y) -> io:format("~s~n",[Y]) end, [fizzbuzz(X) || X <- lists:seq(1,100)]).



fb_reg() ->
  fizzbuzz(1,100).

fizzbuzz(N,M) when N > M -> "";
fizzbuzz(N,M) ->
  io:format("~s~n",[fizzbuzz(N)]),
  fizzbuzz(N+1,M).

fizzbuzz(N) when N rem 3 == 0, N rem 5 == 0 -> "FizzBuzz";
fizzbuzz(N) when N rem 3 == 0 -> "Fizz";
fizzbuzz(N) when N rem 5 == 0 -> "Buzz";
fizzbuzz(N) -> integer_to_list(N).
