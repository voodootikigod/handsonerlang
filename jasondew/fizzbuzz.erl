-module(fizzbuzz).

-compile(export_all).

fizzbuzz([H|T]) when H rem 15 == 0 ->
  io:format("~p, fizzbuzz~n", [H]),
  fizzbuzz(T);
fizzbuzz([H|T]) when H rem 5 == 0 ->
  io:format("~p, buzz~n", [H]),
  fizzbuzz(T);
fizzbuzz([H|T]) when H rem 3 == 0 ->
  io:format("~p, fizz~n", [H]),
  fizzbuzz(T);
fizzbuzz([H|T]) ->
  io:format("~p~n", [H]),
  fizzbuzz(T);
fizzbuzz([]) ->
  ok.
